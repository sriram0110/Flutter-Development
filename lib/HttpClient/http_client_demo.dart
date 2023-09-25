import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class HttpClientDemo extends StatefulWidget {
  const HttpClientDemo({super.key});

  @override
  State<HttpClientDemo> createState() => _HttpClientDemoState();
}

class _HttpClientDemoState extends State<HttpClientDemo> {
  var _responseData = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HttpClient Demo'),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 200,
            child: ElevatedButton(
              child: const Text('Send HTTP Get Request'),
              onPressed: () {
                httpGetRequest();
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 200,
            child: ElevatedButton(
              child: const Text('Send HTTP Post Request'),
              onPressed: () {
                httpPostRequest();
              },
            ),
          ),
          Expanded(
            child: Text(_responseData),
          ),
        ],
      ),
    );
  }

  HttpClient client = HttpClient();
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final url1 = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');

  //get
  void httpGetRequest() async {
    //init http request

    try {
      HttpClientRequest request = await client.getUrl(url1); //first future
      HttpClientResponse response = await request.close(); //second future
      print(response.headers);
      var responseResult = await response.transform(utf8.decoder).join();
      // print(responseResult);

      Map<String, dynamic> jsonData = json.decode(responseResult);
      setState(() {
        _responseData = jsonData['body'];
      });
    } catch (e) {
      _responseData = "Error : $e";
    }
  }

  //post
  Future<void> httpPostRequest() async {
    // Initialize http request
    HttpClient client = HttpClient();

    try {
      HttpClientRequest request =
          await client.postUrl(url); // Change to postUrl
      request.headers.set(HttpHeaders.contentTypeHeader,
          'application/json'); // Set appropriate headers if needed

          var postData = {"userId": "101", "id": "123", "title":"Http", "body":"Flutter Application Demo"};

      // Write the request body if required
      var requestBody = json.encode(postData);
      request.write(requestBody);

      HttpClientResponse response = await request.close();
      print(response.headers);

      var responseResult = await response.transform(utf8.decoder).join();
      Map<String, dynamic> jsonData = json.decode(responseResult);

      setState(() {
        _responseData = jsonData['body'];
      });
    } catch (e) {
      setState(() {
        _responseData = "Error : $e";
      });
    }
  }
}
