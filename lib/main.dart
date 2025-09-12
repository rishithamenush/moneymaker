import 'package:flutter/material.dart';
import 'app/app.dart';
import 'services/database/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseService.initialize();
  
  runApp(const MoneyMakerApp());
}
