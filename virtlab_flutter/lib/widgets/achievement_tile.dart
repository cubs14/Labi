import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../theme/app_theme.dart';

class AchievementTile extends StatelessWidget {
  final Achievement achievement;
  const AchievementTile({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            unlocked ? achievement.iconColorAsset : achievement.iconGrayAsset,
            width: 64,
            height: 64,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(achievement.title,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: unlocked ? AppColors.textDark : Colors.grey)),
                const SizedBox(height: 4),
                Text(achievement.description,
                    style: TextStyle(fontSize: 14, color: unlocked ? AppColors.textDark : Colors.grey)),
                if (unlocked && achievement.unlockedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Desbloqueado el ${achievement.unlockedAt!.day}/${achievement.unlockedAt!.month}/${achievement.unlockedAt!.year}',
                    style: const TextStyle(fontSize: 12, color: AppColors.primaryDark),
                  ),
                ],
              ],
            ),
          ),
          Icon(unlocked ? Icons.emoji_events : Icons.lock_outline,
              color: unlocked ? AppColors.accentGold : Colors.grey),
        ],
      ),
    );
  }
}
