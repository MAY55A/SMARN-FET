import 'dart:ui';

import 'package:flutter/material.dart';

PreferredSizeWidget? Appbar() {
   return AppBar(
     title: const Text('Admin Dashboard'),
     backgroundColor:
         const Color.fromARGB(255, 129, 77, 139), // AppBar color
     elevation: 4, // Slight elevation for shadow effect
   );
 }