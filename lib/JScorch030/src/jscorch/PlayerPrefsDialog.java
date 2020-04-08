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
import java.awt.event.*;

public class PlayerPrefsDialog extends JDialog {
	Player player;

	JTextField nameField;
	JComboBox colorMenu,typeMenu;
	JButton ok = new JButton("OK");
	JButton cancel = new JButton("Cancel");

	public PlayerPrefsDialog(Frame par, Player p) {
		super(par,"Player Preferences",true);
		player = p;
		init();
		this.getRootPane().setDefaultButton(ok);
		this.pack();
		this.setResizable(false);
		this.setVisible(true);
	}

	private void init() {
		Font f = Preferences.FONT;
		JLabel nameLabel = new JLabel("Player Name: ");
		nameLabel.setFont(f);
		JLabel colorLabel = new JLabel("Tank Color: ");
		colorLabel.setFont(f);
		JLabel typeLabel = new JLabel("Tank Type: ");
		typeLabel.setFont(f);

		ok.setFont(f);
		ok.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				player.setName(nameField.getText());
				player.setColor(Preferences.tankColors[colorMenu.getSelectedIndex()]);
				player.getTank().setType(typeMenu.getSelectedIndex());
				dispose();
			}
		});
		cancel.setFont(f);
		cancel.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				dispose();
			}
		});
		nameField = new JTextField(player.getName(),20);
		nameField.setAlignmentX(this.RIGHT_ALIGNMENT);
		nameField.setFont(f);
		nameField.setText(player.getName());
		colorMenu = new JComboBox(Preferences.tankColorNames);
		colorMenu.setFont(f);
		for(int i = 0; i < Preferences.tankColors.length; i++) {
			if (player.getColor() == Preferences.tankColors[i]) {
				colorMenu.setSelectedIndex(i);
			}
		}
		colorMenu.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				ok.requestFocus();
			}
		});
		typeMenu = new JComboBox(TankTypes.getTypeNames());
		typeMenu.setFont(f);
		typeMenu.setSelectedIndex(player.getTank().getType());
		typeMenu.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				ok.requestFocus();
			}
		});
		
		JPanel contentPane = new JPanel();
		Container namePanel = new Container();
		Container colorPanel = new Container();
		Container typePanel = new Container();
		Container buttonPanel = new Container();
		
		contentPane.setLayout(new BoxLayout(contentPane,BoxLayout.Y_AXIS));
		namePanel.setLayout(new BoxLayout(namePanel,BoxLayout.X_AXIS));
		colorPanel.setLayout(new BoxLayout(colorPanel,BoxLayout.X_AXIS));
		typePanel.setLayout(new BoxLayout(typePanel,BoxLayout.X_AXIS));
		buttonPanel.setLayout(new BoxLayout(buttonPanel,BoxLayout.X_AXIS));
		nameLabel.setLabelFor(nameField);
		colorLabel.setLabelFor(colorMenu);
		typeLabel.setLabelFor(typeMenu);

		namePanel.add(nameLabel);namePanel.add(nameField);
		colorPanel.add(colorLabel);colorPanel.add(colorMenu);
		typePanel.add(typeLabel);typePanel.add(typeMenu);
		buttonPanel.add(Box.createHorizontalGlue());buttonPanel.add(cancel);buttonPanel.add(ok);

		contentPane.setBorder(BorderFactory.createEmptyBorder(5,5,5,5));
		contentPane.add(namePanel);
		contentPane.add(Box.createRigidArea(new Dimension(0,5)));
		contentPane.add(colorPanel);
		contentPane.add(Box.createRigidArea(new Dimension(0,5)));
		contentPane.add(typePanel);
		contentPane.add(Box.createRigidArea(new Dimension(0,10)));
		contentPane.add(buttonPanel);
		this.setContentPane(contentPane);
	}
}