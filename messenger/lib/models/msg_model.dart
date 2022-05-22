class MsgModel {
  late String from;
  late String msg;
  late String to;

  MsgModel({required this.from, required this.msg, required this.to});

  MsgModel.fromJson(Map<String, dynamic> json) {
    print("inside model......" + json.toString());
    from = json['from'];
    msg = json['content'];
    to = json['to'];
  }
}
