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
import java.awt.image.*;
import java.util.*;

 /**
  * A class that will eventually draw and control the landscape for the game.
  * Currently nothing is implemented here.
  */
public class Landscape extends JPanel{
	GameWindow parent;
	Dimension bounds;
	BufferedImage image;

	int argb = 0;

	 public Landscape (GameWindow g) {
		 parent = g;
		 bounds = parent.getBoundary();
		 setOpaque(false);
		 //bounds = parent.getViewSize();

		 image = new BufferedImage(bounds.width,bounds.height,BufferedImage.TYPE_INT_ARGB);
		 int numPts = (int)(Math.random()*10+10);
		 int edgePts = 4;
		 int[] xpts = new int[numPts+edgePts];
		 int[] ypts = new int[numPts+edgePts];
		 double ang;
		 Point startPoint = new Point(0,(int)((bounds.height)*(1-Math.random()*.5)));
		 Point endPoint = new Point(bounds.width,(int)((bounds.height)*(1-Math.random()/2)));
		 xpts[0] = startPoint.x; xpts[numPts+1] = endPoint.x;
		 ypts[0] = startPoint.y; ypts[numPts+1] = endPoint.y;
		 for(int i = 1; i <= numPts; i++) {
			 xpts[i] = (int)(Math.random()*bounds.width);
		 }
		 xpts[numPts+2] = bounds.width; ypts[numPts+2] = bounds.height;
		 xpts[numPts+3] = 0; ypts[numPts+3] = bounds.height;
		 java.util.Arrays.sort(xpts,0,numPts+1);
		 int y;
		 for (int i = 1; i <= numPts+1; i++) {
			 do {
				 ang = Math.random()*60-120;
				 y = (int)(ypts[i-1] + (xpts[i] - xpts[i-1])*Math.tan(ang));
			 } while (y > bounds.height || y < bounds.height*.25);
			 ypts[i] = y;
		 }

		 Shape landShape = new Polygon(xpts,ypts,numPts+edgePts);
		 Stroke s = new BasicStroke(0f);
		 Graphics2D landg = image.createGraphics();
		 landg.setStroke(s);
		 landg.setPaint(Color.green);
		 landg.fill(landShape);
	 }

	public boolean pointIsValid(Point p) {
		return pointIsValid(p.x,p.y);
	}
	public boolean pointIsValid(int x, int y) {
		try {
			argb = image.getRGB(x,y);
			if ( ((argb & 0xFF000000)>>>24) == (0xFF) ) {
				return false;
			}
		} catch (Exception e) {
//			System.out.println("Size: "+image.getWidth()+", "+image.getHeight());
//			System.out.println(x+", "+y);
//			e.printStackTrace();
			return true;
		}
		return true;
	}
	public void clearCircle(int x, int y, int r) {
		for (int i = 0; i < r; i++) {
			for (int j = 0; j < r; j++) {

			}
		}
	}
	public void clearRectUp(Rectangle r) {
		 for(int i = 0; i <= r.y+r.height; i++) {
			 for(int j = r.x; j <= r.x+r.width; j++) {
				 image.setRGB(j,i,0x0000);
			 }
		 }
	}
	public Graphics2D getImageGraphics() {
		return image.createGraphics();
	}
	public void paintComponent(Graphics g) {
		Rectangle r = g.getClipBounds();
		g.drawImage(image,r.x,r.y,r.x+r.width,r.y+r.height,r.x,r.y,r.x+r.width,r.y+r.height,this);
	}
}