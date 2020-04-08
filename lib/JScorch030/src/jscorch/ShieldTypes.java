package jscorch;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author unascribed
 * @version 1.0
 */
import java.awt.*;
import java.awt.image.*;
import java.net.URL;
import javax.swing.JComponent;

public abstract class ShieldTypes {
	public static final int NO_SHIELD = 0;
	public static final int MAG_DEFLECTOR = 1;
	public static final int SHIELD = 2;
	public static final int FORCE_SHIELD = 3;
	public static final int HEAVY_SHIELD = 4;
	public static final int SUPER_MAG = 5;
	private static final String[] shieldList = {"No Shield","Mag Deflector","Shield","Force Shield","Heavy Shield","Super Mag"};
	public static final int NUM_TYPES = shieldList.length;

	private static BufferedImage magDefImage;
	private static BufferedImage shieldImage;
	private static BufferedImage forceShieldImage;
	private static BufferedImage heavyShieldImage;
	private static BufferedImage superMagImage;

	public static String[] getShieldList() {
		return shieldList;
	}
	public static Shield makeShield(Tank o, int type) {
		Shield result = null;
		switch(type) {
			case NO_SHIELD:
				result = new Shield(o,null);
				break;
			case MAG_DEFLECTOR:
				if(magDefImage == null) {
					magDefImage = JScorchUtils.getBufImage(o,"images/shields/mag_deflector_strip.png");
				}
				result = new MagDeflector(o,magDefImage);
				break;
			case SHIELD:
				if(shieldImage == null){
					shieldImage = JScorchUtils.getBufImage(o, "images/shields/normal_shield_strip.png");
				}
				result = new NormalShield(o,shieldImage);
				break;
			case FORCE_SHIELD:
				if(forceShieldImage == null){
					forceShieldImage = JScorchUtils.getBufImage(o, "images/shields/force_shield_strip.png");
				}
				result = new ForceShield(o,forceShieldImage);
				break;
			case HEAVY_SHIELD:
				if(heavyShieldImage == null){
					heavyShieldImage = JScorchUtils.getBufImage(o, "images/shields/heavy_shield_strip.png");
				}
				result = new HeavyShield(o,heavyShieldImage);
				break;
			case SUPER_MAG:
				if(superMagImage == null){
					superMagImage = JScorchUtils.getBufImage(o, "images/shields/super_mag_strip.png");
				}
				result = new SuperMag(o,superMagImage);
				break;
			default:
				result = new Shield(o,null);
		}
		return result;
	}
}








