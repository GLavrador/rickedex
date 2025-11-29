import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/leaderboard/leaderboard_filter_button.dart'; 
import 'package:rick_morty_app/components/leaderboard/leaderboard_header.dart';
import 'package:rick_morty_app/components/leaderboard/leaderboard_list.dart'; 
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/models/app_user.dart';
import 'package:rick_morty_app/models/quiz_types.dart';
import 'package:rick_morty_app/services/leaderboard_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class LeaderboardPage extends StatefulWidget {
  static const routeId = '/leaderboard';
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  QuizDifficulty _currentDifficulty = QuizDifficulty.hard;
  Future<List<AppUser>>? _future;

  @override
  void initState() {
    super.initState();
    _loadRanking();
  }

  void _loadRanking() {
    setState(() {
      _future = LeaderboardService.instance.getTopPlayers(_currentDifficulty);
    });
  }

  void _changeDifficulty(QuizDifficulty newDiff) {
    if (_currentDifficulty == newDiff) return;
    setState(() {
      _currentDifficulty = newDiff;
      _loadRanking();
    });
  }

  Future<void> _onRefresh() async {
    _loadRanking();
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBarComponent(
        context,
        isMenuAndHome: true,
        actions: [
          LeaderboardFilterButton(
            currentDifficulty: _currentDifficulty,
            onSelected: _changeDifficulty,
          ),
        ],
      ),
      drawer: const SideBarComponent(),
      body: SafeArea(
        child: Column(
          children: [
            LeaderboardHeader(difficulty: _currentDifficulty),
            
            Expanded(
              child: LeaderboardList(
                future: _future,
                currentDifficulty: _currentDifficulty,
                onRefresh: _onRefresh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}