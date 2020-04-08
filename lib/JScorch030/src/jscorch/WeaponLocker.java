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
  * A class encapsulating a locker that contains Weapons for use by a tank.
  */
public class WeaponLocker {
	int[] weaponList;
	int current;

	/**
	 * Creates a new, empty WeaponLocker except for the infinite
	 * Baby Missiles
	 */
	public WeaponLocker() {
		weaponList = new int[WeaponTypes.NUM_TYPES];
		weaponList[WeaponTypes.BABY_MISSILE] = -1;
	}

	/**
	 * adds num weapons of the given type to the WeaponLocker
	 * @param type integer of the weapon's type
	 * @param num number of weapons to add
	 */
	public void addWeapon(int type, int num) {
		if (type < weaponList.length)
			weaponList[type]+=num;
		else
			System.out.println("Error in adding to WeaponLocker: "+type+" is not a valid type");
	}

	/**
	 * returns the number of weapons of a given type
	 * @param type the weapon's type
	 * @return number of weapons of the type
	 */
	public int getNum(int type) {
		if (weaponList[type] == -1)
			return 99;
		else
			return weaponList[type];
	}

	/**
	 * returns the current weapon's type
	 * @return integer of the current weapon's type
	 */
	public int getCurrent() {
		return current;
	}

	/**
	 * sets the current weapon's type
	 * @param c integer of the new type
	 */
	public void setCurrent(int c) {
		current = c;
	}

	public int getCurrentOfInventory() {
		int num = 0;
		for (int i = 0; i < current ; i++) {
			if (weaponList[i] != 0) {
				num++;
			}
		}
		return num;
	}
	public void setCurrentOfInventory(int num) {
		for (int i = 0; i < weaponList.length; i++) {
			if (weaponList[i] != 0) {
				num--;
			}
			if (num < 0) {
				current = i;
				break;
			}
		}
	}

	public String[] getInventory() {
		int num = 0;
		String[] result = null;
		String[] names = WeaponTypes.getWeaponList();
		for (int i = 0; i < weaponList.length; i++) {
			if (weaponList[i] != 0) {
				num++;
			}
		}
		int j = 0;
		int c = 0;
		if (num > 0) {
			result = new String[num];
			while(num > 0) {
				if (weaponList[j] != 0) {
					result[c] = names[j] + " (" + getNum(j) + ")";
					c++;
					num--;
				}
				j++;
			}
		}
		return result;
	}

	/**
	 * returns an array of strings containing data on
	 * the contents of this WeaponLocker. Each string has
	 * the weapon's name followed by the number of weapons of
	 * that type in parentheses
	 * @return array of strings of locker's contents
	 */
	public String[] checkLocker() {
		String[] list = new String[weaponList.length];
		int n = 0;
		for(int i = 0;i<list.length;i++) {
			if (weaponList[i] != 0)
				list[n++] = WeaponTypes.getStringFromInt(i) + "("+getNum(i)+ ")";
		}
		String[] result = new String[n];
		for(int i = 0;i<n;i++) {
			result[i] = list[i];
		}
		return result;
	}

	/**
	 * returns a string of the current weapon's name, followed by the the number of them
	 * @return string of the current weapon
	 */
	public String toString() {
		return WeaponTypes.getStringFromInt(current) + "("+getNum(current)+ ")";
	}

	/**
	 * called when a weapon is taken out of the locker.
	 * @param type integer of weapon type
	 */
	public Weapon useWeapon(int type,Tank o, Point loc,int ang,int pow) {
		if (weaponList[type] != -1) {
			weaponList[type]--;
			if (weaponList[type] == 0)
				setCurrent(WeaponTypes.BABY_MISSILE);
		}
		return (WeaponTypes.newWeapon(type,o,loc,ang,pow));
	}
}