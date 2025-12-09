import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/services/web3_service.dart';
import 'presentation/providers/calculator_provider.dart';
import 'presentation/screens/calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final web3Service = Web3Service();
        final provider = CalculatorProvider(web3Service);
        provider.initialize();
        return provider;
      },
      child: MaterialApp(
        title: 'Web3 Calculator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const CalculatorScreen(),
      ),
    );
  }
}