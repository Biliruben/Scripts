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
 * a graphical helper class this merely displays an arrow indicating
 * the direction the wind is blowing. Right is positive, and left
 * is negative.
 */
public class WindDirLabel extends Sprite{
	int windDir;
	Polygon shape,pointLeft,pointRight,noWind;
	Graphics2D g2;
	BasicStroke outline = new BasicStroke(1.0f);
	Color fill = Color.cyan;
	Color line = Color.white;

	public static final int LEFT = -1;
	public static final int RIGHT = 1;
	public static final int NONE = 0;

	/**
	 * creates a new instance and then sets the direction.
	 */
	public WindDirLabel() {
		super();
		WIDTH = 15;
		HEIGHT = 15;
		Dimension size = new Dimension(WIDTH,HEIGHT);
		setMaximumSize(size);
		setPreferredSize(size);

		int numPts;
		int[] XL = {WIDTH-1,0,WIDTH-1,WIDTH-1};
		int[] YL = {0,HEIGHT/2-1,HEIGHT-1,0};
		numPts = 4;
		pointLeft = new Polygon(XL,YL,numPts);

		int[] XR = {0,WIDTH-1,0,0};
		int[] YR = {0,HEIGHT/2-1,HEIGHT-1,0};
		numPts = 4;
		pointRight = new Polygon(XR,YR,numPts);

		int[] XN = {WIDTH/4-1,3*WIDTH/4-1,3*WIDTH/4-1,WIDTH/4-1};
		int[] YN = {HEIGHT/4-1,HEIGHT/4-1,3*HEIGHT/4-1,3*HEIGHT/4-1};
		numPts = 4;
		noWind = new Polygon(XN,YN,numPts);

		changeDir();
	}

	/**
	 * sets the direction of the windLabel and repaints
	 */
	public void changeDir() {
		windDir = Physics.getWindDir();
		switch (windDir) {
			case LEFT:
				shape = pointLeft;
				break;
			case RIGHT:
				shape = pointRight;
				break;
			case NONE:
				shape = noWind;
				break;
			default:
		}
		repaint();
	}

	/**
	 * overridden method, paints the label in the given graphics context
	 */
	public void paintComponent(Graphics g) {
		g2 = (Graphics2D) g;
		g2.setPaint(line);
		g2.setStroke(outline);
		g2.drawPolygon(shape);
		g2.setPaint(fill);
		g2.fillPolygon(shape);
	}
}
