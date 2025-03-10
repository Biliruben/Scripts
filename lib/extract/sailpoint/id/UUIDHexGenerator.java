//$Id: UUIDHexGenerator.java,v 1.10 2005/08/30 23:28:50 turin42 Exp $
package sailpoint.id;

import java.io.Serializable;
import java.util.Properties;


/**
 * <b>uuid</b><br>
 * <br>
 * A <tt>UUIDGenerator</tt> that returns a string of length 32,
 * This string will consist of only hex digits. Optionally,
 * the string may be generated with separators between each
 * component of the UUID.
 *
 * Mapping parameters supported: separator.
 *
 * @author Gavin King
 */

public class UUIDHexGenerator extends AbstractUUIDGenerator {

	private String sep = "";

	protected String format(int intval) {
		String formatted = Integer.toHexString(intval);
		StringBuffer buf = new StringBuffer("00000000");
		buf.replace( 8-formatted.length(), 8, formatted );
		return buf.toString();
	}

	protected String format(short shortval) {
		String formatted = Integer.toHexString(shortval);
		StringBuffer buf = new StringBuffer("0000");
		buf.replace( 4-formatted.length(), 4, formatted );
		return buf.toString();
	}

	public Serializable generate() {
		return new StringBuffer(36)
			.append( format( getIP() ) ).append(sep)
			.append( format( getJVM() ) ).append(sep)
			.append( format( getHiTime() ) ).append(sep)
			.append( format( getLoTime() ) ).append(sep)
			.append( format( getCount() ) )
			.toString();
	}

	public static void main( String[] args ) throws Exception {
	    long toConvert = 5343122154L;
	    int converted = (int) toConvert;
	    System.out.println(converted);
		Properties props = new Properties();
		props.setProperty("separator", "/");
		UUIDHexGenerator gen = new UUIDHexGenerator();
		UUIDHexGenerator gen2 = new UUIDHexGenerator();
		for ( int i=0; i<10; i++) {
			String id = (String) gen.generate();
			System.out.println(id);
			String id2 = (String) gen2.generate();
			System.out.println(id2);
		}

	}

}
