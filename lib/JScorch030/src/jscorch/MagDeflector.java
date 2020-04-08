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

public class MagDeflector extends Shield{
	public MagDeflector(Tank o,BufferedImage img) {
		super(o,img);
		type = ShieldTypes.MAG_DEFLECTOR;
		strengthFactor = 1.25;
		int FPS = 8;
		timer = new Timer(1000/FPS,this);
		timer.start();
	}
}