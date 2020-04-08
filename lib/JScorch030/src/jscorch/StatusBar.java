package jscorch;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class StatusBar extends JPanel{
	ActionArea actionArea;
	GameWindow parent;

	Font f = new Font("monospaced",Font.PLAIN,10);
	JLabel powerLabel,angleLabel,windLabel,weaponLabel,armorLabel,shieldLabel;
	WindDirLabel windDir;
	JScorchButton weaponPicker,fireButton,playerPrefButton,gamePrefButton;

	public StatusBar (GameWindow g) {
		super();
		parent = g;

		this.setOpaque(true);
		this.setBackground(Color.white);
		this.setForeground(Color.black);
		this.setLayout(new BoxLayout(this,BoxLayout.X_AXIS));

		this.setBorder(BorderFactory.createEmptyBorder());

		powerLabel = new JLabel("Power:");
			powerLabel.setAlignmentY(CENTER_ALIGNMENT);
			powerLabel.setFont(f);
		angleLabel = new JLabel("Angle:");
			angleLabel.setAlignmentY(CENTER_ALIGNMENT);
			angleLabel.setFont(f);
		windLabel = new JLabel("Wind:");
			windLabel.setFont(f);
			windLabel.setAlignmentY(CENTER_ALIGNMENT);
		windDir = Physics.getWindDirLabel();
			windDir.setAlignmentY(CENTER_ALIGNMENT);
			windDir.setPreferredSize(new Dimension(windDir.WIDTH,windDir.HEIGHT));
		weaponLabel = new JLabel("No Weapon");
			weaponLabel.setFont(f);
			weaponLabel.setAlignmentY(CENTER_ALIGNMENT);
		armorLabel = new JLabel("Armor:");
		armorLabel.setFont(f);
		armorLabel.setAlignmentY(CENTER_ALIGNMENT);
		shieldLabel = new JLabel("Shield:");
		shieldLabel.setFont(f);
		shieldLabel.setAlignmentY(CENTER_ALIGNMENT);

		this.add(powerLabel);
		this.add(Box.createHorizontalGlue());
		this.add(angleLabel);
		this.add(Box.createHorizontalGlue());
		this.add(armorLabel);
		this.add(Box.createHorizontalGlue());
		this.add(shieldLabel);
		this.add(Box.createHorizontalGlue());

		this.setVisible(true);
	}

	public void setActionArea(ActionArea a) {
		actionArea = a;
	}

	public void updateStatus() {
		parent.updateStatus();
	}

	/**
	 * returns the current Tank from the actionArea
	 * @return current Tank from this MessageArea's ActionArea
	 */
	public Tank findCurTank() {
		return actionArea.getCurTank();
	}
	/**
	 * updates the current info
	 */
	public void updateInfo() {
		updateAngle();
		updateArmor();
		updatePower();
		updateShield();
		updateWind();
		updateWeapon();
	}

	/**
	 * updates the data for the Angle Label
	 */
	public void updateAngle() {
		angleLabel.setText("Angle: "+findCurTank().getAngle());
	}

	/**
	 * updates the data for the armore label
	 */
	 public void updateArmor() {
		 armorLabel.setText("Armor: "+(int)(findCurTank().getHealth())+"%");
	 }

	/**
	 * updates the data for the Power Label
	 */
	public void updatePower() {
		powerLabel.setText("Power: "+findCurTank().getPower()+"%");
	}

	/**
	 * updates the data for the shield label
	 */
	 public void updateShield() {
		 shieldLabel.setText("Shield: "+(int)(findCurTank().getShield().getHealth())+"%");
	 }

	/**
	 * updates the data for the Weapon Label
	 */
	public void updateWeapon() {
		weaponLabel.setText(findCurTank().getPlayer().getWeaponLocker().toString());
	}

	/**
	 * updates the data for the Wind Label
	 */
	public void updateWind() {
		windLabel.setText("Wind: "+Math.abs((int)Physics.wind));
		this.repaint(windDir.getBounds());
	}

	/**
	 * method called when the user clicks the preferences button
	 */
	public void playerPrefButton_actionPerformed(ActionEvent e) {
		Player cur = actionArea.getCurTank().getPlayer();
		OptionDialogs.showPlayerPrefsDialog(parent,cur);
		updateStatus();
	}
	/**
	 * method called when the user clicks the preferences button
	 */
	public void gamePrefButton_actionPerformed(ActionEvent e) {
		OptionDialogs.showGamePrefsDialog(parent);
		updateStatus();
	}

	/**
	 * method called when the user clicks the weapon picker button
	 */
	public void weaponPicker_actionPerformed(ActionEvent e) {
		Player cur = actionArea.getCurTank().getPlayer();
		OptionDialogs.showWeaponChooser(parent,cur);
		updateWeapon();
	}

	/**
	 * method called when the user clicks the weapon picker button
	 */
	public void fireButton_actionPerformed(ActionEvent e) {
		actionArea.tankFire();
	}
}