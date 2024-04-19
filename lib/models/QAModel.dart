class QuestionAnswers {
  final String QuestionId;
  final String Question;
  final dynamic Answer;
  final DateTime Date;
  final ImageLinks;
  final category;
  final type;

  QuestionAnswers({
    required this.QuestionId,
    required this.Question,
    required this.Answer,
    required this.ImageLinks,
    required this.category,
    required this.type
  }) : Date = DateTime.now();
}