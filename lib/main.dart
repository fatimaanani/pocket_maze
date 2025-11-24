import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'fatima_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MazePage(),
    );
  }
}

class MazePage extends StatefulWidget {
  const MazePage({super.key});

  @override
  State<MazePage> createState() => _MazePageState();
}

class _MazePageState extends State<MazePage> {

  int gridSize = 8;
  List<List<int>> grid = [];          // hayde maze map

  int moves = 0;
  int mistakes = 0;
  bool hasKey = false;                // player key eza ma3o aw no

  final Random random = Random();
  final FocusNode keyboardFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    resetGame();                      // build maze on load
  }

  // rebuild the maze from zero every time
  void resetGame() {

    // start with an empty grid
    grid = List.generate(
      gridSize,
          (row) => List.generate(gridSize, (column) => 0),
    );

    moves = 0;
    mistakes = 0;
    hasKey = false;

    grid[0][0] = 4;                   // start position lal player

    // safe zone kermel player moves safely
    if (gridSize > 1) {
      grid[0][1] = 0;
      grid[1][0] = 0;
      grid[1][1] = 0;
    }

    fixedWalls();                     // manual walls we placed
    randomWalls();                    // extra random walls
    trapsPlacing();                   // key + exit + traps kellon

    // to prevent random walls ny mistkee
    if (gridSize > 1) {
      grid[0][1] = 0;
      grid[1][0] = 0;
      grid[1][1] = 0;
    }

    setState(() {});
  }

  //tiles w movement
  void movePlayer(int rowChange, int colChange) {

    // find current player location
    int currentRow = 0;
    int currentColumn = 0;

    for (int row = 0; row < gridSize; row++) {
      for (int column = 0; column < gridSize; column++) {
        if (grid[row][column] == 4) {
          currentRow = row;
          currentColumn = column;
        }
      }
    }

    int newRow = currentRow + rowChange;
    int newColumn = currentColumn + colChange;

    // block moves outside the maze
    if (newRow < 0 || newRow >= gridSize || newColumn < 0 || newColumn >= gridSize) {
      return;
    }

    int tile = grid[newRow][newColumn];

    // WALL
    if (tile == 1) {
      increaseMistakes();
      return;
    }

    // kill trap, resets key w restarts game
    if (tile == 5) {
      hasKey = false;
      switchKey();
      increaseMistakes();
      respawnPlayer(currentRow, currentColumn);
      return;
    }

    // return trap betredd to start posititon
    if (tile == 6) {
      increaseMistakes();
      respawnPlayer(currentRow, currentColumn);
      return;
    }

    // randomize key place even if ma3o yeh l player
    if (tile == 7) {
      hasKey = false;
      switchKey();
      increaseMistakes();
    }

    // tile for key
    if (tile == 2) {
      hasKey = true;
    }

    // exitflag tile
    if (tile == 3) {
      if (hasKey) {
        mazeDone();
      } else {
        increaseMistakes();
      }
      return;
    }

    // normal movement
    grid[currentRow][currentColumn] = 0;
    grid[newRow][newColumn] = 4;
    moves++;

    setState(() {});
  }

  // adds a mistake and checks if player reached the limit
  void increaseMistakes() {
    mistakes++;
    if (mistakes >= 3) {
      mazeLost();
    } else {
      setState(() {});
    }
  }

  // sends player back to the start
  void respawnPlayer(int oldRow, int oldColumn) {
    grid[oldRow][oldColumn] = 0;
    grid[0][0] = 4;
    setState(() {});
  }

  // removes old key and places a new random one
  void switchKey() {
    for (int row = 0; row < gridSize; row++) {
      for (int column = 0; column < gridSize; column++) {
        if (grid[row][column] == 2) grid[row][column] = 0;
      }
    }
    randomTiles(2);
  }

  // fixed walls la kel grid size
  void fixedWalls() {
    if (gridSize >= 6) {
      grid[1][2] = 1;
      grid[2][4] = 1;
      grid[3][1] = 1;
    }
    if (gridSize >= 8) {
      grid[4][5] = 1;
      grid[5][3] = 1;
    }
    if (gridSize >= 10) grid[6][6] = 1;
    if (gridSize >= 12) {
      grid[7][4] = 1;
      grid[8][7] = 1;
    }
  }

  // places random walls depending on grid size
  void randomWalls() {
    int wallCount = 0;

    if (gridSize == 6) wallCount = 1;
    if (gridSize == 8) wallCount = 2;
    if (gridSize == 10) wallCount = 3;
    if (gridSize == 12) wallCount = 4;

    int placed = 0;

    while (placed < wallCount) {
      int row = random.nextInt(gridSize);
      int column = random.nextInt(gridSize);

      if (grid[row][column] == 0) {
        grid[row][column] = 1;
        placed++;
      }
    }
  }

  // add key, exit, kill traps, return traps, scramble traps
  void trapsPlacing() {
    int trapType = 1;

    if (gridSize == 8) trapType = 2;
    if (gridSize == 10) trapType = 3;
    if (gridSize == 12) trapType = 4;

    placeTrap(5, trapType);   // kill traps
    placeTrap(6, trapType);   // return traps
    placeTrap(7, trapType);   // scramble traps

    randomTiles(2);           // key
    randomTiles(3);           // exit
  }

  // trap placing function
  void placeTrap(int placedTrap, int count) {
    int placed = 0;

    while (placed < count) {
      int row = random.nextInt(gridSize);
      int column = random.nextInt(gridSize);

      if (grid[row][column] == 0) {
        grid[row][column] = placedTrap;
        placed++;
      }
    }
  }

  // random key or exit tile
  void randomTiles(int tileType) {
    bool placed = false;

    while (!placed) {
      int row = random.nextInt(gridSize);
      int column = random.nextInt(gridSize);

      if (grid[row][column] == 0) {
        grid[row][column] = tileType;
        placed = true;
      }
    }
  }

  // win popup
  void mazeDone() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('good job!◝(ᵔᵕᵔ)◜'),
          content: Text('Moves: $moves\nMistakes: $mistakes'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame();
              },
              child: const Text('Play again'),
            ),
          ],
        );
      },
    );
  }

  // lose popup
  void mazeLost() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('you lose (⇀‿↼ )っ✧'),
          content: Text('You made 3 mistakes (｡•̀ᴖ•́｡).\nMoves: $moves'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame();
              },
              child: const Text('Play again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) { //la yemshe l keyboard
    return KeyboardListener(
      focusNode: keyboardFocus,
      autofocus: true,

      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            movePlayer(-1, 0);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {movePlayer(1, 0);}
          else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            movePlayer(0, -1);
          }
          else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            movePlayer(0, 1);
          }
        }
      },

      // pass logic to me (fatima ui)
      child: MazeUi(
        gridSize: gridSize,
        grid: grid,
        moves: moves,
        mistakes: mistakes,

        onMove: movePlayer,
        onReset: resetGame,

        onGridSizeChange: (newSize) {
          gridSize = newSize;
          resetGame();
        },
      ),
    );
  }
}
