class Credentials {
  final String email;
  final String password;

  Credentials({
    required this.email,
    required this.password,
  });

  // Add a method to convert Credentials object to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  // Add a factory method to create a Credentials object from JSON
  factory Credentials.fromJson(Map<String, dynamic> json) {
    return Credentials(
      email: json['email'],
      password: json['password'],
    );
  }
}
