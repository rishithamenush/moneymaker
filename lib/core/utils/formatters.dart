import 'package:intl/intl.dart';
import '../constants/colors.dart';

class Formatters {
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');
  static final DateFormat _dayFormat = DateFormat('dd');
  static final DateFormat _monthFormat = DateFormat('MMM');
  
  static String formatCurrency(double amount, {String? currencyCode}) {
    final code = currencyCode ?? 'LKR';
    final symbol = CurrencyOptions.getCurrencySymbol(code);
    
    // Create currency format based on currency type
    NumberFormat currencyFormat;
    if (code == 'JPY' || code == 'KRW') {
      // No decimal places for JPY and KRW
      currencyFormat = NumberFormat.currency(
        symbol: symbol,
        decimalDigits: 0,
      );
    } else {
      // 2 decimal places for most currencies
      currencyFormat = NumberFormat.currency(
        symbol: symbol,
        decimalDigits: 2,
      );
    }
    
    return currencyFormat.format(amount);
  }
  
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }
  
  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }
  
  static String formatDay(DateTime date) {
    return _dayFormat.format(date);
  }
  
  static String formatMonth(DateTime date) {
    return _monthFormat.format(date);
  }
  
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }
  
  static String formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }
}
