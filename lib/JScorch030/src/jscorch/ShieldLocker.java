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

public class ShieldLocker {
	private int[] shieldList;
	private int current;

	/**
	 * creates a new, empty GuidanceLocker
	 */
	public ShieldLocker() {
		shieldList = new int[ShieldTypes.NUM_TYPES];
		shieldList[ShieldTypes.NO_SHIELD] = -1;
	}

	public void addShield(int type, int num) {
		if (type < shieldList.length)
			shieldList[type]+=num;
		else
			System.out.println("Error in adding to ShieldLocker: "+type+" is not a valid type");
	}

	public int getCurrent() {
		return current;
	}
	public int getCurrentOfInventory() {
		int num = 0;
		for (int i = 0; i < current ; i++) {
			if (shieldList[i] != 0) {
				num++;
			}
		}
		return num;
	}
	public String[] getInventory() {
		int num = 0;
		String[] result = null;
		String[] names = ShieldTypes.getShieldList();
		for (int i = 0; i < shieldList.length; i++) {
			if (shieldList[i] != 0) {
				num++;
			}
		}
		int j = 0;
		int c = 0;
		if (num > 0) {
			result = new String[num];
			while(num > 0) {
				if (shieldList[j] != 0) {
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
	 * returns the number of shields of a given type
	 * @param type the shield's type
	 * @return number of shields of the type
	 */
	public int getNum(int type) {
		if (shieldList[type] == -1)
			return 99;
		else
			return shieldList[type];
	}
	public void setCurrent(int i) {
		current = i;
	}
	public void setCurrentOfInventory(int num) {
		for (int i = 0; i < shieldList.length; i++) {
			if (shieldList[i] > 0) {
				num--;
			}
			if(num == 0){
				current = i;
				break;
			}
		}
	}

	/**
	 * called when a shield is taken out of the locker.
	 * @param type integer of shield type
	 */
	public Shield useShield(Tank o, int type) {
		if (shieldList[type] != -1) {
			shieldList[type]--;
			if (shieldList[type] == 0)
				setCurrent(ShieldTypes.NO_SHIELD);
		}
		return (ShieldTypes.makeShield(o,type));
	}

	public Shield useStrongestShield(Tank o) {
		int i = shieldList.length - 1;
		while (shieldList[i] == 0 && i > 0) {
			i--;
		}
		setCurrent(i);
		return (useShield(o,i));
	}
}












