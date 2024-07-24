/// Class to model other users

class OtherUser {
  int userId;
  String firstName;
  String lastName;
  String userName;
  String bio;
  String profileImage;

  OtherUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.bio,
    required this.profileImage,
  });

  factory OtherUser.fromJson(Map<String, dynamic> json) {
    try {
      return OtherUser(
          userId: json['userId'],
          firstName: json['firstName'],
          lastName: json['lastName'],
          userName: json['username'],
          bio: json['bio'],
          profileImage: json['profile_Image']);
    } catch (e) {
      throw Exception(e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'username': userName,
      'bio': bio,
      'profile_Image': profileImage
    };
  }
}
