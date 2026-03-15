class PracticeText {
  const PracticeText({
    required this.id,
    required this.localeCode,
    required this.title,
    required this.body,
    required this.category,
    required this.difficulty,
  });

  final String id;
  final String localeCode;
  final String title;
  final String body;
  final String category;
  final int difficulty;
}
