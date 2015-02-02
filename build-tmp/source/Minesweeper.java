import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Minesweeper extends PApplet {

private TheBoard b1;
private Boolean gameOver = false;
private int bombCount = 0;
//Creates the game boeard
public class TheBoard{
	private MSButton[][] buttons = new MSButton[20][20]; //2d array of minesweeper buttons

	//initialize the board
	public TheBoard(){
		bombCount=0;
		for(int i = 0; i<buttons.length; i++){
			for(int a = 0; a<buttons[i].length; a++){
				buttons[i][a] = new MSButton(i*(25),a*(25), "");
			}
		}
		for(int i = 0; i<buttons.length; i++){
			for(int a = 0; a<buttons[i].length; a++){
				double d = Math.random();
				if(d>.1f)
					continue;
				buttons[i][a] = new MSButton(i*(25),a*(25), "B");
				bombCount++;
				try {//1
					buttons[i-1][a-1].addValue();
				} catch (Throwable e) { 
				}

				try { //2 
					buttons[i][a-1].addValue();
				} catch (Throwable e) {
				}

				try { //3
					buttons[i+1][a-1].addValue();
				} catch (Throwable e) {
				}

				try { //4
					buttons[i+1][a].addValue();
				} catch (Throwable e) {
				}

				try {//5
					buttons[i+1][a+1].addValue();
				} catch (Throwable e) {
				}

				try { // 6
					buttons[i][a+1].addValue();
				} catch (Throwable e) {
				}

				try { //7
					buttons[i-1][a+1].addValue();
				} catch (Throwable e) {
				}

				try { //8
					buttons[i-1][a].addValue();	
				} catch (Throwable e) {
				}
			}
		}
	}

	//called when left mouse button is pressed
	public void checkClick(){
		for(int i = 0; i<buttons.length; i++){
			for(int a = 0; a<buttons[i].length; a++){
				buttons[i][a].setPressed(buttons,i,a);
			}
		}
	}

	//called when right mouse button is pressed
	public void checkFlag(){
		for(MSButton[] array: buttons){
			for(MSButton c : array){
				c.setFlag();
			}
		}
	}

	//called every frame to draw board
	public void drawBoard(){
		for(MSButton[] array: buttons){
			for(MSButton c : array){
				c.hoverOff();
				c.checkHover();
				c.drawButton();
			}
		}
	}
}

public class MSButton{
	private int x;
	private int y;
	private int theLength = 25;
	private int val = 0;
	private String theText="";
	private boolean isPressed = false;
	private boolean isFlagged = false;
	private boolean isHover = false;
	int c = color(224, 224, 224);
	int str = color(0, 0, 0);
	//instantiates at x and y
	public MSButton(int x, int y, String theText){
		this.x=x;
		this.y=y;
		this.theText = theText;
	}

	//checks if mouse is on button
	private boolean checkMouse(){
		if(mouseX>x && mouseY>y && mouseX<x+theLength && mouseY<y+theLength)
			return true;
		return false;
	}

	//sets button's text
	public void setText(String theText){
		this.theText = theText;
	}

	//sets button's color
	public void setColor(int r, int g, int b){
		this.c = color(r, g, b);
	}

	//set's button's border color
	public void setStroke(int r, int g, int b){
		this.str = color(r, g, b);
	}

	public void addValue(){
		val++;
		if(!theText.equals("B"))
			theText = "" + val;
	}

	//draws button
	public void drawButton(){
		//draws rect
		stroke(1);
		if(!isPressed && !isHover){
			setColor(224,224,224);
			setStroke(0,0,0);
		}

		fill(c);
		stroke(str);
		rect(x,y,theLength,theLength);

		if(gameOver){
			isPressed = true;
			setColor(0,0,0);
			setStroke(25,0,255);
		}
		//draws flag is the button is flagged
		if(isFlagged){
			noStroke();
			fill(139,69,19);
			rect(x+7, y+12, 4, 12);
			fill(165,42,42);
			rect(x+7, y+6, 12, 8);
		}
		//draws text if the button is pressed
		if(isPressed){
			fill(255);
			textSize(15);
			text(theText,x+12,y+12);
		}
	}

	//if the button is hovered over by the mouse, change the color
	public void checkHover(){
		if(checkMouse() && !isPressed){
			isHover = true;
			setColor(135,135,135);
			setStroke(200,200,200);
		}
	}

	//if mouse not on object, turn hover off
	public void hoverOff(){
		isHover = false;
	}

	//recursive spread to surrounding buttons
	public void spreadPress(MSButton[][] buttons, int i, int a){
		if (!isPressed && !isFlagged){
			isPressed=true;
			setColor(0,0,0);
			setStroke(25,0,255);
			if(theText.equals("")){
				try {//1
					buttons[i-1][a-1].spreadPress(buttons, i-1,a-1);
				} catch (Throwable e) { 
				}

				try { //2 
					buttons[i][a-1].spreadPress(buttons, i,a-1);
				} catch (Throwable e) {
				}

				try { //3
					buttons[i+1][a-1].spreadPress(buttons, i+1,a-1);
				} catch (Throwable e) {
				}

				try { //4
					buttons[i+1][a].spreadPress(buttons, i+1, a);
				} catch (Throwable e) {
				}

				try {//5
					buttons[i+1][a+1].spreadPress(buttons, i+1, a+1);
				} catch (Throwable e) {
				}

				try { // 6
					buttons[i][a+1].spreadPress(buttons, i, a+1);
				} catch (Throwable e) {
				}

				try { //7
					buttons[i-1][a+1].spreadPress(buttons, i-1, a+1);
				} catch (Throwable e) {
				}

				try { //8
					buttons[i-1][a].spreadPress(buttons, i-1,a);	
				} catch (Throwable e) {
				} 
			}
		}
	}

	//if button is pressed remove flag, change color, and start recursive spread
	public void setPressed(MSButton[][] buttons, int i, int a){
		if(checkMouse() && !isPressed && !isFlagged){
			isPressed = true;
			setColor(0,0,0);
			setStroke(25,0,255);
			if(theText.equals("B")){
				gameOver=true;
			} else if (theText.equals("")){
				try {//1
					buttons[i-1][a-1].spreadPress(buttons, i-1,a-1);
				} catch (Throwable e) { 
				}

				try { //2 
					buttons[i][a-1].spreadPress(buttons, i,a-1);
				} catch (Throwable e) {
				}

				try { //3
					buttons[i+1][a-1].spreadPress(buttons, i+1,a-1);
				} catch (Throwable e) {
				}

				try { //4
					buttons[i+1][a].spreadPress(buttons, i+1, a);
				} catch (Throwable e) {
				}

				try {//5
					buttons[i+1][a+1].spreadPress(buttons, i+1, a+1);
				} catch (Throwable e) {
				}

				try { // 6
					buttons[i][a+1].spreadPress(buttons, i, a+1);
				} catch (Throwable e) {
				}

				try { //7
					buttons[i-1][a+1].spreadPress(buttons, i-1, a+1);
				} catch (Throwable e) {
				}

				try { //8
					buttons[i-1][a].spreadPress(buttons, i-1,a);	
				} catch (Throwable e) {
				} 
			}
		}
	}

	//if button is pressed add flag
	public void setFlag(){
		if(checkMouse() && !isPressed && !isFlagged){
			isFlagged=true;
			if(theText.equals("B")){
				bombCount--;
			} else {
				bombCount++;
			}
		} else if(checkMouse() && !isPressed && isFlagged){
			isFlagged=false;
			if(theText.equals("B"))
				bombCount++;
			else
				bombCount--;
		}
		System.out.println(bombCount);
	}
}

public void setup (){
    size(500, 500);
    textAlign(CENTER,CENTER);
    //rectMode(CENTER);   
    b1=new TheBoard(); 
    System.out.println(bombCount);
}


public void draw (){
    background(0);
    b1.drawBoard();

    if(bombCount==0){
    	gameOver=true;
    	fill(102,255,102);
    	stroke(10);
    	textAlign(CENTER,CENTER);
    	textSize(80);
    	text("YOU WIN", width/2,height/2);
    	textSize(20);
    	text("click to restart", width/2,height/2+height/6);
    } else if(gameOver){
    	fill(255,0,0);
    	stroke(10);
    	textAlign(CENTER,CENTER);
    	textSize(80);
    	text("YOU LOSE", width/2,height/2);
    	textSize(20);
    	text("click to restart", width/2,height/2+height/6);
    }
}

public void mouseClicked() {
  if (mouseButton == LEFT) {
  	if(!gameOver){
    	b1.checkClick();
  	}else{
    	b1=new TheBoard(); 
    	gameOver=false;
    }

  } else if (mouseButton == RIGHT) {
  	if(!gameOver){
    	b1.checkFlag();
	}else{
    	b1=new TheBoard(); 
    	gameOver=false;
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Minesweeper" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
