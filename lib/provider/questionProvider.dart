import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';
import 'package:account/database/questionDB.dart';
import 'package:account/model/question.dart';

class TestResult {
  final int score;
  final DateTime date;

  TestResult({required this.score, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'date': date.toIso8601String(),
    };
  }

  static TestResult fromMap(Map<String, dynamic> map) {
    return TestResult(
      score: map['score'],
      date: DateTime.parse(map['date']),
    );
  }
}

class QuestionProvider with ChangeNotifier {
  List<QuestionItem> questions = [];
  List<TestResult> _history = [];

  List<TestResult> get history => _history;

  void initQuestions() {
    questions = [
      QuestionItem(question: "ฉันรู้สึกเครียดบ่อย ๆ"),
      QuestionItem(question: "ฉันมีปัญหาในการนอนหลับ"),
      QuestionItem(question: "ฉันรู้สึกหมดพลังและไม่มีแรงจูงใจ"),
      QuestionItem(question: "ฉันมีความกังวลมากเกินไปเกี่ยวกับอนาคต"),
      QuestionItem(question: "ฉันรู้สึกเหงาหรือโดดเดี่ยว"),
      QuestionItem(question: "ฉันมีอารมณ์แปรปรวนง่ายและโกรธบ่อย"),
      QuestionItem(question: "ฉันไม่มีความสุขกับชีวิตประจำวันของฉัน"),
      QuestionItem(question: "ฉันรู้สึกว่าตัวเองไม่มีค่า"),
      QuestionItem(question: "ฉันมีปัญหาในการจดจ่อหรือทำงานให้สำเร็จ"),
      QuestionItem(question: "ฉันรู้สึกกดดันจากสิ่งรอบตัวบ่อย ๆ"),
    ];
    _updateQuestionNumbers();
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
      questions[index].question =
          "${index + 1}. ${updatedQuestion.replaceAll(RegExp(r'^\d+\.\s*'), '')}";
      notifyListeners();
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
      notifyListeners();
    }
  }

  int calculateScore() {
    return questions.fold(0, (sum, item) => sum + item.score);
  }

  String getMentalHealthResult() {
    int score = calculateScore();
    int maxScore = questions.length * 5;

    if (score <= maxScore * 0.2) {
      return "สุขภาพจิตดีมาก\n\nคุณมีสุขภาพจิตที่แข็งแรง...";
    }
    if (score <= maxScore * 0.4) {
      return "สุขภาพจิตดี\n\nคุณมีสุขภาพจิตที่ดี แต่บางครั้งอาจมีความเครียดบ้าง...";
    }
    if (score <= maxScore * 0.6) {
      return "สุขภาพจิตปานกลาง\n\nคุณอาจมีภาวะเครียดในระดับหนึ่ง...";
    }
    if (score <= maxScore * 0.8) {
      return "สุขภาพจิตค่อนข้างแย่\n\nคุณอาจมีความเครียดและความกังวลในระดับสูง...";
    }
    return "สุขภาพจิตแย่ ควรปรึกษาผู้เชี่ยวชาญ\n\nคุณมีภาวะเครียดสูง...";
  }

  Future<void> saveTestResult() async {
    int totalScore = calculateScore();
    TestResult newResult = TestResult(score: totalScore, date: DateTime.now());

    var db = await TransactionDB(dbName: "history.db").openDatabase();
    var store = intMapStoreFactory.store('history');
    await store.add(db, newResult.toMap());

    _history.add(newResult);
    notifyListeners();
  }

  Future<void> loadHistory() async {
    var db = await TransactionDB(dbName: "history.db").openDatabase();
    var store = intMapStoreFactory.store('history');

    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder('date', false)]));
    _history =
        snapshot.map((record) => TestResult.fromMap(record.value)).toList();

    notifyListeners();
  }
}
