package jscorch;

/**
 * <p>Title: JScorch</p>
 * <p>Description: Scorched Earth for Java</p>
 * <p>Copyright: Copyright (c) 2001</p>
 * <p>Company: HK Creations</p>
 * @author Andrew Cooper
 * @version 1.0
 */
import javax.swing.*;
import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.image.*;
import java.awt.event.*;

/**
 * Top level class for graphic representations of Tanks on the playing field.
 * A Tank keeps track of its health, status, power, and angle. Also, the Tank
 * knows the container is belongs in and the Player which owns it.
 */
public class Tank extends Sprite{
	private Point center;
	private Player owner;

	//painting vars
	private BufferedImage tankImage;
	private BufferedImage barrelImage;
	private AffineTransform transform;
//	private Color outlineColor = Color.black;
//	private BasicStroke outline = new BasicStroke(1.0f);
//	private BasicStroke barrel = new BasicStroke(2.0f);
//	private BasicStroke barrelOutline = new BasicStroke(4.0f);

	private int LENGTH = 10;
	private int OUT_DIAM = 4;
//	private int IN_DIAM = 2;
	private int tankType = 0;
	private Point pivot;

	private Shield shield;
	private double health;
	private int fuel;
	private int energy;
	private int safetyThreshold;

	private boolean chutesActive,triggerArmed,guidanceArmed,alive,current;
	private int angle,power,barrelX,barrelY;

	/**
	 * initializes the variables for the tank to defaults
	 * @param par where the Tank is held
	 * @param own the owner of the Tank
	 * @param t the type of the Tank
	 */
	public Tank(ActionArea aa, Player own,int type) {
		container = aa;
		owner = own;
		setOpaque(false);

		angle = (int)(Math.random()*180);
		power = 50;
		health = 100;
		fuel = 0;
		safetyThreshold = 0;
		chutesActive = false;
		triggerArmed = false;
		guidanceArmed = false;
		alive = true;
		current = false;
		setType(type);
		center = new Point(WIDTH/2,HEIGHT/2);
		setSize(new Dimension(WIDTH,HEIGHT));
		shield = ShieldTypes.makeShield(this,ShieldTypes.NO_SHIELD);
		setToolTipText(owner.getName());
//		this.getToolTipText();
	}

	public boolean checkCollision(Point p) {
		if (alive) {
			if (getBounds().contains(p)) {
				int x = p.x - getLocation().x;
				int y = p.y - getLocation().y;
				if( ((tankImage.getRGB(x,y) & 0xFF000000)>>>24) == (0xFF) ) {
					return true;
				}
			}
		}
		return false;
	}
	/**
	 * doles out damage from a Damager. if the Tank is destroyed, goes
	 * through the Damager to let the killer know.
	 * @param d the damage
	 * @param dam the Damaager
	 */
	public void damage(double d,Damager dam) {
		if(alive) {
			d = shield.damage(d);
			health -= d;
			if (health <= 0) {
				health = 0;
				dam.getExplosion().getTank().getPlayer().giveKill(this);
				explode();
			}
		}
	}
	/**
	 * used when a tank has lost all of its health and destruction is imminent.
	 */
	public void explode () {
		int t = getPlayer().getWeaponLocker().getCurrent();
		Point c = this.getCenter();
		alive = false;
		container.removeTank(this);
		container.addExplosion(ExplosionTypes.newExplosion(t,this,c));
	}

	/**
	 * implements firing for the Tank. finds the point at the end of the Tank's
	 * barrel and adds the appropriate weapon there, using the current angle
	 * and power
	 */
	public void fire() {
		int barrelX = (int)((LENGTH+1)*JScorchUtils.cos(angle));
		int barrelY = (int)((LENGTH+1)*JScorchUtils.sin(angle));
		Point l = this.getLocation();
		l.translate(pivot.x+barrelX,pivot.y-barrelY);
		WeaponLocker wl = owner.getWeaponLocker();
		int type = wl.getCurrent();
		container.addWeapon(wl.useWeapon(type,this,l,angle,power));
	}

	/**
	 * returns the angle of the barrel, from 0 to 90. The position(left
	 * or right) isn't important, only the magnitude of the angle.
	 * @return integer angle
	 */
	public int getAngle() {
		if (angle <= 90) {
			return angle;
		} else {
			return (180-angle);
		}
	}
	/**
	 * returns the center point of the Tank in real-world coordinates
	 * @return center point
	 */
	public Point getCenter() {
		return (new Point(getBounds().x+center.x,getBounds().y+center.y));
	}
	public boolean getChutesActive() {
		return chutesActive;
	}
	public int getEnergy() {
		return energy;
	}
	public int getFuel() {
		return fuel;
	}
	public boolean getGuidanceArmed() {
		return guidanceArmed;
	}
	/**
	 * returns the health of the Tank
	 * @return health in double precision
	 */
	public double getHealth() {
		return health;
	}
	/**
	 * returns the Player who owns this Tank
	 * @return owner
	 */
	public Player getPlayer() {
		return owner;
	}
	/**
	 * returns the current power of the Tank
	 * @return integer power
	 */
	public int getPower() {
		return power;
	}
	public int getSafetyThreshold() {
		return safetyThreshold;
	}
	public Shield getShield() {
		return shield;
	}
	public String getToolTipText() {
		String pre = "<html><font face=system size=0>";
		String post = "</font></html>";
//		return super.getToolTipText();
//		return (pre+"line1 <br>line2 <br>line3"+post);
		return (pre+"Shield: "+(int)shield.getHealth()+"%<br>Armor: "+(int)health+"%<br></font><font face=system size=1>"+owner.getName()+post);
	}
	public boolean getTriggerArmed() {
		return triggerArmed;
	}
	/**
	 * returns the type of the Tank
	 * @return type
	 */
	public int getType() {
		return tankType;
	}

	/**
	 * returns the status of the Tank(alive or dead)
	 * @return boolean status
	 */
	public boolean isAlive() {
		return alive;
	}
	/**
	 * returns true or false for if the Tank is the current one
	 * @return boolean current
	 */
	public boolean isCurrent() {
		return current;
	}
	public void move(int d) {
		//does nothing!!
	}
	/**
	 * paints the component, type depending on what the type of the tamk is.
	 * @param g the graphics context
	 */
	public void paintComponent(Graphics g) {
		Graphics2D g2 = (Graphics2D) g;
		g2.drawImage(barrelImage,transform,this);
		g2.drawImage(tankImage,0,0,this);
	}
	/**
	 * increments the angle by the delta. also wraps around if the angle
	 * goes below 0 or above 180
	 * @param delta the increment
	 */
	public void setAngle(int delta) {
		angle += delta;
		transform.rotate(-1*Math.toRadians(delta),0,OUT_DIAM/2.0);
		if (angle > 180) {
			angle = 0;
			transform.rotate(-Math.PI,0,OUT_DIAM/2.0);
		}
		if (angle < 0) {
			angle = 180;
			transform.rotate(Math.PI,0,OUT_DIAM/2.0);
		}
		repaint();
	}
	public void setChutesActive(boolean b) {
		chutesActive = b;
	}
	/**
	 * sets the current status(true or false)
	 * @param b boolean current status
	 */
	public void setCurrent(boolean b) {
		current = b;
	}
	public void setFuel(int f) {
		fuel = f;
	}
	public void setGuidanceArmed(boolean b) {
		guidanceArmed = b;
	}
	public void setLocation(int x, int y) {
		super.setLocation(x,y);
		shield.setLocation(getCenter().x-shield.WIDTH/2,getCenter().y-shield.HEIGHT/2);
	}

	/**
	 * increments the power of the Tank by delta. sets max at 100 and min at 0
	 * @param delta the increment
	 */
	public void setPower(int delta) {
		power += delta;
		if (power > 100)
			power = 100;
		if (power < 0)
			power = 0;
	}
	public void setSafetyThreshold(int s) {
		safetyThreshold = s;
	}
	public void setShield(Shield s) {
		container.removeShield(shield);
		shield = s;
		container.addShield(shield);
	}
	public void setTriggerArmed(boolean b) {
		triggerArmed = b;
	}
	/**
	 * sets the type of this tank
	 * @param t the type
	 */
	public void setType(int t) {
		tankType = t;
		initImage();
	}
//	private void initImage() {
//		Graphics2D g2;
//		Shape tankShape;
//		Color tankColor = owner.getColor();
//		tankImage = new BufferedImage(WIDTH,HEIGHT,BufferedImage.TYPE_INT_ARGB);
//		barrelImage = new BufferedImage(this.LENGTH,this.OUT_DIAM,BufferedImage.TYPE_INT_RGB);
//		transform = new AffineTransform();
//		transform.translate(center.x-1,center.y-1);
//		transform.rotate(-angle*Math.PI/180.0,0,OUT_DIAM/2);
//
//		g2 = barrelImage.createGraphics();
//		g2.setPaint(this.outlineColor);
//		g2.fillRect(0,0,this.LENGTH,this.OUT_DIAM);
//		g2.setPaint(tankColor);
//		g2.fillRect(0,(OUT_DIAM-IN_DIAM)/2,LENGTH - (OUT_DIAM-IN_DIAM)/2,IN_DIAM);
//
//		g2 = tankImage.createGraphics();
//		g2.setPaint(tankColor);
//		switch(tankType) {
//			case TankTypes.BOX:
//				tankShape = new Rectangle(0,HEIGHT/2,WIDTH-1,HEIGHT/2);
//				g2.fill(tankShape);
//				g2.setPaint(outlineColor);
//				g2.setStroke(outline);
//				g2.draw(tankShape);
//				break;
//			case TankTypes.OVAL:
//				tankShape = null;
//				g2.fillOval(0,HEIGHT/2,WIDTH,HEIGHT/2);
//				g2.setPaint(outlineColor);
//				g2.setStroke(outline);
//				g2.drawOval(0,HEIGHT/2,WIDTH,HEIGHT/2);
//				break;
//			case TankTypes.TRI:
//				int[] xcoords = {1       ,WIDTH/2 ,WIDTH-1 ,1};
//				int[] ycoords = {HEIGHT-1,HEIGHT/2,HEIGHT-1,HEIGHT-1};
//				tankShape = new Polygon(xcoords,ycoords,4);
//				g2.fill(tankShape);
//				g2.setPaint(outlineColor);
//				g2.setStroke(outline);
//				g2.draw(tankShape);
//				break;
//		}
	private void initImage() {
		Color tankColor = owner.getColor();
		float[] components = new float[4];
		float o = 0f;
		float[] offsets = {o,o,o,0f};
		tankColor.getComponents(components);
		for (int i = 0; i < components.length-1; i++) {
			components[i] *= 1.5;
		}

		RescaleOp filter = new RescaleOp(components,offsets,null);
		BufferedImage t = JScorchUtils.getBufImage(this,"images/tanks/tank1.png");
		tankImage = filter.filter(t,null);
		WIDTH = t.getWidth(); HEIGHT = t.getHeight();
		BufferedImage b = JScorchUtils.getBufImage(this,"images/tanks/barrel1.png");
		barrelImage = filter.filter(b,null);
		pivot = new Point(15,7);
		LENGTH = barrelImage.getWidth();
		OUT_DIAM = barrelImage.getHeight();
		transform = new AffineTransform();
		transform.translate(pivot.x-1,pivot.y-1);
		transform.rotate(-1*Math.toRadians(angle),0,OUT_DIAM/2.0);
	}
//end of class
}
