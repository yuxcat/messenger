class Reply {
  final int id;
  final int thread;
  final String createdby;
  final DateTime uptime;
  final String title;
  final String contents;

  Reply({
    required this.id,
    required this.thread,
    required this.createdby,
    required this.uptime,
    required this.contents,
    required this.title,
  });

  factory Reply.toReply(Map<String, dynamic> result) {

    return Reply(
      id: result['id'],
      thread: result['thread'],
      createdby: result['createdby'],
      uptime: DateTime.parse(result['updated_at']),
      title: result['title'],
      contents: result['contents'],
    );
  }
}
