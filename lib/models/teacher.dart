class Teacher {
  String? id;
  String name;
  String? email;
  String phone;
  String picture;
  int nbHours;
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
        id: map['id'],
        name: map['name'],
        email: map['email'],
        phone: map['phone'],
        picture: map['picture'],
        nbHours: map['nbHours'],
        subjects: List<String>.from(map['subjects']));
  }

  @override
  String toString() {
    return 'Teacher{\nid: $id,\n name: $name,\n email: $email,\n phone: $phone,\n picture: $picture,\n nbHours: $nbHours\n}';
  }
}