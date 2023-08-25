import 'Department.dart';
import 'Division.dart';
import 'Role.dart';
import 'Team.dart';
import 'UserPersonalData.dart';

class User {
  late int id;
  late String name;
  late String email;
  late String signFile;
  late String kontak;
  late int status;
  late String foto_file;
  late UserPersonalData? userPersonalData;
  late Team? team;
  late List<Role>? roles;
  late Division? division;
  late Department? department;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.signFile,
    required this.kontak,
    required this.status,
    required this.foto_file,
    required this.userPersonalData,
    required this.team,
    required this.roles,
    required this.division,
    required this.department,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    signFile = json['signFile'] ?? "";
    kontak = json['phoneNumber'] ?? "";
    status = json['status'] ?? 0;
    foto_file = json['foto_file'] ?? "";
    userPersonalData = UserPersonalData.fromJson(json['user_personal_data'] ?? {});
    team = Team.fromJson(json['team'] ?? {});
    division = Division.fromJson(json['division'] ?? {});
    department = Department.fromJson(json['department'] ?? {});

    Iterable it = json['roles'] ?? [];
    roles = it.map((e) {
      var role = Role.fromJson(e);
      return role;
    }).toList();
  }
}