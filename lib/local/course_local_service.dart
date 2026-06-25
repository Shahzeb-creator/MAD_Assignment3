import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';

class CourseLocalService {
  static const String key = 'courses';

  Future<void> saveCourses(List<Course> courses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(courses.map((e) => e.toJson()).toList()));
  }

  Future<List<Course>> getCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];
    return (jsonDecode(data) as List).map((e) => Course.fromJson(e)).toList();
  }
}
