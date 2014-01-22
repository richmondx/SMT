//standard library imports
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;

//processing imports
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

//smt imports
import vialab.SMT.*;
import vialab.SMT.swipekeyboard.*;

//SMT library imports

/**
 * Demo program for the new SwipeKeyboard zone
 * by Kalev Kalda Sikes
 */

// display properties
int window_width = 1600;
int window_height = 900;
int window_halfWidth;
int window_halfHeight;
final int fps_limit = 60;

// objects
SwipeKeyboard keyboard;
SwipeKeyboard arrows;

// other
PShape arrow_down;
PShape arrow_left;
PShape arrow_right;
PShape arrow_up;
boolean arrow_down_visible;
boolean arrow_left_visible;
boolean arrow_right_visible;
boolean arrow_up_visible;

// main functions
public void setup(){
	window_halfWidth = window_width / 2;
	window_halfHeight = window_height / 2;
	//processing library setup
	frameRate( fps_limit);
	size( window_width, window_height, P3D);
	textMode( SHAPE);
	frame.setTitle("Swipe Keyboard Test");
	//smt library setup
	SMT.init( this, TouchSource.AUTOMATIC);
	SMT.setTouchDraw( TouchDraw.TEXTURED);
	SMT.setTrailEnabled( false);

	//add keyboards
	keyboard = new SwipeKeyboard( SwipeKeyboard.condensedLayout);
	keyboard.translate( 40, 400);
	SMT.add( keyboard);

	arrows = new SwipeKeyboard( SwipeKeyboard.arrowKeysLayout);
	arrows.translate(
		keyboard.width + 100,
		400 + keyboard.height - arrows.height);
	SMT.add( arrows);

	//add text zone
	SwipeDisplayer texty = new SwipeDisplayer( "Texty", 300, 100, 1000, 200);
	SMT.add( texty);
	keyboard.addKeyListener( texty);
	keyboard.addSwipeKeyboardListener( texty);
	arrows.addKeyListener( texty);
	arrows.addSwipeKeyboardListener( texty);

	arrow_down = loadShape( "resources/arrow_down.svg");
	arrow_left = loadShape( "resources/arrow_left.svg");
	arrow_right = loadShape( "resources/arrow_right.svg");
	arrow_up = loadShape( "resources/arrow_up.svg");
	arrow_down_visible = false;
	arrow_left_visible = false;
	arrow_right_visible = false;
	arrow_up_visible = false;
}

public void draw(){
	fill( 50, 50, 50);
	//draw background
	rect( 0, 0, window_width, window_height);
	//draw textures
	draw_shapes();
}

public void draw_shapes(){
	//setup drawing options
	pushStyle();
	noFill();
	//draw pics
	if( arrow_down_visible)
		shape( arrow_down, 100f, 0f);
	if( arrow_left_visible)
		shape( arrow_left, 200f, 0f);
	if( arrow_right_visible)
		shape( arrow_right, 300f, 0f);
	if( arrow_up_visible)
		shape( arrow_up, 400f, 0f);
	//clean up
	popStyle();
}

public void debug_shapes(){
	System.out.printf( "arrow_down: %f, %f\n",
		arrow_down.getWidth(), arrow_down.getHeight());
	System.out.printf( "arrow_left: %f, %f\n",
		arrow_left.getWidth(), arrow_left.getHeight());
	System.out.printf( "arrow_right: %f, %f\n",
		arrow_right.getWidth(), arrow_right.getHeight());
	System.out.printf( "arrow_up: %f, %f\n",
		arrow_up.getWidth(), arrow_up.getHeight());
}

public void stop(){
	super.stop();
}

private class SwipeDisplayer extends Zone
		implements SwipeKeyboardListener, KeyListener {
	String content;
	public SwipeDisplayer( String name, int x, int y, int width, int height){
		super( name, x, y , width, height);
		content = new String();
	}
	public void drawImpl(){
		pushStyle();
		noFill();
		strokeWeight( 3);
		stroke( 200, 120, 120, 150);
		rect( 0, 0, width, height);
		drawText( content);
		popStyle();
	}
	public void drawText( String text){
		pushStyle();
		fill( 255, 255, 255, 255);
		textSize( Math.round( dimension.height * 0.6));
		textAlign( CENTER);
		float halfAscent = textAscent() / 2;
		float halfDescent = textDescent() / 2;
		text( text,
			halfDimension.width,
			halfDimension.height + halfAscent - halfDescent);
		popStyle();
	}

	public void touchImpl(){
		rst();
	}

	//swipe events
	public void swipeCompleted( SwipeKeyboardEvent event){}
	public void swipeStarted( SwipeKeyboardEvent event){}
	public void swipeProgressed( SwipeKeyboardEvent event){
		content = new String();
		for( String suggestion : event.getSuggestions())
			content += String.format( "%s ", suggestion);
	}

	//key events
	public void keyPressed( KeyEvent event){
		System.out.printf("Key pressed: %d\n", event.getKeyCode());
		switch( event.getKeyCode()){
			case KeyEvent.VK_LEFT:
				arrow_left_visible = true;
				break;
			case KeyEvent.VK_RIGHT:
				arrow_right_visible = true;
				break;
			case KeyEvent.VK_UP:
				arrow_up_visible = true;
				break;
			case KeyEvent.VK_DOWN:
				arrow_down_visible = true;
				break;
			default: break;
		}
	}
	public void keyReleased( KeyEvent event){
		System.out.printf("Key released: %d\n", event.getKeyCode());
		switch( event.getKeyCode()){
			case KeyEvent.VK_LEFT:
				arrow_left_visible = false;
				break;
			case KeyEvent.VK_RIGHT:
				arrow_right_visible = false;
				break;
			case KeyEvent.VK_UP:
				arrow_up_visible = false;
				break;
			case KeyEvent.VK_DOWN:
				arrow_down_visible = false;
				break;
			default: break;
		}
	}
	public void keyTyped( KeyEvent event){
		System.out.printf("Key typed: %d\n", event.getKeyCode());

	}
}
