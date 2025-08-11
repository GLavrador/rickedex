import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar_component.dart';
import 'package:rick_morty_app/components/character_card.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/paginated_characters.dart';
import 'package:rick_morty_app/pages/details_page.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  static const routeId = '/';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<PaginatedCharacters>? characters;

  @override
  void initState() {
    super.initState();
    characters = Repository.getCharacters(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context),
      backgroundColor: AppColors.backgroundColor,
      body: FutureBuilder<PaginatedCharacters>(
        future: characters,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final dataResults = snapshot.data!.results;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 7.5),
              itemCount: dataResults.length,
              itemBuilder: (context, index) {
                final character = dataResults[index];
                return CharacterCard(
                  character: character,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      DetailsPage.routeId,
                      arguments: character.id,
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ocorreu um erro.',
                style: TextStyle(color: AppColors.white),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
