enum Gender {
  male,
  female,
}

extension SexeExtension on Gender {
  String get toValue {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
    }
  }
  String get value{
    switch(this){
      case Gender.male:
        return 'male';
      case Gender.female:
        return 'female';
    }
  }
}


