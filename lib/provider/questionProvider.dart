import 'package:flutter/foundation.dart';

class QuestionItem {
  String question;
  int score;

  QuestionItem({required this.question, this.score = 0});
}

class QuestionProvider with ChangeNotifier {
  List<QuestionItem> questions = [];

  void initQuestions() {
    questions = [
      QuestionItem(question: "1.ฉันรู้สึกเครียดบ่อย ๆ"),
      QuestionItem(question: "2.ฉันมีปัญหาในการนอนหลับ"),
      QuestionItem(question: "3.ฉันรู้สึกโดดเดี่ยว"),
      QuestionItem(question: "4.ฉันรู้สึกกังวลมากเกินไป"),
      QuestionItem(question: "5.ฉันไม่มีความสุขกับชีวิตของฉัน"),
      QuestionItem(question: "6.ฉันมีความมั่นใจในตัวเองต่ำ"),
      QuestionItem(question: "7.ฉันรู้สึกหมดแรงและหมดพลัง"),
      QuestionItem(question: "8.ฉันรู้สึกสิ้นหวังเกี่ยวกับอนาคต"),
      QuestionItem(question: "9.ฉันรู้สึกวิตกกังวลตลอดเวลา"),
      QuestionItem(question: "10.ฉันไม่สามารถควบคุมความเครียดได้"),
      QuestionItem(question: "11.ฉันรู้สึกไม่มีความสุขกับคนรอบตัว"),
      QuestionItem(question: "12.ฉันรู้สึกโดดเดี่ยวและไม่มีใครเข้าใจ"),
      QuestionItem(question: "13.ฉันมักจะโทษตัวเองเมื่อเกิดปัญหา"),
      QuestionItem(question: "14.ฉันรู้สึกกลัวสิ่งที่ไม่สามารถควบคุมได้"),
      QuestionItem(question: "15.ฉันนอนไม่หลับหรือตื่นกลางดึกบ่อย ๆ"),
      QuestionItem(question: "16.ฉันรู้สึกว่าตัวเองไร้ค่า"),
      QuestionItem(question: "17.ฉันไม่สามารถสนุกกับสิ่งที่เคยชอบได้"),
      QuestionItem(question: "18.ฉันมักจะคิดมากเกี่ยวกับสิ่งที่ผ่านมา"),
      QuestionItem(question: "19.ฉันรู้สึกกดดันจากสิ่งรอบตัว"),
      QuestionItem(question: "20.ฉันรู้สึกว่าชีวิตไม่มีความหมาย"),
    ];
    notifyListeners();
  }

  void updateScore(int index, int score) {
    if (index >= 0 && index < questions.length) {
      questions[index].score = score;
      debugPrint(
          "Updated question ${index + 1} with score: $score"); // ตรวจสอบค่าใน debug console
      notifyListeners();
    }
  }

  int calculateScore() {
    int totalScore = questions.fold(0, (sum, item) {
      debugPrint("Question: ${item.question}, Score: ${item.score}");
      return sum + item.score;
    });
    debugPrint("Total Score: $totalScore"); // ตรวจสอบคะแนนรวม
    return totalScore;
  }

  String getMentalHealthResult() {
    int score = calculateScore();
    if (score >= 70) return "ควรปรึกษาผู้เชี่ยวชาญ";
    if (score >= 50) return "สุขภาพจิตปานกลาง";
    return "สุขภาพจิตดี";
  }
}
