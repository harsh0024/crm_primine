class User {
  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;
  final String password;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.password,
  });

  // Add a method to convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'contactNumber': contactNumber,
      'password': password,
    };
  }

  // Add a factory method to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      contactNumber: json['contactNumber'],
      password: json['password'],
    );
  }
}
