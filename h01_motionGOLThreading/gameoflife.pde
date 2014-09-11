class GOL {

  int w = 5;
  int columns, rows;

  Cell[][] board;

  GOL() {
    columns = width/w;
    rows = height/w;
    board = new Cell[columns][rows];
    init();
  } 

  void init() {
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        board[i][j] = new Cell(i*w, j*w, w);
      }
    }
  }

  void generate() {
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        board[i][j].savePrevious();
      }
    }

    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {

        int neighbors = 0;
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            neighbors += board[(x+i+columns)%columns][(y+j+rows)%rows].previous;
          }
        }

        neighbors -= board[x][y].previous;

        if      ((board[x][y].state == 1) && (neighbors <  2)) board[x][y].newState(0);           // Loneliness
        else if ((board[x][y].state == 1) && (neighbors >  3)) board[x][y].newState(0);           // Overpopulation
        else if ((board[x][y].state == 0) && (neighbors == 3)) board[x][y].newState(1);
      }
    }
  }

  void display() {
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        board[i][j].display();
      }
    }
  }

  void click(int X, int Y) {
    int posX = ((int(X - (X % w) ))/w)-1; 
    int posY = ((int(Y - (Y % w) ))/w)-1;
    //fill(0);
    //ellipseMode(CORNER);
    //ellipse(posX, posY, 10, 10);
    if (posX >= 0 && posY >= 0) {
      board[(posX)][posY].state = 1;
    }
    //board[posX/w][posY/w].previous = 0;
    //board[63][47].state = 1;
    //board[63][47].previous = 0;
  }
}
