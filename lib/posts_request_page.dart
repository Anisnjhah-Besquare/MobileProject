import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PostRequestPage extends StatefulWidget {
  @override
  _PostRequestPageState createState() => _PostRequestPageState();
}

class _PostRequestPageState extends State<PostRequestPage> {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://besquare-demo.herokuapp.com'),
  );

  @override
  initState() {
    super.initState();
    channel.sink.add('{"type": "sign_in","data": {"name": "anis"}}');
  }

  GlobalKey<FormState> _formKey = GlobalKey();

  String? title;
  String? description;

  final textController_1 = TextEditingController();
  final textController_2 = TextEditingController();
  final textController_3 = TextEditingController();

  void _createPost() {
    print("hi");
    channel.stream.listen((event) {
      final decodedMessage = jsonDecode(event);
      print(decodedMessage);
    });

    channel.sink.add(
        '{"type": "create_post","data": {"title": "${textController_1.text}", "description": "${textController_2.text}","image": "${textController_3.text}"}}');
  }

  //final String _imageUrl = ()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[900],
      appBar: AppBar(
        title: const Center(
          child: Text('Add Posts Page'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _createPost();
            },
            icon: Icon(Icons.check),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: textController_1,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Title",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        )),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                    validator: (String? value) {
                      String? errorMessage;
                      if (value!.isEmpty) {
                        errorMessage = "The title is required";
                      }
                      return errorMessage;
                    },
                    onSaved: (value) {
                      title = value!.trim();
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: textController_2,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Description",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                          color: Colors.white,
                        )),
                    maxLines: 6,
                    validator: (String? value) {
                      String? errorMessage;
                      if (value!.isEmpty) {
                        errorMessage = "The description is required";
                      }
                      return errorMessage;
                    },
                    onSaved: (value) {
                      description = value!.trim();
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: textController_3,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Image URL",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  /*Expanded(
                    child: getMessageList(),
                  )*/
                ],
              )),
        ),
      ),
    );
  }

  void onSubmit(Function _createPost) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      channel.sink.add(
          '{"type":"new_post","data":{"_id": string,"title": "${textController_1.text}","description": "${textController_2.text}"}}');

      _createPost();

      //print("The title: $title and description: $description");
    }
  }
}
