class Building {
  String? id;
  String name;
  String longName;
  String description;

  // Constructor
  Building({
    this.id,
    required this.name,
    required this.longName,
    required this.description,
  });

  // Convert a Building object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'longName': longName,
      'description': description,
    };
  }

  // Create a Building object from a Map
  factory Building.fromMap(Map<String, dynamic> map) {
    return Building(
      id: map['id'],
      name: map['name'],
      longName: map['longName'],
      description: map['description'],
    );
  }

  bool equals(Building other) {
    return id == other.id &&
        name == other.name &&
        longName == other.longName &&
        description == other.description;
  }

  @override
  String toString() {
    return "building $id : \n name: $name\n long name: $longName\ndescription: $description";
  }
}
