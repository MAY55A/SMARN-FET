class Teacher {
  String? id;
  String name;
  String? email;
  String? phone;
  String picture;
  int? nbHours;
  List<String> subjects;

  // Constructor
  Teacher(
      {this.id,
      required this.name,
      this.email,
      required this.phone,
      this.picture = "/teachers/default.jpg",
      required this.nbHours,
      required this.subjects});

  // Convert a Teacher object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'picture': picture,
      'phone': phone,
      'nbHours': nbHours,
      'subjects': subjects
    };
  }

  // Create a Teacher object from a Map
  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'] ?? '', // Provide default if null
      name: map['name'] ?? '', // Provide default if null
      email: map['email'] ?? '', // Provide default if null
      phone: map['phone'] ?? '', // Provide default if null
      picture: map['picture'], // This can be null
      nbHours: map['nbHours'] ?? 0, // Default to 0 if null
      subjects: map['subjects'] != null
          ? List<String>.from(map['subjects']) // Ensure it is a list of Strings
          : [], // Provide an empty list if subjects is null
    );
  }

  bool equals(Teacher other) {
    return id == other.id &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        picture == other.picture &&
        nbHours == other.nbHours &&
        subjects == other.subjects;
  }

  @override
  String toString() {
    return 'Teacher{\nid: $id,\n name: $name,\n email: $email,\n phone: $phone,\n picture: $picture,\n nbHours: $nbHours\n}';
  }
}
