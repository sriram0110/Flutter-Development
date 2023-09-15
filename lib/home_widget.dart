import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_example/models/post.dart';
import 'package:http/http.dart' as http;

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Future<Post?>? post;
  final String url = "https://jsonplaceholder.typicode.com/posts";
  final String url1 = "https://jsonplaceholder.typicode.com/posts/1";

  //GET

  Future<Post> fetchPost() async {  //call the API endpoint
    final uri = Uri.parse(url1);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<Post> createPost(String title, String body) async {
    Map<String, dynamic> request = {
      'title': title,
      'body': body,
      'userId': '111'
    };
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(request),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Post> updatePost(String title, String body) async {
    Map<String, dynamic> request = {
      'id': "101",
      'title': title,
      'body': body,
      'userId': "111"
    };
    final uri = Uri.parse(url1);
    final response = await http.put(uri, body: request);

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Post?>? deletePost() async {
    final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return null;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void getButton() {
    setState(() {
      post = fetchPost();
    });
  }

  void deleteButton() {
    setState(() {
      post = deletePost();
    });
  }

  void postButton() {
    setState(() {
      post = createPost('new post', 'an example post');
    });
  }

  void updateButton() {
    setState(() {
      post = updatePost('new update', 'an example update');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('API Calls'),
        ),
      ),
      body: SizedBox(
        height: 500,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<Post?>(
              future: post, //return the result to snapshot
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Container();
                } else {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snapshot.data!.title),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snapshot.data!.description),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Container(); //by default case
                }
              },
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () => getButton(),
                child: const Text("GET"),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () => postButton(),
                child: const Text("POST"),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () => updateButton(),
                child: const Text("UPDATE"),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () => deleteButton(),
                child: const Text("DELETE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
