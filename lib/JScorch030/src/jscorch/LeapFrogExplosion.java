package jscorch;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author unascribed
 * @version 1.0
 */
import java.awt.*;

public class LeapFrogExplosion extends CircularExplosion {

	public LeapFrogExplosion(Tank o, Point loc,int type) {
		super(o,loc,type);
		int angle = (int)(Math.random()*60+60);
		int power = (int)(Math.random()*50+50);
		owner.getContainer().addWeapon(WeaponTypes.newWeapon(WeaponTypes.LEAP_FROG, owner, loc, angle, power));
		angle = (int)(Math.random()*60+60);
		power = (int)(Math.random()*50+50);
		owner.getContainer().addWeapon(WeaponTypes.newWeapon(WeaponTypes.LEAP_FROG, owner, loc, angle, power));
	}
}