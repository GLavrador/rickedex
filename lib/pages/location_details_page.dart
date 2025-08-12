import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/detailed_cards/detailed_location_card.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/location.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class LocationDetailsPage extends StatefulWidget {
  static const routeId = '/location_details';

  const LocationDetailsPage({super.key, required this.locationId});

  final int locationId;

  @override
  State<LocationDetailsPage> createState() => _LocationDetailsPageState();
}

class _LocationDetailsPageState extends State<LocationDetailsPage> {
  late Future<LocationRM> _locationFuture;
  Future<List<String>>? _residentNamesFuture;

  @override
  void initState() {
    super.initState();
    _locationFuture = Repository.getLocationDetails(widget.locationId);
    _residentNamesFuture = _loadResidentNames();
  }

  Future<List<String>> _loadResidentNames() async {
    final dio = Dio(BaseOptions(headers: {'Accept': 'application/json'}));
    try {
      final loc = await _locationFuture;
      final urls = loc.residents.take(12).toList(); // limita para performance
      final futures = urls.map((u) async {
        try {
          final resp = await dio.getUri(Uri.parse(u));
          return (resp.data?['name'] as String?) ?? '';
        } catch (_) {
          return '';
        }
      });
      final names = await Future.wait(futures);
      return names.where((e) => e.isNotEmpty).toList();
    } catch (_) {
      return <String>[];
    }
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
            return FutureBuilder<List<String>>(
              future: _residentNamesFuture,
              builder: (context, resSnap) {
                final names = resSnap.data;
                return ListView(
                  children: [
                    LocationDetailsCard(
                      location: loc,
                      residentNames: names,
                    ),
                  ],
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
