import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FieldOptions {
  static List<String> genderOptions(BuildContext context) => [
    AppLocalizations.of(context)!.male,
    AppLocalizations.of(context)!.female,
    AppLocalizations.of(context)!.preferNotToSay, // Make sure this key exists in your localizations
  ];

  static List<String> activityLevelOptions(BuildContext context) => [
    AppLocalizations.of(context)!.sedentary,
    AppLocalizations.of(context)!.lightlyActive,
    AppLocalizations.of(context)!.moderatelyActive,
    AppLocalizations.of(context)!.veryActive,
    AppLocalizations.of(context)!.extraActive,
  ];

  static List<String> allergyOptions(BuildContext context) => [
    AppLocalizations.of(context)!.allergyNuts,
    AppLocalizations.of(context)!.allergyDairy,
    AppLocalizations.of(context)!.allergyGluten, // Added
    AppLocalizations.of(context)!.allergySeafood, // Added
    AppLocalizations.of(context)!.allergyPollen,
    AppLocalizations.of(context)!.allergyLatex, // Added
    AppLocalizations.of(context)!.allergyNoKnown,
  ];

  static List<String> diseaseOptions(BuildContext context) => [
    AppLocalizations.of(context)!.diseaseDiabetes,
    AppLocalizations.of(context)!.diseaseHypertension,
    AppLocalizations.of(context)!.diseaseHeartDisease, // Added
    AppLocalizations.of(context)!.diseaseAsthma, // Added
    AppLocalizations.of(context)!.diseaseThyroidDisorder, // Added
    AppLocalizations.of(context)!.diseaseNone,
  ];

  static List<String> healthGoalOptions(BuildContext context) => [
    AppLocalizations.of(context)!.goalGainWeight, // Added
    AppLocalizations.of(context)!.goalMaintainWeight, // Added
    AppLocalizations.of(context)!.goalWeightLoss,
    AppLocalizations.of(context)!.goalImproveMuscleTone, // Added
    AppLocalizations.of(context)!.goalIncreaseStamina, // Added
    AppLocalizations.of(context)!.goalImproveHealth, // Added
  ];

  static List<String> dietaryPreferenceOptions(BuildContext context) => [
    AppLocalizations.of(context)!.dietVegetarian,
    AppLocalizations.of(context)!.dietVegan,
    AppLocalizations.of(context)!.dietPescatarian, // Added
    AppLocalizations.of(context)!.dietOmnivore, // Added
    AppLocalizations.of(context)!.dietKeto,
    AppLocalizations.of(context)!.dietPaleo, // Added
    AppLocalizations.of(context)!.dietNone,
  ];

  static List<String> religiousDietaryRestrictions(BuildContext context) => [
    AppLocalizations.of(context)!.dietHalal, // Added
    AppLocalizations.of(context)!.dietKosher, // Added
    AppLocalizations.of(context)!.dietNoPork, // Added
    AppLocalizations.of(context)!.dietNoBeef, // Added
    AppLocalizations.of(context)!.dietVegetarianReligious, // Added
    AppLocalizations.of(context)!.dietNone,
  ];

  static List<String> appPurposeOptions(BuildContext context) => [
    AppLocalizations.of(context)!.appPurposeFitness,
    AppLocalizations.of(context)!.appPurposeHealthMonitoring, // Added
    AppLocalizations.of(context)!.appPurposeDietPlanning, // Added
    AppLocalizations.of(context)!.appPurposeWeightManagement, // Added
    AppLocalizations.of(context)!.appPurposeConditionManagement, // Added
    AppLocalizations.of(context)!.appPurposeActivityMotivation, // Added
    AppLocalizations.of(context)!.appPurposeResearch, // Added
  ];
}

class FieldInitialValues {
  static const int initialAge = 18;
  static const String initialGender = 'Male'; // Assuming 'Male' is a valid option
  static const int initialWeight = 60;
  static const int initialHeight = 170;
  static List<String> initialAllergies = [];
  static List<String> initialDiseases = [];
  static List<String> initialHealthGoals = [];
  static const String initialActivityLevel = 'Sedentary';
  static List<String> initialDietaryPreferences = [];
  static List<String> initialReligiousRestrictions = []; // Added
  static List<String> initialAppPurpose = [];
  static String initialOtherDiseases = '';
  static String initialOtherAllergies = '';
  static String initialOtherHealthGoals = ''; // Added
  static String initialOtherDietaryPreferences = ''; // Added
  static String initialOtherReligiousRestrictions = ''; // Added
  static String initialAdditionalInfo = ''; // Added
}
