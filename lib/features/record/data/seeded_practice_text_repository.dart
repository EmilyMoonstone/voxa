import '../domain/practice_text.dart';
import '../domain/practice_text_repository.dart';

class SeededPracticeTextRepository implements PracticeTextRepository {
  @override
  List<PracticeText> listForLocale(String localeCode) {
    return _allTexts
        .where((text) => text.localeCode == localeCode)
        .toList(growable: false);
  }
}

const _allTexts = <PracticeText>[
  PracticeText(
    id: 'warmup_en',
    localeCode: 'en',
    title: 'Warm-up paragraph',
    body:
        'I am taking a calm breath and speaking with a steady, comfortable voice today.',
    category: 'warmup',
    difficulty: 1,
  ),
  PracticeText(
    id: 'daily_en',
    localeCode: 'en',
    title: 'Daily check-in',
    body:
        'My voice can change over time, and I can practice in a way that feels supportive and sustainable.',
    category: 'reflection',
    difficulty: 1,
  ),
  PracticeText(
    id: 'warmup_de',
    localeCode: 'de',
    title: 'Warm-up-Absatz',
    body:
        'Ich atme ruhig ein und spreche heute mit einer stabilen, angenehmen Stimme.',
    category: 'warmup',
    difficulty: 1,
  ),
  PracticeText(
    id: 'daily_de',
    localeCode: 'de',
    title: 'Alltags-Check-in',
    body:
        'Meine Stimme darf sich verandern, und ich kann auf eine Weise uben, die sich unterstutzend und nachhaltig anfuhlt.',
    category: 'reflection',
    difficulty: 1,
  ),
];
