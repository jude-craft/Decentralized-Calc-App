import 'package:flutter/foundation.dart';
import '../../data/models/transaction_result.dart';
import '../../data/services/web3_service.dart';

class CalculatorProvider with ChangeNotifier {
  final Web3Service _web3Service;
  
  String _displayValue = '0';
  BigInt? _firstNumber;
  String? _operation;
  bool _isLoading = false;
  String? _errorMessage;
  TransactionResult? _lastResult;

  CalculatorProvider(this._web3Service);

  String get displayValue => _displayValue;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TransactionResult? get lastResult => _lastResult;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _web3Service.initialize();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to initialize: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void inputNumber(String number) {
    if (_displayValue == '0') {
      _displayValue = number;
    } else {
      _displayValue += number;
    }
    _errorMessage = null;
    notifyListeners();
  }

  void setOperation(String operation) {
    if (_displayValue.isNotEmpty) {
      _firstNumber = BigInt.tryParse(_displayValue);
      _operation = operation;
      _displayValue = '0';
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<void> calculate() async {
    if (_firstNumber == null || _operation == null) return;

    final secondNumber = BigInt.tryParse(_displayValue);
    if (secondNumber == null) {
      _errorMessage = 'Invalid input';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      TransactionResult result;
      
      switch (_operation) {
        case '+':
          result = await _web3Service.add(_firstNumber!, secondNumber);
          break;
        case '-':
          result = await _web3Service.subtract(_firstNumber!, secondNumber);
          break;
        case '×':
          result = await _web3Service.multiply(_firstNumber!, secondNumber);
          break;
        case '÷':
          result = await _web3Service.divide(_firstNumber!, secondNumber);
          break;
        case '%':
          result = await _web3Service.modulus(_firstNumber!, secondNumber);
          break;
        default:
          result = TransactionResult.error('Unknown operation');
      }

      _lastResult = result;
      
      if (result.isSuccess) {
        _displayValue = result.result.toString();
        _errorMessage = null;
      } else {
        _errorMessage = result.errorMessage;
      }
    } catch (e) {
      _errorMessage = 'Calculation failed: ${e.toString()}';
    } finally {
      _firstNumber = null;
      _operation = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _displayValue = '0';
    _firstNumber = null;
    _operation = null;
    _errorMessage = null;
    _lastResult = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}