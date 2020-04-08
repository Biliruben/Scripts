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
import java.awt.event.*;
import javax.swing.*;

/**
 * Class responsible for displaying status information so that the user
 * can have real-time data about the current tank.
 */
public class MessageArea extends JPanel {
	GameWindow parent;
	ActionArea actionArea;

	//StatusBox status;
	JPanel windLabel;
	JLabel windSpeed;
	WindDirLabel windDir;
	Font f = new Font("monospaced",Font.PLAIN,10);
	int ttX,ttY;

	/**
	 * creates a MessageArea for the given GameWindow, recieving information
	 * from the given ActionArea
	 * @param par the window for this MessageArea
	 * @param a the ActionArea to get information from
	 */
	public MessageArea  (GameWindow par, ActionArea a) {
		super();
		setOpaque(false);
		this.setLayout(null);

		parent = par;
		actionArea = a;
//		status = new StatusBox(actionArea.getPlayers());
//		status.setLocation(0,0);

		windLabel = new JPanel();
		windSpeed = new JLabel("Wind:");
		windSpeed.setFont(f);
		windSpeed.setAlignmentY(CENTER_ALIGNMENT);
		windDir = Physics.getWindDirLabel();
		windDir.setAlignmentY(CENTER_ALIGNMENT);
		windDir.setPreferredSize(new Dimension(windDir.WIDTH,windDir.HEIGHT));

		windLabel.setLayout(new BoxLayout(windLabel,BoxLayout.X_AXIS));
		windLabel.add(Box.createHorizontalGlue());
		windLabel.add(windSpeed);
		windLabel.add(Box.createRigidArea(new Dimension(2,0)));
		windLabel.add(windDir);
		windLabel.add(Box.createHorizontalGlue());
//		windLabel.setOpaque(false);
		windLabel.setOpaque(true);
		windLabel.setBackground(new Color(1f,1f,1f,.75f));
		windLabel.setBounds(3*parent.getBoundary().width/4,0,parent.getBoundary().width/4,20);

//		this.add(status);
		this.add(windLabel);
		this.setVisible(true);
	}

	/**
	 * returns the current Tank from the actionArea
	 * @return current Tank from this MessageArea's ActionArea
	 */
	public Tank findCurTank() {
		return actionArea.getCurTank();
	}
	/**
	 * calls for an update of the StatusBox
	 */
	public void updateStatus() {
//		status.updateInfo();
		updateWind();
	}
	/**
	 * updates the data for the Wind Label
	 */
	public void updateWind() {
		windSpeed.setText("Wind: "+Math.abs((int)Physics.wind));
		this.repaint(windDir.getBounds());
	}
}