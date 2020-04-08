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
 * a Baby Nuke
 */
public class BabyNuke extends Missile {
	/**
	 * creates a new Baby Nuke
	 */
	public BabyNuke(Tank owner,Point loc,int angle, int power) {
		super(owner,loc,angle,power);
		expType = WeaponTypes.BABY_NUKE;
	}
}