import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/leaderboard/leaderboard_user_card.dart';
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

  int _getScoreForDifficulty(AppUser user, QuizDifficulty diff) {
    switch (diff) {
      case QuizDifficulty.easy: return user.highScoreEasy;
      case QuizDifficulty.medium: return user.highScoreMedium;
      case QuizDifficulty.hard: return user.highScoreHard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBarComponent(
        context,
        isMenuAndHome: true,
        actions: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 6, right: 8),
              child: PopupMenuButton<QuizDifficulty>(
                icon: Icon(Icons.filter_list, color: AppColors.primaryColorLight),
                tooltip: 'Ranking Filter',
                initialValue: _currentDifficulty,
                onSelected: _changeDifficulty,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: QuizDifficulty.hard,
                    child: Text('Hard'),
                  ),
                  const PopupMenuItem(
                    value: QuizDifficulty.medium,
                    child: Text('Medium'),
                  ),
                  const PopupMenuItem(
                    value: QuizDifficulty.easy,
                    child: Text('Easy'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: const SideBarComponent(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                children: [
                  Text(
                    "TOP 20 PLAYERS",
                    style: TextStyle(
                      color: AppColors.primaryColorLight,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _currentDifficulty.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primaryColorLight,
                backgroundColor: AppColors.appBarColor,
                child: FutureBuilder<List<AppUser>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Failed to load ranking", style: TextStyle(color: Colors.white)),
                      );
                    }

                    final players = snapshot.data ?? [];

                    if (players.isEmpty) {
                      return const Center(
                        child: Text("No records yet.", style: TextStyle(color: Colors.white)),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final user = players[index];
                        final score = _getScoreForDifficulty(user, _currentDifficulty);
                        
                        if (score == 0) return const SizedBox.shrink();

                        return LeaderboardUserCard(
                          user: user,
                          rank: index + 1,
                          score: score,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}