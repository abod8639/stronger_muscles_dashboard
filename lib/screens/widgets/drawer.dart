import 'package:flutter/material.dart';
import './sidebar.dart';

Widget myDrawer() {
  return const Drawer(
    backgroundColor: Colors.transparent,
    elevation: 0,
    child: Sidebar(isDrawer: true),
  );
}
