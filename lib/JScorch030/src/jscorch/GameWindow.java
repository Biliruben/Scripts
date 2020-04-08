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
 * Each new game of JScorch takes place in an instance of GameWindow.
 * The GameWindow holds the GameBackground, Landscape, ActionArea,
 * and MessageArea. The GameWindow is also the container which catches
 * and responds to Key Events
 */
public class GameWindow extends JFrame{
	private Dimension size;
	private Player[] players;

	private JPanel contentPane;

	private JMenuBar menuBar;
	private JLayeredPane layers;
	private GameBackground background;
	private JPanel subLandscape;
	private Landscape landscape;
	private ActionArea actionArea;
	private MessageArea messageArea;
	private StatusBar statusBar;
	private SideBar sideBar;
	private JLabel statusMessage;

	private final Integer BACKGROUND = new Integer(0);
	private final Integer SUBLANDSCAPE = new Integer(1);
	private final Integer LANDSCAPE = new Integer(2);
	private final Integer ACTION = new Integer(3);
	private final Integer MESSAGE = new Integer(4);

	//changeTimer vars
	private final int POWER_CHANGE = 50;
	private final int ANGLE_CHANGE = 50;
	private Timer powerChanger;
	private Timer angleChanger;
	private int dir; //1 for up, -1 for down
	private Tank curTank;

	/**
	 * Creates a new window for a game of JScorch. This window will
	 * have a size of d and use the array of Players.
	 * @param d size of the window
	 * @param p aray of Players
	 */
	public GameWindow(Dimension d,Player[] p, JLabel m) {
		statusMessage = m;
		enableEvents(AWTEvent.WINDOW_EVENT_MASK);
		try {
			addWindowListener(new WindowAdapter() {
				public void windowClosing(WindowEvent e) {
					gameWindowClosing(e);
				}
			});
			size = d;
			players = p;
			init();
			addScorchKeyListener();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * called by the windowListener when the window tries to close
	 * @param e the WindowEvent
	 */
	protected void gameWindowClosing(WindowEvent e) {
		OptionDialogs.showGameOverDialog(this);
	}

	/**
	 * init() sets up and initializes the graphical components of
	 * the GameWindow.
	 * @throws Exception this might happen sometime?
	 */
	private void init() throws Exception  {
		this.setSize(size);
		this.setTitle("JScorch");

		statusMessage.setText("Loading... Menu Bar");
		initMenuBar();
		this.setJMenuBar(menuBar);
		statusMessage.setText("Loading... Status Bar");
		statusBar = new StatusBar(this);
		statusMessage.setText("Loading... Side Bar");
		sideBar = new SideBar(this);
		layers = new JLayeredPane();

		contentPane = (JPanel) this.getContentPane();
		contentPane.setLayout(new BoxLayout(contentPane,BoxLayout.X_AXIS));
		JPanel gamePanel = new JPanel();
		gamePanel.setLayout(new BorderLayout());
		gamePanel.add(statusBar, BorderLayout.NORTH);
		gamePanel.add(layers, BorderLayout.CENTER);
		contentPane.add(gamePanel);
		contentPane.add(sideBar);

		sideBar.setPreferredSize(sideBar.getMinimumSize());
		gamePanel.setMinimumSize(size);
		gamePanel.setPreferredSize(size);
//		contentPane.setMinimumSize(new Dimension(size.width + sideBar.getMinimumSize().width, size.height));
//		contentPane.setPreferredSize(new Dimension(size.width + sideBar.getMinimumSize().width, size.height));
		pack();

		fillLayers();
		statusMessage.setText("Initializing Player Data...");
		sideBar.initData(players[0]);
		statusBar.setActionArea(actionArea);
		setResizable(false);
		setupTimers();
		updateAll();
		this.requestFocus();
	}

	/**
	 * Creates and fills the different parts of the GameWindow's
	 * JLayeredPane, including setting the bounds for those items,
	 * based upon the size of the JLayeredPane that contains them.
	 */
	private void fillLayers() {
		layers.setLayout(null);

		statusMessage.setText("Loading... Background");
		background = new GameBackground(this);
		statusMessage.setText("Loading... SubLandscape");
		subLandscape = new JPanel(); initSubLandscape();
		statusMessage.setText("Loading... Landscape");
		landscape = new Landscape(this);
		statusMessage.setText("Loading... Action Area");
		actionArea = new ActionArea(this,landscape,players);
		statusMessage.setText("Loading... Message Area");
		messageArea = new MessageArea(this,actionArea);

		layers.add(background,BACKGROUND);
		layers.add(subLandscape,SUBLANDSCAPE);
		layers.add(landscape,LANDSCAPE);
		layers.add(actionArea,ACTION);
		layers.add(messageArea,MESSAGE);

		background.setBounds(0,0,layers.getWidth(),layers.getHeight());
		subLandscape.setBounds(0,0,layers.getWidth(),layers.getHeight());
		landscape.setBounds(0,0,layers.getWidth(),layers.getHeight());
		actionArea.setBounds(0,0,layers.getWidth(),layers.getHeight());
		messageArea.setBounds(0,0,layers.getWidth(),layers.getHeight());
	}

	private void initMenuBar() {
		menuBar = new JMenuBar();
		JMenu menu = new JMenu("Game");
		JMenuItem item = new JMenuItem("Choose Weapon...");
		item.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				showWeaponDialog();
			}
		});
		menu.add(item);
		item = new JMenuItem("Player Prefs...");
		item.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				showPlayerDialog();
			}
		});
		menu.add(item);
		item = new JMenuItem("Game Prefs...");
		item.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				showGameDialog();
			}
		});
		menu.add(item);
		menu.addSeparator();
		item = new JMenuItem("End Game");
		item.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				showEndDialog();
			}
		});
		menu.add(item);
		menuBar.add(menu);
		JButton toggle = new JButton("Toggle");
		toggle.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				actionArea.toggleTimer();
			}
		});
		menuBar.add(toggle);
	}

	private void initSubLandscape() {
		subLandscape.setOpaque(false);
		subLandscape.setLayout(null);
	}

	public JPanel getSubLandscape() {
		return subLandscape;
	}

	/**
	 * initializes the timers used for fast repeating of keystrokes
	 */
	private void setupTimers() {
		powerChanger = new Timer(POWER_CHANGE,new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				powerChanger_actionPerformed(e);
			}
		});
		angleChanger = new Timer(ANGLE_CHANGE,new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				angleChanger_actionPerformed(e);
			}
		});
	}

	/**
	 * returns the size of the JLayeredPane for this GameWindow
	 * @return the Dimension of layers, the JLayeredPane
	 */
	public Dimension getBoundary() {
		while(layers.getSize().width != size.width);
		return layers.getSize();
	}

	public void takeFocus() {
		actionArea.requestFocus();
	}

	/**
	 * convenience method used to send an update message to the MessageArea object
	 */
	public void updateAll() {
		statusBar.updateInfo();
		messageArea.updateStatus();
		updateSideBar();
	}
	/**
	 * convenience method used to send an update message to the MessageArea object
	 */
	public void updateInfo() {
		statusBar.updateInfo();
	}

	/**
	 * convenience method used to send an update message to the
	 * StatusBox object inside of the MessageArea
	 */
	public void updateStatus() {
		messageArea.updateStatus();
	}

	public void updateSideBar() {
		sideBar.initData(actionArea.getCurTank().getPlayer());
	}

	/**
	 * convenience method indirectly called when the angleChanger fires an ActionEvent
	 * @param e the ActionEvent fired
	 */
	public void angleChanger_actionPerformed(ActionEvent e) {
		curTank.setAngle(dir);
		statusBar.updateAngle();
	}

	/**
	 * convenience method indirectly called when the powerChanger fires an ActionEvent
	 * @param e the ActionEvent fired
	 */
	public void powerChanger_actionPerformed(ActionEvent e) {
		curTank.setPower(dir);
		statusBar.updatePower();
	}
	private void showEndDialog() {
		OptionDialogs.showGameOverDialog(this);
	}
	private void showGameDialog() {
		OptionDialogs.showGamePrefsDialog(this);
	}
	private void showPlayerDialog() {
		OptionDialogs.showPlayerPrefsDialog(this,actionArea.getCurTank().getPlayer());
		updateSideBar();
	}
	private void showWeaponDialog() {
		OptionDialogs.showWeaponChooser(this,actionArea.getCurTank().getPlayer());
		updateSideBar();
	}

	private void addScorchKeyListener() {
		actionArea.addKeyListener(new KeyAdapter() {
			/**
			 * handles the keystroke method called when a KeyEvent is fired
			 * for a key being pressed
			 * @param e corresponds to the KeyEvent for the key being pressed
			 */
			public void keyPressed(KeyEvent e) {
				if(!angleChanger.isRunning() || !powerChanger.isRunning()){
					int key = e.getKeyCode();
					if(!actionArea.isRunning()) {
						switch (key) {
							case KeyEvent.VK_UP:
								dir = 1;
								curTank = actionArea.getCurTank();
								powerChanger.start();
								break;
							case KeyEvent.VK_DOWN:
								dir = -1;
								curTank = actionArea.getCurTank();
								powerChanger.start();
								break;
							case KeyEvent.VK_LEFT:
								dir = 1;
								curTank = actionArea.getCurTank();
								angleChanger.start();
								break;
							case KeyEvent.VK_RIGHT:
								dir = -1;
								curTank = actionArea.getCurTank();
								angleChanger.start();
								break;
							case KeyEvent.VK_SPACE:
								actionArea.tankFire();
								break;
							case KeyEvent.VK_W:
								showWeaponDialog();
								break;
							default:
						}
					}
				}
			}

			/**
			 * method called when the KeyEvent for a key being released is fired
			 * @param e the KeyEvent for the key being released
			 */
			public void keyReleased(KeyEvent e) {
				int key = e.getKeyCode();
				switch (key) {
					case KeyEvent.VK_UP:
						powerChanger.stop();
						break;
					case KeyEvent.VK_DOWN:
						powerChanger.stop();
						break;
					case KeyEvent.VK_LEFT:
						angleChanger.stop();
						break;
					case KeyEvent.VK_RIGHT:
						angleChanger.stop();
						break;
					default:
				}
			}
		});
	}
//	/**
//	 * inner class used to handle keystrokes for the GameWindow
//	 */
//	class ScorchKeyListener extends KeyAdapter{
//
//		/**
//		 * handles the keystroke method called when a KeyEvent is fired
//		 * for a key being pressed
//		 * @param e corresponds to the KeyEvent for the key being pressed
//		 */
//		public void keyPressed(KeyEvent e) {
//			if(!angleChanger.isRunning() || !powerChanger.isRunning()){
//				int key = e.getKeyCode();
//				if(!actionArea.isRunning()) {
//					switch (key) {
//						case KeyEvent.VK_UP:
//							dir = 1;
//							curTank = actionArea.getCurTank();
//							powerChanger.start();
//							break;
//						case KeyEvent.VK_DOWN:
//							dir = -1;
//							curTank = actionArea.getCurTank();
//							powerChanger.start();
//							break;
//						case KeyEvent.VK_LEFT:
//							dir = 1;
//							curTank = actionArea.getCurTank();
//							angleChanger.start();
//							break;
//						case KeyEvent.VK_RIGHT:
//							dir = -1;
//							curTank = actionArea.getCurTank();
//							angleChanger.start();
//							break;
//						case KeyEvent.VK_SPACE:
//							actionArea.tankFire();
//							break;
//						case KeyEvent.VK_W:
//							OptionDialogs.showWeaponChooser((Frame)(e.getComponent()),actionArea.getCurTank().getPlayer());
//							updateInfo();
//							break;
//						default:
//					}
//				}
//			}
//		}
//
//		/**
//		 * method called when the KeyEvent for a key being released is fired
//		 * @param e the KeyEvent for the key being released
//		 */
//		public void keyReleased(KeyEvent e) {
//			int key = e.getKeyCode();
//			switch (key) {
//				case KeyEvent.VK_UP:
//					powerChanger.stop();
//					break;
//				case KeyEvent.VK_DOWN:
//					powerChanger.stop();
//					break;
//				case KeyEvent.VK_LEFT:
//					angleChanger.stop();
//					break;
//				case KeyEvent.VK_RIGHT:
//					angleChanger.stop();
//					break;
//				default:
//			}
//		}
//	}
}