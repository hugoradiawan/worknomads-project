import 'package:flutter/material.dart';
import 'package:frontend/app.dart' show MyApp;
import 'package:frontend/core/widgets/core_provider.dart' show CoreProvider;

void main() {
  runApp(CoreProvider(child: const MyApp()));
}
