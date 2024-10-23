class Teacher {
  String id;
  String name;
  String email;
  String phone;
  int nbHours;
  String password;

  // Constructor
  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.nbHours,
    required this.password
  });

  // Convert a Teacher object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'nbHours': nbHours,
      'password': password
    };
  }

  // Create a Teacher object from a Map
  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      nbHours: map['nbHours'],
      password: map['password']
    );
  }
}
