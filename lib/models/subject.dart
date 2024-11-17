class Subject {
  String? id;
  String name;
  String longName;
  String description;

  // Constructor
  Subject({
    this.id,
    required this.name,
    required this.longName,
    required this.description
  });

  // Convert a Subject object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'longName': longName,
      'description': description
    };
  }

  // Create a Subject object from a Map
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
        id: map['id'],
        name: map['name'],
        longName: map['longName'],
        description: map['description']);
  }

  
  @override
  String toString() {
    return "subject $id : \n name: $name\n long name: $longName\ndescription: $description";
  }
}
