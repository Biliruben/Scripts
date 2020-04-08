package jscorch;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author unascribed
 * @version 1.0
 */

public abstract class GuidanceTypes {
	public static final int NO_GUIDANCE = 0;
	public static final int HEAT = 1;
	public static final int BALLISTIC = 2;
	public static final int HORIZONTAL = 3;
	public static final int VERTICAL = 4;
	public static final int LAZY_BOY = 5;
	private static final String[] guidanceList = {"No Guidance","Heat","Ballistic","Horizontal","Vertical","Lazy Boy"};
	public static final int NUM_TYPES = guidanceList.length;

	public static String[] getGuidanceList() {
		return guidanceList;
	}
	public static Guidance newGuidance(Tank o, int type) {
		Guidance result = null;
		switch (type) {
			case NO_GUIDANCE:
				result = new Guidance(o);
				break;
			case HEAT:
				result = new Guidance(o);
				break;
			case BALLISTIC:
				result = new Guidance(o);
				break;
			case HORIZONTAL:
				result = new Guidance(o);
				break;
			case VERTICAL:
				result = new Guidance(o);
				break;
			case LAZY_BOY:
				result = new Guidance(o);
				break;
			default:
				result = new Guidance(o);
		}
		return result;
	}
}