import 'package:flutter/material.dart';
import 'package:assignment/models/course.dart';

/// Single form screen reused for both Create and Update.
///
/// If [existingCourse] is null, the form is in "Add" mode and returns a
/// new Course (with a placeholder id) via Navigator.pop on success.
/// If [existingCourse] is provided, the form pre-fills the fields and
/// returns an updated Course with the same id.
class CourseFormScreen extends StatefulWidget {
  final Course? existingCourse;

  const CourseFormScreen({super.key, this.existingCourse});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  bool get isEditing => widget.existingCourse != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingCourse?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.existingCourse?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final result = Course(
      // 0 is a placeholder id for new courses; the API assigns the real
      // id on POST and the service layer returns it to the caller.
      id: widget.existingCourse?.id ?? 0,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      userId: widget.existingCourse?.userId ?? 1,
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Course' : 'Add Course')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Course Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? 'Save Changes' : 'Add Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
