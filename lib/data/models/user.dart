import 'enums/gender.dart';

class User {
  String uid;
  String docId;
  String name;
  String lastName;
  String email;
  String password;
  DateTime? birthday;
  Gender gender;
  String? phoneNumber;
  String? profilePicture;
  String? bio;
  String? fcmToken;
  bool? isNotificationEnabled;

  User({
      required this.uid,
      required this.docId,
      required this.name,
      required this.lastName,
      required this.email,
      required this.password,
      this.birthday,
      required this.gender,
      this.phoneNumber,
      this.profilePicture,
      this.bio,
      this.fcmToken,
      this.isNotificationEnabled
      });

    User.empty({
    this.uid = '',
      this.docId='',
    this.name = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.birthday,
    this.gender = Gender.male,
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
        birthday:data['birthday']!=null? DateTime.parse(data['birthday']):null,
        gender: data['sexe']==Gender.male.value ?Gender.male :Gender.female,
        phoneNumber: data['phoneNumber'],
        profilePicture: data['profilePicture'],
        bio: data['bio'],
        fcmToken: data['fcmToken'],
        isNotificationEnabled: data['isNotificationEnabled']
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
      'sexe': gender.value,
      'phoneNumber':phoneNumber,
      'profilePicture': profilePicture,
      'bio': bio,
      'fcmToken':fcmToken,
      'isNotificationEnabled':isNotificationEnabled
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.docId == docId &&
        other.name == name &&
        other.lastName == lastName &&
        other.email == email &&
        other.password == password &&
        other.birthday == birthday &&
        other.gender == gender &&
        other.phoneNumber == phoneNumber &&
        other.profilePicture == profilePicture &&
        other.bio == bio &&
        other.fcmToken == fcmToken &&
        other.isNotificationEnabled == isNotificationEnabled;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
    docId.hashCode ^
    name.hashCode ^
    lastName.hashCode ^
    email.hashCode ^
    password.hashCode ^
    birthday.hashCode ^
    gender.hashCode ^
    phoneNumber.hashCode ^
    profilePicture.hashCode ^
    bio.hashCode ^
    fcmToken.hashCode ^
    isNotificationEnabled.hashCode;
  }



  
  
}
