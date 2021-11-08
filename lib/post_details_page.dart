import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class PostDetailsPage extends StatefulWidget {
  PostDetailsPage(
      {required this.getTitle,
      required this.getDesc,
      required this.getImageUrl,
      Key? key})
      : super(key: key);

  final String getTitle;
  final String getDesc;
  final String getImageUrl;

  State<StatefulWidget> createState() {
    return PostDetailsPageState(getTitle, getDesc, getImageUrl);
  }
}

class PostDetailsPageState extends State<PostDetailsPage> {
  PostDetailsPageState(this.getTitle, this.getDesc, this.getImageUrl);
  String getTitle;
  String getDesc;
  String getImageUrl;

  @override
  Widget build(BuildContext context) {
    Padding pad10 = const Padding(
      padding: EdgeInsets.all(10),
    );

    Container postImage = Container(
        width: 250.0,
        height: 170.0,
        alignment: Alignment.center,
        child: Image(
          image: NetworkImage(Uri.parse(getImageUrl).isAbsolute
              ? getImageUrl
              : 'https://i.ytimg.com/vi/ImC2Rf2sJRA/maxresdefault.jpg'),
        ));
    /*decoration: BoxDecoration(
        image:
            /*DecorationImage(image: NetworkImage(getImageUrl), fit: BoxFit.fill),
      ),*/
    );*/

    return Scaffold(
      backgroundColor: Colors.purple[900],
      appBar: AppBar(
        title: const Center(
          child: Text('Post Details Page'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              pad10,
              postImage,
              Text(
                getTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              Divider(color: Colors.white),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  getDesc,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
