package jscorch;

/**
 * <p>Title: JScorch</p>
 * <p>Description: Scorched Earth for Java</p>
 * <p>Copyright: Copyright (c) 2001</p>
 * <p>Company: HK Creations</p>
 * @author Andrew Cooper
 * @version 1.0
 */
import java.awt.Point;

/**
 * a utility class used to create and return an Explosion when given the type
 * of Explosion to make and the data to pass along. Used so objects which need
 * Explosions need only keep track of an integer type.
 */
public abstract class ExplosionTypes extends WeaponTypes{
	/**
	 * creates and returns a new explosion of the given type t, and passing along
	 * the other given info
	 * @param t the type of Explosion to make
	 * @param o the owner of the new Explosion
	 * @param loc the location of the new Explosion
	 * @return a new Explosion
	 */
	public static Explosion newExplosion(int t,Tank o, Point loc) {
		Explosion newExplosion;
		switch(t) {
			case BABY_MISSILE:
			case NORMAL_MISSILE:
			case BABY_NUKE:
			case NUKE:
			case MIRV:
			case DEATH_HEAD:
				newExplosion = new CircularExplosion(o,loc,t);
				break;
			case LEAP_FROG:
				newExplosion = new LeapFrogExplosion(o,loc,t);
				break;
			case FUNKY_BOMB:
				newExplosion = new FunkyBombExplosion(o,loc,t);
				break;
			default:
				System.out.println("Error creating new explosion: type "+t+" does not exist.");
				return null;
		}
		return newExplosion;
	}
}