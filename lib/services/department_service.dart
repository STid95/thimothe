import 'dart:convert';

import 'package:thimothe/models/department.dart';
import 'package:http/http.dart' as http;

class DepartmentService {
  String baseApi = 'https://geo.api.gouv.fr';

  Future<List<Department>> fetchAllDepartments() async {
    final response = await http.get(Uri.parse('$baseApi/departements'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Department> departmentList = jsonResponse.map((json) {
        return Department.fromJson(json);
      }).toList();

      return departmentList;
    } else {
      throw Exception('Failed to load departments');
    }
  }
}
