import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/cards/character_card.dart';
import 'package:rick_morty_app/components/filters/filter_character_component.dart';
import 'package:rick_morty_app/components/navigation/page_flag.dart';
import 'package:rick_morty_app/components/navigation/pagination_bar.dart';
import 'package:rick_morty_app/components/navigation/search_bar_component.dart';
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/paginated_characters.dart';
import 'package:rick_morty_app/pages/character_details_page.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class CharactersPage extends StatefulWidget {
  static const routeId = '/characters';
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  Future<PaginatedCharacters>? _charactersFuture;
  final _searchController = TextEditingController();

  int _currentPage = 1;
  String? _searchQuery; 
  Map<String, String?> _filters = {
    'gender': null,
    'status': null,
    'species': null,
  };

  @override
  void initState() {
    super.initState();
    _loadPage(1);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadPage(int page) {
    setState(() {
      _currentPage = page;
      _charactersFuture = Repository.getCharacters(
        page: page,
        name: _searchQuery,
        gender: _filters['gender'],
        status: _filters['status'],
        species: _filters['species'],
      );
    });
  }

  void _applySearch(String value) {
    _searchQuery = value.trim().isEmpty ? null : value.trim();
    _loadPage(1); // sempre volta pra primeira página ao buscar
  }

  void _clearSearch() {
    _searchController.clear();
    if (_searchQuery != null) {
      _searchQuery = null;
      _loadPage(1);
    }
  }

  void _applyFilters(Map<String, String?> newFilters) {
    setState(() {
      _filters = newFilters;
    });
    _loadPage(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context, isMenuAndHome: true),
      drawer: const SideBarComponent(),
      backgroundColor: AppColors.backgroundColor,
      body: FutureBuilder<PaginatedCharacters>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;

          if (snapshot.hasData) {
            final data = snapshot.data!;
            final results = data.results;
            final apiPages = data.info.pages;
            final totalPages = apiPages == 0 ? 1 : apiPages;
            final showEmpty = results.isEmpty;

            final itemCount = showEmpty ? 3 : results.length + 2;
            // 0: header (busca + filtro)
            // 1: (se vazio) empty state
            // último: footer (paginaçao)

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 7.5),
              itemCount: itemCount,
              itemBuilder: (context, index) {

                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PageFlag('Characters'),
                        const SizedBox(height: 16),
                        SearchBarComponent(
                          controller: _searchController,
                          onSubmitted: _applySearch,
                          onClear: _clearSearch,
                          isLoading: isLoading,
                          trailingFilter: FilterCharacterComponent(
                            currentFilters: _filters,
                            onApplyFilters: _applyFilters,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (showEmpty && index == 1) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No character found.',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  );
                }

                final isLast = index == itemCount - 1;
                if (isLast) {
                  if (apiPages <= 1) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: PaginationBar(
                        currentPage: _currentPage,
                        totalPages: totalPages,
                        onPageSelected: (page) {
                          if (page != _currentPage) _loadPage(page);
                        },
                      ),
                    ),
                  );
                }

                final listIndex = showEmpty ? index - 2 : index - 1;
                final character = results[listIndex];
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
                'An error occurred.',
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