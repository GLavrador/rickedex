import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar_component.dart';
import 'package:rick_morty_app/components/character_card.dart';
import 'package:rick_morty_app/components/filter_character_component.dart';
import 'package:rick_morty_app/components/pagination_bar.dart';
import 'package:rick_morty_app/components/search_bar_component.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/paginated_characters.dart';
import 'package:rick_morty_app/pages/details_page.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  static const routeId = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<PaginatedCharacters>? _charactersFuture;
  final _searchController = TextEditingController();

  int _currentPage = 1;
  String? _searchQuery; // termo atual
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
    _loadPage(1); // volta pra página 1 ao aplicar filtros
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context),
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
                // barra de busca com filtro e spinner
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 20),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Expanded(
                          child: SearchBarComponent(
                            controller: _searchController,
                            onSubmitted: _applySearch,
                            onClear: _clearSearch,
                            isLoading: isLoading, 
                          ),
                        ),
                        FilterCharacterComponent(
                          currentFilters: _filters,
                          onApplyFilters: _applyFilters,
                        ),
                      ],
                    ),
                  );
                }

                // se não houver resultados
                if (showEmpty && index == 1) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Nenhum personagem encontrado.',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  );
                }

                // paginação: só mostra se houver 2+ páginas
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

                // quando showEmpty == true, os cards não existem, então só cai aqui quando há resultados
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
                'Ocorreu um erro.',
                style: TextStyle(color: AppColors.white),
              ),
            );
          } else {
            // carregamento inicial
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}