class User {
  final String name;
  final String email;
  final String symbol;
  final String phone;

  User.fromJson(Map<String, dynamic> json)
      : name = json['first_name'],
        email = json['email'],
        symbol = json['user_name'].toString().substring(0, 1),
        phone = json['phone_number'];
}
