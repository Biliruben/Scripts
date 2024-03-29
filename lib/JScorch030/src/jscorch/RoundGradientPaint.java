package jscorch;

import java.awt.*;
import java.awt.geom.*;
import java.awt.image.*;

public class RoundGradientPaint implements Paint {
	protected Point2D mPoint;
	protected double mRadius;
	protected Color mPointColor, mBackgroundColor;

	public RoundGradientPaint(double x, double y, Color pointColor, double radius, Color backgroundColor) {
		mPoint = new Point2D.Double(x, y);
		mPointColor = pointColor;
		mRadius = radius;
		mBackgroundColor = backgroundColor;
	}

	public PaintContext createContext(ColorModel cm, Rectangle deviceBounds, Rectangle2D userBounds, AffineTransform xform, RenderingHints hints) {
		Point2D transformedPoint = xform.transform(mPoint, null);
		return new RoundGradientContext(transformedPoint, mPointColor, mRadius, mBackgroundColor);
	}

	public int getTransparency() {
		int a1 = mPointColor.getAlpha();
		int a2 = mBackgroundColor.getAlpha();
		return (((a1 & a2) == 0xff) ? OPAQUE : TRANSLUCENT);
	}
}

class RoundGradientContext implements PaintContext {
	protected Point2D mPoint;
	protected double mRadius;
	protected Color mC1, mC2;

	public RoundGradientContext(Point2D p, Color c1, double r, Color c2) {
		mPoint = p;
		mC1 = c1;
		mRadius = r;
		mC2 = c2;
	}

	public void dispose() {}

	public ColorModel getColorModel() { return ColorModel.getRGBdefault(); }

	public Raster getRaster(int x, int y, int w, int h) {
		WritableRaster raster = getColorModel().createCompatibleWritableRaster(w, h);

		int[] data = new int[w * h * 4];
		for (int j = 0; j < h; j++) {
			for (int i = 0; i < w; i++) {
				double distance = mPoint.distance(x + i, y + j);
				double ratio = distance / mRadius;
				if (ratio > 1.0)
		ratio = 1.0;

	int base = (j * w + i) * 4;
	data[base + 0] = (int)(mC1.getRed() + ratio *
						   (mC2.getRed() - mC1.getRed()));
	data[base + 1] = (int)(mC1.getGreen() + ratio *
						   (mC2.getGreen() - mC1.getGreen()));
	data[base + 2] = (int)(mC1.getBlue() + ratio *
						   (mC2.getBlue() - mC1.getBlue()));
	data[base + 3] = (int)(mC1.getAlpha() + ratio *
						   (mC2.getAlpha() - mC1.getAlpha()));
			}
		}
		raster.setPixels(0, 0, w, h, data);

		return raster;
	}
}