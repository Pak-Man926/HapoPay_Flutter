class AchievementItem {
  final String id;
  final String title;
  final String desc;
  final String emoji;
  final int pts;
  final bool isClaimed;
  final bool isLocked;

  const AchievementItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.emoji,
    required this.pts,
    this.isClaimed = false,
    this.isLocked = false,
  });

  AchievementItem copyWith({bool? isClaimed}) {
    return AchievementItem(
      id: id,
      title: title,
      desc: desc,
      emoji: emoji,
      pts: pts,
      isClaimed: isClaimed ?? this.isClaimed,
      isLocked: isLocked,
    );
  }
}
