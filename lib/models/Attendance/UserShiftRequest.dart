import '../Employee/User.dart';

class UserShiftRequest {
  late int id;
  late User? user;
  late User? approvalLine;
  late String status;
  late int working_shift_id;
  late String date;
  late String notes;

  UserShiftRequest({
    required this.id,
    required this.user,
    required this.approvalLine,
    required this.status,
    required this.working_shift_id,
    required this.date,
    required this.notes,
  });

  UserShiftRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    user = User.fromJson(json['user'] ?? {});
    approvalLine = User.fromJson(json['approval_line'] ?? {});
    status = json['status'] ?? "";
    working_shift_id = json['working_shift_id'] ?? 0;
    date = json['date'] ?? "";
    notes = json['notes'] ?? "";
  }
}