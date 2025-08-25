/// Domain entity representing a Post
class PostEntity {
  /// Post ID
  final int id;
  
  /// User ID who created the post
  final int userId;
  
  /// Post title
  final String title;
  
  /// Post body content
  final String body;
  
  /// Creates a PostEntity instance
  const PostEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });
  
  /// Creates a copy of PostEntity with updated fields
  PostEntity copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return PostEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostEntity &&
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
    return 'PostEntity(id: $id, userId: $userId, title: $title, body: $body)';
  }
}