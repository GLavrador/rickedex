class AppUser {
  final String id;
  final String email;
  final String nickname;
  final int highScoreEasy;
  final int highScoreMedium;
  final int highScoreHard;
  final bool isVerified; 

  AppUser({
    required this.id,
    required this.email,
    required this.nickname,
    this.highScoreEasy = 0,
    this.highScoreMedium = 0,
    this.highScoreHard = 0,
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'highScoreEasy': highScoreEasy,
      'highScoreMedium': highScoreMedium,
      'highScoreHard': highScoreHard,
      'isVerified': isVerified, 
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      nickname: map['nickname'] ?? 'Unknown',
      highScoreEasy: (map['highScoreEasy'] ?? 0) as int,
      highScoreMedium: (map['highScoreMedium'] ?? 0) as int,
      highScoreHard: (map['highScoreHard'] ?? 0) as int,
      isVerified: map['isVerified'] ?? false, 
    );
  }
}