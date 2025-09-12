import '../../repositories/income_repository.dart';
import '../../entities/income.dart';

class GetIncomes {
  final IncomeRepository repository;

  GetIncomes(this.repository);

  Future<List<Income>> call() async {
    return await repository.getIncomes();
  }
}
