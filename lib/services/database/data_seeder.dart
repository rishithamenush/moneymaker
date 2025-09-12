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
    
    // Only seed categories, no dummy expenses or budgets
    print('Database initialized with categories only');
  }
}
