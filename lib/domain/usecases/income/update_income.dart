import '../../repositories/income_repository.dart';
import '../../entities/income.dart';

class UpdateIncome {
  final IncomeRepository repository;

  UpdateIncome(this.repository);

  Future<Income> call(Income income) async {
    return await repository.updateIncome(income);
  }
}
