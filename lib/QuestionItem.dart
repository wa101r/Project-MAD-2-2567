import 'package:flutter/foundation.dart';

class QuestionItem {
  String question;
  int score; // คะแนนที่ผู้ใช้เลือก (1-5)

  QuestionItem({required this.question, this.score = 0});
}

class QuestionProvider with ChangeNotifier {
  List<QuestionItem> questions = [];

  void initQuestions() {
    questions = [
      QuestionItem(question: "ฉันรู้สึกเครียดบ่อย ๆ"),
      QuestionItem(question: "ฉันมีปัญหาในการนอนหลับ"),
      QuestionItem(question: "ฉันรู้สึกโดดเดี่ยว"),
      QuestionItem(question: "ฉันรู้สึกกังวลมากเกินไป"),
      QuestionItem(question: "ฉันไม่มีความสุขกับชีวิตของฉัน"),
      // เพิ่มจนครบ 20 ข้อ
    ];
    notifyListeners();
  }

  void updateScore(int index, int score) {
    if (index >= 0 && index < questions.length) {
      questions[index].score = score;
      notifyListeners();
    }
  }

  int calculateScore() {
    return questions.fold(0, (sum, item) => sum + item.score);
  }

  String getMentalHealthResult() {
    int score = calculateScore();
    if (score >= 80) return "สุขภาพจิตดี";
    if (score >= 60) return "สุขภาพจิตปานกลาง";
    return "ควรปรึกษาผู้เชี่ยวชาญ";
  }
}
