package jscorch;
/**
 * <p>Title: JScorch</p>
 * <p>Description: Scorched Earth for Java</p>
 * <p>Copyright: Copyright (c) 2001</p>
 * <p>Company: HK Creations</p>
 * @author Andrew Cooper
 * @version 1.0
 */

/**
 * Utility class keeping track of variables related to the environment,
 * such as gravity and wind.
 */
 public abstract class Physics {
	public static final double gravity = 9.8;
	public static double wind;
	private static final double V_SCALE = 100;

	private static WindDirLabel windDir = new WindDirLabel();

//	/**
//	 * returns the gravity of the environment
//	 * @return double representaion of gravity
//	 */
//	public static double getGravity () {
//		return G;
//	}

//	/**
//	 * returns the current wind of the environment
//	 * @return double representaion of wind
//	 */
//	public static double getWind () {
//		return wind;
//	}

	/**
	 * returns the wind direction as an integer
	 * @retrun integer of wind direction
	 */
	public static int getWindDir() {
		if(wind < 0)
			return WindDirLabel.LEFT;
		else if (wind > 0)
			return WindDirLabel.RIGHT;
		else if (wind == 0)
			return WindDirLabel.NONE;
		return WindDirLabel.NONE;
	}

	/**
	 * returns the WindDirLabel object representing the wind of the environment
	 * @return a WindDirLabel for this environment
	 */
	public static WindDirLabel getWindDirLabel() {
		return windDir;
	}

	/**
	 * returns the Velocity Scale for the environment. The Velocity Scale
	 * is what relates the size of the sprites to the size of the environment.
	 * @retrun the integer velocity scale
	 */
	public static double getVScale () {
		return V_SCALE;
	}

	/**
	 * sets the wind for the environment to a random value between -50 and 50
	 */
	public static void randomWind() {
		wind = Math.random() * 100 - 50;
		windDir.changeDir();
	}
}
