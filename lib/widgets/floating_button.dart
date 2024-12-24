import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
  Key? key;

  FloatingButton({Key? key,required this.onPressed, this.icon = Icons.add}){
    this.key = key;
  }


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: key,
      onPressed: onPressed,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      child: Icon(this.icon),
    );
  }
}