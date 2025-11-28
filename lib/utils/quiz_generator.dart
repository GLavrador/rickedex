import 'dart:math';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/models/quiz_types.dart';

class QuizGenerator {
  static Future<QuizRound> generateRound(QuizDifficulty difficulty) async {

    final chars = await Repository.getRandomCharacters(4);

    if (chars.length < 4) throw Exception("Not enough chars");

    final subject = chars[Random().nextInt(chars.length)];

    int type = 0;

    if (difficulty == QuizDifficulty.easy) {

      type = Random().nextBool() ? 0 : 2;
    } else if (difficulty == QuizDifficulty.medium) {

      type = Random().nextInt(4);
    } else {

      type = Random().nextInt(6);
    }
    
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
          final fallbacks = ['Post-Apocalyptic Earth', 'Nuptia 4', 'Purge Planet', 'Bird World','Gromflom Prime', 'Earth (C-137)']
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

      case 4:
        final correctEpName = await _fetchFirstSeenName(subject);
        
        if (correctEpName == null) {
          return _generateAppearancesRound(subject);
        }

        final otherChars = chars.where((c) => c.id != subject.id).take(3).toList();
        
        final distractorNames = await Future.wait(
          otherChars.map((c) => _fetchFirstSeenName(c))
        );

        final Set<String> distractorEpNames = distractorNames
            .where((name) => name != null && name != correctEpName)
            .cast<String>()
            .toSet();

        if (distractorEpNames.length < 3) {
          final fallbacks = ['Pilot', 'Lawnmower Dog', 'Anatomy Park', 'M. Night Shaym-Aliens!']
              .where((f) => f != correctEpName);
          distractorEpNames.addAll(fallbacks.take(3 - distractorEpNames.length));
        }

        final epOptions = [correctEpName, ...distractorEpNames.take(3)]..shuffle();

        return QuizRound(
          subject: subject,
          question: "First episode appearance?",
          correctAnswer: correctEpName,
          options: epOptions,
        );

      case 5: 
        return _generateAppearancesRound(subject);
        
      default:
        return QuizRound(
          subject: subject,
          question: "Who is this?",
          correctAnswer: subject.name,
          options: chars.map((c) => c.name).toList(),
        );
    }
  }

  static QuizRound _generateAppearancesRound(Character subject) {
    final count = subject.episode.length;
    final correctAnswer = '$count';
    final Set<String> optionsSet = {correctAnswer};
    final random = Random();
    
    while (optionsSet.length < 4) {
      final variation = random.nextInt(11) - 5; 
      if (variation == 0) continue;
      
      final fakeCount = count + variation;
      if (fakeCount > 0) {
        optionsSet.add('$fakeCount');
      }
    }

    return QuizRound(
      subject: subject,
      question: "How many episodes appearances?",
      correctAnswer: correctAnswer,
      options: optionsSet.toList()..shuffle(),
    );
  }

  static Future<String?> _fetchFirstSeenName(Character c) async {
    if (c.episode.isEmpty) return null;
    return Repository.getNameFromUrl(c.episode.first);
  }
}