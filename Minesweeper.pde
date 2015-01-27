TheBoard b1;
Boolean gameOver = false;
//Creates the game boeard
public class TheBoard{
	private MSButton[][] buttons = new MSButton[20][20]; //2d array of minesweeper buttons

	//initialize the board
	public TheBoard(){
		for(int i = 0; i<buttons.length; i++){
			for(int a = 0; a<buttons[i].length; a++){
				double d = Math.random();
				if(d<.1)
					buttons[i][a] = new MSButton(i*(25),a*(25), "B");
				else
					buttons[i][a] = new MSButton(i*(25),a*(25), "");
			}
		}
	}

	//called when left mouse button is pressed
	public void checkClick(){
		for(MSButton[] array: buttons){
			for(MSButton c : array){
				c.setPressed();
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
	int theLength = 25;
	int x;
	int y;
	String theText="";
	boolean isPressed = false;
	boolean isFlagged = false;
	boolean isHover = false;
	color c = color(224, 224, 224);
	color str = color(0, 0, 0);
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

		//draws text if the button is pressed
		if(isPressed){
			fill(255);
			textSize(15);
			text(theText,x+12,y+12);
		}

		//draws flag is the button is flagged
		if(isFlagged){
			noStroke();
			fill(139,69,19);
			rect(x+7, y+12, 4, 12);
			fill(165,42,42);
			rect(x+7, y+6, 12, 8);
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

	//if button is pressed remove flag and change color
	public void setPressed(){
		if(checkMouse() && !isPressed){
			isPressed = true;
			isFlagged=false;
			setColor(0,0,0);
			setStroke(25,0,255);
			if(theText.equals("B")){
				gameOver=true;
			}
		}
	}

	//if button is pressed add flag
	public void setFlag(){
		if(checkMouse() && !isPressed && !isFlagged){
			isFlagged=true;
		} else if(checkMouse() && !isPressed && isFlagged){
			isFlagged=false;
		}
	}
}

void setup (){
    size(500, 500);
    textAlign(CENTER,CENTER);
    //rectMode(CENTER);   
    b1=new TheBoard(); 
}


public void draw (){
    background(0);
    b1.drawBoard();
}

void mousePressed() {
  if (mouseButton == LEFT) {
  	if(!gameOver)
    	b1.checkClick();
  } else if (mouseButton == RIGHT) {
  	if(!gameOver)
    	b1.checkFlag();
  }
}