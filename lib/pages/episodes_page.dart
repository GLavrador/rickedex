import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar_component.dart';
import 'package:rick_morty_app/components/episode_card.dart';
import 'package:rick_morty_app/components/filter_episode_component.dart';
import 'package:rick_morty_app/components/pagination_bar.dart';
import 'package:rick_morty_app/components/search_bar_component.dart';
import 'package:rick_morty_app/components/side_bar_component.dart';
import 'package:rick_morty_app/models/paginated_episodes.dart';
import 'package:rick_morty_app/pages/episode_details_page.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/data/repository.dart';

class EpisodesPage extends StatefulWidget {
  static const routeId = '/episodes';
  const EpisodesPage({super.key});
  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  final _searchController = TextEditingController();
  Future<PaginatedEpisodes>? _future;
  int _currentPage = 1;
  String? _searchQuery;
  String? _seasonFilter;

  @override
  void initState() {
    super.initState();
    _load(1);
  }

  void _load(int page) {
  setState(() {
    _currentPage = page;
    _future = Repository.getEpisodes(
      page: page,
      name: _searchQuery,
      episodeCode: _seasonFilter, 
    );
  });
}

  void _onSubmitted(String value) {
    _searchQuery = value.trim().isEmpty ? null : value.trim();
    _load(1);
  }

  void _clearSearch() {
    _searchController.clear();
    if (_searchQuery != null) { _searchQuery = null; _load(1); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context),
      drawer: const SideBarComponent(),
      backgroundColor: AppColors.backgroundColor,
      body: FutureBuilder<PaginatedEpisodes>(
        future: _future,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ocorreu um erro.', style: TextStyle(color: AppColors.white)));
          }
          if (!snapshot.hasData) return const SizedBox.shrink();

          final data = snapshot.data!;
          final results = data.results;
          final showEmpty = results.isEmpty;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              SearchBarComponent(
                controller: _searchController,
                hintText: 'Search episode...',
                onSubmitted: _onSubmitted,
                onClear: _clearSearch,
                isLoading: isLoading,
                trailingFilter: FilterEpisodeComponent(
                  selectedSeason: _seasonFilter,
                  onChanged: (value) {
                    _seasonFilter = value;     
                    _load(1);                   
                  },
                ),
              ),
              const SizedBox(height: 12),

              if (showEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('Nenhum episódio encontrado.', style: TextStyle(color: Colors.white)),
                  ),
                )
              else ...[
                GridView.builder(
                  itemCount: results.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.45,
                  ),
                  itemBuilder: (context, index) {
                    final ep = results[index];
                    return EpisodeCard(
                      episode: ep,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          settings: const RouteSettings(name: EpisodeDetailsPage.routeId),
                          builder: (_) => EpisodeDetailsPage(episodeId: ep.id),
                        ));
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (data.info.pages > 0)
                  PaginationBar(
                    currentPage: _currentPage,
                    totalPages: data.info.pages,
                    onPageSelected: _load,
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
