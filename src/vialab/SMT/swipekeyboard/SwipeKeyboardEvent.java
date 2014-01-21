package vialab.SMT.swipekeyboard;

//standard library imports
import java.util.Collection;

/**
 * A class to contain the information related to swipe keyboard state changes.
 */
public class SwipeKeyboardEvent extends java.util.EventObject{
	/** The suggestions for the current swipe */
	private Collection<String> words;
	/** The object to be used to resolve the current swipe into suggestions */
	private SwipeResolver resolver;
	/** The raw data of the swipe - all of the characters that were hit, in order */
	private String swipe;
	/** The type of event that occurred */
	private Type type;

	/**
	 * Create a new SwipeKeyboardEvent
	 * @param  source The object (presumably a swipe keyboard) from which this
	 * event originated
	 * @param  type The desired type of the event
	 * @param  swipe The raw data of the swipe
	 * @param  resolver The object to be used to resolve the swipe string into
	 * suggestions
	 */
	public SwipeKeyboardEvent(
			Object source, Type type, String swipe, SwipeResolver resolver){
		super( source);
		this.type = type;
		this.swipe = swipe;
		this.resolver = resolver;
		this.words = null;
	}

	/**
	 * Get a list of words that user was probably trying to create with the swipe.
	 * This function stores its result, to save time in the case that it is
	 * needed again.
	 * 
	 * @return A list of words that the user was probably trying to create
	 * with the swipe
	 */
	public Collection<String> getSuggestions(){
		if( words == null && resolver != null)
			words = resolver.resolve( swipe);
		return words;
	}
	/**
	 * Get the raw data of the swipe - all of the characters that were hit,
	 * in order.
	 * @return All the characters that were hit by the swipe, in order.
	 */
	public String getSwipeString(){
		return swipe;
	}

	/**
	 * An enum used to describe the type of events that could occur
	 */
	public enum Type {
		SWIPE_COMPLETED, SWIPE_STARTED, SWIPE_PROGRESSED}
}