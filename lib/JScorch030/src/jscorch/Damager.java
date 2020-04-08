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

/**
 * utility method used to apply damage from an explosion
 */
public class Damager extends Component {
	double power;
	Point center;
	Explosion expl;
	int radius;

	/**
	 * creates a new damager for the given Explosion
	 * @param e the explosion this Damager is derived from
	 */
	public Damager(CircularExplosion e) {
		expl = e;
		power = e.getPower();
		center = e.getCenter();
		radius = e.MAXRAD;
	}

	/**
	 * returns the power of this Damager
	 * @return power
	 */
	public double getPower() {
		return power;
	}

	/**
	 * returns the center Point for this Damager
	 * @return center
	 */
	public Point getCenter() {
		return center;
	}

	/**
	 * returns the Explosion for this Damager
	 * @return the Explosion
	 */
	public Explosion getExplosion() {
		return expl;
	}

	/**
	 * returns the radius of operation for the Damager
	 * @return radius
	 */
	public int getRadius() {
		return radius;
	}
}