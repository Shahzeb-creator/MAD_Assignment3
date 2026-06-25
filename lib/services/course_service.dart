import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:assignment/models/course.dart';

/// Thin, UI-agnostic wrapper around the JSONPlaceholder REST API.
///
/// JSONPlaceholder docs: https://jsonplaceholder.typicode.com/guide
/// We use the `/posts` resource to represent "courses": `title` maps to
/// the course title and `body` maps to the course description.
///
/// NOTE: JSONPlaceholder is a fake API. POST/PUT/DELETE requests return a
/// valid success response (and POST always echoes back id: 101) but the
/// server does NOT actually persist the change. This is expected and
/// documented behaviour of the API, not a bug in this app — the UI layer
/// is responsible for updating its local state after a successful
/// response so the change is reflected on screen.
class CourseService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Limits the number of seed courses fetched so the list stays small
  /// and readable for a classroom demo.
  static const int _fetchLimit = 10;

  /// GET /posts?_limit=10 -> List<Course>
  Future<List<Course>> fetchCourses() async {
    final uri = Uri.parse('$_baseUrl/posts?_limit=$_fetchLimit');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Course.fromJson(json)).toList();
    } else {
      throw CourseApiException(
        'Failed to load courses (status ${response.statusCode})',
      );
    }
  }

  /// POST /posts -> Course (server echoes id: 101 for any new post)
  Future<Course> addCourse(Course course) async {
    final uri = Uri.parse('$_baseUrl/posts');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'title': course.title,
        'body': course.description,
        'userId': course.userId,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return Course.fromJson(json);
    } else {
      throw CourseApiException(
        'Failed to add course (status ${response.statusCode})',
      );
    }
  }

  /// PUT /posts/:id -> Course
  Future<Course> updateCourse(Course course) async {
    final uri = Uri.parse('$_baseUrl/posts/${course.id}');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Course.fromJson(json);
    } else {
      throw CourseApiException(
        'Failed to update course (status ${response.statusCode})',
      );
    }
  }

  /// DELETE /posts/:id -> void
  Future<void> deleteCourse(int id) async {
    final uri = Uri.parse('$_baseUrl/posts/$id');
    final response = await http.delete(uri);

    if (response.statusCode != 200) {
      throw CourseApiException(
        'Failed to delete course (status ${response.statusCode})',
      );
    }
  }
}

/// Custom exception so the UI layer can catch API-specific failures
/// distinctly from other errors (e.g. JSON parsing issues).
class CourseApiException implements Exception {
  final String message;
  CourseApiException(this.message);

  @override
  String toString() => message;
}
