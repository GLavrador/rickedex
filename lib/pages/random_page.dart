import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/cards/character_card.dart';
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/pages/details_page.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class RandomPage extends StatefulWidget {
  static const routeId = '/random';

  const RandomPage({super.key});

  @override
  State<RandomPage> createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  Character? _character;
  bool _loading = false;
  String? _error;

  Future<void> _roll() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final c = await Repository.getRandomCharacter();
      setState(() => _character = c);
    } catch (e) {
      setState(() => _error = 'An error occurred.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context),
      backgroundColor: AppColors.backgroundColor,
      drawer: const SideBarComponent(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          ElevatedButton.icon(
            onPressed: _loading ? null : _roll,
            icon: const Icon(Icons.casino),
            label: const Text('Randomize'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColorLight,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),

          if (_loading)
            const Center(child: CircularProgressIndicator()),

          if (_error != null && !_loading)
            Center(child: Text(_error!, style: TextStyle(color: AppColors.white))),

          if (_character != null && !_loading)
            CharacterCard(
              character: _character!,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    settings: const RouteSettings(name: DetailsPage.routeId),
                    builder: (_) => DetailsPage(characterId: _character!.id),
                  ),
                );
              },
              imageHeight: 300,                 
              imageAlignment: Alignment.center, 
            ),
        ],
      ),
    );
  }
}
