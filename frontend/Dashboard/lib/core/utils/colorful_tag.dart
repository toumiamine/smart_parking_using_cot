import 'dart:ui';

import 'package:flutter/material.dart';

Color getRoleColor(String? role) {
  if (role == "Admin") {
    return Colors.green;
  } else if (role == "User") {
    return Colors.blueAccent;
  }
  return Colors.black38;
}
