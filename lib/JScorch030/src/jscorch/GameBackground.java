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

/**
 * A simple class providing a background for a game of JScorch.
 */
public class GameBackground extends JLabel{
	Color bgColor;
	GameWindow parent;
//	Image i;

	/**
	 * Creates a new instance of GameBackground for the given GameWindow
	 * @param par a GameWindow that will hold this GameBackground
	 */
	public GameBackground (GameWindow par) {
		super();
//		i = JScorchUtils.getImage(this,"images/splash.png");
		parent = par;
//		bgColor = Color.black;
		bgColor = Color.lightGray;
//		bgColor = JScorchUtils.RandomColor();

		setOpaque(true);
		setForeground(Color.black);
		setBackground(bgColor);
	}
//	public void paintComponent(Graphics g) {
//		super.paintComponent(g);
//		g.drawImage(i,0,0,this);
//	}
}
