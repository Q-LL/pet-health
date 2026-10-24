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
  /// **'Every {days}'**
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

  /// App name shown in the task switcher.
  ///
  /// In en, this message translates to:
  /// **'Pet Health'**
  String get appName;

  /// Bottom bar: today page.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// Bottom bar: timeline page.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get navTimeline;

  /// Bottom bar: plans page.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get navPlans;

  /// Bottom bar: dog profile, when the dog has no name yet.
  ///
  /// In en, this message translates to:
  /// **'My dog'**
  String get navPetFallback;

  /// Screen reader name of the center + button.
  ///
  /// In en, this message translates to:
  /// **'Log something'**
  String get navLog;

  /// Temporary placeholder on pages not built yet.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get pageComingSoon;

  /// A plan repeating every N weeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Every week} other{Every {count} weeks}}'**
  String scheduleEveryNWeeks(int count);

  /// Progress through the onboarding steps.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String onboardingStep(int current, int total);

  /// Button: go to the next onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Button: go to the previous onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// Button: skip an optional onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Button: finish onboarding and create the profile.
  ///
  /// In en, this message translates to:
  /// **'All set'**
  String get onboardingDone;

  /// Title of the first onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Let\'s meet your dog'**
  String get onboardingWelcomeTitle;

  /// Intro text on the first onboarding step.
  ///
  /// In en, this message translates to:
  /// **'A few quick questions. Skip anything you like — you can change it all later.'**
  String get onboardingWelcomeBody;

  /// Label of the dog's name field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get onboardingNameLabel;

  /// Hint in the dog's name field.
  ///
  /// In en, this message translates to:
  /// **'e.g. Lucky'**
  String get onboardingNameHint;

  /// Error when the name is empty.
  ///
  /// In en, this message translates to:
  /// **'Give your dog a name first.'**
  String get onboardingNameRequired;

  /// Label of the optional sex choice.
  ///
  /// In en, this message translates to:
  /// **'Sex (optional)'**
  String get onboardingSexLabel;

  /// Title of the breed step.
  ///
  /// In en, this message translates to:
  /// **'What breed is {name}?'**
  String onboardingBreedTitle(String name);

  /// Hint in the breed search field.
  ///
  /// In en, this message translates to:
  /// **'Search breeds'**
  String get onboardingBreedSearch;

  /// Option for a breed not in the list.
  ///
  /// In en, this message translates to:
  /// **'Not listed / mixed'**
  String get onboardingBreedOther;

  /// Field for a breed typed by the user.
  ///
  /// In en, this message translates to:
  /// **'Breed (optional)'**
  String get onboardingBreedOtherName;

  /// Label of the breed group choice.
  ///
  /// In en, this message translates to:
  /// **'Size and coat'**
  String get onboardingBreedGroupLabel;

  /// Why the breed group is asked.
  ///
  /// In en, this message translates to:
  /// **'We use this to suggest a care routine.'**
  String get onboardingBreedGroupHint;

  /// Title of the dates step.
  ///
  /// In en, this message translates to:
  /// **'Two days to remember'**
  String get onboardingDatesTitle;

  /// Label of the birthday field.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get onboardingBirthday;

  /// Switch: the birthday is only known to the month.
  ///
  /// In en, this message translates to:
  /// **'I only know the month'**
  String get onboardingBirthdayMonthOnly;

  /// Label of the homecoming date field.
  ///
  /// In en, this message translates to:
  /// **'Came home on'**
  String get onboardingHomeDate;

  /// Why the homecoming date is asked.
  ///
  /// In en, this message translates to:
  /// **'For counting your days together.'**
  String get onboardingHomeDateHint;

  /// Shown for an empty optional date.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get onboardingNotSet;

  /// Button: clear a filled-in value.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get onboardingClear;

  /// Title of the habits step.
  ///
  /// In en, this message translates to:
  /// **'Daily routine'**
  String get onboardingHabitsTitle;

  /// Why daily habits are asked.
  ///
  /// In en, this message translates to:
  /// **'So one tap logs the right amount.'**
  String get onboardingHabitsBody;

  /// Label of the per-meal portion.
  ///
  /// In en, this message translates to:
  /// **'Each meal'**
  String get onboardingMealAmount;

  /// Label of the meals-per-day choice.
  ///
  /// In en, this message translates to:
  /// **'Meals a day'**
  String get onboardingMealsPerDay;

  /// Label of the water bowl size.
  ///
  /// In en, this message translates to:
  /// **'Water bowl holds'**
  String get onboardingBowl;

  /// Title of the parasite step.
  ///
  /// In en, this message translates to:
  /// **'Parasite prevention'**
  String get onboardingParasiteTitle;

  /// Intro on the parasite step.
  ///
  /// In en, this message translates to:
  /// **'Go with what your vet recommends. You can change it anytime.'**
  String get onboardingParasiteBody;

  /// Parasite approach: regular doses.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get parasiteModeScheduled;

  /// Parasite approach: tests, treat when the vet says so.
  ///
  /// In en, this message translates to:
  /// **'Vet tests'**
  String get parasiteModeTests;

  /// Parasite approach: no plan for now.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get parasiteModeNone;

  /// Neutral note under heartworm prevention. Not medical advice.
  ///
  /// In en, this message translates to:
  /// **'Vets usually test for heartworm before starting prevention.'**
  String get parasiteHeartwormTestFirst;

  /// Explains the test-based approach for intestinal worms.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you about fecal tests. Log a dose whenever your vet says so.'**
  String get parasiteIntestinalTestsHint;

  /// Explains the test-based approach for heartworm.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you about heartworm tests.'**
  String get parasiteHeartwormTestsHint;

  /// Unit name shown next to an amount field.
  ///
  /// In en, this message translates to:
  /// **'Scoop'**
  String get unitScoop;

  /// Unit name shown next to an amount field.
  ///
  /// In en, this message translates to:
  /// **'Cup'**
  String get unitCup;

  /// Unit name shown next to an amount field.
  ///
  /// In en, this message translates to:
  /// **'Gram'**
  String get unitGram;

  /// Unit name shown next to an amount field.
  ///
  /// In en, this message translates to:
  /// **'Can'**
  String get unitCan;

  /// Unit name shown next to an amount field.
  ///
  /// In en, this message translates to:
  /// **'Pouch'**
  String get unitPouch;

  /// Unit name shown next to an amount field.
  ///
  /// In en, this message translates to:
  /// **'Piece'**
  String get unitPiece;

  /// Unit name shown next to an amount field.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unitMl;

  /// Unit name shown next to an amount field.
  ///
  /// In en, this message translates to:
  /// **'oz'**
  String get unitOz;

  /// Unit name shown next to an amount field.
  ///
  /// In en, this message translates to:
  /// **'cups'**
  String get unitCups;

  /// Greeting at the top of Today.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}!'**
  String todayGreeting(String name);

  /// Section title above the one-tap buttons.
  ///
  /// In en, this message translates to:
  /// **'Quick log'**
  String get todayQuickLog;

  /// Section title above today's cards.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get todayForYou;

  /// Shown when no plan is due today.
  ///
  /// In en, this message translates to:
  /// **'Nothing on the list today.'**
  String get todayNothingDue;

  /// Meals logged today out of the usual number.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String captionMeals(int done, int total);

  /// How many times something was logged today.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Not yet} =1{1 time} other{{count} times}}'**
  String captionTimes(int count);

  /// Water bowl refills logged today.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Not yet} =1{1 refill} other{{count} refills}}'**
  String captionWater(int count);

  /// Poops logged today.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Not yet} =1{1 poop} other{{count} poops}}'**
  String captionPoop(int count);

  /// A plan for this is due today.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get captionDueToday;

  /// A walk is in progress.
  ///
  /// In en, this message translates to:
  /// **'Walking · {minutes} min'**
  String captionWalking(int minutes);

  /// This one needs a few details, so tapping opens a form.
  ///
  /// In en, this message translates to:
  /// **'Tap to log'**
  String get captionTapToLog;

  /// Toast title after a one-tap log.
  ///
  /// In en, this message translates to:
  /// **'Logged'**
  String get toastLogged;

  /// Toast title after starting a walk.
  ///
  /// In en, this message translates to:
  /// **'Walk started'**
  String get toastWalkStarted;

  /// Toast title after finishing a walk.
  ///
  /// In en, this message translates to:
  /// **'Walk done'**
  String get toastWalkFinished;

  /// Toast button: undo the log.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get toastUndo;

  /// Toast button: open the details form.
  ///
  /// In en, this message translates to:
  /// **'Add details'**
  String get toastMore;

  /// A duration in minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// Coming-up card body: days since the plan was last done. Never says late.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day since last time.} other{{days} days since last time.}}'**
  String cardDaysSince(int days);

  /// Coming-up card body for a weekday plan with no history yet.
  ///
  /// In en, this message translates to:
  /// **'{name} is on today\'s list.'**
  String cardOnTodaysList(String name);

  /// Card button: log the plan as done.
  ///
  /// In en, this message translates to:
  /// **'Log it'**
  String get cardLogIt;

  /// Card button: snooze the plan for a few hours.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get cardLater;

  /// Title of the details form for an entry already logged.
  ///
  /// In en, this message translates to:
  /// **'Add details'**
  String get sheetAddDetails;

  /// Subtitle of the details form.
  ///
  /// In en, this message translates to:
  /// **'Logged · {time}'**
  String sheetLoggedAt(String time);

  /// Label of the time field.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get sheetTime;

  /// Button that opens the note field.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get sheetAddNote;

  /// Label of the note field.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get sheetNote;

  /// Button: close the details form after saving.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get sheetDone;

  /// Button: save a new entry from the form.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get sheetSave;

  /// Screen reader name of the close button.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get sheetClose;

  /// Label of an amount field.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get sheetAmount;

  /// Label of a name field (medicine, vaccine, custom item).
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sheetName;

  /// Label of the product name field for parasite prevention.
  ///
  /// In en, this message translates to:
  /// **'Product (optional)'**
  String get sheetProduct;

  /// Label of the appetite options.
  ///
  /// In en, this message translates to:
  /// **'How much was eaten'**
  String get fieldAppetite;

  /// Label of the water intake options.
  ///
  /// In en, this message translates to:
  /// **'Compared with usual'**
  String get fieldIntake;

  /// Label of the poop or pee options.
  ///
  /// In en, this message translates to:
  /// **'How it looked'**
  String get fieldLooks;

  /// Label of the coat options.
  ///
  /// In en, this message translates to:
  /// **'Coat'**
  String get fieldCoat;

  /// Label of the place options.
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get fieldWhere;

  /// Label of the ear options.
  ///
  /// In en, this message translates to:
  /// **'Ears'**
  String get fieldEars;

  /// Label of a kind choice.
  ///
  /// In en, this message translates to:
  /// **'What'**
  String get fieldWhat;

  /// Label of the symptom options. Never a diagnosis.
  ///
  /// In en, this message translates to:
  /// **'What you noticed'**
  String get fieldNoticed;

  /// Label of the symptom trend options.
  ///
  /// In en, this message translates to:
  /// **'Compared with before'**
  String get fieldTrend;

  /// Label of the vet test result options.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get fieldResult;

  /// Label of the parasite coverage options.
  ///
  /// In en, this message translates to:
  /// **'Covers'**
  String get fieldCovers;

  /// Unit name shown next to an amount field.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// Unit name shown next to an amount field.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get unitLb;

  /// Unit name shown next to an amount field.
  ///
  /// In en, this message translates to:
  /// **'jin'**
  String get unitJin;

  /// Title of the plans page.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s plans'**
  String plansTitle(String name);

  /// Explains how plans work, on the plans page.
  ///
  /// In en, this message translates to:
  /// **'Doing it once counts. The next time is counted from when you actually did it.'**
  String get plansSubtitle;

  /// Button: create a new plan.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get plansNew;

  /// Shown when the dog has no plans.
  ///
  /// In en, this message translates to:
  /// **'No plans yet.'**
  String get plansEmpty;

  /// Plans group: due today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get groupToday;

  /// Plans group: not due yet.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get groupSoon;

  /// Plans group: never logged, so no next date yet.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get groupNotStarted;

  /// Plans group: paused plans.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get groupPaused;

  /// Plans group: finished one-time plans.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get groupDone;

  /// Chip on a plan due today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get chipToday;

  /// Chip on a plan snoozed for now.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get chipLater;

  /// A plan with no history yet. Never nags.
  ///
  /// In en, this message translates to:
  /// **'Starts after the first log'**
  String get planStartsAfterFirstLog;

  /// When a plan was last done.
  ///
  /// In en, this message translates to:
  /// **'Last {date}'**
  String planLastDone(String date);

  /// Title of the plan form when creating.
  ///
  /// In en, this message translates to:
  /// **'New plan'**
  String get planNew;

  /// Label of the plan's entry type choice.
  ///
  /// In en, this message translates to:
  /// **'What'**
  String get planWhat;

  /// Label of a custom plan's name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get planTitleLabel;

  /// Label of the schedule choice.
  ///
  /// In en, this message translates to:
  /// **'How often'**
  String get planHowOften;

  /// Schedule type: every N days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get scheduleKindEveryNDays;

  /// Schedule type: every N calendar months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get scheduleKindEveryNMonths;

  /// Schedule type: on chosen weekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get scheduleKindWeekdays;

  /// Schedule type: a one-time plan.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get scheduleKindOnce;

  /// A number of months.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month} other{{count} months}}'**
  String monthCount(int count);

  /// Label of a one-time plan's date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get planDate;

  /// Switch: pause a plan.
  ///
  /// In en, this message translates to:
  /// **'Pause this plan'**
  String get planPause;

  /// Button: delete a plan.
  ///
  /// In en, this message translates to:
  /// **'Delete plan'**
  String get planDelete;

  /// Confirmation before deleting a plan.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”? Past logs are kept.'**
  String planDeleteConfirm(String name);

  /// Generic cancel button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Generic delete button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// Screen reader name of the minus button.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get stepperLess;

  /// Screen reader name of the plus button.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get stepperMore;
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
