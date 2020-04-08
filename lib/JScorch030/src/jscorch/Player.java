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
import jscorch.*;

/**
 * A class representing a player of a game of JScorch.
 * This class encapsulates all of the details and actions of a
 * JScorch player.
 */
public class Player {
	private String name;
	private Color color;
	private int tankType;
	private int cash;
	private int score;
	private Tank tank;
	private WeaponLocker weapons;
	private GuidanceLocker guidances;
	private ShieldLocker shields;
	private int triggers;
	private int batteries;
	private int parachutes;
	private boolean autoDefense;

	/**
	 * Creates a new Player with the specified name n, using the tank type t.
	 * @param n the name of the new Player
	 * @param t the type of the new Player's tank
	 */
	public Player (String n, int t,Color c) {
		name = n;
		color = c;
		tankType = t;
		cash = 0;
		score = 0;
		triggers = 0;
		batteries = 0;
		parachutes = 0;
		autoDefense = true;
		guidances = new GuidanceLocker();
		shields = new ShieldLocker();
		weapons = new WeaponLocker();
		for(int i = 1;i < WeaponTypes.NUM_TYPES;i++) {
			weapons.addWeapon(i,10);
		}
		for(int i = 1;i < ShieldTypes.NUM_TYPES;i++) {
			shields.addShield(i,10);
		}
	}
	public boolean getAutoDefense() {
		return autoDefense;
	}
	/**
	 * returns the number of batteries
	 * @return number of batteries
	 */
	public int getBatteryCount() {
		 return batteries;
	}
	/**
	  * sets the number of batteries
	  * @param n number of batteries
	*/
	public void setBatteries(int n) {
		batteries = n;
	}
	/**
	 * returns the Player's cash
	 * @return integer of the cash the player has
	 */
	public int getCash(){
		return cash;
	}
	/**
	 * returns the Player's color
	 * @return player's color
	 */
	 public Color getColor(){
		return color;
	}
	/**
	 * sets the Player's color
	 * @param c the color
	 */
	public void setColor(Color c) {
		color = c;
	}
	/**
	 * returns the Player's GuidanceLocker
	 * @return a GuidanceLocker
	 */
	public GuidanceLocker getGuidanceLocker() {
		return guidances;
	}
	/**
	 * returns Player's name
	 * @return String of the Player's name
	 */
	public String getName() {
		return name;
	}
	/**
	 * sets the Player's name
	 * @param n the new name
	 */
	public void setName(String n) {
		name = n;
	}
	/**
	 * creates and returns a new Tank
	 * @param c passed to the Tank constructor
	 * @return newly created tank
	 */
	public Tank getNewTank(ActionArea a) {
		tank = TankTypes.newTank(tankType,a,this);
		return tank;
	}
	/**
	 * returns number of parachutes
	 * @return number of parachutes
	 */
	public int getParachutes() {
		return parachutes;
	}
	/**
	 * sets the number of parachutes
	 * @param n number of parachutes
	 */
	public void setParachutes(int n) {
		parachutes = n;
	}
	/**
	 * returns Player's score
	 * @return integer of the player's score
	 */
	public int getScore() {
		return score;
	}
	/**
	 * returns the Player's ShieldLocker
	 * @return a ShieldLocker
	 */
	public ShieldLocker getShieldLocker() {
		return shields;
	}
	/**
	 * returns Player's Tank
	 * @return the Player's Tank
	 */
	public Tank getTank() {
		return tank;
	}
	/**
	 * returns the number of triggers
	 * @return number of triggers
	 */
	 public int getTriggers() {
		 return triggers;
	 }
	 /**
	  * returns Player's WeaponLocker
	  * @return the Player's WeaponLocker
	  */
	 public WeaponLocker getWeaponLocker() {
		 return weapons;
	 }
	 /**
	  * Called when this Player destroys a Tank.
	  * If the Player owns this tank, its score is decremented,
	  * otherwise it is incremented.
	  * @param t the tank that was destroyed
	  */
	 public void giveKill(Tank t) {
		 if (t == tank)
			 score--;
		 else
			 score++;
	 }
	 /**
	  * set the numbers of triggers
	  * @param n number of triggers
	  */
	  public void setTriggers(int n) {
		  triggers = n;
	  }
	  public void useBattery() {

	  }
}
