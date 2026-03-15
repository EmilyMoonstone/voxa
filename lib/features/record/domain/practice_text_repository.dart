import 'practice_text.dart';

abstract interface class PracticeTextRepository {
  List<PracticeText> listForLocale(String localeCode);
}
