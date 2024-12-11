import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;

  FloatingButton({required this.onPressed, this.icon = Icons.add});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      child: Icon(this.icon),
    );
  }
}