private TheBoard b1;
private Boolean gameOver = false;
private int bombCount = 0;
public static final int BOMBAMOUNT = 50;
private boolean firstClick = true;
//Creates the game boeard
public class TheBoard{
	private MSButton[][] buttons = new MSButton[20][20]; //2d array of minesweeper buttons

	//initialize the board
	public TheBoard(){
		bombCount=1;
		for(int i = 0; i<buttons.length; i++){
			for(int a = 0; a<buttons[i].length; a++){
				buttons[i][a] = new MSButton(i*(25),a*(25), "");
			}
		}
	}

	public void genBoard(){
		bombCount=0;
		for(int i = 0; i<buttons.length; i++){
			for(int a = 0; a<buttons[i].length; a++){
				buttons[i][a] = new MSButton(i*(25),a*(25), "");
			}
		}
		for(int i = 0; i<BOMBAMOUNT; i++){
			int r = (int) (Math.random()*buttons.length);
			int c = (int) (Math.random()*buttons.length);
			if(buttons[r][c].getValue().equals("B") || buttons[r][c].checkGen()){
				i--;
				continue;
			}
			buttons[r][c] = new MSButton(r*25,c*25, "B");
			bombCount++;
			for(int a=-1; a<=1; a++){
				for(int b=-1; b<=1; b++){
					try {//1
						buttons[r+a][c+b].addValue();
					} catch (Throwable e) { 
					}
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
	color c = color(224, 224, 224);
	color str = color(0, 0, 0);
	//instantiates at x and y
	public MSButton(int x, int y, String theText){
		this.x=x;
		this.y=y;
		this.theText = theText;
	}

	//checks if mouse is on button
	public boolean checkMouse(){
		if(mouseX>x && mouseY>y && mouseX<x+theLength && mouseY<y+theLength)
			return true;
		return false;
	}

	public boolean checkGen(){
		if(mouseX>(x-theLength) && mouseY>(y-theLength) && mouseX<(x+2*theLength) && mouseY<(y+2*theLength))
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
			setColor(255,255,255);
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
			setColor(200,200,200);
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
				for(int g=-1; g<=1; g++){
					for(int b=-1; b<=1; b++){
						try {//1
							buttons[i+g][a+b].spreadPress(buttons, i+g,a+b);
						} catch (Throwable e) { 
						}
					}
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
				for(int g=-1; g<=1; g++){
					for(int b=-1; b<=1; b++){
						try {//1
							buttons[i+g][a+b].spreadPress(buttons, i+g,a+b);
						} catch (Throwable e) { 
						}
					}
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
	}

	public String getValue(){
		return theText;
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

void mouseClicked() {
  if (mouseButton == LEFT) {
    if(firstClick){
    	firstClick=false;
    	b1.genBoard();
    }

  	if(!gameOver){
    	b1.checkClick();
  	}else{
    	b1=new TheBoard(); 
    	gameOver=false;
    	firstClick=true;
    }

  } else if (mouseButton == RIGHT) {
    if(firstClick){
    	firstClick=false;
    	b1.genBoard();
    }

  	if(!gameOver){
    	b1.checkFlag();
	}else{
    	b1=new TheBoard(); 
    	gameOver=false;
    	firstClick=true;
    }

  }
}
