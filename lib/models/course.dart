/// Represents a single Course, mapped on top of the JSONPlaceholder
/// `/posts` resource:
///   JSONPlaceholder field  ->  Course field
///   id                      ->  id
///   title                   ->  title
///   body                    ->  description
///   userId                  ->  userId (kept so PUT/POST payloads stay valid)
class Course {
  final int id;
  final String title;
  final String description;
  final int userId;

  Course({
    required this.id,
    required this.title,
    required this.description,
    this.userId = 1,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['body']?.toString() ?? '',
      userId: json['userId'] is int
          ? json['userId']
          : int.tryParse('${json['userId']}') ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': description,
      'userId': userId,
    };
  }

  Course copyWith({int? id, String? title, String? description, int? userId}) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
    );
  }
}
