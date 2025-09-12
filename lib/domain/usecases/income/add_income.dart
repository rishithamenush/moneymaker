import '../../repositories/income_repository.dart';
import '../../entities/income.dart';

class AddIncome {
  final IncomeRepository repository;

  AddIncome(this.repository);

  Future<Income> call(Income income) async {
    return await repository.addIncome(income);
  }
}
