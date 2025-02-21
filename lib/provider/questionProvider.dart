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
      QuestionItem(question: "1. ฉันรู้สึกเครียดบ่อย ๆ"),
      QuestionItem(question: "2. ฉันมีปัญหาในการนอนหลับ"),
      QuestionItem(question: "3. ฉันรู้สึกโดดเดี่ยว"),
      QuestionItem(question: "4. ฉันรู้สึกกังวลมากเกินไป"),
      QuestionItem(question: "5. ฉันไม่มีความสุขกับชีวิตของฉัน"),
    ];
    notifyListeners();
  }

  void _updateQuestionNumbers() {
    for (int i = 0; i < questions.length; i++) {
      questions[i].question =
          "${i + 1}. ${questions[i].question.replaceAll(RegExp(r'^\d+\.\s*'), '')}";
    }
    notifyListeners();
  }

  void addQuestion(String newQuestion) {
    questions.add(QuestionItem(question: newQuestion));
    _updateQuestionNumbers();
  }

  void updateQuestion(int index, String updatedQuestion) {
    if (index >= 0 && index < questions.length) {
      questions[index].question = updatedQuestion;
      _updateQuestionNumbers();
    }
  }

  void deleteQuestion(int index) {
    if (index >= 0 && index < questions.length) {
      questions.removeAt(index);
      _updateQuestionNumbers();
    }
  }

  void updateScore(int index, int score) {
    if (index >= 0 && index < questions.length) {
      questions[index].score = score;
      debugPrint("Updated question ${index + 1} with score: $score");
      notifyListeners();
    }
  }

  int calculateScore() {
    int totalScore = questions.fold(0, (sum, item) => sum + item.score);
    debugPrint("Total Score: $totalScore");
    return totalScore;
  }

  String getMentalHealthResult() {
    int score = calculateScore();
    int maxScore = questions.length * 5;
    debugPrint("Final Score for Result: $score");

    if (score <= maxScore * 0.2) {
      return "สุขภาพจิตดีมาก\n\nคุณมีสุขภาพจิตที่แข็งแรงและสามารถรับมือกับความเครียดได้ดี แนะนำให้คงกิจกรรมที่ทำให้รู้สึกดี เช่น ออกกำลังกาย นั่งสมาธิ และสานสัมพันธ์กับคนรอบตัว";
    }
    if (score <= maxScore * 0.4) {
      return "สุขภาพจิตดี\n\nคุณมีสุขภาพจิตที่ดี แต่บางครั้งอาจมีความเครียดบ้าง แนะนำให้หมั่นดูแลตัวเอง พักผ่อนให้เพียงพอ และทำกิจกรรมที่ช่วยผ่อนคลาย";
    }
    if (score <= maxScore * 0.6) {
      return "สุขภาพจิตปานกลาง\n\nคุณอาจมีภาวะเครียดในระดับหนึ่งและควรเริ่มให้ความสำคัญกับการดูแลสุขภาพจิต เช่น การออกกำลังกาย จัดการเวลาพักผ่อน และพูดคุยกับคนที่ไว้ใจ";
    }
    if (score <= maxScore * 0.8) {
      return "สุขภาพจิตค่อนข้างแย่\n\nคุณอาจมีความเครียดและความกังวลในระดับสูง ควรหาเวลาผ่อนคลายและหาวิธีจัดการกับอารมณ์ เช่น พูดคุยกับเพื่อน ครอบครัว หรือผู้เชี่ยวชาญด้านสุขภาพจิต";
    }
    return "สุขภาพจิตแย่ ควรปรึกษาผู้เชี่ยวชาญ\n\nคุณมีภาวะเครียดสูงและอาจส่งผลกระทบต่อชีวิตประจำวัน แนะนำให้พูดคุยกับนักจิตวิทยาหรือแพทย์ผู้เชี่ยวชาญเพื่อรับคำแนะนำในการดูแลสุขภาพจิตของคุณ";
  }
}
