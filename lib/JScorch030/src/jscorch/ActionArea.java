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
import java.awt.geom.*;
import javax.swing.event.*;
import java.awt.event.*;

/**
 * This class is where the action in JScorch happens. An instance of
 * ActionArea contains all of the Tanks, Weapons, Explosions, and other
 * action-oriented objects that need to be drawn. Also, ActionArea
 * contains objects and methods for controlling the animation,
 * including firing timing events and updating the various sprites.
 * <BR>Most of the code in ActionArea has to do with adding and
 * removing the sprites, and the rest are basically accessor methods
 * for modifying those sprites.
 */
public class ActionArea extends JLayeredPane implements ActionListener{
	//inherited vars
	GameWindow parent;
	Landscape land;

	//layer vars
	final Integer TANKS = new Integer(0);
	final Integer WEAPONS = new Integer(1);
	final Integer EXPLOSIONS = new Integer(2);
	Player[] players;
	Tank[] tanks;
	Shield[] shields;
	Weapon weaponHead;
	Explosion explosionHead;
	int actionSprites;

	//animTimer vars
	final int ANIM_DELAY = (int) (1000 / Preferences.FPS);
	Timer animTimer;

	//Tank vars
	int numTanks,curTankID;
	int activeTanks;
	final int ANG_DELTA = 1;
	final int POW_DELTA = 1;

	/**
	 * Creates a new instance of an ActionArea, with the specified
	 * GameWindow as a parent, and using the array of Players as
	 * players in the current game. The constructor assigns random
	 * positions in the lineup to the Player's tanks and then assigns
	 * those tanks their positions in the window.
	 * @param par the GameWindow parent for this ActionArea
	 * @param p the array of Players for this game
	 */
	public ActionArea(GameWindow par, Landscape l, Player[] p) {
		super();
		parent = par;
		land = l;
		players = p;

		numTanks = players.length;
		Dimension bounds = parent.getBoundary();

		setOpaque(false);

		tanks = new Tank[numTanks];
		shields = new Shield[numTanks];
		int xloc,yloc;
		for(int i = 0; i < numTanks; i++) {
			tanks[i] = players[i].getNewTank(this);
			add(tanks[i], TANKS);
		}

		int num;
		Tank temp;
		Point bl = new Point();	Point bc = new Point();	Point br = new Point();
		for(int i = 0; i < numTanks; i++) {
			num = (int) (Math.random() * (numTanks - i));
			temp = tanks[i];
			tanks[i] = tanks[num + i];
			tanks[num + i] = temp;
//			xloc = (int)((i + Math.random()) * (bounds.width - tanks[i].getWidth()) / numTanks);
			xloc = (int)(Math.random()*(bounds.width/numTanks - 3*tanks[i].getWidth()/2) + i*bounds.width/numTanks);
			yloc = 0;
			bl.y = bc.y = br.y = tanks[i].getHeight();
			bl.x = xloc;  bc.x = xloc + tanks[i].getWidth()/2;  br.x = xloc + tanks[i].getWidth();
			while((land.pointIsValid(bl) || land.pointIsValid(br)) && land.pointIsValid(bc)) {
				yloc++;
				bl.translate(0, 1); br.translate(0, 1); bc.translate(0, 1);
			}
			tanks[i].setLocation(xloc, yloc);
			land.clearRectUp(tanks[i].getBounds());
			if (tanks[i].getPlayer().getAutoDefense()) {
				tanks[i].setShield(tanks[i].getPlayer().getShieldLocker().useStrongestShield(tanks[i]));
			}
		}

		activeTanks = numTanks;
		curTankID = 0;
		tanks[curTankID].setCurrent(true);
		actionSprites = 0;

		Physics.randomWind();
		animTimer = new Timer(ANIM_DELAY,this);
	}

	/**
	 * Convenience method for the ActionEvents fired by the animation timer.
	 * @param e ActionEvent fired by the animation timer and redirected here.
	 */
	public void actionPerformed(ActionEvent e) {
		updateSprites();
		if(actionSprites == 0) {
			animTimer.stop();
			getNextTank();
			parent.updateAll();
		}
	}

	/**
	 * Special adding method for a Damager type object to
	 * damage tanks from a weapon's explosion.
	 * @param d the Damager about to cause damage
	 */
	public void addDamager(Damager d) {
		double dist;
		double damage;
		int radius = d.getRadius();
		double pow = d.getPower();
		Point dCent = d.getCenter();
		Point tCent;
		for(int i = 0; i < numTanks; i++) {
			if (tanks[i].isAlive()) {
				tCent = tanks[i].getCenter();
				dist = dCent.distance(tCent);
				damage = pow - pow / radius * (dist - 15);
				if(damage >= 0) {
					tanks[i].damage(damage, d);
				}
			}
		}
	}

	/**
	 * Special adding method for an Explosion. Adds the
	 * Explosion to the ActionArea and also to the linked
	 * list of Explosions.
	 * @param e Explosion to be added
	 */
	public void addExplosion(Explosion e) {
		super.add(e, EXPLOSIONS);
		if(explosionHead == null) {
			explosionHead = e;
		} else {
			e.setNext(explosionHead);
			e.setPrev(null);
			explosionHead.setPrev(e);
			explosionHead = e;
		}
		if(!animTimer.isRunning())
			animTimer.start();
		actionSprites++;
	}
	public void addMisc(Component c) {
		parent.getSubLandscape().add(c);
		c.repaint();
	}
	public void addShield(Shield s) {
		Tank t = s.getOwner();
		for (int i = 0; i < shields.length; i++) {
			if (tanks[i] == t) {
				shields[i] = s;
			}
		}
		JPanel panel = parent.getSubLandscape();
		panel.add(s);
		s.repaint();
	}
	/**
	 * Special adding method for a Weapon. Adds the
	 * Weapon to the Actionarea and also to the linked
	 * list of Weapons.
	 * @param w Weapon to be added
	 */
	public void addWeapon(Weapon w) {
		super.add(w, WEAPONS);
		if(weaponHead == null) {
			weaponHead = w;
		} else {
			w.setNext(weaponHead);
			w.setPrev(null);
			weaponHead.setPrev(w);
			weaponHead = w;
		}
		actionSprites++;
	}

	/**
	 * Buffer method for decreasing the current Tank's angle.
	 */
	public void angleDown() {
		tanks[curTankID].setAngle(-ANG_DELTA);
	}

	/**
	 * Buffer method for increasing the current Tank's angle.
	 */
	public void angleUp() {
		tanks[curTankID].setAngle(ANG_DELTA);
	}

	/**
	 * Checks to make sure that there are more than 1 active tanks.
	 * If not, this methods makes a call to show the Game Over Dialog.
	 */
//	public void checkEndGame() {
//		if(activeTanks <= 1)
//			OptionDialogs.showGameOverDialog(parent);
//	}

	/**
	 * returns the current Tank
	 * @return the current Tank
	 */
	public Tank getCurTank() {
		return tanks[curTankID];
	}

	public Landscape getLandscape() {
		return land;
	}

	/**
	 * Sets the index pointer, curTankID, to the index of the next
	 * active tank. Also causes the wind to be reset.
	 */
	public void getNextTank() {
		Tank lastTank = tanks[curTankID];
		do {
			curTankID++;
			if(curTankID == numTanks) {
				curTankID = 0;
			}
		} while (!tanks[curTankID].isAlive() && tanks[curTankID] != lastTank);
		if (activeTanks <= 1) {
			OptionDialogs.showGameOverDialog(parent);
		} else {
			tanks[curTankID].setCurrent(true);
			Physics.randomWind();
			parent.updateAll();
		}
	}

	/**
	 * returns the number of tanks
	 * @return the integer number of tanks
	 */
	public int getNumTanks() {
		return numTanks;
	}

	/**
	 * Returns the array of players for this ActionArea
	 * @return array of Player objects
	 */
	public Player[] getPlayers() {
		return players;
	}

	/**
	 * returns the Tank of an index
	 * @param i integer index of a Tank
	 * @return the Tank for index i
	 */
	public Tank getTank(int i) {
		return tanks[i];
	}

	/**
	 * returns the boolean status of the animation timer
	 * @return the boolean status of the animation timer
	 */
	public boolean isRunning() {
		return animTimer.isRunning();
	}

	public boolean pointIsValid(Point p) {
		if (land.pointIsValid(p)) {
			for (int i = 0; i < numTanks; i++) {
				if (shields[i].getType() != ShieldTypes.NO_SHIELD) {
					if (shields[i].getCenter().distance(p) < shields[i].getRadius()) {
						return false;
					}
				} else {
					if (tanks[i].checkCollision(p)) {
						return false;
					}
				}
			}
		} else {
			return false;
		}
		return true;
	}

	/**
	 * Buffer method for powering up the current Tank
	 */
	public void powerUp() {
		tanks[curTankID].setPower(POW_DELTA);
	}

	/**
	 * Buffer method for powering down the current Tank
	 */
	public void powerDown() {
		tanks[curTankID].setPower(-POW_DELTA);
	}

	/**
	 * Special removing method to remove an Explosion.
	 * Removes the Explosion from the ActionArea and also
	 * from the linked list of Explosions.
	 * @param e the Explosion to be removed
	 */
	public void removeExplosion(Explosion e) {
		repaint(e.getBounds());
		super.remove(e);
		if(e.getPrev() == null && e.getNext() == null) {
			explosionHead = null;
		} else if(e.getPrev() == null) {
			explosionHead = e.getNext();
			explosionHead.setPrev(null);
		} else if(e.getNext() == null) {
			e.getPrev().setNext(null);
		} else {
			e.getPrev().setNext(e.getNext());
			e.getNext().setPrev(e.getPrev());
		}
		actionSprites--;
	}

	public void removeMisc(Component c) {
		parent.getSubLandscape().remove(c);
		parent.getSubLandscape().repaint(c.getBounds());
	}

	public void removeShield(Shield s) {
		Tank t = s.getOwner();
		for (int i = 0; i < shields.length; i++) {
			if (tanks[i] == t) {
				shields[i] = null;
			}
		}
		JPanel panel = parent.getSubLandscape();
		panel.remove(s);
		panel.repaint(s.getBounds());
	}

	/**
	 * Special removing method to remove a Tank. Moves the tank to
	 * the end of the array and reduces the number of activeTanks.
	 * @param t the Tank to be removed
	 */
	public void removeTank(Tank t) {
		activeTanks--;
		super.remove(t);
		repaint(t.getBounds());
//		Tank temp = null;
//		for(int i = 0; i < activeTanks; i++) {
//			if(t == tanks[i]) {
//				temp = tanks[i];
//				temp.setCurrent(false);
//				activeTanks--;
//				if(i <= curTankID)
//					curTankID--;
//			}
//			if(temp != null && i != tanks.length - 1) {
//				tanks[i] = tanks[i + 1];
//			}
//		}
//		tanks[activeTanks] = temp;
	}

	/**
	 * Special removing method to remove a Weapon. Removes
	 * the Weapon both from the ActionArea and from the
	 * Weapon linked list.
	 * @param w the Weapon to be removed
	 */
	public void removeWeapon(Weapon w) {
		repaint(w.getBounds());
		super.remove(w);
		if(w.getPrev() == null && w.getNext() == null) {
			weaponHead = null;
		} else if(w.getPrev() == null) {
			weaponHead = w.getNext();
			weaponHead.setPrev(null);
		} else if(w.getNext() == null) {
			w.getPrev().setNext(null);
		} else {
			w.getPrev().setNext(w.getNext());
			w.getNext().setPrev(w.getPrev());
		}
		actionSprites--;
	}

	public void toggleTimer() {
		if (animTimer.isRunning()) {
			animTimer.stop();
		} else {
			animTimer.start();
		}
	}

	/**
	 * Called when a tank fires. Either starts the animation or waits
	 * until all tanks have fired until starting.
	 */
	public void tankFire() {
		tanks[curTankID].fire();
		if(Preferences.GAME_FLOW == GameConstants.FLOW_SEQUENTIAL) {
			if(!animTimer.isRunning())
				animTimer.start();
		} else {
			if(curTankID == numTanks - 1) {
				if(!animTimer.isRunning())
					animTimer.start();
			} else {
				getNextTank();
			}
		}
	}

	/**
	 * Traverses the Weapon and explosion linked lists and updates
	 * those sprites.
	 */
	public void updateSprites() {
		Weapon tempW = weaponHead;
		Explosion tempE = explosionHead;
		while(tempW != null) {
			tempW.move(ANIM_DELAY);
			tempW = tempW.getNext();
		}
		while(tempE != null) {
			tempE.expand(ANIM_DELAY);
			tempE = tempE.getNext();
		}
	}
//end of class
}
