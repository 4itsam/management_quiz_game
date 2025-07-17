enum Difficulty { easy, medium, hard }

class Question {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final Difficulty difficulty;
  final String explanation;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.explanation,
  });
}
