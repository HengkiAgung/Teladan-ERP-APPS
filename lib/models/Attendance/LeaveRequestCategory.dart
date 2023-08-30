import '../Employee/User.dart';

class LeaveRequestCategory {
  late int id;
  late String name;
  late String code;
  late String effective_date;
  late int leave_quota_reduction;
  late String expired_date;
  				

  LeaveRequestCategory({
    required this.id,
    required this.name,
    required this.code,
    required this.effective_date,
    required this.leave_quota_reduction,
    required this.expired_date,
  });

  LeaveRequestCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    code = json['code'] ?? "";
    effective_date = json['effective_date'] ?? "";
    leave_quota_reduction = json['leave_quota_reduction'] ?? 0;
    expired_date = json['expired_date'] ?? "";
  }
}