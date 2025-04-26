import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const ActionButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: _ActionButtonContent(),
    );
  }
}

class _ActionButtonContent extends StatelessWidget {
  const _ActionButtonContent();

  @override
  Widget build(BuildContext context) {
    final ActionButton button =
        context.findAncestorWidgetOfExactType<ActionButton>()!;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 48),
      ),
      onPressed: button.onPressed,
      child: Text(button.label, style: const TextStyle(color: Colors.black)),
    );
  }
}
