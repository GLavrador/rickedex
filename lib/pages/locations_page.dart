import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/cards/location_card.dart';
import 'package:rick_morty_app/components/filters/filter_location_component.dart';
import 'package:rick_morty_app/components/navigation/page_flag.dart';
import 'package:rick_morty_app/components/navigation/pagination_bar.dart';
import 'package:rick_morty_app/components/navigation/search_bar_component.dart';
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/paginated_locations.dart';
import 'package:rick_morty_app/pages/location_details_page.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class LocationsPage extends StatefulWidget {
  static const routeId = '/locations';
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final _searchController = TextEditingController();
  Future<PaginatedLocations>? _future;
  int _currentPage = 1;
  String? _searchQuery;
  String? _dimensionFilter;

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        _dimensionFilter = args;
      }
      _load(1);
      _isInit = false;
    }
  }

  void _load(int page) {
    setState(() {
      _currentPage = page;
      _future = Repository.getLocations(
        page: page,
        name: _searchQuery,
        dimension: _dimensionFilter, 
      );
    });
  }

  void _onSubmitted(String value) {
    _searchQuery = value.trim().isEmpty ? null : value.trim();
    _load(1);
  }

  void _clearSearch() {
    _searchController.clear();
    if (_searchQuery != null) {
      _searchQuery = null;
      _load(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context, isMenuAndHome: true),
      drawer: const SideBarComponent(),
      backgroundColor: AppColors.backgroundColor,
      body: FutureBuilder<PaginatedLocations>(
        future: _future,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred.', style: TextStyle(color: AppColors.white)),
            );
          }

          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final data = snapshot.data!;
          final results = data.results;
          final showEmpty = results.isEmpty;

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            children: [
              const PageFlag('Locations'),
              const SizedBox(height: 16),
              SearchBarComponent(
                controller: _searchController,
                hintText: 'Search location...',
                onSubmitted: _onSubmitted,
                onClear: _clearSearch,
                isLoading: isLoading,
                trailingFilter: FilterLocationComponent(
                  selectedDimension: _dimensionFilter,
                  onChanged: (val) {
                    _dimensionFilter = val;
                    _load(1);
                  },
                ),
              ),
              const SizedBox(height: 12),

              if (showEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('No location found.',
                        style: TextStyle(color: AppColors.white)),
                  ),
                )
              else ...[
                GridView.builder(
                  itemCount: results.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.45,
                  ),
                  itemBuilder: (context, index) {
                    final loc = results[index];
                    return LocationCard(
                      location: loc,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: const RouteSettings(name: LocationDetailsPage.routeId),
                            builder: (_) => LocationDetailsPage(locationId: loc.id),
                          ),
                        );
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
