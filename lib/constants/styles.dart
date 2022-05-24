import 'package:flutter/material.dart';

const Color primaryColor = Color.fromRGBO(17, 120, 248, 1);
const Color secondaryColor = Color.fromRGBO(33, 32, 50, 1);
const Color hoverColor = Color.fromRGBO(51, 50, 68, 1);

final RoundedButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
);
