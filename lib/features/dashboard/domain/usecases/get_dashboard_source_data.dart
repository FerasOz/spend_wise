import 'package:spend_wise/features/dashboard/domain/entities/dashboard_source_data.dart';
import 'package:spend_wise/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardSourceData {
  const GetDashboardSourceData(this._dashboardRepository);

  final DashboardRepository _dashboardRepository;

  Future<DashboardSourceData> call() {
    return _dashboardRepository.getDashboardSourceData();
  }
}
