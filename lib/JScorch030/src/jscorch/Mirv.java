package jscorch;

/**
 * <p>Title: JScorch</p>
 * <p>Description: Scorched Earth for Java</p>
 * <p>Copyright: Copyright (c) 2001</p>
 * <p>Company: HK Creations</p>
 * @author Andrew Cooper
 * @version 1.0
 */
 import java.awt.geom.*;
 import java.awt.*;
 import javax.swing.*;

 /**
  * a Mirv Missile, one that splits into 3 missiles when it reaches
  * its max height
  */
public class Mirv extends BabyNuke {
	private Point oldLoc = new Point();
	private int num = 5;
	/**
	 * creates a new Mirv Missile
	 */
	public Mirv(Tank o,Point loc,int angle, int power) {
		super(o,loc,angle,power);
	}
	/**
	 * called once per frame, gets the new position of the Missile and
	 * makes sure the position is still valid
	 * @param step the time for one frame to happen
	 */
	public void move(int step) {
		oldLoc.x = curLoc.x; oldLoc.y = curLoc.y;
		super.move(step);
		if (curLoc.y > oldLoc.y) {
			split();
		}
	}
	/**
	 * this method is called when the Mirv reaches its height and must split into 3 missiles
	 */
	protected void split() {
		ActionArea a = owner.getContainer();
		a.removeWeapon(this);
		int type = WeaponTypes.NORMAL_MISSILE;
		double vx = path.getVelocity().x;
		for (int i=0;i<num;i++) {
			a.addWeapon(WeaponTypes.newWeapon(type,owner,new Point(curLoc),0,(int)((i+num/2)*vx/(num-1))));
		}
	}
}