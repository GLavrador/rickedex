import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rick_morty_app/pages/auth_page.dart';
import 'package:rick_morty_app/pages/episode_details_page.dart';
import 'package:rick_morty_app/pages/episodes_page.dart';
import 'package:rick_morty_app/pages/favorites_page.dart';
import 'package:rick_morty_app/pages/feed_page.dart';
import 'package:rick_morty_app/pages/leaderboard_page.dart'; 
import 'package:rick_morty_app/pages/location_details_page.dart';
import 'package:rick_morty_app/pages/locations_page.dart';
import 'package:rick_morty_app/pages/profile_page.dart';
import 'package:rick_morty_app/pages/quiz_page.dart';
import 'package:rick_morty_app/pages/random_page.dart';
import 'pages/character_details_page.dart';
import 'pages/characters_page.dart';
import 'package:rick_morty_app/services/auth_service.dart';
import 'package:rick_morty_app/services/favorites_service.dart';
import 'package:rick_morty_app/services/quiz_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rick_morty_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);

  await AuthService.instance.init();
  await FavoritesService.instance.init();
  await QuizService.instance.init();
  
  runApp(const RickMortyApp());
}

class RickMortyApp extends StatelessWidget {
  const RickMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick & Morty App',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {

          case MainFeedPage.routeId:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const MainFeedPage(),
            );

          case AuthPage.routeId:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const AuthPage(),
            );

          case ProfilePage.routeId:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const ProfilePage(),
            );

          case CharactersPage.routeId:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const CharactersPage(),
            );

          case CharacterDetailsPage.routeId:
            final characterId = settings.arguments as int;
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => CharacterDetailsPage(characterId: characterId),
            );

          case LocationsPage.routeId:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const LocationsPage(),
            );

          case LocationDetailsPage.routeId:
            final args = settings.arguments as Map<String, dynamic>?;
            final id = args?['id'] as int?;
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => LocationDetailsPage(locationId: id!),
            );

          case EpisodesPage.routeId:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const EpisodesPage(),
            );

          case EpisodeDetailsPage.routeId:
            final id = (settings.arguments as Map?)?['id'] as int?;
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => EpisodeDetailsPage(episodeId: id!),
            );

          case FavoritesPage.routeId:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const FavoritesPage(),
            );

          case RandomPage.routeId:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const RandomPage(),
            );

          case QuizPage.routeId:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const QuizPage(),
            );

          case LeaderboardPage.routeId:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const LeaderboardPage(),
            );

          default:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const MainFeedPage(),
            );
        }
      },
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
