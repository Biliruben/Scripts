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
  * A class that statically keeps track of game preferences
  */
public class Preferences {

	/**
	 * a variable containing info on the type of game flow,
	 * using constants from GameConstants
	 */

	public static Font FONT = new Font("monospaced",Font.PLAIN,10);

	public static int GAME_FLOW = GameConstants.FLOW_SEQUENTIAL;

	public static int WALL_TYPE = GameConstants.WALL_RUBBER;

	public static int PHYSICS_BORDERS_EXTEND = 0;

	public static double FPS = 40;

	public static Color[] tankColors = {Color.red,Color.orange,Color.yellow,Color.green,new Color(.3f,.3f,1f),Color.cyan,Color.magenta,Color.gray};
	public static String[] tankColorNames = {"Red","Orange","Yellow","Green","Blue","Cyan","Magenta","Gray"};

}