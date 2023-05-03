// ignore_for_file: file_names

class User {
  late String id;
  late String name;
  late String password;
  late String status;

  User(
      {required this.id,
      required this.name,
      required this.password,
      required this.status});

  User.fromJson(data) {
    if (data == null) {
      return;
    }
    if (data['id'] != null) {
      id = data['id'];
    } else {
      id = '';
    }
    if (data['name'] != null) {
      name = data['name'];
    } else {
      name = '';
    }
    if (data['password'] != null) {
      password = data['password'];
    } else {
      password = '';
    }
    if (data['status'] != null) {
      status = data['status'];
    } else {
      status = '';
    }
  }
}