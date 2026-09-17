import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/language_provider.dart';
import '../widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool locationEnabled = false;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final languageProvider = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(localization.settings)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Section
            _SettingsSectionTitle(title: localization.appSettings),
            _SettingsToggle(
              icon: Icons.notifications,
              title: localization.pushNotifications,
              subtitle: localization.receiveScanResults,
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() => notificationsEnabled = value);
              },
            ),
            _SettingsToggle(
              icon: Icons.location_on,
              title: localization.locationServices,
              subtitle: localization.improveDiagnosis,
              value: locationEnabled,
              onChanged: (value) {
                setState(() => locationEnabled = value);
              },
            ),

            // Language & Region
            _SettingsSectionTitle(title: localization.languageAndRegion),
            _SettingsDropdown(
              icon: Icons.language,
              title: localization.language,
              subtitle: localization.choosePreferredLanguage,
              value: languageProvider.locale.languageCode,
              options: [
                _LanguageOption(locale: const Locale('en'), label: 'English'),
                _LanguageOption(locale: const Locale('tl'), label: 'Tagalog'),
                _LanguageOption(
                  locale: const Locale('es'),
                  label: 'Spanish (${localization.comingSoon})',
                  enabled: false,
                ),
                _LanguageOption(
                  locale: const Locale('fr'),
                  label: 'French (${localization.comingSoon})',
                  enabled: false,
                ),
                _LanguageOption(
                  locale: const Locale('zh'),
                  label: 'Chinese (${localization.comingSoon})',
                  enabled: false,
                ),
              ],
              onChanged: context.read<LanguageProvider>().setLanguage,
            ),

            // Privacy & Data
            _SettingsSectionTitle(title: localization.privacyData),
            _SettingsTile(
              icon: Icons.privacy_tip,
              title: localization.privacyPolicy,
              subtitle: localization.readPrivacyPolicy,
              onTap: () =>
                  showCustomSnackBar(context, 'Opening privacy policy...'),
            ),
            _SettingsTile(
              icon: Icons.description,
              title: localization.termsOfService,
              subtitle: localization.readTerms,
              onTap: () =>
                  showCustomSnackBar(context, 'Opening terms of service...'),
            ),
            _SettingsTile(
              icon: Icons.data_usage,
              title: localization.dataManagement,
              subtitle: localization.exportDeleteData,
              onTap: () => showCustomSnackBar(
                context,
                'Data management feature coming soon!',
              ),
            ),

            // About
            _SettingsSectionTitle(title: localization.about),
            _SettingsTile(
              icon: Icons.info,
              title: localization.aboutApp,
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
              title: localization.helpSupport,
              subtitle: localization.getHelp,
              onTap: () => showCustomSnackBar(context, 'Support coming soon!'),
            ),

            // Danger Zone
            _SettingsSectionTitle(
              title: localization.dangerZone,
              isDanger: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DangerButton(
                label: localization.clearAllData,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(localization.clearAllDataQuestion),
                      content: Text(localization.clearDataWarning),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(localization.cancel),
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
                          child: Text(localization.clear),
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
            flex: 3,
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
  final List<_LanguageOption> options;
  final Function(Locale) onChanged;

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
          const SizedBox(width: 12),
          Flexible(
            flex: 2,
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              selectedItemBuilder: (context) => options
                  .map(
                    (option) => Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        option.shortLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              items: options
                  .map(
                    (option) => DropdownMenuItem(
                      value: option.locale.languageCode,
                      enabled: option.enabled,
                      child: Text(
                        option.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (selected) {
                if (selected != null) {
                  final option = options.firstWhere(
                    (option) => option.locale.languageCode == selected,
                  );
                  onChanged(option.locale);
                }
              },
              underline: const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption {
  final Locale locale;
  final String label;
  final bool enabled;

  String get shortLabel => label.split(' (').first;

  const _LanguageOption({
    required this.locale,
    required this.label,
    this.enabled = true,
  });
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
