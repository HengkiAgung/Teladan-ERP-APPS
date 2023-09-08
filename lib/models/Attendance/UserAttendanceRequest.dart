import '../Employee/User.dart';
import '../Employee/WorkingShift.dart';

class UserAttendanceRequest {
  late int id;
  late User? user;
  late User? approvalLine;
  late String status;
  late String date;
  late String notes;
  late String comment;
  late String? file;
  late String check_in;
  late String check_out;
  late WorkingShift? workingShift;

  UserAttendanceRequest({
    required this.id,
    required this.user,
    required this.approvalLine,
    required this.status,
    required this.date,
    required this.notes,
    required this.check_in,
    required this.check_out,
    required this.workingShift,
    required this.comment,
    required this.file,

  });

  UserAttendanceRequest.fromJson(Map<String, dynamic> json) {
    // print(json['user']);
    id = json['id'] ?? 0;
    user = User.fromJson(json['user'] ?? {});
    workingShift = WorkingShift.fromJson(json['shift'] ?? {});
    approvalLine = json['approval_line'] is int ? null : User.fromJson(json['approval_line'] ?? {});
    status = json['status'] ?? "";
    date = json['date'] ?? "";
    notes = json['notes'] ?? "";
    check_in = json['check_in'] ?? "";
    check_out = json['check_out'] ?? "";
    comment = json['comment'] ?? "";
    file = json['file'];
  }
}