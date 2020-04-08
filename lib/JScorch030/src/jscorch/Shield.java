package jscorch;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author unascribed
 * @version 1.0
 */
import java.awt.geom.*;
import java.awt.*;
import java.awt.image.*;
import java.awt.event.*;
import javax.swing.*;

public class Shield extends Sprite implements ActionListener{
	protected Tank owner;
	protected double health = 0;
	protected int type = ShieldTypes.NO_SHIELD;
	protected double strengthFactor = 0;

	protected BufferedImage image;
	protected BufferedImage fimage;
	protected float[] rule = {1f,1f,1f,1f};
	protected float[] off = {0f,0f,0f,0f};
	protected RescaleOp op;
	protected Timer timer;
	protected int frames;
	protected int curFrame = 0;
	protected Point center;
	protected Point trueCenter;

	public Shield(Tank o, BufferedImage img) {
		owner = o;
		image = img;
		container = owner.getContainer();
		if (image != null) {
			health = 100;
			op = new RescaleOp(rule,off,null);
			fimage = op.filter(image,null);
			frames = image.getWidth()/image.getHeight();
			WIDTH = image.getHeight();
			HEIGHT = image.getHeight();
		}
		trueCenter = owner.getCenter();
		center = new Point(WIDTH/2,HEIGHT/2);
		this.setBounds(trueCenter.x - center.x,trueCenter.y - center.y,WIDTH,HEIGHT);
	}
	public double damage(double dam) {
		if (type != ShieldTypes.NO_SHIELD) {
			health -= strengthFactor*dam;
			if( health <= 0) {
				timer.stop();
				owner.setShield(ShieldTypes.makeShield(owner,ShieldTypes.NO_SHIELD));
				return Math.abs(health);
			} else {
				rule[3] = (float)(health/100.0);
				op = new RescaleOp(rule,off,null);
				op.filter(image,fimage);
				return 0;
			}
		} else {
			return dam;
		}
	}
	public Point getCenter() {
		return (new Point(getBounds().x+center.x,getBounds().y+center.y));
	}
	public double getHealth() {
		return health;
	}
	public Tank getOwner() {
		return owner;
	}
	public int getRadius() {
		return WIDTH/2;
	}
	public int getType() {
		return type;
	}
	public void actionPerformed(ActionEvent e) {
		curFrame++;
		if (curFrame == frames) {
			curFrame = 0;
		}
		repaint();
	}
	public void paintComponent(Graphics g) {
		super.paintComponent(g);
		if (type != ShieldTypes.NO_SHIELD) {
			g.drawImage(fimage,0,0,WIDTH,HEIGHT,curFrame*WIDTH,0,(curFrame+1)*WIDTH,HEIGHT,this);
		}
	}
}