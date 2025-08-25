/// Data model for Post from JSONPlaceholder API
class PostModel {
  /// Post ID
  final int id;
  
  /// User ID who created the post
  final int userId;
  
  /// Post title
  final String title;
  
  /// Post body content
  final String body;
  
  /// Creates a PostModel instance
  const PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });
  
  /// Creates a PostModel from JSON
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
  
  /// Converts PostModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
  
  /// Creates a copy of PostModel with updated fields
  PostModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostModel &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.body == body;
  }
  
  @override
  int get hashCode {
    return Object.hash(id, userId, title, body);
  }
  
  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, title: $title, body: $body)';
  }
}