class QuestionItem {
  String question;
  int score;

  QuestionItem({required this.question, this.score = 0});

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'score': score,
    };
  }

  static QuestionItem fromMap(Map<String, dynamic> map) {
    return QuestionItem(
      question: map['question'],
      score: map['score'] ?? 0,
    );
  }
}
