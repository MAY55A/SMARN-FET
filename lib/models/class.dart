class Class {
  String? id;
  String name;
  String longName;
  int nbStudents;
  String? accessKey;

  // Constructor
  Class(
      {this.id,
      required this.name,
      required this.longName,
      required this.nbStudents,
      this.accessKey});

  // Convert a Class object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'longName': longName,
      'nbStudents': nbStudents,
      'accessKey': accessKey
    };
  }

  // Create a Class object from a Map
  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
        id: map['id'],
        name: map['name'],
        longName: map['longName'],
        nbStudents: map['nbStudents'],
        accessKey: map['accessKey']);
  }

  bool equals(Class other) {
    return other.id == id &&
        other.name == name &&
        other.longName == longName &&
        other.nbStudents == nbStudents &&
        other.accessKey == accessKey;
  }

  @override
  String toString() {
    return "class $id : \n name: $name\n long name: $longName\nnbStudents: $nbStudents\n access key: $accessKey";
  }
}
