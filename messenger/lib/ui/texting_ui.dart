import 'package:flutter/material.dart';
import 'package:messenger/services/data.dart';
import 'package:provider/provider.dart';

class TextingUI extends StatelessWidget {
  const TextingUI({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    var link = Provider.of<Data>(context, listen: true);

    TextEditingController _msg = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text(name.toString()),
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
              // Chat list

              ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: link.setMessages.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (_, int index) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  // Bubble
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 60),
                    child: Align(
                      alignment:
                          (link.setMessages[index].from.toString() != link.uid
                              ? Alignment.topLeft
                              : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (link.setMessages[index].from.toString() !=
                                  link.uid
                              ? Colors.grey.shade200
                              : Colors.blue[200]),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          link.setMessages[index].msg.toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Aligned Chat Box
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _msg,
                          decoration: const InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          await link.specSend(name, _msg.text);
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
