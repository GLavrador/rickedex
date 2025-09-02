import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/detailed_cards/detailed_location_card.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/location.dart';
import 'package:rick_morty_app/models/character.dart';          
import 'package:rick_morty_app/pages/details_page.dart';        
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/utils/id_from_url.dart';

class LocationDetailsPage extends StatefulWidget {
  static const routeId = '/location_details';
  const LocationDetailsPage({super.key, required this.locationId});
  final int locationId;

  @override
  State<LocationDetailsPage> createState() => _LocationDetailsPageState();
}

class _LocationDetailsPageState extends State<LocationDetailsPage> {
  late Future<LocationRM> _locationFuture;
  Future<List<Character>>? _residentCharsFuture;   // muda de string para character

  @override
  void initState() {
    super.initState();
    _locationFuture = Repository.getLocationDetails(widget.locationId);
    _residentCharsFuture = _loadResidents();
  }

  Future<List<Character>> _loadResidents() async {
    final loc = await _locationFuture;
    final ids = loc.residents
        .map(idFromUrl).whereType<int>().toSet().toList();

    if (ids.isEmpty) return const <Character>[];

    final characters = await Repository.getCharactersByIds(ids);
    characters.sort((a, b) => a.name.compareTo(b.name));
    return characters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context, isSecondPage: true),
      backgroundColor: AppColors.backgroundColor,
      body: FutureBuilder<LocationRM>(
        future: _locationFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final loc = snapshot.data!;
            return FutureBuilder<List<Character>>(
              future: _residentCharsFuture,
              builder: (context, resSnap) {
                final chars = resSnap.data ?? const <Character>[];
                return ListView(
                  children: [
                    LocationDetailsCard(
                      location: loc,
                      residentCharacters: chars,
                      onResidentTap: (id) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: const RouteSettings(name: DetailsPage.routeId),
                            builder: (_) => DetailsPage(characterId: id),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred.', style: TextStyle(color: AppColors.white)),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
