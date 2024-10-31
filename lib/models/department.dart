class Department {
  String code;
  String name;

  Department({required this.code, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(code: json['code'], name: json['nom']);
  }
}
