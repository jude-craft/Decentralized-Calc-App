import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import '../../core/constants/contract_constants.dart';
import '../models/transaction_result.dart';

class Web3Service {
  late Web3Client _client;
  late DeployedContract _contract;
  late ContractFunction _addFunction;
  late ContractFunction _subtractFunction;
  late ContractFunction _multiplyFunction;
  late ContractFunction _divideFunction;
  late ContractFunction _modulusFunction;

  Future<void> initialize() async {
    _client = Web3Client(
      ContractConstants.rpcUrl,
      Client(),
    );

    // Load ABI
    final abiString = await rootBundle.loadString(
      ContractConstants.abiPath,
    );
    final abi = jsonDecode(abiString) as List;

    // Setup contract
    _contract = DeployedContract(
      ContractAbi.fromJson(jsonEncode(abi), 'Calculator'),
      EthereumAddress.fromHex(ContractConstants.contractAddress),
    );

    // Get functions
    _addFunction = _contract.function('add');
    _subtractFunction = _contract.function('substract');
    _multiplyFunction = _contract.function('multiply');
    _divideFunction = _contract.function('divide');
    _modulusFunction = _contract.function('modulus');
  }

  Future<TransactionResult> add(BigInt a, BigInt b) async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _addFunction,
        params: [a, b],
      );
      return TransactionResult(result: result.first as BigInt);
    } catch (e) {
      return TransactionResult.error('Addition failed: ${e.toString()}');
    }
  }

  Future<TransactionResult> subtract(BigInt a, BigInt b) async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _subtractFunction,
        params: [a, b],
      );
      return TransactionResult(result: result.first as BigInt);
    } catch (e) {
      return TransactionResult.error('Subtraction failed: ${e.toString()}');
    }
  }

  Future<TransactionResult> multiply(BigInt a, BigInt b) async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _multiplyFunction,
        params: [a, b],
      );
      return TransactionResult(result: result.first as BigInt);
    } catch (e) {
      return TransactionResult.error('Multiplication failed: ${e.toString()}');
    }
  }

  Future<TransactionResult> divide(BigInt a, BigInt b) async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _divideFunction,
        params: [a, b],
      );
      return TransactionResult(result: result.first as BigInt);
    } catch (e) {
      return TransactionResult.error('Division failed: ${e.toString()}');
    }
  }

  Future<TransactionResult> modulus(BigInt a, BigInt b) async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _modulusFunction,
        params: [a, b],
      );
      return TransactionResult(result: result.first as BigInt);
    } catch (e) {
      return TransactionResult.error('Modulus failed: ${e.toString()}');
    }
  }

  void dispose() {
    _client.dispose();
  }
}