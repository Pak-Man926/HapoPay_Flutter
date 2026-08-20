/// Shared tier colours / gradients for rewards UI surfaces.
library;

import 'package:flutter/material.dart';
import '../models/reward_model.dart';

const Map<RewardTier, Color> rewardTierColors = {
  RewardTier.bronze: Color(0xFFCD7F32),
  RewardTier.silver: Color(0xFFC0C0C0),
  RewardTier.gold: Color(0xFFFFD700),
  RewardTier.platinum: Color(0xFF00E5FF),
};

const Map<RewardTier, List<Color>> rewardTierGradients = {
  RewardTier.bronze: [Color(0xFF8B4513), Color(0xFFCD7F32)],
  RewardTier.silver: [Color(0xFF708090), Color(0xFFC0C0C0)],
  RewardTier.gold: [Color(0xFFB8860B), Color(0xFFFFD700)],
  RewardTier.platinum: [Color(0xFF006064), Color(0xFF00E5FF)],
};
