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
import java.awt.image.*;

public class CircularExplosion extends Explosion {
	//painting vars
	Color color = new Color(255,100,0);
	Color white = Color.white;
	Color clear = new Color(1f,1f,1f,0f);
	Paint gradPaint;
	Paint shockwavePaint;

	//inherited vars
	Tank owner;

	//Linked List vars
	Explosion next,prev;

	//layout positioning
	Rectangle bounds;

	//motion vars
	Point center;
	double time;
	int rad,SPEED,POWER,MINRAD;
	public int MAXRAD;
	int MAXTOTRAD,SHOCKRAD;
	boolean expanding,shockwave,active;

	public CircularExplosion(Tank o, Point loc, int type) {
		this(o,loc,type,true);
	}

	public CircularExplosion(Tank o, Point loc, int type,boolean check) {
		super(o,loc);
		rad = 0;
		time = 0;
		expanding = true;
		shockwave = false;
		owner = o;

		switch(type) {
			case ExplosionTypes.BABY_MISSILE:
				SPEED = 2; //how fast it expands and contracts
				POWER = 50; //how much damage a direct hit will do, %
				MINRAD = 0; //the smallest radius this can have
				MAXRAD = 10; //the biggest radius this can have
				break;
			case ExplosionTypes.NORMAL_MISSILE: case ExplosionTypes.LEAP_FROG:
				SPEED = 2;
				POWER = 75;
				MINRAD = 0;
				MAXRAD = 14;
				break;
			case ExplosionTypes.BABY_NUKE:
			case ExplosionTypes.MIRV:
			case ExplosionTypes.DEATH_HEAD:
			case ExplosionTypes.FUNKY_BOMB:
				SPEED = 2;
				POWER = 100;
				MINRAD = 0;
				MAXRAD = 24;
				break;
			case ExplosionTypes.NUKE:
				SPEED = 2;
				POWER = 125;
				MINRAD = 0;
				MAXRAD = 30;
				break;
			default:
				SPEED = 0;
				POWER = 0;
				MINRAD = 0;
				MAXRAD = 0;
				break;
		}
		SHOCKRAD = MAXRAD/3;
		if (check && Preferences.WALL_TYPE == GameConstants.WALL_WRAPPING) {
			if (loc.x - MAXRAD < 0) {
				container.addExplosion(new CircularExplosion(owner,new Point(loc.x+container.getWidth(),loc.y),type,false));
			} else if (loc.x + MAXRAD > container.getWidth()) {
				container.addExplosion(new CircularExplosion(owner,new Point(loc.x-container.getWidth(),loc.y),type,false));
			}
		}

		center = loc;
		MAXTOTRAD = MAXRAD+SHOCKRAD;
		gradPaint = new RoundGradientPaint(MAXRAD,MAXRAD,white,MAXRAD,color);
		shockwavePaint = new RoundGradientPaint(MAXTOTRAD,MAXTOTRAD,clear,2*MAXRAD,color);

		this.setBounds(loc.x,loc.y,0,0);
	}

	/**
	 * calculates the size based on the time step. the SPEED variable determines
	 * how much the explosion should expand per frame, and the time step should
	 * be the time for one frame to execute. The explosion expands to the max size,
	 * adds a damager to the ActionArea, and then shrinks to the minimum size.
	 * @param step time length of one frame
	 */
	public void expand(int step) {
		if (expanding) {
			if (!shockwave) {
				rad += SPEED;
				if (rad >= MAXRAD) {
					owner.getContainer().addDamager(new Damager(this));
					shockwave = true;
				}
			} else {
				rad+=SPEED;
				if (rad >= MAXTOTRAD) {
					expanding = false;
				}
			}
		} else {
			if (shockwave) {
				rad-=SPEED;
				shockwavePaint = new RoundGradientPaint(rad,rad,clear,2*rad,color);
				if (rad <= MAXRAD) {
					shockwave = false;
				}
			} else {
				rad -= SPEED;
				if (rad < MINRAD) {
					owner.getContainer().removeExplosion(this);
				}
			}
		}
		gradPaint = new RoundGradientPaint(rad,rad,white,rad,color);
		this.setBounds(center.x-rad,center.y-rad,2*rad,2*rad);
	}

	/**
	 * returns the power of this explosion, or the %damage of a perfect direct hit
	 * @return integer power
	 */
	public double getPower() {
		return POWER;
	}

	/**
	 * overridden method, paints the Explosion in the given Graphics context
	 * @param g the graphics context to paint in
	 */
	public void paintComponent(Graphics g) {
		Graphics2D g2 = (Graphics2D) g;

		if (shockwave) {
			g2.setPaint(shockwavePaint);
			g2.fillOval(0,0,2*rad,2*rad);
			g2.setPaint(gradPaint);
			g2.fillOval(rad-MAXRAD,rad-MAXRAD,2*MAXRAD,2*MAXRAD);
		} else {
			g2.setPaint(gradPaint);
			g2.fillOval(0,0,2*rad,2*rad);
		}
	}
//end class
}