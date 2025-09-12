import '../../repositories/income_repository.dart';
import '../../entities/income.dart';

class GetIncomesByMonth {
  final IncomeRepository repository;

  GetIncomesByMonth(this.repository);

  Future<List<Income>> call(DateTime month) async {
    return await repository.getIncomesByMonth(month);
  }
}
