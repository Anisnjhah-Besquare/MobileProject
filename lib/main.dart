import 'package:project_anis/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_anis/post.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceArt',
      theme: ThemeData(
// is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginPage(),
          )
        ],
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
//

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _imageUrl =
      'https://i.ytimg.com/vi/ImC2Rf2sJRA/maxresdefault.jpg';

  final username = TextEditingController();
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://besquare-demo.herokuapp.com'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.network(_imageUrl),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: TextField(
                    controller: username,
                    autofocus: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      labelText: 'Username',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onChanged: (value) =>
                        context.read<LoginPage>().textInput(username.text)),
              ),
              BlocBuilder<LoginPage, String>(builder: (context, state) {
                return Text('Hello $state');
              }),
              ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    if (username.text.isNotEmpty) {
                      channel.sink.add(
                          '{"type": "sign_in","data": {"name": "${username.text}"}}');
                      print('Successfully login');
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyPostPage()));
                      });
                    }
                  },
                  child: const Text('Enter the application')),
              SizedBox(height: 10),
              /*Expanded(
              child: StreamBuilder(
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    messageList.add(snapshot.data)
                  }
                } ,) ,)*/
            ],
          ),
        ),
      ),
    );
  }
}

/*class PostPage extends StatelessWidget{
@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
theme: ThemeData(
primarySwatch: Colors.teal,
),
home: BlocProvider(
create: (context) => DisplayText(),
child: Exercise2App(),
));
}
}*/

