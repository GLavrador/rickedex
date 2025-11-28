import 'package:rick_morty_app/models/character.dart';

enum QuizDifficulty { easy, medium, hard }

class QuizRound {
  final Character subject; 
  final String question;   
  final List<String> options; 
  final String correctAnswer; 

  QuizRound({
    required this.subject,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

const List<String> kSpeciesList = [
  'Alien', 'Animal', 'Cronenberg', 'Disease', 'Human', 'Humanoid', 
  'Mythological Creature', 'Poopybutthole', 'Robot', 'Unknown'
];

const List<String> kStatusList = ['Alive', 'Dead', 'unknown'];