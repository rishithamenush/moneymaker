import '../../domain/entities/expense.dart';
import '../../domain/entities/budget.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../data/repositories/budget_repository_impl.dart';
import '../../data/repositories/category_repository_impl.dart';

class DataSeeder {
  static Future<void> seedInitialData() async {
    final expenseRepo = ExpenseRepositoryImpl();
    final budgetRepo = BudgetRepositoryImpl();
    final categoryRepo = CategoryRepositoryImpl();
    
    // Check if data already exists
    final existingExpenses = await expenseRepo.getExpenses();
    if (existingExpenses.isNotEmpty) {
      print('Data already exists, skipping seed');
      return;
    }
    
    // Get categories
    final categories = await categoryRepo.getCategories();
    final foodCategory = categories.firstWhere((c) => c.id == 'food');
    final transportCategory = categories.firstWhere((c) => c.id == 'transport');
    final billsCategory = categories.firstWhere((c) => c.id == 'bills');
    
    // Seed sample expenses
    final sampleExpenses = [
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_1',
        amount: 500.0,
        description: 'Coffee',
        categoryId: foodCategory.id,
        categoryName: foodCategory.name,
        date: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_2',
        amount: 2500.0,
        description: 'Petrol',
        categoryId: transportCategory.id,
        categoryName: transportCategory.name,
        date: DateTime.now().subtract(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_3',
        amount: 1500.0,
        description: 'Lunch',
        categoryId: foodCategory.id,
        categoryName: foodCategory.name,
        date: DateTime.now().subtract(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_4',
        amount: 8000.0,
        description: 'Electricity Bill',
        categoryId: billsCategory.id,
        categoryName: billsCategory.name,
        date: DateTime.now().subtract(const Duration(days: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
    
    // Add expenses
    for (final expense in sampleExpenses) {
      await expenseRepo.addExpense(expense);
    }
    
    // Seed sample budgets
    final currentMonth = DateTime.now();
    final sampleBudgets = [
      Budget(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_budget_1',
        amount: 15000.0,
        categoryId: foodCategory.id,
        categoryName: foodCategory.name,
        month: currentMonth,
        spentAmount: 2000.0,
        createdAt: currentMonth.subtract(const Duration(days: 30)),
        updatedAt: currentMonth.subtract(const Duration(days: 30)),
      ),
      Budget(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_budget_2',
        amount: 10000.0,
        categoryId: transportCategory.id,
        categoryName: transportCategory.name,
        month: currentMonth,
        spentAmount: 2500.0,
        createdAt: currentMonth.subtract(const Duration(days: 30)),
        updatedAt: currentMonth.subtract(const Duration(days: 30)),
      ),
      Budget(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_budget_3',
        amount: 25000.0,
        categoryId: billsCategory.id,
        categoryName: billsCategory.name,
        month: currentMonth,
        spentAmount: 8000.0,
        createdAt: currentMonth.subtract(const Duration(days: 30)),
        updatedAt: currentMonth.subtract(const Duration(days: 30)),
      ),
    ];
    
    // Add budgets
    for (final budget in sampleBudgets) {
      await budgetRepo.createBudget(budget);
    }
    
    print('Sample data seeded successfully');
  }
}
