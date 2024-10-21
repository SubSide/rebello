import 'package:flutter/material.dart';
import 'package:presentation/app.dart';

import 'di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const RebelloApp());
}