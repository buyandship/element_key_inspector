import 'dart:ui';

import 'package:flutter/material.dart';

final FlutterView window = WidgetsBinding.instance.platformDispatcher.views.first;
final Size physicalSize = window.physicalSize;
final double devicePixelRatio = window.devicePixelRatio;

final double screenHeight = physicalSize.height / devicePixelRatio;
final double screenWidth = physicalSize.width / devicePixelRatio;
