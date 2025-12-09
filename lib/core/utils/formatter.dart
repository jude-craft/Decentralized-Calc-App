class Formatter {
  // Private constructor
  Formatter._();
  
  /// Formats a BigInt to a readable string with commas
  static String formatBigInt(BigInt value) {
    final str = value.toString();
    final buffer = StringBuffer();
    
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    
    return buffer.toString();
  }
  
  /// Formats operation for display
  static String formatOperation(String operation) {
    switch (operation) {
      case '+':
        return 'Addition';
      case '-':
        return 'Subtraction';
      case '×':
        return 'Multiplication';
      case '÷':
        return 'Division';
      case '%':
        return 'Modulus';
      default:
        return operation;
    }
  }
  
  /// Truncates a string to a maximum length
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '\${text.substring(0, maxLength)}...';
  }
  
  /// Formats transaction hash for display
  static String formatTxHash(String hash) {
    if (hash.length <= 16) return hash;
    return '\${hash.substring(0, 8)}...\${hash.substring(hash.length - 8)}';
  }
}