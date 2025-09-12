import '../../domain/entities/expense.dart';
import '../../domain/entities/income.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../data/repositories/income_repository_impl.dart';
import '../../data/repositories/category_repository_impl.dart';

class DataSeeder {
  static Future<void> seedInitialData() async {
    final expenseRepo = ExpenseRepositoryImpl();
    final incomeRepo = IncomeRepositoryImpl();
    final categoryRepo = CategoryRepositoryImpl();
    
    // Check if data already exists
    final existingExpenses = await expenseRepo.getExpenses();
    final existingIncomes = await incomeRepo.getIncomes();
    
    if (existingExpenses.isNotEmpty || existingIncomes.isNotEmpty) {
      print('Data already exists, skipping seed');
      return;
    }
    
    // Get categories
    final categories = await categoryRepo.getCategories();
    
    // Find categories with fallback
    final foodCategory = categories.firstWhere((c) => c.id == 'food', orElse: () => categories.first);
    final transportCategory = categories.firstWhere((c) => c.id == 'transport', orElse: () => categories.first);
    final billsCategory = categories.firstWhere((c) => c.id == 'bills', orElse: () => categories.first);
    final salaryCategory = categories.firstWhere((c) => c.id == 'salary', orElse: () => categories.first);
    
    // Seed sample expenses
    final sampleExpenses = [
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_exp_1',
        amount: 500.0,
        description: 'Coffee',
        categoryId: foodCategory.id,
        categoryName: foodCategory.name,
        date: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_exp_2',
        amount: 2500.0,
        description: 'Petrol',
        categoryId: transportCategory.id,
        categoryName: transportCategory.name,
        date: DateTime.now().subtract(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_exp_3',
        amount: 8000.0,
        description: 'Electricity Bill',
        categoryId: billsCategory.id,
        categoryName: billsCategory.name,
        date: DateTime.now().subtract(const Duration(days: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
    
    // Seed sample incomes
    final sampleIncomes = [
      Income(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_inc_1',
        amount: 50000.0,
        description: 'Monthly Salary',
        categoryId: salaryCategory.id,
        categoryName: salaryCategory.name,
        date: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Income(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_inc_2',
        amount: 5000.0,
        description: 'Freelance Work',
        categoryId: salaryCategory.id,
        categoryName: salaryCategory.name,
        date: DateTime.now().subtract(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
    
    // Add expenses
    for (final expense in sampleExpenses) {
      await expenseRepo.addExpense(expense);
    }
    
    // Add incomes
    for (final income in sampleIncomes) {
      await incomeRepo.addIncome(income);
    }
    
    print('Sample data seeded successfully');
  }
}
