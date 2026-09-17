import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tl'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @languageAndRegion.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get languageAndRegion;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @choosePreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get choosePreferredLanguage;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @receiveScanResults.
  ///
  /// In en, this message translates to:
  /// **'Receive scan results and alerts'**
  String get receiveScanResults;

  /// No description provided for @locationServices.
  ///
  /// In en, this message translates to:
  /// **'Location Services'**
  String get locationServices;

  /// No description provided for @improveDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Help improve diagnosis accuracy'**
  String get improveDiagnosis;

  /// No description provided for @privacyData.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Data'**
  String get privacyData;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @readPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get readPrivacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @readTerms.
  ///
  /// In en, this message translates to:
  /// **'Read terms and conditions'**
  String get readTerms;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @exportDeleteData.
  ///
  /// In en, this message translates to:
  /// **'Export or delete your data'**
  String get exportDeleteData;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @getHelp.
  ///
  /// In en, this message translates to:
  /// **'Get help with the app'**
  String get getHelp;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @clearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// No description provided for @clearAllDataQuestion.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data?'**
  String get clearAllDataQuestion;

  /// No description provided for @clearDataWarning.
  ///
  /// In en, this message translates to:
  /// **'This will delete all your scan history and settings. This action cannot be undone.'**
  String get clearDataWarning;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @allDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All data cleared'**
  String get allDataCleared;

  /// No description provided for @diseaseDetection.
  ///
  /// In en, this message translates to:
  /// **'Disease Detection'**
  String get diseaseDetection;

  /// No description provided for @goodLighting.
  ///
  /// In en, this message translates to:
  /// **'Good lighting'**
  String get goodLighting;

  /// No description provided for @fillFrame.
  ///
  /// In en, this message translates to:
  /// **'Fill frame'**
  String get fillFrame;

  /// No description provided for @avoidBlur.
  ///
  /// In en, this message translates to:
  /// **'Avoid blur'**
  String get avoidBlur;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @alignSample.
  ///
  /// In en, this message translates to:
  /// **'Align sample inside the frame'**
  String get alignSample;

  /// No description provided for @preparingScanner.
  ///
  /// In en, this message translates to:
  /// **'Preparing scanner...'**
  String get preparingScanner;

  /// No description provided for @scannerAttention.
  ///
  /// In en, this message translates to:
  /// **'Scanner needs attention'**
  String get scannerAttention;

  /// No description provided for @startingCamera.
  ///
  /// In en, this message translates to:
  /// **'Starting camera...'**
  String get startingCamera;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable.'**
  String get cameraUnavailable;

  /// No description provided for @loadingAiModel.
  ///
  /// In en, this message translates to:
  /// **'Loading AI model...'**
  String get loadingAiModel;

  /// No description provided for @modelFailed.
  ///
  /// In en, this message translates to:
  /// **'Model failed to load.'**
  String get modelFailed;

  /// No description provided for @retryCamera.
  ///
  /// In en, this message translates to:
  /// **'Retry Camera'**
  String get retryCamera;

  /// No description provided for @retryModel.
  ///
  /// In en, this message translates to:
  /// **'Retry Model'**
  String get retryModel;

  /// No description provided for @detectionResult.
  ///
  /// In en, this message translates to:
  /// **'Detection Result'**
  String get detectionResult;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @saveToHistory.
  ///
  /// In en, this message translates to:
  /// **'Save to History'**
  String get saveToHistory;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @scanHistory.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scanHistory;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @disease.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get disease;

  /// No description provided for @totalScans.
  ///
  /// In en, this message translates to:
  /// **'Total Scans'**
  String get totalScans;

  /// No description provided for @diseasesFound.
  ///
  /// In en, this message translates to:
  /// **'Diseases Found'**
  String get diseasesFound;

  /// No description provided for @successRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get successRate;

  /// No description provided for @recentScans.
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get recentScans;

  /// No description provided for @noScansYet.
  ///
  /// In en, this message translates to:
  /// **'No scans yet'**
  String get noScansYet;

  /// No description provided for @runFirstScan.
  ///
  /// In en, this message translates to:
  /// **'Run your first scan to see results here.'**
  String get runFirstScan;

  /// No description provided for @photoTipsGuide.
  ///
  /// In en, this message translates to:
  /// **'Photo Tips & Guide'**
  String get photoTipsGuide;

  /// No description provided for @diseaseGuide.
  ///
  /// In en, this message translates to:
  /// **'Diseases Guide'**
  String get diseaseGuide;

  /// No description provided for @analysisResult.
  ///
  /// In en, this message translates to:
  /// **'Analysis Result'**
  String get analysisResult;

  /// No description provided for @confirmPhoto.
  ///
  /// In en, this message translates to:
  /// **'Confirm Photo'**
  String get confirmPhoto;

  /// No description provided for @chickenSample.
  ///
  /// In en, this message translates to:
  /// **'Chicken Poop Sample'**
  String get chickenSample;

  /// No description provided for @photoQualityCheck.
  ///
  /// In en, this message translates to:
  /// **'Photo Quality Check'**
  String get photoQualityCheck;

  /// No description provided for @lighting.
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get lighting;

  /// No description provided for @focus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focus;

  /// No description provided for @frame.
  ///
  /// In en, this message translates to:
  /// **'Frame'**
  String get frame;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @proper.
  ///
  /// In en, this message translates to:
  /// **'Proper'**
  String get proper;

  /// No description provided for @usePhoto.
  ///
  /// In en, this message translates to:
  /// **'Use Photo'**
  String get usePhoto;

  /// No description provided for @retakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Retake Photo'**
  String get retakePhoto;

  /// No description provided for @uploadDifferent.
  ///
  /// In en, this message translates to:
  /// **'Upload Different'**
  String get uploadDifferent;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @photoReceived.
  ///
  /// In en, this message translates to:
  /// **'Photo Received'**
  String get photoReceived;

  /// No description provided for @processingImage.
  ///
  /// In en, this message translates to:
  /// **'Processing Image'**
  String get processingImage;

  /// No description provided for @runningAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Running Analysis'**
  String get runningAnalysis;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @smartScanning.
  ///
  /// In en, this message translates to:
  /// **'Smart Scanning'**
  String get smartScanning;

  /// No description provided for @aiDiseaseDetection.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered\nDisease Detection'**
  String get aiDiseaseDetection;

  /// No description provided for @fastAccurate.
  ///
  /// In en, this message translates to:
  /// **'Fast & Accurate'**
  String get fastAccurate;

  /// No description provided for @getResultsSeconds.
  ///
  /// In en, this message translates to:
  /// **'Get Results\nin Seconds'**
  String get getResultsSeconds;

  /// No description provided for @farmManagement.
  ///
  /// In en, this message translates to:
  /// **'Farm Management'**
  String get farmManagement;

  /// No description provided for @keepFlockHealthy.
  ///
  /// In en, this message translates to:
  /// **'Keep Your\nFlock Healthy'**
  String get keepFlockHealthy;

  /// No description provided for @commonSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Common Symptoms:'**
  String get commonSymptoms;

  /// No description provided for @contactVeterinarian.
  ///
  /// In en, this message translates to:
  /// **'Contact a veterinarian for treatment recommendations'**
  String get contactVeterinarian;

  /// No description provided for @scanDetails.
  ///
  /// In en, this message translates to:
  /// **'Scan Details'**
  String get scanDetails;

  /// No description provided for @diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get diagnosis;

  /// No description provided for @analysisBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Analysis Breakdown'**
  String get analysisBreakdown;

  /// No description provided for @primaryFinding.
  ///
  /// In en, this message translates to:
  /// **'Primary Finding'**
  String get primaryFinding;

  /// No description provided for @confidenceLevel.
  ///
  /// In en, this message translates to:
  /// **'Confidence Level'**
  String get confidenceLevel;

  /// No description provided for @backToHistory.
  ///
  /// In en, this message translates to:
  /// **'Back to History'**
  String get backToHistory;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @shareComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Share feature coming soon!'**
  String get shareComingSoon;

  /// No description provided for @almostReady.
  ///
  /// In en, this message translates to:
  /// **'Almost ready...'**
  String get almostReady;

  /// No description provided for @tipClearPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Take Clear Photos'**
  String get tipClearPhotosTitle;

  /// No description provided for @tipClearPhotosDescription.
  ///
  /// In en, this message translates to:
  /// **'Learn the best way to capture sharp, clear images for accurate diagnosis. Use natural light and avoid shadows.'**
  String get tipClearPhotosDescription;

  /// No description provided for @tipLightingTitle.
  ///
  /// In en, this message translates to:
  /// **'Lighting Guide'**
  String get tipLightingTitle;

  /// No description provided for @tipLightingDescription.
  ///
  /// In en, this message translates to:
  /// **'Natural light works best. Avoid direct sunlight that creates harsh shadows. Overcast days are ideal.'**
  String get tipLightingDescription;

  /// No description provided for @tipCameraMistakesTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera Mistakes'**
  String get tipCameraMistakesTitle;

  /// No description provided for @tipCameraMistakesDescription.
  ///
  /// In en, this message translates to:
  /// **'Blurry images reduce diagnosis accuracy. Keep your hand steady and ensure the sample is in focus.'**
  String get tipCameraMistakesDescription;

  /// No description provided for @tipWhatToPhotographTitle.
  ///
  /// In en, this message translates to:
  /// **'What to Photograph'**
  String get tipWhatToPhotographTitle;

  /// No description provided for @tipWhatToPhotographDescription.
  ///
  /// In en, this message translates to:
  /// **'Always photograph chicken poop samples. Get close-up shots showing texture and color clearly.'**
  String get tipWhatToPhotographDescription;

  /// No description provided for @tipExamples.
  ///
  /// In en, this message translates to:
  /// **'Examples'**
  String get tipExamples;

  /// No description provided for @tipExamplesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Example content can be added here later.'**
  String get tipExamplesPlaceholder;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tl':
      return AppLocalizationsTl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
