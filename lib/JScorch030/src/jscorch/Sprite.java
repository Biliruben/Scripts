package jscorch;
/*
 * Created by IntelliJ IDEA.
 * User: acooper
 * Date: Jul 8, 2002
 * Time: 10:19:44 PM
 * To change template for new class use
 * Code Style | Class Templates options (Tools | IDE Options).
 */

import javax.swing.*;

public abstract class Sprite extends JLabel{
	protected ActionArea container;
	int WIDTH = 0;
	int HEIGHT = 0;

	public ActionArea getContainer() {
		return container;
	}

	public int getWIDTH() {
		return WIDTH;
	}

	public int getHEIGHT() {
		return HEIGHT;
	}
	public void setContainer(ActionArea a) {
		container = a;
	}
//	public void setHeight(int h) {
//		HEIGHT = h;
//	}
//	public void setWidth(int w) {
//		WIDTH = w;
//	}
}
