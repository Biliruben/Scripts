package jscorch;
/**
* <p>Title: JScorch</p>
 * <p>Description: Scorched Earth for Java</p>
 * <p>Copyright: Copyright (c) 2001</p>
 * <p>Company: HK Creations</p>
 * @author Andrew Cooper
 * @version 1.0
 */
import java.util.*;
import java.awt.*;
import javax.swing.*;
import javax.swing.border.*;
import java.awt.event.*;
import jscorch.*;

/**
 * This is a small graphics utility class which paints a simple button with an icon.
 * I use this to have a consistent cross platform look and also to prevent the annoying
 * focus managing stuff with swing tries to pull.
 */
public class JScorchButton extends Sprite {
	ImageIcon image;
	Border upBorder,downBorder;
	Vector actionListeners = new Vector(1);
	/**
	 * creates a new instance, displaying the specified icon
	 * @param i the icon to display
	 */
	public JScorchButton(ImageIcon i) {
		super();
		WIDTH = 30;
		HEIGHT = 30;
		this.setBackground(Color.lightGray);
		image = i;
		setLayout(null);
		upBorder = BorderFactory.createRaisedBevelBorder();
		downBorder = BorderFactory.createLoweredBevelBorder();
		this.setPreferredSize(new Dimension(image.getIconWidth()+10,image.getIconHeight()+10));
		this.setMinimumSize(new Dimension(image.getIconWidth()+10,image.getIconHeight()+10));
		this.setMaximumSize(new Dimension(image.getIconWidth()+10,image.getIconHeight()+10));
		this.setBorder(upBorder);
		this.addMouseListener(new MouseAdapter() {
			public void mouseClicked(MouseEvent e) {
				for(int i = 0;i < actionListeners.size();i++) {
					ActionEvent ae = new ActionEvent(JScorchButton.this,ActionEvent.ACTION_PERFORMED,"action");
					((ActionListener)actionListeners.get(i)).actionPerformed(ae);
				}
			}
			public void mousePressed(MouseEvent e) {
				JScorchButton.this.setBorder(downBorder);
				repaint();
			}
			public void mouseReleased(MouseEvent e) {
				JScorchButton.this.setBorder(upBorder);
				repaint();
			}
		});
	}
	/**
	 * adds a listener to this JScorchButton to recieve messages
	 * when the button is pressed
	 * @param a the ActionListener to be registered
	 */
	public void addActionListener(ActionListener a) {
		actionListeners.add(a);
	}
	/**
	 * paints the background and then paints the icon on top.
	 * @param g the graphics context to paint in
	 */
	public void paintComponent(Graphics g) {
		super.paintComponent(g);
		image.paintIcon(this,g,5,5);
	}
}