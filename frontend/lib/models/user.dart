/// Class to model a user
class User {
  int userId;
  String firstName;
  String lastName;
  String username;
  String email;
  // String gender;
  // DateTime dob;
  String? bio;
  String? profileImage;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    // required this.gender,
    //required this.dob,
    required this.bio,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
          userId: json['userId'],
          firstName: json['firstname'],
          lastName: json['lastname'],
          username: json['username'],
          email: json['email'],
          // gender: json['gender'],
          //dob: DateTime.parse(json['dob']),
          bio: json['bio'],
          profileImage: json['profile_Image']);
    } catch (e) {
      throw Exception(e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstname': firstName,
      'lastname': lastName,
      'username': username,
      'email': email,
      //'gender': gender,
      // 'dob': dob.toIso8601String(),
      'bio': bio,
      'profile_Image': profileImage
    };
  }
}
