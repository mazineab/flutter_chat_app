enum Sexe {
  male,
  female,
}

extension SexeExtension on Sexe {
  String get toValue {
    switch (this) {
      case Sexe.male:
        return 'Male';
      case Sexe.female:
        return 'Female';
    }
  }
  String get value{
    switch(this){
      case Sexe.male:
        return 'male';
      case Sexe.female:
        return 'female';
    }
  }
}


