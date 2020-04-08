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

public class GuidanceLocker {
	private int[] guidanceList;
	private int current;

	/**
	 * creates a new, empty GuidanceLocker
	 */
	public GuidanceLocker() {
		guidanceList = new int[GuidanceTypes.NUM_TYPES];
		guidanceList[GuidanceTypes.NO_GUIDANCE] = -1;
	}

	public void addGuidance(int type, int num) {
		if (type < guidanceList.length)
			guidanceList[type]+=num;
		else
			System.out.println("Error in adding to GuidanceLocker: "+type+" is not a valid type");
	}

	public int getCurrent() {
		return current;
	}
	public int getCurrentOfInventory() {
		int num = 0;
		for (int i = 0; i < current ; i++) {
			if (guidanceList[i] != 0) {
				num++;
			}
		}
		return num;
	}
	public String[] getInventory() {
		int num = 0;
		String[] result = null;
		String[] names = GuidanceTypes.getGuidanceList();
		for (int i = 0; i < guidanceList.length; i++) {
			if (guidanceList[i] != 0) {
				num++;
			}
		}
		int j = 0;
		int c = 0;
		if (num > 0) {
			result = new String[num];
			while(num > 0) {
				if (guidanceList[j] != 0) {
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
	 * returns the number of guidances of a given type
	 * @param type the guidance's type
	 * @return number of guidances of the type
	 */
	public int getNum(int type) {
		if (guidanceList[type] == -1)
			return 99;
		else
			return guidanceList[type];
	}

	public void setCurrent(int i) {
		current = i;
	}
	public void setCurrentOfInventory(int num) {
		for (int i = 0; i < guidanceList.length; i++) {
			if (guidanceList[i] > 0) {
				num--;
			}
			if(num == 0){
				current = i;
				break;
			}
		}
	}
	/**
	 * called when a guidance is taken out of the locker.
	 * @param type integer of guidance type
	 */
	public Guidance useGuidance(Tank o, int type) {
		if (guidanceList[type] != -1) {
			guidanceList[type]--;
			if (guidanceList[type] == 0)
				setCurrent(GuidanceTypes.NO_GUIDANCE);
		}
		return (GuidanceTypes.newGuidance(o,type));
	}

}

















