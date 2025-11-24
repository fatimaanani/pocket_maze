//ui fatima
import 'package:flutter/material.dart';

class MazeUi extends StatelessWidget {
  final int gridSize;
final List<List<int>> grid;
final int moves;
final int mistakes;
final Function(int rowChange , int colChange) onMove;
final VoidCallback onReset;
final Function(int newSize) onGridSizeChange;
  const MazeUi({super.key ,required this.gridSize,
    required this.grid,
    required this.moves,
    required this.mistakes,
    required this.onMove,
    required this.onReset,
    required this.onGridSizeChange,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xff1e1e1e),
    appBar: AppBar(
    title: const Text(
    'Maze Escape Mini Game',
    style: TextStyle(color: Color(0xff6bb397)),
    ),
    centerTitle: true,
    backgroundColor: const Color(0xff1e1e1e),
    foregroundColor: const Color(0xff6bb397),
    ),
    body: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [],
    ),
    );
  }
}
