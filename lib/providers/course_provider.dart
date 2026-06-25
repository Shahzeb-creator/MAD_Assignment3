import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository = CourseRepository();
  bool isLoading = false;
  List<Course> courses = [];

  Future<void> loadCourses() async {
    isLoading = true;
    notifyListeners();
    courses = await repository.fetchCourses();
    isLoading = false;
    notifyListeners();
  }
}
