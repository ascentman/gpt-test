import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHAT GPT',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CHAT GPT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          OpenAiService.generateImage('football ball with flag of Ukraine');
        },
        child: const Icon(Icons.microwave_rounded),
      ),
    );
  }
}

class OpenAiService {
  static Future<void> generateImage(String prompt) async {
    final uri = Uri.parse('https://api.openai.com/v1/images/generations');
    try {
      final result = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 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'
        },
        body: jsonEncode({
          'prompt': prompt,
          'n': 5,
          'size': "1024x1024",
        }),
      );
      print(result.body);
      if (result.statusCode == 200) {
        print('success');
        final jsonData = json.decode(result.body);
        final myData = MyDataModel.fromJson(jsonData);
        print(myData.data.first);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class MyDataModel {
  final int created;
  final List<MyDataItem> data;

  MyDataModel({
    required this.created,
    required this.data,
  });

  factory MyDataModel.fromJson(Map<String, dynamic> json) {
    return MyDataModel(
      created: json['created'],
      data: List<MyDataItem>.from(
        json['data'].map((item) => MyDataItem.fromJson(item)),
      ),
    );
  }
}

class MyDataItem {
  final String url;

  MyDataItem({
    required this.url,
  });

  factory MyDataItem.fromJson(Map<String, dynamic> json) {
    return MyDataItem(
      url: json['url'],
    );
  }
}
