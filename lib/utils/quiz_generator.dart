import 'dart:math';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/quiz_types.dart';

class QuizGenerator {
  static Future<QuizRound> generateRound(QuizDifficulty difficulty) async {

    final chars = await Repository.getRandomCharacters(4);

    if (chars.length < 4) throw Exception("Not enough chars");

    final subject = chars[Random().nextInt(chars.length)];

    if (difficulty == QuizDifficulty.easy) {
      return QuizRound(
        subject: subject,
        question: "Who is this character?",
        correctAnswer: subject.name,
        options: chars.map((c) => c.name).toList()..shuffle(),
      );
    }

    final type = Random().nextInt(4);
    
    switch (type) {
      case 0: 
        return QuizRound(
          subject: subject,
          question: "Who is this character?",
          correctAnswer: subject.name,
          options: chars.map((c) => c.name).toList()..shuffle(),
        );
        
      case 1:
        return QuizRound(
          subject: subject,
          question: "Is ${subject.name}...",
          correctAnswer: subject.status,
          options: List.from(kStatusList),
        );
        
      case 2: 
        final correct = subject.species;
        final distractors = kSpeciesList
            .where((s) => s != correct)
            .toList()
            ..shuffle();
        
        final options = [correct, ...distractors.take(3)]..shuffle();
        
        return QuizRound(
          subject: subject,
          question: "What is ${subject.name}'s species?",
          correctAnswer: correct,
          options: options,
        );
        
      case 3: 
        final correct = subject.origin.name;
        final otherOrigins = chars
            .where((c) => c.id != subject.id)
            .map((c) => c.origin.name)
            .where((origin) => origin != correct)
            .toSet()
            .toList();
        
        if (otherOrigins.length < 3) {
          final fallbacks = ['Post-Apocalyptic Earth', 'Nuptia 4', 'Purge Planet', 'Bird World',
            'Gromflom Prime', 'Earth (C-137)']
              .where((f) => f != correct);
          otherOrigins.addAll(fallbacks);
        }
        
        final options = [correct, ...otherOrigins.take(3)]..shuffle();

        return QuizRound(
          subject: subject,
          question: "Where is ${subject.name} from?",
          correctAnswer: correct,
          options: options,
        );
        
      default:
        return QuizRound(
          subject: subject,
          question: "Who is this?",
          correctAnswer: subject.name,
          options: chars.map((c) => c.name).toList(),
        );
    }
  }
}