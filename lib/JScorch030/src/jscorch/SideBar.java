package jscorch;

/**
* <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author unascribed
 * @version 1.0
 */
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.border.*;

public class SideBar extends JPanel {
	private GameWindow parent;
	private Player player;

	private String[] weapons = {"Baby Missile","Normal Missile","Baby Nuke","Nuke","FunkyBomb","MIRV","Death's Head"};
	private String[] guidances = {"Heat","Ballistic","Horizontal","Vertical","Lazy Boy"};
	private String[] shields = {"Mag Deflectors","Shields","Force Shields","Heavy Shields","Super Mags"};
	private Font f = Preferences.FONT;
	private Font f2 = Preferences.FONT;

	private GridBagLayout sectionLayout;
	private GridBagConstraints gbc;

	private JPanel playerBox = new JPanel();
	private JLabel nameField = new JLabel("xxxxxxxxxx");
	private JLabel scoreField = new JLabel("3.1415");

	private JPanel weaponBox = new JPanel();
	private JComboBox weaponChooser = new JComboBox(weapons);
	private JComboBox guidanceChooser = new JComboBox(guidances);
	private JCheckBox guidanceArm = new JCheckBox("Arm");
	private JLabel triggerCount = new JLabel("99 Remaining");
	private JCheckBox triggerArm = new JCheckBox("Arm");

	private JPanel shieldBox = new JPanel();
	private JComboBox shieldChooser = new JComboBox(shields);
	private JButton shieldCharger = new JButton("Charge");
	private JProgressBar shieldProgress = new JProgressBar(0,100);
	private JLabel shieldStrength = new JLabel("100%");
	private JCheckBox autoDefCheck = new JCheckBox("Auto Defense");

	private JPanel energyBox = new JPanel();
	private JLabel batteryCount = new JLabel("99 Remaining");
	private JButton batteryUse = new JButton("Use");
	private JProgressBar energyProgress = new JProgressBar(0,100);
	private JLabel energyStrength = new JLabel("100%");

	private JPanel chuteBox = new JPanel();
	private JLabel chuteCount = new JLabel("99 Remaining");
	private JCheckBox chuteDeploy = new JCheckBox("Deploy");
	private JTextField safetyThreshold = new JTextField("99",2);

	private JPanel fuelBox = new JPanel();
	private JLabel fuelCount = new JLabel("99 Units Remaining");
	private JButton moveLeft = new JButton("<");
	private JButton moveRight = new JButton(">");

	public SideBar(GameWindow g) {
		parent = g;
		this.setOpaque(true);
		this.setBackground(Color.white);
		try {
			init();
			initListeners();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}

	private void init() throws Exception {
		JLabel nameLabel = new JLabel("Name:");
		JLabel scoreLabel = new JLabel("Score:");
		JLabel weaponLabel = new JLabel("Weapon:");
		JLabel guidanceLabel = new JLabel("Guidance:");
		JLabel triggerLabel = new JLabel("Trigger:");
		JLabel shieldLabel = new JLabel("Shield:");
		JLabel batteryLabel = new JLabel("Battery:");
		JLabel chutesLabel = new JLabel("Chutes:");
		JLabel thresholdLabel = new JLabel("Safety Threshold:");
		JLabel fuelLabel = new JLabel("Fuel:");

		this.setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));
		TitledBorder tb = BorderFactory.createTitledBorder("Player");
		tb.setTitleFont(f2);	playerBox.setBorder(tb);
		tb = BorderFactory.createTitledBorder("Weapon");
		tb.setTitleFont(f2);	weaponBox.setBorder(tb);
		tb = BorderFactory.createTitledBorder("Shield");
		tb.setTitleFont(f2);	shieldBox.setBorder(tb);
		tb = BorderFactory.createTitledBorder("Energy");
		tb.setTitleFont(f2);	energyBox.setBorder(tb);
		tb = BorderFactory.createTitledBorder("Parachutes");
		tb.setTitleFont(f2);	chuteBox.setBorder(tb);
		tb = BorderFactory.createTitledBorder("Fuel");
		tb.setTitleFont(f2);	fuelBox.setBorder(tb);

		//moveLeft and moveRight buttons
		JPanel moveBox = new JPanel();
		moveBox.setLayout(new BoxLayout(moveBox,BoxLayout.X_AXIS));
		moveBox.add(moveLeft);
		moveBox.add(moveRight);
		//disable autoDef checkbox
		autoDefCheck.setEnabled(false);

		sectionLayout = new GridBagLayout();
		gbc = new GridBagConstraints();
		gbc.fill = GridBagConstraints.HORIZONTAL;
		gbc.weightx = 0; gbc.weighty = 0;
		gbc.gridwidth = 1; gbc.gridheight = 1;
		gbc.insets = new Insets(0,0,0,3);

		//playerBox row1
		playerBox.setLayout(sectionLayout);
		nameLabel.setHorizontalAlignment(weaponLabel.RIGHT);
		nameLabel.setFont(f);
		nameField.setFont(f);
		gbc.gridx = 0; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.EAST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(nameLabel,gbc);
		playerBox.add(nameLabel);
		gbc.gridx = 1; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.WEST;
		gbc.weightx = 1;
		sectionLayout.setConstraints(nameField,gbc);
		playerBox.add(nameField);

		//playerBox row2
		nameLabel.setHorizontalAlignment(weaponLabel.RIGHT);
		scoreLabel.setFont(f);
		scoreField.setFont(f);
		gbc.gridx = 0; gbc.gridy = 1;
		gbc.anchor = GridBagConstraints.EAST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(scoreLabel,gbc);
		playerBox.add(scoreLabel);
		gbc.gridx = 1; gbc.gridy = 1;
		gbc.anchor = GridBagConstraints.WEST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(scoreField,gbc);
		playerBox.add(scoreField);


		//weaponBox row1
		sectionLayout = new GridBagLayout();
		weaponBox.setLayout(sectionLayout);
		weaponLabel.setHorizontalAlignment(weaponLabel.RIGHT);
		weaponLabel.setFont(f);
		weaponChooser.setFont(f);
		gbc.gridx = 0; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.EAST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(weaponLabel,gbc);
		weaponBox.add(weaponLabel);
		gbc.gridx = 1; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		sectionLayout.setConstraints(weaponChooser,gbc);
		weaponBox.add(weaponChooser);

		//weaponBox row2
		guidanceLabel.setHorizontalAlignment(guidanceLabel.RIGHT);
		guidanceArm.setHorizontalAlignment(guidanceArm.LEFT);
		guidanceLabel.setFont(f);
		guidanceChooser.setFont(f);
		guidanceArm.setFont(f);
		gbc.gridx = 0; gbc.gridy = 1;
		gbc.anchor = GridBagConstraints.EAST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(guidanceLabel,gbc);
		weaponBox.add(guidanceLabel);
		gbc.gridx = 1; gbc.gridy = 1;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		sectionLayout.setConstraints(guidanceChooser,gbc);
		weaponBox.add(guidanceChooser);
		gbc.gridx = 2; gbc.gridy = 1;
		gbc.anchor = GridBagConstraints.WEST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(guidanceArm,gbc);
		weaponBox.add(guidanceArm);

		//weaponBox row3
		triggerLabel.setHorizontalAlignment(triggerLabel.RIGHT);
		triggerCount.setHorizontalAlignment(triggerCount.CENTER);
		triggerArm.setHorizontalAlignment(triggerArm.LEFT);
		triggerLabel.setFont(f);
		triggerCount.setFont(f);
		triggerArm.setFont(f);
		gbc.gridx = 0; gbc.gridy = 2;
		gbc.anchor = GridBagConstraints.EAST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(triggerLabel,gbc);
		weaponBox.add(triggerLabel);
		gbc.gridx = 1; gbc.gridy = 2;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		sectionLayout.setConstraints(triggerCount,gbc);
		weaponBox.add(triggerCount);
		gbc.gridx = 2; gbc.gridy = 2;
		gbc.anchor = GridBagConstraints.WEST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(triggerArm,gbc);
		weaponBox.add(triggerArm);

		//shieldBox row1
		sectionLayout = new GridBagLayout();
		shieldBox.setLayout(sectionLayout);
		shieldLabel.setHorizontalAlignment(shieldLabel.RIGHT);
		shieldLabel.setFont(f);
		shieldChooser.setFont(f);
		shieldCharger.setFont(f);
		gbc.gridx = 0; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.EAST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(shieldLabel,gbc);
		shieldBox.add(shieldLabel);
		gbc.gridx = 1; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		sectionLayout.setConstraints(shieldChooser,gbc);
		shieldBox.add(shieldChooser);
		gbc.gridx = 2; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.WEST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(shieldCharger,gbc);
		shieldBox.add(shieldCharger);

		//shieldBox row2
		shieldStrength.setHorizontalAlignment(shieldStrength.LEFT);
		shieldStrength.setFont(f);
		gbc.gridx = 1; gbc.gridy = 1;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		sectionLayout.setConstraints(shieldProgress,gbc);
		shieldBox.add(shieldProgress);
		gbc.gridx = 2; gbc.gridy = 1;
		gbc.anchor = GridBagConstraints.WEST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(shieldStrength,gbc);
		shieldBox.add(shieldStrength);

		//shieldBox row3
		autoDefCheck.setHorizontalAlignment(autoDefCheck.LEFT);
		autoDefCheck.setFont(f);
		gbc.gridx = 1; gbc.gridy = 2;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		sectionLayout.setConstraints(autoDefCheck,gbc);
		shieldBox.add(autoDefCheck);

		//energyBox row1
		sectionLayout = new GridBagLayout();
		energyBox.setLayout(sectionLayout);
		batteryLabel.setHorizontalAlignment(batteryLabel.RIGHT);
		batteryCount.setHorizontalAlignment(batteryCount.LEFT);
		batteryLabel.setFont(f);
		batteryCount.setFont(f);
		batteryUse.setFont(f);
		gbc.gridx = 0; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.EAST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(batteryLabel,gbc);
		energyBox.add(batteryLabel);
		gbc.gridx = 1; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		sectionLayout.setConstraints(batteryCount,gbc);
		energyBox.add(batteryCount);
		gbc.gridx = 2; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.WEST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(batteryUse,gbc);
		energyBox.add(batteryUse);

		//energyBox row2
		energyStrength.setHorizontalAlignment(energyStrength.LEFT);
		energyStrength.setFont(f);
		gbc.gridx = 1; gbc.gridy = 1;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		sectionLayout.setConstraints(energyProgress,gbc);
		energyBox.add(energyProgress);
		gbc.gridx = 2; gbc.gridy = 1;
		gbc.anchor = GridBagConstraints.WEST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(energyStrength,gbc);
		energyBox.add(energyStrength);

		//chuteBox row1
		sectionLayout = new GridBagLayout();
		chuteBox.setLayout(sectionLayout);
		chutesLabel.setHorizontalAlignment(chutesLabel.RIGHT);
		chuteCount.setHorizontalAlignment(chuteCount.LEFT);
		chuteDeploy.setHorizontalAlignment(chuteDeploy.LEFT);
		chutesLabel.setFont(f);
		chuteCount.setFont(f);
		chuteDeploy.setFont(f);
		gbc.gridx = 0; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.EAST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(chutesLabel,gbc);
		chuteBox.add(chutesLabel);
		gbc.gridx = 1; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		sectionLayout.setConstraints(chuteCount,gbc);
		chuteBox.add(chuteCount);
		gbc.gridx = 2; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.WEST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(chuteDeploy,gbc);
		chuteBox.add(chuteDeploy);

		//chuteBox row2
		thresholdLabel.setHorizontalAlignment(thresholdLabel.RIGHT);
		thresholdLabel.setFont(f);
		safetyThreshold.setFont(f);
		gbc.gridx = 1; gbc.gridy = 1;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		sectionLayout.setConstraints(thresholdLabel,gbc);
		chuteBox.add(thresholdLabel);
		gbc.gridx = 2; gbc.gridy = 1;
		gbc.anchor = GridBagConstraints.WEST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(safetyThreshold,gbc);
		chuteBox.add(safetyThreshold);

		//fuelBox row1
		sectionLayout = new GridBagLayout();
		fuelBox.setLayout(sectionLayout);
		fuelLabel.setHorizontalAlignment(fuelLabel.RIGHT);
		fuelCount.setHorizontalAlignment(fuelCount.LEFT);
		fuelLabel.setFont(f);
		fuelCount.setFont(f);
		moveLeft.setFont(f);
		moveRight.setFont(f);
		gbc.gridx = 0; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.EAST;
		gbc.weightx = 0;
		sectionLayout.setConstraints(fuelLabel,gbc);
		fuelBox.add(fuelLabel);
		gbc.gridx = 1; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		sectionLayout.setConstraints(fuelCount,gbc);
		fuelBox.add(fuelCount);
		gbc.gridx = 2; gbc.gridy = 0;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 0;
		sectionLayout.setConstraints(moveBox,gbc);
		fuelBox.add(moveBox);

		playerBox.setOpaque(false);
		weaponBox.setOpaque(false);
		shieldBox.setOpaque(false);
		energyBox.setOpaque(false);
		chuteBox.setOpaque(false);
		fuelBox.setOpaque(false);
		moveBox.setOpaque(false);
		guidanceArm.setOpaque(false);
		triggerArm.setOpaque(false);
		autoDefCheck.setOpaque(false);
		chuteDeploy.setOpaque(false);

		this.add(playerBox);
		this.add(weaponBox);
		this.add(shieldBox);
		this.add(energyBox);
		this.add(chuteBox);
		this.add(fuelBox);
	}

	public void initData(Player p) {
		player = p;
		System.out.println("init data");
		System.out.println(player.getName());
		updateWeaponChooser();
		updateGuidanceChooser();
		updateShieldChooser();
		nameField.setText(player.getName());
		nameField.setForeground(player.getColor());
		scoreField.setText(player.getScore()+"");
		guidanceArm.setSelected(player.getTank().getGuidanceArmed());
		triggerCount.setText(player.getTriggers() + " Remaining");
		triggerArm.setSelected(player.getTank().getTriggerArmed());
		shieldProgress.setValue((int)(player.getTank().getShield().getHealth()));
		shieldStrength.setText((int)(player.getTank().getShield().getHealth())+"%");
		autoDefCheck.setSelected(player.getAutoDefense());
		batteryCount.setText(player.getBatteryCount()+" Remaining");
		energyProgress.setValue((int)(player.getTank().getEnergy()));
		energyStrength.setText((int)(player.getTank().getEnergy()) + "%");
		chuteCount.setText(player.getParachutes() + " Remaining");
		chuteDeploy.setSelected(player.getTank().getChutesActive());
		safetyThreshold.setText(player.getTank().getSafetyThreshold() + "");
		fuelCount.setText(player.getTank().getFuel() + " Units Remaining");
	}

	public void updateGuidanceChooser() {
		String[] names = player.getGuidanceLocker().getInventory();
		int selected = player.getGuidanceLocker().getCurrentOfInventory();
		guidanceChooser.removeAllItems();
		if (names != null) {
			for (int i = 0; i < names.length; i++) {
				guidanceChooser.addItem(names[i]);
			}
			guidanceChooser.setSelectedIndex(selected);
		}
	}
	public void updateShieldChooser() {
		String[] names = player.getShieldLocker().getInventory();
		int selected = player.getShieldLocker().getCurrentOfInventory();
		shieldChooser.removeAllItems();
		if (names != null) {
			for (int i = 0; i < names.length; i++) {
				shieldChooser.addItem(names[i]);
			}
			shieldChooser.setSelectedIndex(selected);
		}
	}
	public void updateWeaponChooser() {
		String[] names = player.getWeaponLocker().getInventory();
		int selected = player.getWeaponLocker().getCurrentOfInventory();
		weaponChooser.removeAllItems();
		if (names != null) {
			for (int i = 0; i < names.length; i++) {
				weaponChooser.addItem(names[i]);
			}
			weaponChooser.setSelectedIndex(selected);
		}
	}

	private void initListeners() {
		//weaponBox
		weaponChooser.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				player.getWeaponLocker().setCurrentOfInventory(weaponChooser.getSelectedIndex());
				parent.takeFocus();
			}
		});
		guidanceChooser.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				player.getGuidanceLocker().setCurrentOfInventory(guidanceChooser.getSelectedIndex());
				parent.takeFocus();
			}
		});
		guidanceArm.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				player.getTank().setGuidanceArmed(guidanceArm.isSelected());
				parent.takeFocus();
			}
		});
		triggerArm.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				player.getTank().setTriggerArmed(triggerArm.isSelected());
				parent.takeFocus();
			}
		});
		//shieldBox
		shieldChooser.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				player.getShieldLocker().setCurrentOfInventory(shieldChooser.getSelectedIndex());
				parent.takeFocus();
			}
		});
		shieldCharger.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				player.getTank().setShield(player.getShieldLocker().useShield(player.getTank(),player.getShieldLocker().getCurrent()));
				shieldProgress.setValue((int)(player.getTank().getShield().getHealth()));
				shieldStrength.setText((int)(player.getTank().getShield().getHealth())+"%");
				updateShieldChooser();
				parent.updateInfo();
				parent.takeFocus();
			}
		});
		//energyBox
		batteryUse.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				player.useBattery();
				batteryCount.setText(player.getBatteryCount()+" Remaining");
				energyProgress.setValue(player.getTank().getEnergy());
				energyStrength.setText(player.getTank().getEnergy()+"%");
				parent.takeFocus();
			}
		});
		//chutesBox
		chuteDeploy.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				player.getTank().setChutesActive(chuteDeploy.isSelected());
				parent.takeFocus();
			}
		});
		safetyThreshold.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				player.getTank().setSafetyThreshold(Integer.parseInt(safetyThreshold.getText()));
				parent.takeFocus();
			}
		});
		//fuelBox
		moveLeft.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				player.getTank().move(-1);
				fuelCount.setText(player.getTank().getFuel()+" Units Remaining");
				parent.takeFocus();
			}
		});
		moveRight.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				player.getTank().move(-1);
				fuelCount.setText(player.getTank().getFuel()+" Units Remaining");
				parent.takeFocus();
			}
		});
	}
}












