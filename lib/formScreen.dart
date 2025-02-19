import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/questionProvider.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final questionProvider = Provider.of<QuestionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'แบบทดสอบสุขภาพจิต',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: questionProvider.questions.length,
                itemBuilder: (context, index) {
                  final question = questionProvider.questions[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.question,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("น้อย", style: TextStyle(fontSize: 14)),
                              ...List.generate(
                                5,
                                (score) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Radio<int>(
                                    value: score + 1,
                                    groupValue: question.score,
                                    onChanged: (value) {
                                      questionProvider.updateScore(
                                          index, value!);
                                    },
                                  ),
                                ),
                              ),
                              Text("มาก", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                String result = questionProvider.getMentalHealthResult();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('ผลการทดสอบ'),
                      content: Text(result),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('ตกลง'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                'ดูผลลัพธ์',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
