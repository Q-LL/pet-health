import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('zh'),
  ];

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get entryTypeMeal;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get entryTypeWater;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Potty'**
  String get entryTypePotty;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Brushing'**
  String get entryTypeBrushing;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get entryTypeWalk;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Bath'**
  String get entryTypeBath;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get entryTypeGrooming;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Parasite prevention'**
  String get entryTypeParasitePrevention;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get entryTypeWeight;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Ear check'**
  String get entryTypeEarCheck;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Other care'**
  String get entryTypeOtherCare;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Symptom'**
  String get entryTypeSymptom;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get entryTypeMedication;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Vaccine'**
  String get entryTypeVaccine;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Vet test'**
  String get entryTypeVetTest;

  /// Name of a record type.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get entryTypeCustom;

  /// How much of a meal the dog ate.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get appetiteFinished;

  /// How much of a meal the dog ate.
  ///
  /// In en, this message translates to:
  /// **'Left some'**
  String get appetiteLeftSome;

  /// How much of a meal the dog ate.
  ///
  /// In en, this message translates to:
  /// **'Barely ate'**
  String get appetiteBarelyAte;

  /// How much the dog drank compared with usual.
  ///
  /// In en, this message translates to:
  /// **'More than usual'**
  String get waterIntakeMore;

  /// How much the dog drank compared with usual.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get waterIntakeNormal;

  /// How much the dog drank compared with usual.
  ///
  /// In en, this message translates to:
  /// **'Less than usual'**
  String get waterIntakeLess;

  /// Kind of potty break.
  ///
  /// In en, this message translates to:
  /// **'Poop'**
  String get pottyKindPoop;

  /// Kind of potty break.
  ///
  /// In en, this message translates to:
  /// **'Pee'**
  String get pottyKindPee;

  /// What the poop looked like.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get stoolNormal;

  /// What the poop looked like.
  ///
  /// In en, this message translates to:
  /// **'Soft'**
  String get stoolSoft;

  /// What the poop looked like.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea'**
  String get stoolDiarrhea;

  /// What the poop looked like.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get stoolHard;

  /// What the poop looked like.
  ///
  /// In en, this message translates to:
  /// **'Blood or mucus'**
  String get stoolBloodOrMucus;

  /// What peeing looked like.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get urineNormal;

  /// What peeing looked like.
  ///
  /// In en, this message translates to:
  /// **'More often'**
  String get urineFrequent;

  /// What peeing looked like.
  ///
  /// In en, this message translates to:
  /// **'Very little'**
  String get urineLittle;

  /// What peeing looked like.
  ///
  /// In en, this message translates to:
  /// **'Unusual color'**
  String get urineUnusualColor;

  /// Coat condition noticed while brushing.
  ///
  /// In en, this message translates to:
  /// **'Smooth'**
  String get coatSmooth;

  /// Coat condition noticed while brushing.
  ///
  /// In en, this message translates to:
  /// **'Some tangles'**
  String get coatTangles;

  /// Coat condition noticed while brushing.
  ///
  /// In en, this message translates to:
  /// **'Heavy shedding'**
  String get coatHeavyShedding;

  /// Coat condition noticed while brushing.
  ///
  /// In en, this message translates to:
  /// **'Skin looks off'**
  String get coatSkinIssue;

  /// Where the bath happened.
  ///
  /// In en, this message translates to:
  /// **'At home'**
  String get bathPlaceHome;

  /// Where the bath happened.
  ///
  /// In en, this message translates to:
  /// **'At the groomer'**
  String get bathPlaceGroomer;

  /// Where the bath happened.
  ///
  /// In en, this message translates to:
  /// **'At the vet'**
  String get bathPlaceVet;

  /// Where grooming happened.
  ///
  /// In en, this message translates to:
  /// **'At the groomer'**
  String get groomingPlaceGroomer;

  /// Where grooming happened.
  ///
  /// In en, this message translates to:
  /// **'At home'**
  String get groomingPlaceHome;

  /// What a parasite prevention dose covers. Heartworm is prevention, never treatment.
  ///
  /// In en, this message translates to:
  /// **'Intestinal worms'**
  String get parasiteCoverageIntestinal;

  /// What a parasite prevention dose covers. Heartworm is prevention, never treatment.
  ///
  /// In en, this message translates to:
  /// **'Fleas & ticks'**
  String get parasiteCoverageFleasTicks;

  /// What a parasite prevention dose covers. Heartworm is prevention, never treatment.
  ///
  /// In en, this message translates to:
  /// **'Heartworm prevention'**
  String get parasiteCoverageHeartworm;

  /// Kind of test done by the vet.
  ///
  /// In en, this message translates to:
  /// **'Fecal test'**
  String get vetTestKindFecal;

  /// Kind of test done by the vet.
  ///
  /// In en, this message translates to:
  /// **'Heartworm test'**
  String get vetTestKindHeartworm;

  /// Kind of test done by the vet.
  ///
  /// In en, this message translates to:
  /// **'Other test'**
  String get vetTestKindOther;

  /// Result of a vet test, as reported by the vet.
  ///
  /// In en, this message translates to:
  /// **'Negative'**
  String get vetTestResultNegative;

  /// Result of a vet test, as reported by the vet.
  ///
  /// In en, this message translates to:
  /// **'Positive'**
  String get vetTestResultPositive;

  /// Result of a vet test, as reported by the vet.
  ///
  /// In en, this message translates to:
  /// **'Waiting for results'**
  String get vetTestResultPending;

  /// What the ears looked like.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get earsClean;

  /// What the ears looked like.
  ///
  /// In en, this message translates to:
  /// **'Waxy'**
  String get earsWaxy;

  /// What the ears looked like.
  ///
  /// In en, this message translates to:
  /// **'Red or smelly'**
  String get earsRedOrSmelly;

  /// Kind of other care.
  ///
  /// In en, this message translates to:
  /// **'Teeth'**
  String get otherCareTeeth;

  /// Kind of other care.
  ///
  /// In en, this message translates to:
  /// **'Nails'**
  String get otherCareNails;

  /// Kind of other care.
  ///
  /// In en, this message translates to:
  /// **'Eyes'**
  String get otherCareEyes;

  /// Kind of other care.
  ///
  /// In en, this message translates to:
  /// **'Paws'**
  String get otherCarePaws;

  /// Kind of other care.
  ///
  /// In en, this message translates to:
  /// **'Bedding & home'**
  String get otherCareEnvironment;

  /// Kind of other care.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherCareOther;

  /// Something the owner can see. Never a diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Vomiting'**
  String get symptomKindVomiting;

  /// Something the owner can see. Never a diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea'**
  String get symptomKindDiarrhea;

  /// Something the owner can see. Never a diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Coughing'**
  String get symptomKindCoughing;

  /// Something the owner can see. Never a diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Itching'**
  String get symptomKindItching;

  /// Something the owner can see. Never a diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Limping'**
  String get symptomKindLimping;

  /// Something the owner can see. Never a diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Low energy'**
  String get symptomKindLowEnergy;

  /// Something the owner can see. Never a diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get symptomKindOther;

  /// How a symptom is changing.
  ///
  /// In en, this message translates to:
  /// **'Getting better'**
  String get symptomStatusBetter;

  /// How a symptom is changing.
  ///
  /// In en, this message translates to:
  /// **'About the same'**
  String get symptomStatusSame;

  /// How a symptom is changing.
  ///
  /// In en, this message translates to:
  /// **'Getting worse'**
  String get symptomStatusWorse;

  /// Sex of the dog.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get sexMale;

  /// Sex of the dog.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get sexFemale;

  /// Breed group by size and coat type.
  ///
  /// In en, this message translates to:
  /// **'Large, double coat'**
  String get breedGroupLargeDouble;

  /// Breed group by size and coat type.
  ///
  /// In en, this message translates to:
  /// **'Medium, double coat'**
  String get breedGroupMediumDouble;

  /// Breed group by size and coat type.
  ///
  /// In en, this message translates to:
  /// **'Small, long silky coat'**
  String get breedGroupSmallSilky;

  /// Breed group by size and coat type.
  ///
  /// In en, this message translates to:
  /// **'Curly, low-shedding'**
  String get breedGroupCurly;

  /// Breed group by size and coat type.
  ///
  /// In en, this message translates to:
  /// **'Small, short coat'**
  String get breedGroupSmallShort;

  /// Breed group by size and coat type.
  ///
  /// In en, this message translates to:
  /// **'Medium to large, short coat'**
  String get breedGroupLargeShort;

  /// Breed group by size and coat type.
  ///
  /// In en, this message translates to:
  /// **'Mixed / not sure'**
  String get breedGroupMixed;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Golden Retriever'**
  String get breedGoldenRetriever;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Labrador Retriever'**
  String get breedLabradorRetriever;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'German Shepherd'**
  String get breedGermanShepherd;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Bernese Mountain Dog'**
  String get breedBerneseMountainDog;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Samoyed'**
  String get breedSamoyed;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Siberian Husky'**
  String get breedSiberianHusky;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Corgi'**
  String get breedCorgi;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Shiba Inu'**
  String get breedShibaInu;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Border Collie'**
  String get breedBorderCollie;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Australian Shepherd'**
  String get breedAustralianShepherd;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Cavalier King Charles Spaniel'**
  String get breedCavalierKingCharlesSpaniel;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Maltese'**
  String get breedMaltese;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Yorkshire Terrier'**
  String get breedYorkshireTerrier;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Shih Tzu'**
  String get breedShihTzu;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Papillon'**
  String get breedPapillon;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Poodle'**
  String get breedPoodle;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Bichon Frise'**
  String get breedBichonFrise;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Doodle'**
  String get breedDoodle;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'French Bulldog'**
  String get breedFrenchBulldog;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Pug'**
  String get breedPug;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Chihuahua'**
  String get breedChihuahua;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Dachshund'**
  String get breedDachshund;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Beagle'**
  String get breedBeagle;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Boxer'**
  String get breedBoxer;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Doberman'**
  String get breedDoberman;

  /// Breed name.
  ///
  /// In en, this message translates to:
  /// **'Pit Bull'**
  String get breedPitBull;

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value} kg'**
  String weightKg(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value} lb'**
  String weightLb(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value} jin'**
  String weightJin(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value} ml'**
  String volumeMl(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value} oz'**
  String volumeOz(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 cup} other{{value} cups}}'**
  String volumeCup(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value} km'**
  String distanceKm(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value} mi'**
  String distanceMi(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value}°C'**
  String temperatureC(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value}°F'**
  String temperatureF(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 scoop} other{{value} scoops}}'**
  String portionScoop(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 cup} other{{value} cups}}'**
  String portionCup(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value} g'**
  String portionG(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 can} other{{value} cans}}'**
  String portionCan(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 pouch} other{{value} pouches}}'**
  String portionPouch(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 piece} other{{value} pieces}}'**
  String portionPiece(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 tablet} other{{value} tablets}}'**
  String portionTablet(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value} ml'**
  String portionMl(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value} mg'**
  String portionMg(num value);

  /// An amount with its unit. The number is already rounded.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 drop} other{{value} drops}}'**
  String portionDrop(num value);

  /// A number of days.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String dayCount(int count);

  /// How long ago something happened.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Today} =1{Yesterday} other{{count} days ago}}'**
  String daysAgo(int count);

  /// Counting days since the dog came home; the first day is day 1.
  ///
  /// In en, this message translates to:
  /// **'Day {day} together'**
  String dayTogether(int day);

  /// A plan repeating every N days.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Every day} other{Every {count} days}}'**
  String scheduleEveryNDays(int count);

  /// A plan repeating every 7 days.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get scheduleEveryWeek;

  /// A plan repeating every N calendar months.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Every month} other{Every {count} months}}'**
  String scheduleEveryNMonths(int count);

  /// A plan repeating every 12 months.
  ///
  /// In en, this message translates to:
  /// **'Every year'**
  String get scheduleEveryYear;

  /// A plan on chosen weekdays; days is the joined list of short weekday names.
  ///
  /// In en, this message translates to:
  /// **'{days}'**
  String scheduleWeekdays(String days);

  /// A weekday plan with all seven days chosen.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get scheduleEveryDay;

  /// A one-time plan on a date.
  ///
  /// In en, this message translates to:
  /// **'On {date}'**
  String scheduleOnce(String date);

  /// Separator between weekday names in a list.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get weekdayListSeparator;

  /// Short weekday name; 1 is Monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayShort1;

  /// Short weekday name; 1 is Monday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayShort2;

  /// Short weekday name; 1 is Monday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayShort3;

  /// Short weekday name; 1 is Monday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayShort4;

  /// Short weekday name; 1 is Monday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayShort5;

  /// Short weekday name; 1 is Monday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdayShort6;

  /// Short weekday name; 1 is Monday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdayShort7;

  /// App language option. Language names stay in their own language.
  ///
  /// In en, this message translates to:
  /// **'Same as system'**
  String get languageSystem;

  /// App language option. Language names stay in their own language.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageZh;

  /// App language option. Language names stay in their own language.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// Unit system option.
  ///
  /// In en, this message translates to:
  /// **'Auto (by region)'**
  String get unitSystemAuto;

  /// Unit system option.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get unitSystemMetric;

  /// Unit system option.
  ///
  /// In en, this message translates to:
  /// **'Imperial (US)'**
  String get unitSystemImperial;

  /// Date order option.
  ///
  /// In en, this message translates to:
  /// **'Auto (by region)'**
  String get dateFormatAuto;

  /// Date order option.
  ///
  /// In en, this message translates to:
  /// **'Year-month-day'**
  String get dateFormatYmd;

  /// Date order option.
  ///
  /// In en, this message translates to:
  /// **'Month/day/year'**
  String get dateFormatMdy;

  /// Date order option.
  ///
  /// In en, this message translates to:
  /// **'Day/month/year'**
  String get dateFormatDmy;

  /// Kind of daily card.
  ///
  /// In en, this message translates to:
  /// **'Noticed'**
  String get cardCategoryObservation;

  /// Kind of daily card.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get cardCategoryComingUp;

  /// Kind of daily card.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get cardCategoryTip;

  /// Kind of daily card.
  ///
  /// In en, this message translates to:
  /// **'Moments'**
  String get cardCategoryMoment;

  /// How often a kind of daily card appears.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get cardFrequencyNormal;

  /// How often a kind of daily card appears.
  ///
  /// In en, this message translates to:
  /// **'Less often'**
  String get cardFrequencyLess;

  /// How often a kind of daily card appears.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get cardFrequencyOff;
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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
