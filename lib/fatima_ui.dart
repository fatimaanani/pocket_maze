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
    return const Scaffold();
  }
}
