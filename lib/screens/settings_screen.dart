import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool locationEnabled = false;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Section
            _SettingsSectionTitle(title: 'App Settings'),
            _SettingsToggle(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive scan results and alerts',
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() => notificationsEnabled = value);
              },
            ),
            _SettingsToggle(
              icon: Icons.location_on,
              title: 'Location Services',
              subtitle: 'Help improve diagnosis accuracy',
              value: locationEnabled,
              onChanged: (value) {
                setState(() => locationEnabled = value);
              },
            ),

            // Language & Region
            _SettingsSectionTitle(title: 'Language & Region'),
            _SettingsDropdown(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'Choose your preferred language',
              value: selectedLanguage,
              options: ['English', 'Spanish', 'French', 'Chinese'],
              onChanged: (value) {
                setState(() => selectedLanguage = value);
              },
            ),

            // Privacy & Data
            _SettingsSectionTitle(title: 'Privacy & Data'),
            _SettingsTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () =>
                  showCustomSnackBar(context, 'Opening privacy policy...'),
            ),
            _SettingsTile(
              icon: Icons.description,
              title: 'Terms of Service',
              subtitle: 'Read terms and conditions',
              onTap: () =>
                  showCustomSnackBar(context, 'Opening terms of service...'),
            ),
            _SettingsTile(
              icon: Icons.data_usage,
              title: 'Data Management',
              subtitle: 'Export or delete your data',
              onTap: () => showCustomSnackBar(
                context,
                'Data management feature coming soon!',
              ),
            ),

            // About
            _SettingsSectionTitle(title: 'About'),
            _SettingsTile(
              icon: Icons.info,
              title: 'About App',
              subtitle: 'Version 1.0.0',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('About Chicken Health Scan'),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Version: 1.0.0'),
                        SizedBox(height: 8),
                        Text(
                          'A mobile application for detecting chicken diseases using image analysis and AI technology.',
                        ),
                        SizedBox(height: 8),
                        Text('© 2025 Chicken Health Scan'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
            _SettingsTile(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help with the app',
              onTap: () => showCustomSnackBar(context, 'Support coming soon!'),
            ),

            // Danger Zone
            _SettingsSectionTitle(title: 'Danger Zone', isDanger: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DangerButton(
                label: 'Clear All Data',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear All Data?'),
                      content: const Text(
                        'This will delete all your scan history and settings. This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showCustomSnackBar(
                              context,
                              'All data cleared',
                              isError: true,
                            );
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  final String title;
  final bool isDanger;

  const _SettingsSectionTitle({required this.title, this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDanger ? AppColors.danger : AppColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.gray.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: AppColors.gray),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _SettingsDropdown extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final List<String> options;
  final Function(String) onChanged;

  const _SettingsDropdown({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.gray.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: AppColors.gray),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: value,
            items: options
                .map(
                  (option) =>
                      DropdownMenuItem(value: option, child: Text(option)),
                )
                .toList(),
            onChanged: (selected) {
              if (selected != null) onChanged(selected);
            },
            underline: const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.gray.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: AppColors.gray),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gray),
          ],
        ),
      ),
    );
  }
}
