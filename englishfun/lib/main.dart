import 'package:flutter/material.dart';
import 'package:englishfun/app.dart';
import 'package:englishfun/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService().initialize();
  
  runApp(const MyApp());
}
