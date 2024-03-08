class UserModel {
  final String? id;
  final String email;
  final String password;
  final String nic;
  final String mobile;
  final String gender;

  const UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.nic,
    required this.mobile,
    required this.gender,
  });

  toJson() {
    return {
      "email": email,
      "password": password,
      "nic": nic,
      "mobile": mobile,
      "gender": gender,
    };
  }
}
