import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/features/form/model/form_widgets.dart';
import 'package:byte_app/features/form/model/health_form_field.dart';
import 'package:byte_app/app_theme.dart';

class MedicalInformationForm extends StatefulWidget {
  const MedicalInformationForm({Key? key}) : super(key: key);

  @override
  MedicalInformationFormState createState() => MedicalInformationFormState();
}

class MedicalInformationFormState extends State<MedicalInformationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isExpanded = false;
  bool _isEditing = false;
  List<String> selectedAllergies = [];
  List<String> selectedDiseases = [];
  List<String> selectedHealthGoals = [];
  List<String> selectedDietaryPreferences = [];
  String activityLevel = '';
  String additionalInfo = '';
  bool _isLoading = false;
  String _error = '';
  late TextEditingController _additionalInfoController;

  @override
  void initState() {
    super.initState();
    _additionalInfoController = TextEditingController();
    _fetchFormData();
  }

  void _fetchFormData() async {
    setState(() => _isLoading = true);
    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('user_health_data')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        setState(() {
          selectedAllergies = List<String>.from(data['allergies'] ?? []);
          selectedDiseases = List<String>.from(data['diseases'] ?? []);
          selectedHealthGoals = List<String>.from(data['healthGoals'] ?? []);
          selectedDietaryPreferences =
              List<String>.from(data['dietaryPreferences'] ?? []);
          activityLevel = data['activityLevel'] ?? '';
          additionalInfo = data['additionalInfo'] ?? '';
          _additionalInfoController.text = additionalInfo;
          _isLoading = false;
        });
      }
    } catch (e) {
      _error = "Failed to load data: $e";
      setState(() => _isLoading = false);
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> formData = {
        'allergies': selectedAllergies,
        'diseases': selectedDiseases,
        'healthGoals': selectedHealthGoals,
        'activityLevel': activityLevel,
        'dietaryPreferences': selectedDietaryPreferences,
        'additionalInfo': _additionalInfoController.text,
        'formFilled': true,
      };

      FirebaseFirestore.instance
          .collection('user_health_data')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(formData, SetOptions(merge: true))
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.formSubmitSuccess)));
        setState(
            () => _isExpanded = false); // Collapse the tile after submitting
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.formSubmitFail)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Card(
      color: theme.widgetBackground,
      elevation: 0,
      child: ExpansionTile(
        title: Text(
          AppLocalizations.of(context)!.medicalInformationLabel,
          style: theme.typography.subtitle1,
        ),
        trailing: _isExpanded && !_isEditing
            ? IconButton(
                icon: Icon(Icons.edit, color: theme.primaryColor),
                onPressed: _toggleEditing)
            : null,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
            if (!expanded) _isEditing = false; // Reset editing when collapsed
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? CircularProgressIndicator()
                : _error.isNotEmpty
                    ? Text(_error)
                    : _isEditing
                        ? _buildEditableForm()
                        : _buildReadOnlyData(),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyData() {
    final theme = AppTheme.of(context); // Ensure you have this
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.allergiesLabel,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor),
            ),
          ),
          child: Wrap(
            spacing: 8.0,
            children: selectedAllergies
                .map((allergy) => Chip(
                      label: Text(
                        allergy,
                        style: theme.bodyText1.copyWith(
                          color: theme.primaryBtnText, // Set text color here
                        ),
                      ),
                      backgroundColor: theme.primaryColor,
                    ))
                .toList(),
          ),
        ),
        SizedBox(height: 16),
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.diseasesLabel,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor),
            ),
          ),
          child: Wrap(
            spacing: 8.0,
            children: selectedDiseases
                .map((disease) => Chip(
                      label: Text(
                        disease,
                        style: theme.bodyText1.copyWith(
                          color: theme.primaryBtnText, // Set text color here
                        ),
                      ),
                      backgroundColor: theme.primaryColor,
                    ))
                .toList(),
          ),
        ),
        SizedBox(height: 16),
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.healthGoalsLabel,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor),
            ),
          ),
          child: Wrap(
            spacing: 8.0,
            children: selectedHealthGoals
                .map((goal) => Chip(
                      label: Text(
                        goal,
                        style: theme.bodyText1.copyWith(
                          color: theme.primaryBtnText, // Set text color here
                        ),
                      ),
                      backgroundColor: theme.primaryColor,
                    ))
                .toList(),
          ),
        ),
        SizedBox(height: 16),
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.dietaryPreferencesLabel,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor),
            ),
          ),
          child: Wrap(
            spacing: 8.0,
            children: selectedDietaryPreferences
                .map((preference) => Chip(
                      label: Text(
                        preference,
                        style: theme.bodyText1.copyWith(
                          color: theme.primaryBtnText, // Set text color here
                        ),
                      ),
                      backgroundColor: theme.primaryColor,
                    ))
                .toList(),
          ),
        ),
        SizedBox(height: 16),
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.additionalInfo,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor),
            ),
          ),
          child: Text(
            _additionalInfoController.text.isNotEmpty
                ? _additionalInfoController.text
                : AppLocalizations.of(context)!.noAdditionalInformation,
            style: theme
                .bodyText1, // This needs to be outside of the child parameter
          ),
        ),
      ],
    );
  }

  Widget _buildEditableForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MultiSelectChipField(
            label: AppLocalizations.of(context)!.allergiesLabel,
            options: FieldOptions.allergyOptions(context),
            selectedOptions: selectedAllergies,
            onSelectionChanged: (newSelectedOptions) {
              setState(() {
                selectedAllergies = newSelectedOptions;
              });
            },
          ),
          SizedBox(height: 16),
          MultiSelectChipField(
            label: AppLocalizations.of(context)!.diseasesLabel,
            options: FieldOptions.diseaseOptions(context),
            selectedOptions: selectedDiseases,
            onSelectionChanged: (newSelectedOptions) {
              setState(() {
                selectedDiseases = newSelectedOptions;
              });
            },
          ),
          SizedBox(height: 16),
          MultiSelectChipField(
            label: AppLocalizations.of(context)!.healthGoalsLabel,
            options: FieldOptions.healthGoalOptions(context),
            selectedOptions: selectedHealthGoals,
            onSelectionChanged: (newSelectedOptions) {
              setState(() {
                selectedHealthGoals = newSelectedOptions;
              });
            },
          ),
          SizedBox(height: 16),
          MultiSelectChipField(
            label: AppLocalizations.of(context)!.dietaryPreferencesLabel,
            options: FieldOptions.dietaryPreferenceOptions(context),
            selectedOptions: selectedDietaryPreferences,
            onSelectionChanged: (newSelectedOptions) {
              setState(() {
                selectedDietaryPreferences = newSelectedOptions;
              });
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _additionalInfoController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.additionalInfo,
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppTheme.of(context).primaryColor),
              ),
            ),
            maxLines: 3,
            style: AppTheme.of(context).bodyText1,
          ),
          SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 3, left: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppTheme.of(context).lineColor),
            ),
            child: MaterialButton(
              minWidth: 200,
              height: 30,
              onPressed: _submitForm,
              color: AppTheme.of(context).primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                AppLocalizations.of(context)!.submitButtonLabel,
                style: AppTheme.of(context).bodyText1.copyWith(
                      color: AppTheme.of(context).primaryBtnText,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _additionalInfoController.dispose();
    super.dispose();
  }
}
