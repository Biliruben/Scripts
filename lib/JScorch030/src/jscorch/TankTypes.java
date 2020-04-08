package jscorch;

/**
 * <p>Title: JScorch</p>
 * <p>Description: Scorched Earth for Java</p>
 * <p>Copyright: Copyright (c) 2001</p>
 * <p>Company: HK Creations</p>
 * @author Andrew Cooper
 * @version 1.0
 */
import java.awt.*;

/**
 * a utility class providing means for creating new tanks given an integer type.
 * the other paramaters are passed along to the new Tank's constructor. this
 * class is used as a convenience so objects needing to use Tank's need only
 * keep an integer type, while relying on this class for all the details of
 * deciding which constructor to use.
 */
public class TankTypes {
	/** a Box Tank */
	static final int BOX = 0;
	/** an Oval Tank */
	static final int OVAL = 1;
	/** a Triangle Tank */
	static final int TRI = 2;
	/** String array of type names */
	static final String[] names = {"Box","Oval","Triangle"};

	/**
	 * creates and returns a new tank using the given type, and passing along
	 * the other paramaters
	 * @param t the type
	 * @param c the new Tank's holder
	 * @param own the new Tank's owner
	 */
	public static Tank newTank(int t, ActionArea a,Player own) {
		Tank newTank = new Tank(a,own,t);
/*		switch (t) {
			case BOX:
				newTank = new BoxTank(c,own);
				break;
			case OVAL:
				newTank = new OvalTank(c,own);
				break;
			case TRI:
				newTank = new TriTank(c,own);
				break;
			default:
				System.out.println("Error in creation of new Tank: "+t+" is not a type");
				return null;
		}*/
		return newTank;
	}
	public static String[] getTypeNames() {
		return names;
	}
}
