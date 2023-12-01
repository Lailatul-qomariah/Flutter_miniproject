class Post {
  final String threadsId;
  final String postId;
  final String content;
  final Author author;

  Post({
    required this.threadsId,
    required this.postId,
    required this.content,
    required this.author,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      threadsId: json['threadsId'] ?? '',
      postId: json['postId'] ?? '',
      content: json['content'] ?? '',
      author: Author.fromJson(json['author']),
    );
  }
}

class Author {
  final String id;
  final String name;

  Author({
    required this.id,
    required this.name,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
