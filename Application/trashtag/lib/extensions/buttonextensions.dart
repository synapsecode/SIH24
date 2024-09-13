// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

extension ElevatedButtonExtensions on ElevatedButton {
  ElevatedButton primaryColor(Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
    );
  }
}
