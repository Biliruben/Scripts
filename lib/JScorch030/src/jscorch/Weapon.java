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

/**
 * top-level class for Weapons providing only the methods needed for
 * incorporation into a linked list and a method declaration for moving
 */
public abstract class Weapon extends Sprite{
	//Linked List vars
	Weapon next, prev;

	//getters
	/**
	 * linked list method, returns the next Weapon in the list
	 * @return next Weapon
	 */
	public Weapon getNext () {
		return next;
	}
	/**
	 * linked list method, returns the previous Weapon in the list
	 * @return previous Weapon
	 */
	public Weapon getPrev() {
		return prev;
	}

	//setters
	/**
	 * linked list method, sets the new next Weapon in the list
	 * @param w the new next Weapon
	 */
	public void setNext(Weapon w) {
		next = w;
	}
	/**
	 * linked list method, set the new previous Weapon in the list
	 * @param w the next previous Weapon
	 */
	public void setPrev(Weapon w) {
		prev = w;
	}
	/**
	 * abstract declaration for the move() method required for all Weapons
	 */
	public abstract void move(int i);

}