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
 * a Normal Missile
 */
public class NormalMissile extends Missile{
	/**
	 * creates a new Normal Missile
	 */
	public NormalMissile(Tank owner,Point loc,int angle, int power) {
		super(owner,loc,angle,power);
		expType = WeaponTypes.NORMAL_MISSILE;
	}
}
