import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fetching/post.dart';
import 'package:flutter/material.dart';

Future<Post> fetchPost() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load post dim');
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<Post> _post;

  @override
  void initState() {
    super.initState();
    _post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(46),
        child: FutureBuilder<Post>(
          future: _post,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  Text(
                    snapshot.data!.title,
                    style: Theme.of(context).textTheme.headline6),
                  const Divider(height: 30, thickness: 1.2),
                  Text(snapshot.data!.body),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),

    );
  }
}
