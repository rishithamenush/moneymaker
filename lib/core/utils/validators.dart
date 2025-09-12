class Validators {
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    
    if (amount > 999999.99) {
      return 'Amount is too large';
    }
    
    return null;
  }
  
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    
    if (value.length < 3) {
      return 'Description must be at least 3 characters';
    }
    
    if (value.length > 100) {
      return 'Description must be less than 100 characters';
    }
    
    return null;
  }
  
  static String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Category is required';
    }
    return null;
  }
  
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }
    
    final now = DateTime.now();
    if (value.isAfter(now)) {
      return 'Date cannot be in the future';
    }
    
    final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
    if (value.isBefore(oneYearAgo)) {
      return 'Date cannot be more than one year ago';
    }
    
    return null;
  }
  
  static String? validateBudgetAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Budget amount is required';
    }
    
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    
    if (amount <= 0) {
      return 'Budget amount must be greater than 0';
    }
    
    if (amount > 1000000) {
      return 'Budget amount is too large';
    }
    
    return null;
  }
}
