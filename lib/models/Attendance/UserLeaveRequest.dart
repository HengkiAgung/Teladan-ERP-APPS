import 'package:comtelindo_erp/models/Attendance/LeaveRequestCategory.dart';

import '../Employee/User.dart';

class UserLeaveRequest {
  late int id;
  late User? user;
  late User? approvalLine;
  late LeaveRequestCategory? leaveRequestCategory;
  late String status;
  late String start_date;
  late String end_date;
  late int taken;
  late String notes;
  late String comment;
  late String file;

  UserLeaveRequest({
    required this.id,
    required this.user,
    required this.approvalLine,
    required this.leaveRequestCategory,
    required this.status,
    required this.start_date,
    required this.end_date,
    required this.taken,
    required this.notes,
    required this.comment,
    required this.file,
  });

  UserLeaveRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    user = User.fromJson(json['user'] ?? {});
    approvalLine = json['approval_line'] is int ? null : User.fromJson(json['approval_line'] ?? {});
    leaveRequestCategory = LeaveRequestCategory.fromJson(json['leave_request_category'] ?? {});

    status = json['status'] ?? "";
    start_date = json['start_date'] ?? "";
    end_date = json['end_date'] ?? "";
    taken = json['taken'] ?? 0;
    notes = json['notes'] ?? "";
    comment = json['comment'] ?? "";
    file = json['file'] ?? "";
  }
}