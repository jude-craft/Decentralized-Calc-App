import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Web3 Calculator'),
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 0,
      ),
      body: Consumer<CalculatorProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.displayValue == '0') {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }

          return Column(
            children: [
              _buildDisplay(provider),
              if (provider.errorMessage != null)
                _buildErrorBanner(context, provider),
              Expanded(child: _buildButtonGrid(provider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDisplay(CalculatorProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      color: const Color(0xFF2D2D2D),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (provider.isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          Text(
            provider.displayValue,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, CalculatorProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.red.shade900,
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              provider.errorMessage!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: provider.clearError,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonGrid(CalculatorProvider provider) {
    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(8),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        _buildButton('7', provider, isNumber: true),
        _buildButton('8', provider, isNumber: true),
        _buildButton('9', provider, isNumber: true),
        _buildButton('÷', provider, isOperator: true),
        _buildButton('4', provider, isNumber: true),
        _buildButton('5', provider, isNumber: true),
        _buildButton('6', provider, isNumber: true),
        _buildButton('×', provider, isOperator: true),
        _buildButton('1', provider, isNumber: true),
        _buildButton('2', provider, isNumber: true),
        _buildButton('3', provider, isNumber: true),
        _buildButton('-', provider, isOperator: true),
        _buildButton('C', provider, isSpecial: true),
        _buildButton('0', provider, isNumber: true),
        _buildButton('%', provider, isOperator: true),
        _buildButton('+', provider, isOperator: true),
        _buildButton('=', provider, isEquals: true, span: 4),
      ],
    );
  }

  Widget _buildButton(
    String label,
    CalculatorProvider provider, {
    bool isNumber = false,
    bool isOperator = false,
    bool isSpecial = false,
    bool isEquals = false,
    int span = 1,
  }) {
    Color backgroundColor;
    if (isOperator) {
      backgroundColor = const Color(0xFF505050);
    } else if (isSpecial) {
      backgroundColor = const Color(0xFFA5A5A5);
    } else if (isEquals) {
      backgroundColor = Colors.blueAccent;
    } else {
      backgroundColor = const Color(0xFF3A3A3A);
    }

    final button = Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: provider.isLoading
            ? null
            : () {
                if (isNumber) {
                  provider.inputNumber(label);
                } else if (isOperator) {
                  provider.setOperation(label);
                } else if (isSpecial) {
                  provider.clear();
                } else if (isEquals) {
                  provider.calculate();
                }
              },
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isEquals ? 28 : 32,
              fontWeight: FontWeight.w400,
              color: isSpecial ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );

    if (span > 1) {
      return GridTile(
        child: button,
      );
    }
    return button;
  }
}