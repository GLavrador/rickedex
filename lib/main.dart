import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rick_morty_app/pages/episode_details_page.dart';
import 'package:rick_morty_app/pages/episodes_page.dart';
import 'package:rick_morty_app/pages/favorites_page.dart';
import 'package:rick_morty_app/pages/location_details_page.dart';
import 'package:rick_morty_app/pages/locations_page.dart';
import 'pages/details_page.dart';
import 'pages/home_page.dart';
import 'package:rick_morty_app/services/favorites_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoritesService.instance.init();
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
          case HomePage.routeId:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const HomePage(),
            );
          case DetailsPage.routeId:
            final characterId = settings.arguments as int;
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => DetailsPage(characterId: characterId),
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
              builder: (_) => const EpisodesPage());
          case EpisodeDetailsPage.routeId:
            final id = (settings.arguments as Map?)?['id'] as int?;
            return MaterialPageRoute(
              settings: settings, 
              builder: (_) => EpisodeDetailsPage(episodeId: id!));
          case FavoritesPage.routeId:
            return MaterialPageRoute(
              settings: settings, 
              builder: (_) => const FavoritesPage());              
          default:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const HomePage(),
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
