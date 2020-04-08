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
import javax.swing.*;

/**
 * Top level class for explosions, which are created when a weapon or tank explodes(duh).
 * This class provides functionality that are common to explosions, such as expanding
 * and painting
 */
public class Explosion extends Sprite{
	//inherited vars
	Tank owner;

	//Linked List vars
	Explosion next,prev;

	//layout positioning
	Point center;
	Rectangle bounds;

	/**
	 * Used in place of a constructor for this abstract class. Initializes the explosion
	 * with the given Takn owner and occuring at the given location. Then sets the
	 * explosion data to defaults to be reset by the specific explosion.
	 */
	public Explosion (Tank own, Point loc) {
		//initialize variables
		owner = own;
		container = owner.getContainer();
		setOpaque(false);

		center = loc;
	}

	public void expand(int time) {

	}
	/**
	 * returns the center of this Explosion in Real-World coordinates
	 * @return center point
	 */
	public Point getCenter() {
		return center;
	}
	/**
	 * linked list method, returns the next Explosion in the list.
	 * @return next Explosion
	 */
	public Explosion getNext () {
		return next;
	}
	/**
	 * linked list method, returns the previous Explosion in the list
	 * @return previous Explosion
	 */
	public Explosion getPrev() {
		return prev;
	}
	/**
	 * returns the Tank owner for this explosion, used to be able to keep track of
	 * who is doing the damage to allocate points appropriately
	 * @return owner of this Explosion
	 */
	public Tank getTank() {
		return owner;
	}

	//setters
	/**
	 * linked list method, sets the next Explosion in the list
	 * @param e new next Explosion
	 */
	public void setNext(Explosion e) {
		next = e;
	}
	/**
	 * linked list method, sets the previous Explosion in the list
	 * @param e new previous Explosion
	 */
	public void setPrev(Explosion e) {
		prev = e;
	}
}
