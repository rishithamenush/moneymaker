import '../../repositories/income_repository.dart';

class GetTotalIncomeByMonth {
  final IncomeRepository repository;

  GetTotalIncomeByMonth(this.repository);

  Future<double> call(DateTime month) async {
    return await repository.getTotalIncomeByMonth(month);
  }
}
