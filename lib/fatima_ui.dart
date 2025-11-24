//ui fatima
import 'package:flutter/material.dart';

class MazeUi extends StatelessWidget {
  final int gridSize;
  final List<List<int>> grid;
  final int moves;
  final int mistakes;
  final Function(int rowChange, int colChange) onMove;
  final VoidCallback onReset;
  final Function(int newSize) onGridSizeChange;

  const MazeUi({
    super.key,
    required this.gridSize,
    required this.grid,
    required this.moves,
    required this.mistakes,
    required this.onMove,
    required this.onReset,
    required this.onGridSizeChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1e1e1e),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logoo.jpg', height: 55),
            const SizedBox(width: 12),
            const Text(
              'Pocket Maze',
              style: TextStyle(color: Color(0xff6bb397), fontSize: 22),
            ),
          ],
        ),
        backgroundColor: const Color(0xff262626),
        foregroundColor: const Color(0xff6bb397),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DropdownMenu(
              textStyle: TextStyle(color: Color(0xff6bb397)),
              initialSelection: gridSize,
              onSelected: (value) {
                if (value is int) onGridSizeChange(value);
              },
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 6, label: '6 x 6'),
                DropdownMenuEntry(value: 8, label: '8 x 8'),
                DropdownMenuEntry(value: 10, label: '10 x 10'),
                DropdownMenuEntry(value: 12, label: '12 x 12'),
              ],
            ),
          ),

          Expanded(child: //for the overflow
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 320,
              height: 320,
              child: GridView.builder(
                itemCount: gridSize * gridSize,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                ),
                itemBuilder: (_, index) {
                  int row = index ~/ gridSize; //int division
                  int column =
                      index %
                      gridSize; // hay l % for how far inside the row you are
                  return buildTile(grid[row][column]);
                },
              ),
            ),
          ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Moves: $moves   ',
                style: TextStyle(color: Color(0xff6bb397), fontSize: 18),
              ),
              Text(
                'Mistakes: $mistakes',
                style: TextStyle(color: Color(0xff6bb397), fontSize: 18),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Column(
            children: [
              ElevatedButton(
                onPressed: () => onMove(-1, 0),
                child: Icon(Icons.arrow_upward),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onMove(0, -1),
                    child: Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => onMove(0, 1),
                    child: Icon(Icons.arrow_forward),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () => onMove(1, 0),
                child: Icon(Icons.arrow_downward),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ElevatedButton(onPressed: onReset, child: Text('Restart')),
        ],
      ),
    );
  }

  Widget buildTile(int tile) {
    // player
    if (tile == 4) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Color(0xff6bb397),
          shape: BoxShape.circle,
        ),
      );
    }
    if (tile == 5) return tileIcon('💀');
    if (tile == 6) return iconTile(Icons.refresh, const Color(0xff6bb397));
    if (tile == 7) return iconTile(Icons.shuffle, const Color(0xffe6c34d));
    if (tile == 2) return iconTile(Icons.vpn_key, const Color(0xffe6c34d));
    if (tile == 3) return iconTile(Icons.flag, const Color(0xff6bb397));
    // walls + empty
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: (tile == 1)
            ? const Color(0xff444444) // wall
            : const Color(0xff2c2c2c), // empty tile
        border: Border.all(color: const Color(0xff6bb397), width: 0.5),
      ),
    );
  }

  Widget tileIcon(String emoji) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xff2c2c2c),
        border: Border.all(color: const Color(0xff6bb397), width: 0.5),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
    );
  }

  // helper: icon tile (key, exit, traps)
  Widget iconTile(IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xff2c2c2c),
        border: Border.all(color: const Color(0xff6bb397), width: 0.5),
      ),
      child: Center(child: Icon(icon, color: color, size: 20)),
    );
  }
}
