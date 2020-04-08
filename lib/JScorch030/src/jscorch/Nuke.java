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
 * a Nuke
 */
public class Nuke extends Missile {
	/**
	 * creates a new Nuke
	 */
	public Nuke(Tank owner,Point loc,int angle, int power) {
		super(owner,loc,angle,power);
		expType = WeaponTypes.NUKE;
	}
}