import 'package:flutter/material.dart';
import '../models/direction.dart';

class ControlButtons extends StatelessWidget {
  final void Function(Direction) onDirectionChange;
  final bool enabled;

  const ControlButtons({super.key, required this.onDirectionChange, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _buildButton(context, Icons.keyboard_arrow_up, Direction.up),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildButton(context, Icons.keyboard_arrow_down, Direction.down),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildButton(context, Icons.keyboard_arrow_left, Direction.left),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildButton(context, Icons.keyboard_arrow_right, Direction.right),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, Direction direction) {
    return ElevatedButton(
      onPressed: enabled ? () => onDirectionChange(direction) : null,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.grey.withOpacity(0.3),
        foregroundColor: Colors.white,
      ),
      child: Icon(icon, size: 30),
    );
  }
}
