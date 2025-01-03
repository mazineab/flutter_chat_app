import 'enums/sexe.dart';

class User {
  String uid;
  String docId;
  String name;
  String lastName;
  String email;
  String password;
  DateTime? birthday;
  Sexe sexe;
  String? phoneNumber;
  String? profilePicture;
  String? bio;
  String? fcmToken;

  User({
      required this.uid,
      required this.docId,
      required this.name,
      required this.lastName,
      required this.email,
      required this.password,
      this.birthday,
      required this.sexe,
      this.phoneNumber,
      this.profilePicture,
      this.bio,
      this.fcmToken
      });

    User.empty({
    this.uid = '',
      this.docId='',
    this.name = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.birthday,
    this.sexe = Sexe.male,
    this.phoneNumber,
    this.profilePicture,
    this.bio,
  });

  factory User.fromJson(Map<String,dynamic> data){
    return User(
        uid: data['uid'],
        docId: data['docId'],
        name: data['name'],
        lastName: data['lastName'],
        email: data['email'],
        password: data['password'],
        birthday: DateTime.parse(data['birthday']),
        sexe: data['sexe']==Sexe.male.value ?Sexe.male :Sexe.female,
        phoneNumber: data['phoneNumber'],
        profilePicture: data['profilePicture'],
        bio: data['bio'],
        fcmToken: data['fcmToken'],
    );
  }
  Map<String,dynamic> toJson(){
    return {
      'uid': uid,
      "docId":docId,
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
      'birthday': birthday?.toIso8601String(),
      'sexe': sexe.value,
      'phoneNumber':phoneNumber,
      'profilePicture': profilePicture,
      'bio': bio,
      'fcmToken':fcmToken
    };
  }
  
  
}
