import '../../entities/budget.dart';
import '../../repositories/budget_repository.dart';

class GetBudget {
  final BudgetRepository repository;

  GetBudget(this.repository);

  Future<List<Budget>> call() async {
    return await repository.getBudgets();
  }
}
