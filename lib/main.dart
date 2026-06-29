// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Add this import
import 'package:englishfun/app.dart';
import 'package:englishfun/services/auth_provider.dart';
import 'package:englishfun/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseService().initialize();

  runApp(
    // CRITICAL: Wrap your app inside a ProviderScope
    const ProviderScope(
      child: MyApp(),
    ),
  );
  
}
