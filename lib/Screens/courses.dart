import 'package:flutter/material.dart';
import 'package:assignment/models/course.dart';
import 'package:assignment/services/course_service.dart';
import 'package:assignment/Screens/course_form.dart';

enum _LoadState { loading, success, error }

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final CourseService _service = CourseService();

  List<Course> _courses = [];
  _LoadState _state = _LoadState.loading;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  // ---------------- READ ----------------
  Future<void> _loadCourses() async {
    setState(() => _state = _LoadState.loading);
    try {
      final courses = await _service.fetchCourses();
      setState(() {
        _courses = courses;
        _state = _LoadState.success;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _state = _LoadState.error;
      });
    }
  }

  // ---------------- CREATE ----------------
  Future<void> _addCourse() async {
    final newCourse = await Navigator.push<Course>(
      context,
      MaterialPageRoute(builder: (_) => const CourseFormScreen()),
    );
    if (newCourse == null) return;

    try {
      final created = await _service.addCourse(newCourse);
      setState(() => _courses.insert(0, created));
      _showSnack('Course added successfully');
    } catch (e) {
      _showSnack('Could not add course: $e');
    }
  }

  // ---------------- UPDATE ----------------
  Future<void> _editCourse(Course course) async {
    final updated = await Navigator.push<Course>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseFormScreen(existingCourse: course),
      ),
    );
    if (updated == null) return;

    try {
      final saved = await _service.updateCourse(updated);
      setState(() {
        final index = _courses.indexWhere((c) => c.id == course.id);
        if (index != -1) _courses[index] = saved;
      });
      _showSnack('Course updated successfully');
    } catch (e) {
      _showSnack('Could not update course: $e');
    }
  }

  // ---------------- DELETE ----------------
  Future<void> _deleteCourse(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text('Are you sure you want to delete "${course.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _service.deleteCourse(course.id);
      setState(() => _courses.removeWhere((c) => c.id == course.id));
      _showSnack('Course deleted');
    } catch (e) {
      _showSnack('Could not delete course: $e');
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _state == _LoadState.loading ? null : _loadCourses,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCourse,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _LoadState.loading:
        return const Center(child: CircularProgressIndicator());

      case _LoadState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadCourses,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );

      case _LoadState.success:
        if (_courses.isEmpty) {
          return const Center(child: Text('No courses found.'));
        }
        return RefreshIndicator(
          onRefresh: _loadCourses,
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final course = _courses[index];
              return Card(
                child: ListTile(
                  title: Text(
                    course.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '#${course.id} \u2022 ${course.description}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editCourse(course),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCourse(course),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
    }
  }
}
