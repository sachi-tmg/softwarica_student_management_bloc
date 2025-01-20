import 'package:flutter/material.dart';
import 'package:softwarica_student_management_bloc/app/app.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive Database
  await HiveService.init();

  // Delete all the hive data and boxes
  // await HiveService().clearAll();
  // Initialize Dependencies
  await initDependencies();

  runApp(
    App(),
  );
}
