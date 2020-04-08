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
 * a utility class providing a way to create new Weapons given an integer type.
 */
public abstract class WeaponTypes {
	/** type for Baby Missile */
	public static final int BABY_MISSILE = 0;
	/** type for Normal Missile */
	public static final int NORMAL_MISSILE = 1;
	/** type for Baby Nuke */
	public static final int BABY_NUKE = 2;
	/** type for Nuke */
	public static final int NUKE = 3;
	/** type for LeapFrog */
	public static final int LEAP_FROG = 4;
	/** type for Mirv Missile */
	public static final int MIRV = 5;
	/** type for Funky Bomb */
	public static final int FUNKY_BOMB = 6;
	/** type for Death's Head */
	public static final int DEATH_HEAD = 7;
	/** array of Weapon Names */
	static final String[] weapList = {"Baby Missile","Normal Missile","Baby Nuke","Nuke","Leap Frog","Mirv","Funky Bomb","Death's Head"};
	/** total number of weapon types */
	public static final int NUM_TYPES = weapList.length;

	/**
	 * creates and returns a new instance of a Weapon of the given type.
	 * passes along all other arguments to the constructor of the Weapon.
	 * @param t type
	 * @param o the owning Tank
	 * @param loc the location of the Weapon
	 * @param ang the initial angle
	 * @param pow the power of the Weapon
	 */
	public static Weapon newWeapon(int t,Tank o, Point loc,int ang,int pow) {
		Weapon newWeapon;
		switch(t) {
			case BABY_MISSILE:
				newWeapon = new BabyMissile(o,loc,ang,pow);
				break;
			case NORMAL_MISSILE:
				newWeapon = new NormalMissile(o,loc,ang,pow);
				break;
			case BABY_NUKE:
				newWeapon = new BabyNuke(o,loc,ang,pow);
				break;
			case NUKE:
				newWeapon = new Nuke(o,loc,ang,pow);
				break;
			case LEAP_FROG:
				newWeapon = new LeapFrog(o,loc,ang,pow,2);
				break;
			case MIRV:
				newWeapon = new Mirv(o,loc,ang,pow);
				break;
			case FUNKY_BOMB:
				newWeapon = new FunkyBomb(o,loc,ang,pow);
				break;
			case DEATH_HEAD:
				newWeapon = new DeathHead(o,loc,ang,pow);
				break;
			default:
				System.out.println("Error in creation of new Weapon: "+t+" is not a type");
				return null;
		}
		return newWeapon;
	}
	/**
	 * returns an array of strings containing the names of each Weapon
	 * @return array of Strings
	 */
	public static String[] getWeaponList() {
		return weapList;
	}
	/**
	 * taking a String as an argument, returns the type of the Weapon
	 * @param s a String which starts with the name of a Weapon
	 * @return the type of the Weapon
	 */
	public static int getIntFromString(String s) {
		for (int i=0;i<weapList.length;i++) {
			if (s.startsWith(weapList[i]))
				return i;
		}
		System.out.println(s+" is not a valid Weapon Type.");
		return -1;
	}
	/**
	 * given an integer type, returns the name of the Weapon as a String
	 */
	public static String getStringFromInt(int n) {
		return weapList[n];
	}
}