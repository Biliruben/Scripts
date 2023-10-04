package sailpoint.launcher;

import java.io.PrintWriter;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.hibernate.cfg.Configuration;
import org.hibernate.mapping.PersistentClass;
import org.hibernate.mapping.Property;
import org.hibernate.mapping.Value;
import org.hibernate.type.Type;

import sailpoint.persistence.SPNamingStrategy;
import sailpoint.tools.Console;

/**
 * Custom console to explore hibernate properties for mapped classes
 * @author trey.kirk
 *
 */
public class PropertyExplorer extends Console {

	private static Configuration _config;
	private Set<String[]> _names;
	private PrintWriter _out;
	private int _propNameMaxLength;

	public PropertyExplorer() {
		addCommand("property", "Displays property information of a given class.", "cmdProperty");
		addCommand("mappedClasses", "Displays classes mapped in the Hibernate configuration.", "cmdMappedClasses");
	}

	public static void main(String[] args) {
		PropertyExplorer console = new PropertyExplorer();
		// Horked from the Hibernate Utils class
		_config = new Configuration();
		_config.setNamingStrategy(new SPNamingStrategy());
		_config.configure("hibernate.cfg.xml");
		console.run(args);
	}

	/*
	 * Fetches the name and value type of the given property.  Tracks the longest string
	 * length of all known property names to ensure prety formatting
	 */
	private void addProperty (Property prop) {
		Value v = prop.getValue();
		Type type = v.getType();
		_propNameMaxLength = prop.getName().length() > _propNameMaxLength ? prop.getName().length() : _propNameMaxLength;
		_names.add(new String[] {prop.getName(), type.getName()});
	}
	
	/*
	 * Loads the provided class's mappings and iterates the properties
	 */
	private void exploreProperties(String name) {
		PersistentClass pc = _config.getClassMapping(name);
		if (pc == null) {
			_out.println("Could not load mappings for " + name);
		} else {
			Iterator propertyIt = pc.getDeclaredPropertyIterator(); // Hibernate doesn't parameterize this iterator
			_names = new HashSet<String[]>();
			Set<String> sortedNames = new TreeSet<String>();
			while (propertyIt.hasNext()) {
				addProperty((Property) propertyIt.next()); // They's all properties, so cast away
			}
			addProperty(pc.getIdentifierProperty()); // Don't forget the identifier property (aka 'id')
			// Second pass thru is for formatting and sorting
			for (String[] propNameArry : _names) {
				String propName = propNameArry[0];
				propName = String.format("%1$-" + _propNameMaxLength + "s", propName);
				String typeName = propNameArry[1];
				sortedNames.add(propName + " : " + typeName);
			}
			// Third pass goes out
			for (String sortedName : sortedNames) {
				_out.println(sortedName);
			}
		}
	}

	/**
	 * Property Command: list the provided class's properties
	 * @param args
	 * @param out
	 * @throws Exception
	 */
	public void cmdProperty(List<String> args, PrintWriter out) throws Exception {
		int nargs = args.size();
		_out = out;
		_propNameMaxLength = 1;
		if (nargs != 1) { // balk when no or multiple options passed
			out.format("property <Any Mapped Class>\n");
		}
		else {
			String name = args.get(0);
			if (!name.matches("^.*\\..*")) {  // did they give it a proper path?
				name = "sailpoint.object." + name; // No?  Assume sailpoint.obj
			}
			exploreProperties(name);
		}
	}
	
	/**
	 * Mapped Classes command: List the classes defined in the Hibernate mapping configuration
	 * @param args
	 * @param out
	 * @throws Exception
	 */
	public void cmdMappedClasses(List<String> args, PrintWriter out) throws Exception {
		Iterator classesIt = _config.getClassMappings();
		Set<String> classes = new TreeSet<String>();
		while (classesIt != null && classesIt.hasNext()) {
			PersistentClass pc = (PersistentClass) classesIt.next();
			classes.add(pc.getClassName()); // for auto-sorting
		}
		for (String clazz : classes) {
			out.println(clazz);
		}
	}
}
