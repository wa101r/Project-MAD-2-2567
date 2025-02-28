import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';
import 'package:account/database/questionDB.dart';
import 'package:account/model/question.dart';

class TestResult {
  final int score;
  final String result; // ✅ บันทึกผลลัพธ์จริง
  final DateTime date;

  TestResult({required this.score, required this.result, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'result': result, // ✅ บันทึกผลลัพธ์จริง
      'date': date.toIso8601String(),
    };
  }

  static TestResult fromMap(Map<String, dynamic> map) {
    return TestResult(
      score: map['score'] ?? 0, // ✅ ถ้าคะแนนเป็น null ให้ใช้ 0
      result: map['result'] ??
          "ไม่พบผลลัพธ์", // ✅ ถ้า result เป็น null ให้ใช้ข้อความเริ่มต้น
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
      return "สุขภาพจิตดีมาก\n\n"
          "คุณมีสุขภาพจิตที่แข็งแรง อารมณ์มั่นคง และสามารถจัดการกับปัญหาในชีวิตประจำวันได้ดี "
          "คุณสามารถรับมือกับความเครียดได้อย่างมีประสิทธิภาพ และมองโลกในแง่บวก "
          "หากพบกับปัญหา คุณสามารถปรับตัวและหาวิธีแก้ไขได้อย่างดีเยี่ยม";
    }
    if (score <= maxScore * 0.4) {
      return "สุขภาพจิตดี\n\n"
          "คุณมีสุขภาพจิตที่ดี แต่บางครั้งอาจมีความเครียดหรือความกังวลจากปัจจัยภายนอก "
          "คุณสามารถจัดการกับความเครียดได้ แต่ควรหาเวลาพักผ่อนและทำกิจกรรมที่ช่วยผ่อนคลาย "
          "หากมีความเครียดสะสม ควรแบ่งเวลาให้กับตัวเองมากขึ้น";
    }
    if (score <= maxScore * 0.6) {
      return "สุขภาพจิตปานกลาง\n\n"
          "คุณอาจมีภาวะเครียดในระดับหนึ่งและอาจรู้สึกกดดันหรือวิตกกังวลเกี่ยวกับเรื่องต่างๆ "
          "อาจมีอารมณ์แปรปรวนหรือความรู้สึกไม่มั่นคงเป็นบางครั้ง "
          "ควรหาเวลาดูแลตัวเอง เช่น การออกกำลังกาย ฝึกสมาธิ หรือพูดคุยกับคนใกล้ชิดเพื่อช่วยผ่อนคลายความเครียด";
    }
    if (score <= maxScore * 0.8) {
      return "สุขภาพจิตค่อนข้างแย่\n\n"
          "คุณอาจมีความเครียดและความกังวลในระดับสูง ซึ่งอาจส่งผลต่ออารมณ์และความสามารถในการใช้ชีวิตประจำวัน "
          "คุณอาจรู้สึกเหนื่อยล้า ขาดแรงจูงใจ หรือรู้สึกสิ้นหวังในบางครั้ง "
          "ขอแนะนำให้คุณหาวิธีผ่อนคลาย เช่น การพูดคุยกับเพื่อนสนิทหรือครอบครัว "
          "หากความเครียดยังคงอยู่ ควรพิจารณาปรึกษาผู้เชี่ยวชาญทางด้านสุขภาพจิต";
    }
    return "สุขภาพจิตแย่ ควรปรึกษาผู้เชี่ยวชาญ\n\n"
        "คุณมีภาวะเครียดสูง ซึ่งอาจส่งผลกระทบต่อสุขภาพจิตและร่างกายได้ "
        "อาจมีอาการเช่น นอนไม่หลับ อารมณ์แปรปรวน รู้สึกหมดพลัง หรือคิดลบเกี่ยวกับตัวเอง "
        "ขอแนะนำให้คุณขอความช่วยเหลือจากนักจิตวิทยาหรือผู้เชี่ยวชาญ เพื่อรับคำแนะนำและแนวทางแก้ไขที่เหมาะสม";
  }

  Future<void> saveTestResult() async {
    int totalScore = calculateScore();
    String result = getMentalHealthResult(); // ✅ คำนวณผลลัพธ์จริง

    TestResult newResult = TestResult(
      score: totalScore,
      result: result.isNotEmpty
          ? result
          : "ไม่พบผลลัพธ์", // ✅ ป้องกัน result เป็นค่าว่าง
      date: DateTime.now(),
    );

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
