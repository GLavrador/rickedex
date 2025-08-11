import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar_component.dart';
import 'package:rick_morty_app/components/detailed_character_card.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class DetailsPage extends StatefulWidget {
  static const routeId = '/details';

  const DetailsPage({
    Key? key,
    required this.characterId,
  }) : super(key: key);

  final int characterId;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Future<Character>? characterFuture;

  static const double _minImageHeight = 160.0;
  static const double _maxImageHeight = 380.0;

  double _imageHeight = _minImageHeight;
  double _imageAlignY = 0;

  @override
  void initState() {
    super.initState();
    characterFuture = Repository.getCharacterDetails(widget.characterId);
  }

  void _onImageDragUpdate(double dy) {
    setState(() {
      _imageHeight =
          (_imageHeight + dy).clamp(_minImageHeight, _maxImageHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context, isSecondPage: true),
      backgroundColor: AppColors.backgroundColor,
      body: FutureBuilder<Character>(
        future: characterFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9.5),
                  child: CharacterDetailsCard(
                    character: data,
                    imageHeight: _imageHeight,
                    imageAlignmentY: _imageAlignY,
                    onImageDragUpdate: _onImageDragUpdate,
                  ),
                ),
              ],
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
