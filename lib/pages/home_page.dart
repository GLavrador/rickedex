import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar_component.dart';
import 'package:rick_morty_app/components/character_card.dart';
import 'package:rick_morty_app/components/pagination_bar.dart';
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
  Future<PaginatedCharacters>? _charactersFuture;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadPage(1);
  }

  void _loadPage(int page) {
    setState(() {
      _currentPage = page;
      _charactersFuture = Repository.getCharacters(page: page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context),
      backgroundColor: AppColors.backgroundColor,
      body: FutureBuilder<PaginatedCharacters>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final results = snapshot.data!.results;
            final totalPages = snapshot.data!.info.pages;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 7.5),
              itemCount: results.length + 1, // +1 para o footer de paginação
              itemBuilder: (context, index) {
                if (index < results.length) {
                  final character = results[index];
                  return CharacterCard(
                    character: character,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        DetailsPage.routeId,
                        arguments: character.id,
                      );
                    },
                  );
                } else {
                  // footer de paginação
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: PaginationBar(
                        currentPage: _currentPage,
                        totalPages: totalPages,
                        onPageSelected: (page) {
                          if (page != _currentPage) {
                            _loadPage(page);
                          }
                        },
                      ),
                    ),
                  );
                }
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
