import 'enums/sexe.dart';

class User {
  String uid;
  String name;
  String lastName;
  String email;
  String password;
  DateTime? birthday;
  Sexe sexe;
  String? phoneNumber;
  String? profilePicture;
  String? bio;

  User({
      required this.uid,
      required this.name,
      required this.lastName,
      required this.email,
      required this.password,
      this.birthday,
      required this.sexe,
      this.phoneNumber,
      this.profilePicture,
      this.bio
      });

  factory User.fromJson(Map<String,dynamic> data){
    return User(
        uid: data['uid'],
        name: data['name'],
        lastName: data['lastName'],
        email: data['email'],
        password: data['password'],
        birthday: DateTime.parse(data['birthday']),
        sexe: data['sexe']==Sexe.male.value ?Sexe.male :Sexe.female,
        phoneNumber: data['phoneNumber'],
        profilePicture: data['profilePicture'],
        bio: data['bio']
    );
  }
  Map<String,dynamic> toJson(){
    return {
      'uid': uid,
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
      'birthday': birthday?.toIso8601String(),
      'sexe': sexe.value,
      'phoneNumber':phoneNumber,
      'profilePicture': profilePicture,
      'bio': bio,
    };
  }
  
  
}
