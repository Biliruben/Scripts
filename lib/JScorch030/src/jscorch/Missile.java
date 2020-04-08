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
import java.awt.image.BufferedImage;
import javax.swing.*;
import java.awt.geom.*;
import java.net.URL;

/**
 * superclass for missile weapons; weapons which move along a projectile path.
 */
public class Missile extends Weapon{
	//inherited vars
	Tank owner;
	Rectangle bounds;

	//motion vars
	Trajectory path;
	boolean clearedShield;
	Point curLoc;
	Point lastLoc;

	//size vars
	int expType=0;

	//painting vars
	BufferedImage image;
	Color color = Color.white;
	BasicStroke outline = new BasicStroke(1f);

	/**
	 * initializes Missile global variables.
	 * @param own the owning Tank
	 * @param startLoc starting location of the Missile
	 * @param angle the intial angle of the Missile
	 * @param power the power of the Missile
	 */
	public Missile(Tank own, Point startLoc, int angle, int power) {
		super();
		owner = own;
		container = owner.getContainer();
		setOpaque(false);
		WIDTH = 3;
		HEIGHT = 3;
		startLoc.translate(-WIDTH,-HEIGHT);

		//create start & velocity vectors
		double velX = power/100.0*Physics.getVScale()*JScorchUtils.cos(angle);
		double velY = power/100.0*Physics.getVScale()*JScorchUtils.sin(angle);
		Point2D.Double vel = new Point2D.Double(velX,velY);

		//create a new projectile motion path
		path = new Trajectory(vel,startLoc,owner.getContainer().getBounds());
		lastLoc = new Point();
		curLoc = path.getPositionAtTime(0);

		//set up imaging
		image = new BufferedImage(WIDTH,HEIGHT,BufferedImage.TYPE_INT_ARGB);
		Graphics2D g2 = image.createGraphics();
		g2.setPaint(Color.black);
		g2.fillOval(0,0,WIDTH,HEIGHT);
		g2.setPaint(Color.white);
		g2.fillOval(1,1,WIDTH-2,HEIGHT-2);

		//set boundary variables
		bounds = new Rectangle(curLoc,new Dimension(WIDTH,HEIGHT));
		this.setBounds(bounds);
	}

	/**
	 * called once per frame, gets the new position of the Missile and
	 * makes sure the position is still valid
	 * @param step the time for one frame to happen
	 */
	public void move(int step) {
		int inc = 2;
		for (int i = 1; i <= step; i+=inc) {
			lastLoc.x = curLoc.x; lastLoc.y = curLoc.y;
			curLoc = path.getPositionAtTime(inc);
			if (curLoc != null) {
				if (!getContainer().pointIsValid(curLoc)) {
					if (clearedShield) {
						curLoc = lastLoc;
						explode();
						getContainer().removeWeapon(this);
						break;
					} else {
						if (owner.getShield().getCenter().distance(curLoc) > owner.getShield().getRadius()) {
							clearedShield = true;
						}
					}
				} else {
					if (!clearedShield) {
						if (owner.getShield().getCenter().distance(curLoc) > owner.getShield().getRadius()) {
							clearedShield = true;
						}
					}
				}
				if (i+inc > step) {
					curLoc.translate(-WIDTH/2,-HEIGHT/2);
					bounds.setLocation(curLoc);
					this.setBounds(bounds);
				}
			} else {
				getContainer().removeWeapon(this);
				break;
			}
		}
	}

	/**
	 * happens when a Missile reaches an invalid location and thus explodes
	 */
	protected void explode() {
		getContainer().addExplosion(ExplosionTypes.newExplosion(expType,owner,curLoc));
	}
	/**
	 * overridden method, paints the Missile in the given praphics context
	 * @param g the graphics context
	 */
	public void paintComponent(Graphics g) {
		Graphics2D g2 = (Graphics2D) g;
		g2.drawImage(image,0,0,this);
	}
}//end class

