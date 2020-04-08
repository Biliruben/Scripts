package jscorch;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author unascribed
 * @version 1.0
 */
import java.awt.image.BufferedImage;
import javax.swing.Timer;

public class HeavyShield extends Shield {
	public HeavyShield(Tank o,BufferedImage img) {
		super(o,img);
		type = ShieldTypes.HEAVY_SHIELD;
		strengthFactor = .5;
		int FPS = 12;
		timer = new Timer(1000/FPS,this);
		timer.start();
	}
}