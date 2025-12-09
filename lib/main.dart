import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'app/calculator_app.dart';
import 'core/config/app_config.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // 1. Load the content of config.json
    final String configString = await rootBundle.loadString('config.json');
    // 2. Decode the JSON string
    final Map<String, dynamic> config = json.decode(configString);
    
    // 3. Assign values to the static class
    AppConfig.rpcUrl = config['rpcUrl'] as String;
    AppConfig.contractAddress = config['contractAddress'] as String;
    
    runApp(const CalculatorApp());
  } catch (e) {
    // Handle the case where the config.json file is missing or malformed
    runApp(ErrorApp(error: 'Failed to load configuration. Did you create config.json? Error: $e'));
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Configuration Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}