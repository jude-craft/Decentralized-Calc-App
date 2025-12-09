import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';

import '../core/config/app_config.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solidity Calculator',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Use the securely loaded configuration variables
  late final String rpcUrl = AppConfig.rpcUrl;
  late final String contractAddress = AppConfig.contractAddress;

  late Web3Client _web3client;
  late DeployedContract _deployedContract;
  
  // 1. Declare contract functions
  late ContractFunction _addFunction;
  late ContractFunction _subFunction;
  late ContractFunction _mulFunction;
  late ContractFunction _divFunction;
  late ContractFunction _modFunction;

  // UI state and controllers
  TextEditingController aController = TextEditingController();
  TextEditingController bController = TextEditingController();
  String _result = 'Configuration Loaded. Ready to calculate.';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeWeb3();
  }

  Future<void> _initializeWeb3() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Initialize the client using the secure RPC URL
      _web3client = Web3Client(rpcUrl, Client());

      // Load ABI from assets 
      String abiCode = await rootBundle.loadString('assets/abi.json');

      _deployedContract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'Calculator'),
        EthereumAddress.fromHex(contractAddress), 
      );

      // 2. Initialize all contract functions
      _addFunction = _deployedContract.function('add');
      _subFunction = _deployedContract.function('substract');
      _mulFunction = _deployedContract.function('multiply');
      _divFunction = _deployedContract.function('divide');
      _modFunction = _deployedContract.function('modulus');
      
    } catch (e) {
      setState(() {
        _result = 'Error during Web3 initialization: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Generic function to call any pure contract function
  Future<void> _callFunction(ContractFunction function, String operation) async {
    if (_isLoading) return;
    
    // Basic input validation
    if (aController.text.isEmpty || bController.text.isEmpty) {
      setState(() {
        _result = 'Please enter both numbers.';
      });
      return;
    }
    
    // Convert string inputs to BigInt for contract calls (required for uint256)
    final BigInt a = BigInt.tryParse(aController.text) ?? BigInt.zero;
    final BigInt b = BigInt.tryParse(bController.text) ?? BigInt.zero;

    setState(() {
      _isLoading = true;
      _result = 'Calculating $operation...';
    });

    try {
      // Call the function (using `call` for pure functions)
      final response = await _web3client.call(
        contract: _deployedContract,
        function: function,
        params: [a, b], 
      );

      // The result is decoded from the RPC response. For single return values, it's the first element.
      BigInt resultValue = response.first as BigInt;

      setState(() {
        _result = '$operation Result: ${resultValue.toString()}';
      });
    } catch (e) {
      // Handle contract revert errors (e.g., "Division by Zero" or "Underflow")
      String errorMessage = e.toString();
      if (errorMessage.contains('revert')) {
        // Attempt to extract the custom revert message from the error string
        _result = 'Contract Revert: ${errorMessage.split('revert').last.trim()}';
      } else {
        _result = 'Blockchain Error: $errorMessage';
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secure Calculator DApp')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Input Fields
            TextField(
              controller: aController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Value A (uint256)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Value B (uint256)'),
            ),
            const SizedBox(height: 30),

            // Operation Buttons Grid
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.count(
                    crossAxisCount: 3, // Three columns for clean layout
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildOperationButton('A + B', Icons.add, _addFunction, 'Add'),
                      _buildOperationButton('A - B', Icons.remove, _subFunction, 'Subtract'),
                      _buildOperationButton('A * B', Icons.close, _mulFunction, 'Multiply'),
                      _buildOperationButton('A / B', Icons.percent, _divFunction, 'Divide'),
                      _buildOperationButton('A % B', Icons.all_inclusive, _modFunction, 'Modulus'),
                    ],
                  ),
            const SizedBox(height: 30),

            // Result Display
            Card(
              elevation: 4,
              color: Theme.of(context).primaryColorLight.withValues(alpha: 0.2),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _result,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper widget for cleaner button creation
  Widget _buildOperationButton(String label, IconData icon, ContractFunction function, String opName) {
    return ElevatedButton.icon(
      onPressed: () => _callFunction(function, opName),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}