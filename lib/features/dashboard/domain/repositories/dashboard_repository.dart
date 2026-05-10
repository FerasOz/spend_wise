import 'package:spend_wise/features/dashboard/domain/entities/dashboard_source_data.dart';

abstract class DashboardRepository {
  Future<DashboardSourceData> getDashboardSourceData();
}
