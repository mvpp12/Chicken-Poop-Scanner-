import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chicken Health Scan'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).pushNamed('/tips');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Preview Section
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.gray.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      size: 64,
                      color: AppColors.gray,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Align sample inside frame',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: AppColors.charcoal),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'for accurate diagnosis',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: '📷',
                      label: 'Upload',
                      onPressed: () {
                        Navigator.of(context).pushNamed('/capture');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: '🎥',
                      label: 'Camera',
                      onPressed: () {
                        Navigator.of(context).pushNamed('/capture');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: '💡',
                      label: 'Good Lighting',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: '⚠️',
                      label: 'Avoid blur',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: '🔄',
                      label: 'Fit frame',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: '⭐',
                      label: 'Tips',
                      onPressed: () {
                        Navigator.of(context).pushNamed('/tips');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              ActionCard(
                icon: '📸',
                title: 'View History',
                description: 'Check your previous scans',
                onTap: () {
                  Navigator.of(context).pushNamed('/history');
                },
              ),
              ActionCard(
                icon: '📖',
                title: 'Diseases Guide',
                description: 'Learn about common chicken diseases',
                onTap: () {
                  Navigator.of(context).pushNamed('/tips');
                },
              ),
              ActionCard(
                icon: '⚙️',
                title: 'Settings',
                description: 'Configure app preferences',
                onTap: () {
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
