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
import javax.swing.*;

/**
 * a Baby Missile
 */
public class BabyMissile extends Missile{
	/**
	 * creates a new Baby Missile
	 */
	public BabyMissile(Tank o,Point loc,int angle, int power) {
		super(o, loc, angle, power);
		expType = WeaponTypes.BABY_MISSILE;
	}
}
