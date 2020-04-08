SailPoint Peformance Toolkit 2.0
Feb 18th 2011

--
Directory Contents
benchmarker.xml - The taskdefinition for the data creation utility
csvcreator.xml - The taskdefinition for the create CSV file utility
ldapcreator.xml - The taskdefinition for creating data within a LDAP repository
spaccount.ldif - The schema needed for creating external LDAP entries with the load testing tool
perftool2.jar - Release 2.0 of the performance toolkit

--
Installation
To install the toolkit, simply place the perftool2.jar file into the application server classpath.  
This is typically in the ./WEB-INF/lib directory.  Remove any previous versions of the toolkit jar file.

For each task that needs to be run within IIQ, the appropriate task file(s) need to be imported.  
This can be achieved via the console using the import command as shown below:

>import benchmarker.xml


