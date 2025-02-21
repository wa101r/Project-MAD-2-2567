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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              TextEditingController questionController =
                  TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('เพิ่มคำถามใหม่'),
                    content: TextField(
                      controller: questionController,
                      decoration: const InputDecoration(hintText: 'กรอกคำถาม'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('ยกเลิก'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (questionController.text.isNotEmpty) {
                            questionProvider
                                .addQuestion(questionController.text);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('เพิ่ม'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.purple.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    question.question,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    TextEditingController editController =
                                        TextEditingController(
                                            text: question.question);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('แก้ไขคำถาม'),
                                          content: TextField(
                                            controller: editController,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('ยกเลิก'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (editController
                                                    .text.isNotEmpty) {
                                                  questionProvider
                                                      .updateQuestion(index,
                                                          editController.text);
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text('บันทึก'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    questionProvider.deleteQuestion(index);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                5,
                                (score) => Column(
                                  children: [
                                    Text(
                                      ['😃', '🙂', '😐', '😟', '😢'][score],
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    Radio<int>(
                                      value: score + 1,
                                      groupValue: questionProvider
                                          .questions[index].score,
                                      onChanged: (value) {
                                        questionProvider.updateScore(
                                            index, value!);
                                      },
                                    ),
                                    Text(
                                      [
                                        'น้อยมาก',
                                        'น้อย',
                                        'กลาง',
                                        'ค่อนข้างมาก',
                                        'มาก'
                                      ][score],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
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
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  ElevatedButton(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
