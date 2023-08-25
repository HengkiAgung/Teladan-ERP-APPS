import '../User/User.dart';

class UserAttendanceRequest {
  late int id;
  late User? user;
  late User? approvalLine;
  late String status;
  late String date;
  late String notes;
  late String check_in;
  late String check_out;

  UserAttendanceRequest({
    required this.id,
    required this.user,
    required this.approvalLine,
    required this.status,
    required this.date,
    required this.notes,
    required this.check_in,
    required this.check_out,
  });

  UserAttendanceRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    user = User.fromJson(json['user'] ?? {});
    approvalLine = User.fromJson(json['approval_line'] ?? {});
    print("Asdf");
    status = json['status'] ?? "";
    date = json['date'] ?? "";
    notes = json['notes'] ?? "";
    check_in = json['check_in'] ?? "";
    check_out = json['check_out'] ?? "";
  }
}