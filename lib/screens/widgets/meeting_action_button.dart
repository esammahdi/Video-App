import 'package:flutter/material.dart';

import '../../constants/styles.dart';



// Action Button
class MeetingActionButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;
  final Color backgroundColor, iconColor;
  final double radius, iconSize;

  const MeetingActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = secondaryColor,
    this.iconColor = Colors.white,
    this.radius = 10,
    this.iconSize = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.white30),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.all(8),
        child: IconButton(
          onPressed : onPressed,
          icon : Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
      );
  }
}
