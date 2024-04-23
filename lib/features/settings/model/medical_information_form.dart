import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/features/form/model/form_widgets.dart';
import 'package:byte_app/features/form/model/health_form_field.dart';

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
  late TextEditingController additionalInfoController;
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    additionalInfoController = TextEditingController();
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
          selectedDietaryPreferences = List<String>.from(data['dietaryPreferences'] ?? []);
          activityLevel = data['activityLevel'] ?? '';
          additionalInfo = data['additionalInfo'] ?? '';
          additionalInfoController.text = additionalInfo;
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
        'additionalInfo': additionalInfoController.text,
        'formFilled': true,
      };

      FirebaseFirestore.instance
          .collection('user_health_data')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(formData, SetOptions(merge: true))
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.formSubmitSuccess)));
        setState(() => _isExpanded = false); // Collapse the tile after submitting
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.formSubmitFail)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(AppLocalizations.of(context)!.medicalInformationLabel),
        trailing: _isExpanded && !_isEditing
            ? IconButton(icon: Icon(Icons.edit), onPressed: _toggleEditing)
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
            child: _isLoading ? CircularProgressIndicator() :
            _error.isNotEmpty ? Text(_error) :
            _isEditing ? _buildEditableForm() : _buildReadOnlyData(),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyData() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Displaying allergies
          InputDecorator(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.allergiesLabel,
              border: OutlineInputBorder(),
            ),
            child: Wrap(
              spacing: 8.0,
              children: selectedAllergies.map((allergy) => Chip(
                label: Text(allergy),
                backgroundColor: Colors.grey.shade300,
              )).toList(),
            ),
          ),
          SizedBox(height: 16),

          // Displaying diseases
          InputDecorator(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.diseasesLabel,
              border: OutlineInputBorder(),
            ),
            child: Wrap(
              spacing: 8.0,
              children: selectedDiseases.map((disease) => Chip(
                label: Text(disease),
                backgroundColor: Colors.grey.shade300,
              )).toList(),
            ),
          ),
          SizedBox(height: 16),

          // Displaying health goals
          InputDecorator(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.healthGoalsLabel,
              border: OutlineInputBorder(),
            ),
            child: Wrap(
              spacing: 8.0,
              children: selectedHealthGoals.map((goal) => Chip(
                label: Text(goal),
                backgroundColor: Colors.grey.shade300,
              )).toList(),
            ),
          ),
          SizedBox(height: 16),

          // Displaying dietary preferences
          InputDecorator(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.dietaryPreferencesLabel,
              border: OutlineInputBorder(),
            ),
            child: Wrap(
              spacing: 8.0,
              children: selectedDietaryPreferences.map((preference) => Chip(
                label: Text(preference),
                backgroundColor: Colors.grey.shade300,
              )).toList(),
            ),
          ),
          SizedBox(height: 16),

          // Displaying additional info in a read-only text field
          InputDecorator(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.additionalInfo,
              border: OutlineInputBorder(),
            ),
            child: Text(additionalInfo.isNotEmpty ? additionalInfo : "No additional information provided"),
          ),

        ],
      ),
    );
  }
  Widget _buildEditableForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView( // Ensure the form is scrollable on smaller devices
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MultiSelectChipField(
              label: AppLocalizations.of(context)!.allergiesLabel,
              options: FieldOptions.allergyOptions(context), // Placeholder for actual options
              selectedOptions: selectedAllergies,
              onSelectionChanged: (newSelectedOptions) {
                setState(() {
                  selectedAllergies = newSelectedOptions;
                });
              },
            ),
            OtherTextFormField(
              label: AppLocalizations.of(context)!.allergiesLabel,
              controller: TextEditingController(), // You might need to define this controller
            ),
            MultiSelectChipField(
              label: AppLocalizations.of(context)!.diseasesLabel,
              options: FieldOptions.diseaseOptions(context), // Placeholder for actual options
              selectedOptions: selectedDiseases,
              onSelectionChanged: (newSelectedOptions) {
                setState(() {
                  selectedDiseases = newSelectedOptions;
                });
              },
            ),
            OtherTextFormField(
              label: AppLocalizations.of(context)!.diseasesLabel,
              controller: TextEditingController(), // Define this controller as needed
            ),
            MultiSelectChipField(
              label: AppLocalizations.of(context)!.healthGoalsLabel,
              options: FieldOptions.healthGoalOptions(context), // Placeholder for actual options
              selectedOptions: selectedHealthGoals,
              onSelectionChanged: (newSelectedOptions) {
                setState(() {
                  selectedHealthGoals = newSelectedOptions;
                });
              },
            ),
            MultiSelectChipField(
              label: AppLocalizations.of(context)!.dietaryPreferencesLabel,
              options: FieldOptions.dietaryPreferenceOptions(context), // Placeholder for actual options
              selectedOptions: selectedDietaryPreferences,
              onSelectionChanged: (newSelectedOptions) {
                setState(() {
                  selectedDietaryPreferences = newSelectedOptions;
                });
              },
            ),
            TextFormField(
              controller: additionalInfoController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.additionalInfo,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(AppLocalizations.of(context)!.submitButtonLabel),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    additionalInfoController.dispose();
    super.dispose();
  }
}
