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
import java.awt.image.*;
import java.awt.geom.*;
import javax.swing.*;

/**
 * an Explosion for a Funky Bomb. Also initializes the smaller explosions
 * connected with the Funky Bomb.
 */
public class FunkyBombExplosion extends CircularExplosion {
	FunkyBombPanel fbPanel;

	/**
	 * creates a new Explosion, passing along the owner and location for initialization
	 * Also, because a Funky Bomb has 5 other smaller explosions associated with it,
	 * this sets things up to get those created.
	 */
	public FunkyBombExplosion(Tank own, Point loc, int type) {
		super(own,loc,type);

		ActionArea a = owner.getContainer();
		Rectangle r = a.getBounds();
		fbPanel = new FunkyBombPanel(a,r,loc,own);
		a.addMisc(fbPanel);
	}
	public void expand(int step) {
		super.expand(step);
		if (!expanding && rad < MINRAD) {
			owner.getContainer().removeMisc(fbPanel);
		}
	}
}

/**
 * Companion class to the Funky Bomb, this panel provides a canvas for drawing
 * the projectile paths to the other 5 explosions of the Funky Bomb.
 * @param c the container for the Explosions
 * @param r the rectangle for the bounds of this canvas
 * @param loc the starting point for all the paths
 * @param owner the owner of all the created explosions
 */
class FunkyBombPanel extends JLabel {
	BufferedImage image;
	int numCurves = 5;

	/**
	 * creates an instance of this canvas for adding Explosions for owner to c, drawing
	 * with r, and starting at loc
	 */
	public FunkyBombPanel(ActionArea c, Rectangle r, Point loc, Tank owner) {
		setBounds(r);
		setOpaque(false);

		image = new BufferedImage(r.width,r.height,BufferedImage.TYPE_INT_ARGB);
		Graphics2D g2 = image.createGraphics();

		int expType = WeaponTypes.NORMAL_MISSILE;
		int x0 = loc.x;	int y0 = loc.y;
		int x1; int y1;
		int x2; int y2;
		int x3; int y3;
		double width, height;
		int j;
		double xt,yt,t;
		double xt_o,yt_o;
		Point p;
		BasicStroke out = new BasicStroke(2.5f);
		BasicStroke in = new BasicStroke(1.5f);
		QuadCurve2D.Double curve;

		for (int i = 0;i < numCurves;i++) {
			do {
				x3 = (int)(Math.random()*400-200)+x0;
			} while (x3 < 0 || x3 >= r.width);
			j = 0;
			p = new Point(x3,j);
			while (j < r.height && c.pointIsValid(p)) {
				p.y = ++j;
			}
			y3 = j;
			width = (x3-x0);
			x1 = (int)(width/3+x0); y1 = (int)(y0/3);
			x2 = (int)(2*width/3+x0); y2 = (int)(y3/3);
			xt = x0; yt = y0;
			t = 0;
			p = new Point((int)xt,(int)yt);
			do {
				xt = x0*Math.pow(1-t,3) + 3*x1*t*Math.pow(1-t,2) + 3*x2*Math.pow(t,2)*(1-t) + x3*Math.pow(t,3);
				yt = y0*Math.pow(1-t,3) + 3*y1*t*Math.pow(1-t,2) + 3*y2*Math.pow(t,2)*(1-t) + y3*Math.pow(t,3);
				p.x = (int)xt; p.y = (int)yt;
				t += .005;
			} while (c.pointIsValid(p) && t <= 1 );
			width = (xt-x0);
			height = y0*(1-t);
			curve = new QuadCurve2D.Double(x0,y0,width/2.0+x0,height,xt,yt);
			g2.setStroke(in); g2.setPaint(Color.white);
			g2.draw(curve);
			c.addExplosion(ExplosionTypes.newExplosion(expType,owner,new Point((int)xt,(int)yt)));
		}
	}
	/**
	 * paints all the quadratic projectile motion curves in the Graphics context
	 * @param g the graphics context
	 */
	public void paintComponent(Graphics g) {
		super.paintComponent(g);
		Rectangle r = g.getClipBounds();
		g.drawImage(image,r.x,r.y,r.x+r.width,r.y+r.height,r.x,r.y,r.x+r.width,r.y+r.height,this);
	}
}