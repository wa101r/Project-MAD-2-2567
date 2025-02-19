import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/questionProvider.dart';
import 'package:account/formScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => QuestionProvider()..initQuestions()),
      ],
      child: MaterialApp(
        title: 'Mental Health Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const FormScreen(),
      ),
    );
  }
}
