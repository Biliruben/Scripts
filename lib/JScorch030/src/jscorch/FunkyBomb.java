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
import java.awt.geom.*;
import javax.swing.*;

/**
 * a Funky Bomb
 */
public class FunkyBomb extends Missile {
	/**
	 * creates a new Funky Bomb
	 */
	public FunkyBomb(Tank o, Point loc, int angle, int power) {
		super(o, loc, angle, power);
		color = Color.cyan;
		expType = WeaponTypes.FUNKY_BOMB;

	}
}

