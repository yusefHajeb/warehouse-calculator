import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/welcome_card.dart';
import '../widgets/primary_action_card.dart';
import '../widgets/secondary_action_card.dart';
import '../widgets/recent_activity_banner.dart';

/// Home Screen — static presentation only.
///
/// Mirrors the HTML design: branded header, welcome card with stats,
/// two large action cards (Calculate Order & Manage Products),
/// and a recent activity banner.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              const HomeHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: const [
                    WelcomeCard(),
                    SizedBox(height: 24),
                    PrimaryActionCard(),
                    SizedBox(height: 16),
                    SecondaryActionCard(),
                    SizedBox(height: 24),
                    RecentActivityBanner(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
