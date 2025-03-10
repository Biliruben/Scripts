#!/usr/bin/perl -w
###########################################################################
#  Convert CSV, comma-separated list, to LDIF                             #
#  Version: 1.1                                                           #
#  Author:  Benedikt Hallinger <b.hallinger@skyforcesystems.de>           #
#                                                                         #
#  This script is inspired from the csv2ldif.pl implementation from       #
#  TAKIZAWA Takashi. I found the original csv2ldif.pl at                  #
#  'http://www.emaillab.org/mutt/download.html#ldap', but unfortunatley   #
#  i can't find it there now.                                             #
#  However, *this* csv2ldif is heavily modified and very very VERY        #
#  little of the original code is preserved here.                         #
#                                                                         #
#  Required modules are                                                   #
#    MIME::Base64                                                         #
#    Encode                                                               #
#    Getopt::Std                                                          #
#  Usually these modules are already installed, if not, you can get       #
#  them either from your distributions package system or from CPAN.       #
#                                                                         #
###########################################################################
#  This program is free software; you can redistribute it and/or modify   #
#  it under the terms of the GNU General Public License as published by   #
#  the Free Software Foundation; either version 2 of the License, or      #
#  (at your option) any later version.                                    #
#                                                                         #
#  This program is distributed in the hope that it will be useful,        #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of         #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          #
#  GNU General Public License for more details.                           #
#                                                                         #
#  You should have received a copy of the GNU General Public License      #
#  along with this program; if not, write to the Free Software            #
#  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111, USA. #
###########################################################################

use strict;
use MIME::Base64 qw(encode_base64);
use Getopt::Std;
use Encode qw(decode encode find_encoding encodings);

# This is some workaround variable that is used to identify empty
# fields in the csv. Split eats the emtpy fields up otherwise!
# this gets used inside parse_csv()
our $split_wo_empty = 'csv2ldif2.pl-THIS IS A EMPTY VALUE! IGNORE ME PLEASE! I AM JUST USED FOR A WORKAROUND!';

# Some default values for the options
my $cnattrname = 'cn';
my $cnfields = '1';
my $cnsep = ' ';
my $ignorefields_s = '';
my $basedn = 'unset';
my $print_empty = 0;
our $delim = ',';          # this gets used by parse_csv()
our $quote = '"';          # this gets used by parse_csv()
my $icode = 'latin1';     # input encoding, this gets used by parse_csv()
my $ocode = 'utf8';       # output encoding; fixed to utf8 because of RFC-2849
our $enableBase64 = 1;

# Parse Options:
my %Options;
my $arg_count = @ARGV;
my $arg_ok = getopts('vhxb:Bq:c:d:e:E:f:F:i:s:', \%Options);

if ($Options{h}) {
	help();
	exit 0;
}
if ($Options{v}) {
	version();
	exit 0;
}
if (!$arg_ok){
	usage();
	exit 1;
}
if(!$Options{b}){
	print "Parameter -b basedn is mandatory!\n";
	usage();
	exit 1;
}

if ($Options{b}){ $basedn = $Options{b};}
if ($Options{B}){ $enableBase64 = 0;}
if ($Options{c}){ $cnattrname = $Options{c};}
if ($Options{d}){ $delim = $Options{d};}
if (defined $Options{e}){ $icode = $Options{e};}
if (defined $Options{E}){ $ocode = $Options{E};}
if ($Options{f}){ $cnfields = $Options{f};}
if (defined $Options{F}){
	$cnsep = $Options{F};
}
if ($Options{'q'}){ $quote = $Options{'q'};}
if ($Options{i}){ $ignorefields_s = $Options{i};}
if ($Options{'x'}){ $print_empty = 1}

# Check encoding settings and initialize encoders
# encoding can be shut off if -e '' is given.
our $ienc;
our $oenc;
if ($icode) {
	$ienc = find_encoding($icode);
	if (! defined($ienc) ) { 
		print STDERR "input encoding '$icode' not found! supported:\n";
		my @all_encodings = Encode->encodings(":all");
		print STDERR "@all_encodings\n";
		exit 1;
	}
}
if ($ocode) {
	$oenc = find_encoding($ocode);
	if (! defined($oenc) ) {
        	print STDERR "output encoding '$ocode' not found! supported:\n";
		my @all_encodings = Encode->encodings(":all");
		print STDERR "@all_encodings\n";
	        exit 1;
	}
}



# Get and convert the CN selected fields to array indizes; this is
# for a more intuitive usage of the -f parameter
my @cnselectedfields_raw = split (/,/, $cnfields);
my @cnselectedfields;
foreach my $nr (@cnselectedfields_raw) {
	if ($nr =~ /^\d+$/){
		# single value
		push(@cnselectedfields, $nr - 1);
	} else {
		print STDERR "Parameter error: value of -f not understood: $nr\n";
		usage();
		exit 1;
	}
}

# Get and convert the ignored fields to array indizes
my @ignorefields_raw = split (/,/, $ignorefields_s);
my @ignorefields;
my $index_tmp; # tmp variable for index in foreachs
foreach my $inr (@ignorefields_raw) {
	if ($inr =~ /^(\d+)-(\d+)$/) {
		# range
		foreach $index_tmp ($1 .. $2) {
			push(@ignorefields, $index_tmp -1);
		}
	} else {
		if ($inr =~ /^\d+$/){
			# single value
			push(@ignorefields, $inr - 1);
		} else {
			print STDERR "Parameter error: value of -i not understood: $inr\n";
			usage();
			exit 1;
		}
	}
}

#
# Attribute descriptors (get from the first line of CSV)
#
my $linecounter = 1; #a little happy line counter
$_ = <STDIN>;
chomp;
if ($_ eq '') {
	print STDERR "# Could not get Attribute names from CSV line $linecounter: Line was empty!\n";
	exit;
}
my @attr = split ($delim,$_);
if ($#attr == 0) {
	# splitting failed, probably wrong delimeter
	print STDERR "# Could not get Attribute names from CSV line $linecounter: you probably used the wrong delimeter.\n";
	exit;
}
# now, that we know what fields we have, we can process the -s parameter if set
if ($Options{'s'}){
	my @selected_fields_raw = split (/,/, $Options{'s'});
	my @selected_fields;
	# check for ranges and convert to discrete numbers if necessary
	foreach my $number (@selected_fields_raw) {
		if ($number =~ /^(\d+)-(\d+)$/) {
			# range
			foreach $index_tmp ($1 .. $2) {
				push(@selected_fields, $index_tmp);
			}
		} else {
			if ($number =~ /^\d+$/){
				# single value
				push(@selected_fields, $number);
			} else {
				print STDERR "Parameter error: value of -s not understood: $number\n";
				usage();
				exit 1;
			}
		}
	}
	foreach my $this_index (0 .. $#attr) {
		if(!grep { $_ eq $this_index + 1 } @selected_fields) {
			push(@ignorefields, $this_index);
		}
	}
}


#
# Attribute values
#
my %data; # the hash where the LDIF data will be stored
while(<STDIN>){
	$linecounter++;
	chomp;
	next if ($_ eq '');

	my @value = parse_csv($_);
	if ($#value == 0) {
		# splitting failed, probably wrong delimeter
		print STDERR "# Could not parse CSV line $linecounter: you probably used the wrong delimeter.\n";
		next;
	}
	if ($#attr != $#value) {
		# splitting failed, wrong fieldcount
		print STDERR "# Could not parse CSV line $linecounter: the count of header fields ($#attr) is not equal the number of fields ($#value) in dataset!\n";
		next;
	}

	# Compose the attribute that makes up the DN
	my $fieldnumber;
	my $composed_attr ='';
	my @lines;         # the lines of this LDIF-Entry
	my $dn;            # dn of this entry
	my $dnattr;        # dn attribute of this entry
	my $dncreateerror = 0; # if a error occured creating the DN from several fields
	my $dncreateattr = 0; # if error, in which CSV field it occured
	if ($#cnselectedfields > 0) {
		foreach my $nr2 (@cnselectedfields) {
			$value[$nr2] =~ /^\s*(.+?)\s*$/;  # trim whitespace
			if (defined($1)) {
				$composed_attr = $composed_attr.$1.$cnsep;
			} else {
				# value was empty and cannot be part of dn,
				# store that a error occured so we can skip this entry later
				$dncreateerror = 1;
				$dncreateattr = $nr2;
			}
		}
		if ($dncreateerror) {
			print STDERR "# ERROR: DN could not be built from CSV line $linecounter: value of CSV field ".$attr[$dncreateattr]." was empty!\n";
			next;
		} else {
			# DN creation went fine, print out the DN and DN's composed attribute
			if (length($cnsep) > 0) {
				$composed_attr = substr($composed_attr, 0, - length($cnsep));
			}
			$dn = generate_line('dn', $cnattrname."=".$composed_attr.','.$basedn);
			$dnattr = generate_line($cnattrname, $composed_attr);
		}
	} else {
		# use selected attribute name or name from csv as dn
		$fieldnumber = $cnselectedfields[0];
		if ($value[$fieldnumber] eq ''){
			print STDERR "# ERROR: DN could not be built from CSV line $linecounter: value of CSV field ".$attr[$fieldnumber]." was empty!\n";
			next;
		}
		if ($Options{c}){
			$dn = generate_line('dn', $cnattrname."=".$value[$fieldnumber].",".$basedn);
			$dnattr = generate_line($cnattrname, $value[$fieldnumber]);
		} else {
			$dn = generate_line('dn', $attr[$fieldnumber]."=".$value[$fieldnumber].",".$basedn);
			$dnattr = ''; # will be stored by normal attribute procedure
		}
	}
	
	
	
	# If the entry was already read (multiple lines in csv for the same entry)
	# then fetch the old lines and don't add the dn stuff to the lines since it is already there
	if (defined $data{$dn}) {
		#
		# we already have processed this entry
		#
		
		my $oldlines_ref = $data{$dn};
		my @oldlines = @$oldlines_ref; # fetch the old lines
		
		# add all lines whose attribute is not ignored
		# and which is not already in @oldlines
		for (my $i = 0; $i <= $#value; $i++) {
			if(!grep { $_ eq $i } @ignorefields){
				my $tmp_line = generate_line($attr[$i], $value[$i]);
				if ( !grep { index($_, $tmp_line) >= 0 } @oldlines ) {
					push(@lines, $tmp_line);
				}
			}
		}
		
		# put old and new lines togehter and store them
		my @newlines = (@oldlines, @lines);
		my $line_reference = \@newlines;
		$data{$dn} = $line_reference;
		
	} else {
		#
		# this is the first time we process this entry
		#
		
		if ($dnattr ne '') {
			push(@lines, $dnattr); # add dn attribute to lines, if nonempty
		}
		
		# add all other attributes that are not ignored and not already stored
		for (my $i = 0; $i <= $#value; $i++) {
			if(!grep { $_ eq $i } @ignorefields){
				my $tmp_line = generate_line($attr[$i], $value[$i]);
				if ( !grep { index($_, $tmp_line) >= 0 } @lines ) {
					push(@lines, $tmp_line);
				}
			}
		}
		
		# store the lines in %data hash
		my $line_reference = \@lines;
		$data{$dn} = $line_reference;
	}
}

# Print out the data
while ((my $key, my $ref_lines) = each %data) {
	# print the DN of the entry
	print "$key\n";
	
	# print all attributes of that entry
	my @lines = @$ref_lines;
	foreach my $thisline (@lines) {
		if($thisline) {
			print "$thisline\n";
		}
	}
	
	print "\n";
}
exit 0;



# ------- some subs --------
sub parse_csv {
	# This takes an csv line and splits it up into @values.
	# It consideres the encoding of the csv and also quoted values.
	my @return;
	my $append_next;
	my $composed_field = '';

	if (defined $ienc) { $_ = $ienc->decode($_);}  # use ienc to convert input data
	if (defined $oenc) { $_ = $oenc->encode($_);}  # use oenc to convert output data
	
	# split() eats up empty fields, so a dataset "foo,bar,," contains only 2 values!
	# we test for that case and make a (dirty) workaround
	$_ =~ s/,,/,$split_wo_empty,/;  # fill empty fields with the workaround value
	$_ =~ s/^,/$split_wo_empty,/;   # fill empty fields at beginning with the workaround value
	$_ =~ s/,$/,$split_wo_empty/;   # fill empty fields at end with the workaround value

	my @row_raw;
	@row_raw = split($delim, $_); # parse csv
	
	# if delimeter was used inside a quoted field, then we splitted too much.
	# this gets corrected now
	foreach my $field (@row_raw) {
		# Workaround for split() - substitude workaround value with really empty value
		if ($field eq $split_wo_empty) {
			$field = '';
		}
		
		if (length($quote) > 0 && $field =~ /^$quote/) {
			# Field starts with quote
			$append_next = 1;  # start of quoted field
		}
		
		# appending mode?
		if ($append_next) {
			if (length($composed_field) == 0) {
				$composed_field = $field;
			} else {
				$composed_field = $composed_field.','.$field;
			}
		} else {
			push(@return, $field); # just add the field
		}
		
		# end of appending mode
		if (length($quote) > 0 && $field =~ /$quote$/) {
			$composed_field =~ s/$quote(.*)$quote/$1/; # strip the quoting characters at start and end
			push(@return, $composed_field); # flush composed field into return
			$composed_field = ''; # prepare next composed field
			$append_next = 0;
		}
	}
	
	if ($append_next) {
		# if this is still on, something went wrong!
		# most probably we detected a quote that gets never closed
		print STDERR "# Could not parse CSV line $linecounter: Opening quoting character detected, but never closed!\n";
	}
	
	return @return;
}
sub generate_line {
	my ($attr_raw,$value) = @_;
	$attr_raw =~ /^\s*(.+?)\s*$/;  # trim whitespace
	my $attr = $1;
	
	if (!($value =~ /^\s*$/) || $print_empty){
		if (length($attr)) {
			if ($value =~ /[\x80-\xFF]/ && $enableBase64) {
				return($attr.':: '.encode_base64 ($value,''));
			} else {
				return($attr.': '.$value);
			}
		}
	}
}

sub usage {
	version();
	print "Usage: $0 -b 'basedn' [options] < data.csv > output.ldif\n";
	print "\nAvailable options:\n";
	print "  -b  BaseDN for the entries; Mandatory!\n";
	print "  -B  Disable base64 encoding\n";
	print "  -c  Attribute name for CN to use, if -f is specified      (default: '$cnattrname')\n";
	print "      Overrides the CSV-Name if set.\n";
	print "  -d  Delimeter which separates the fields in CSV           (default: '$delim')\n";
	print "  -e  Encoding of the input file                            (default: '$icode')\n";
	print "  -E  Encoding of attribute values, see -h when changing!   (default: '$ocode')\n";
	print "  -f  Fields to use for DN (comma seperated, e.g. '3,1,2')  (default: '$cnfields')\n";
	print "      Order matters, so you can select random fields.\n";
	print "      If you specify -f with more than one fieldnumber,\n";
	print "      you should also specify -c!\n";
	print "  -F  Separator between multiple cn fields, see -f          (default: '$cnsep')\n";
	print "  -h  Display more help than this short usage notice\n";
	print "  -i  Fields to ignore (comma seperated with range)         (default: no fields)\n";
	print "  -q  Quote character                                       (default: '$quote')\n";
	print "  -s  Fields to select (comma seperated with range)         (default: all fields)\n";
	print "  -v  Print version information and exit\n";
	print "  -x  Print empty attribute values\n";
	print "  If any options are omitted defaults will be used.\n";
	print "\nYou can use ranges (e.g. '2,4-6') with parameters -i and -s.\n";
	print "\n";
	print "For EXCEL csv exports you probably need to adjust -e and -d,\n";
	print "however this depends on the EXCEL version and your region:\n";
	print "  ´$0 -e 'CP850' -d ';' [more ortions]´\n";
	print "\nMore Help and some hints are available using the -h parameter.\n\n";
}

sub help {
	usage();
	print "\nFormat of CSV:\n";
	print "   The first line is a comma-separated list of attribute name descriptors.\n";
	print "   Lines equal to or more than the second line are comma-separated lists\n";
	print "   of attribute values.\n";
	print "   You must not include the delimeter character in an attribute value.\n";
	print "   If you want to do that, quote the value and specify the quoting character.\n";
	print "\nExample of CSV:\n";
	print "   --snip--\n";
	print "     cn,multivalattr,multivalattr,mail,objectClass\n";
	print "     Foo Bar,multivalue1,multivalue2,foo.bar\@example.com,inetOrgPerson\n";
	print "     Test Baz,\"value,including,delimeter\",,test.baz\@example.com,inetOrgPerson\n";
	print "   --snap--\n";
	print "\nHow to generate multivalued attributes:\n";
	print "   As shown in the example above, generating multivalued attributes is quite easy:\n";
	print "   just use the same attribute name in the first line of the CSV for all columns which\n";
	print "   make up the values of the multivalued attribute ('multivalattr' in this case).\n";
	print "\nComposing the DN:\n";
	print "   The DN is composed by using a naming attribute which is selected using the -c and\n";
	print "   -f options. You can generate a naming attribute composed of several attribute values\n";
	print "   as string, by default the values are separated using '$cnsep' which can be\n";
	print "   overridden using -F.\n";
	print "\nParameter -b 'basedn':\n";
	print "   The basedn is appended to the CN, wich in turn is composed with the first field\n";
	print "   of the CSV dataset (if not specified otherwise using -c and -f). With basedn you\n";
	print "   can define the place, wehre the entries should be placed in the directory.\n";
	print "\nParameter -q 'quote character':\n";
	print "   This parameter enables you to define a character you can enclose the field value\n";
	print "   to be able to use the field separator inside the field value.\n";
	print "   If you want to turn off quoting support at all, just use '' (empty) as parameter.\n";
	print "\nSelecting and ignoring Fields using parameters -s and -i:\n";
	print "   You can select and ignore fields from the CSV file by specifying -s and -i.\n";
	print "   Note, that you can combine both parameters. This is useful, if you just want to\n";
	print "   select some fields which are close togehter but not consecutive and you use ranges.\n";
	print "   For example if you have 10 fields, but want only 5,6,8 and 9 then you can do this by\n";
	print "   calling `$0 -s '5-9' -i '7'`\n";
	print "\nError reporting:\n";
	print "   Error messages go to stderr, while normal program output goes to stdout. You\n";
	print "   are strongly encouraged to redirect error output to some sort of log because\n";
	print "   otherwiese your LDIF may become corrupt (but we add a '#' in front of the msg)\n";
	print "\nEncoding of data and LDIF files (EXCEL anyone?):\n";
	print "   The input data can be supplied in different encodings. In default operation, the\n";
	print "   program is compatible to EXCEL-CSV and most LDAP servers. EXCEL for example usually,\n";
	print "   amongst others, exports CSV data in the CP850 or CP1252 codeset, however this\n";
	print "   depends on the exact EXCEL version and your region (search the internet for more).\n";
	print "   Because latin1 is more widely used, we use it as default input encoding. You can\n";
	print "   change the input encoding with the -e parameter (or use the program 'recode').\n";
	print "   RFC-2849 requires LDIF files to be ASCII compliant. All non-ASCII characters are\n";
	print "   required to be in UTF-8 encoding and will be represented by a base64 string.\n\n";
	print "   In some very rare circumstances it may be required to change the encoding of the\n";
	print "   base64 content. Use the -E parameter to define the output encoding of values.\n";
	print "   With -B, you can request that base64 encoding of such attributes is skipped.\n";
	print "\nTricks:\n";
	print "   You can use piping, like parsing an EXCEL CSV and adding it to LDAP in one go:\n";
	print "     'csv2ldif2.pl (...) < input.csv | ldapadd (...)'\n";
	print "   Or supply filters: 'cat foo.csv | someCMD | csv2ldif2.pl (...)'\n";
}

sub version {
	print "$0: Convert CSV to LDIF   (Ver 1.1)\n";
}
