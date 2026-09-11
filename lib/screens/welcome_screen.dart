import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/neo_card.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Title Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'whyNot! ',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.darkText,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.pinkAccent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderColor, width: 2),
                        ),
                        child: const Text(
                          '2026 🥔',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),

                  const SizedBox(height: 8),

                  const Text(
                    '🏅 USELESS OLYMPICS™ 🏅',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.pinkAccent,
                      letterSpacing: 1.2,
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 4),

                  const Text(
                    '“Where absolutely nothing matters.”',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Cat Selfie Sticker Feature Card
                  NeoCard(
                    backgroundColor: Colors.white,
                    padding: 20,
                    borderRadius: 24,
                    shadowOffset: 6,
                    child: Column(
                      children: [
                        // Sticker Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.yellowAccent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.borderColor, width: 2),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('🐱 ', style: TextStyle(fontSize: 16)),
                              Text(
                                'OFFICIAL MASCOT SELFIE',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  color: AppTheme.darkText,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Cat Sticker Image Container
                        Container(
                          height: 280,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.borderColor, width: 3.5),
                            boxShadow: const [
                              BoxShadow(
                                color: AppTheme.borderColor,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/cat_sticker.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback cute mascot graphic if asset is loading
                                return Container(
                                  color: AppTheme.yellowAccent,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('🐱 selfie cat', style: TextStyle(fontSize: 80)),
                                      SizedBox(height: 8),
                                      Text('OMG I TOOK A SELFIE! #STUNTIN',
                                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ).animate()
                         .scaleXY(begin: 0.9, end: 1.0, duration: 600.ms, curve: Curves.elasticOut),

                        const SizedBox(height: 16),

                        const Text(
                          'Join thousands of professional procrastinators competing in completely pointless events!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Start Button
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/registration');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.yellowAccent,
                        foregroundColor: AppTheme.darkText,
                        elevation: 0,
                        side: const BorderSide(color: AppTheme.borderColor, width: 3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ENTER ARENA OF PURE FUTILITY ',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          Text('🚀', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ).animate().scale(delay: 400.ms, duration: 400.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
