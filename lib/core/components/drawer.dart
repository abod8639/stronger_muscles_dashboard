import 'package:flutter/material.dart';
import 'sidebar.dart';

Widget myDrawer() {
  return const Drawer(
    backgroundColor: Colors.transparent,
    elevation: 0,
    width: 290,
    child: SafeArea(
      child: Sidebar(isDrawer: true),
    ),
  );
}

