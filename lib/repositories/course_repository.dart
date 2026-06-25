import '../local/course_local_service.dart';
import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService api = CourseService();
  final CourseLocalService local = CourseLocalService();

  Future<List<Course>> fetchCourses() async {
    try {
      final courses = await api.fetchCourses();
      await local.saveCourses(courses);
      return courses;
    } catch (_) {
      return await local.getCourses();
    }
  }
}
