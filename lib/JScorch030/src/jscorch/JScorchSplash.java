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
import javax.swing.*;
import javax.swing.border.*;

public class JScorchSplash extends JWindow {
	JLabel message;

	public JScorchSplash() {
		super();
//		JPanel c = (JPanel)(this.getContentPane());
		JLayeredPane c = new JLayeredPane();
		JLabel pic = new SplashLabel(JScorchUtils.getImage(this,"images/splash.png"),"Loading");
		message = new MessageLabel("Loading... Splash Screen");
//		c.setLayout(new BoxLayout(c,BoxLayout.Y_AXIS));
		c.setBackground(Color.white);
		message.setHorizontalTextPosition(JLabel.LEFT);
		message.setBackground(new Color(1f,1f,1f,.5f));
//		message.setBackground(Color.white);
		message.setForeground(Color.white);
//		message.setForeground(Color.black);
//		message.setOpaque(true);
		c.setLayout(null);
		Dimension d = pic.getPreferredSize();
		pic.setBounds(0,0,d.width,d.height);
		message.setBounds(65,340,425,60);
		c.add(pic,new Integer(0));
		c.add(message, new Integer(1));
		this.setContentPane(c);
//		this.pack();
		this.setSize(d);

		//Center the window
		Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
		Dimension frameSize = this.getSize();
		if (frameSize.height > screenSize.height) {
			frameSize.height = screenSize.height;
		}
		if (frameSize.width > screenSize.width) {
			frameSize.width = screenSize.width;
		}
		this.setLocation((screenSize.width - frameSize.width) / 2, (screenSize.height - frameSize.height) / 2);
		this.setVisible(true);
	}
	public JLabel getMessage() {
		return message;
	}
	public void setMessage(String m) {
		message.setText(m);
	}
}

class MessageLabel extends JLabel {
	public MessageLabel(String s) {
		super(s);
		this.setDoubleBuffered(false);
	}
	public void paintComponent(Graphics g) {
		super.paintComponent(g);
//System.out.println(g);
		g.setColor(Color.white);
//		g.drawString(getText(),50,50);
	}
}

class SplashLabel extends JLabel {
	Image img;
	String message;
	public SplashLabel (Image i, String m) {
		super();
		img = i;
		message = m;
		this.setOpaque(true);
		Dimension d = new Dimension(img.getWidth(this),img.getHeight(this));
		this.setPreferredSize(d);
		this.setMinimumSize(d);
		this.setMaximumSize(d);
		repaint();
	}
	public void paintComponent(Graphics g) {
		super.paintComponent(g);
		Rectangle r = g.getClipBounds();
		g.drawImage(img,r.x,r.y,r.x+r.width,r.y+r.height,r.x,r.y,r.x+r.width,r.y+r.height,this);
	}
}




