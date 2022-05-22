class Post {
  final int id;
  final String belongs;
  final String createdby;
  final DateTime uptime;
  final String title;
  final String contents;

  Post({
    required this.id,
    required this.belongs,
    required this.createdby,
    required this.uptime,
    required this.contents,
    required this.title,
  });

  factory Post.toNote(Map<String, dynamic> result) {
    return Post(
      id: result['id'],
      belongs: result['belongs'],
      createdby: result['createdby'],
      uptime: DateTime.parse(result['updated_at']),
      title: result['title'],
      contents: result['contents'],
    );
  }
}
