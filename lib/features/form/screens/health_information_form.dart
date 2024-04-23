import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:byte_app/features/form/model/health_form_field.dart';
import 'package:byte_app/features/form/model/form_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:byte_app/features/profile/screens/profile_page.dart';


class HealthInformationForm extends StatefulWidget {
  const HealthInformationForm({Key? key}) : super(key: key);

  @override
  HealthInformationFormState createState() => HealthInformationFormState();
}

class HealthInformationFormState extends State<HealthInformationForm> {
  final _formKey = GlobalKey<FormState>();
  int age = FieldInitialValues.initialAge;
  String gender = FieldInitialValues.initialGender;
  int height = FieldInitialValues.initialHeight;
  List<String> selectedAllergies = FieldInitialValues.initialAllergies;
  List<String> selectedDiseases = FieldInitialValues.initialDiseases;
  List<String> selectedHealthGoals = FieldInitialValues.initialHealthGoals;
  String activityLevel = FieldInitialValues.initialActivityLevel;
  List<String> selectedDietaryPreferences = FieldInitialValues.initialDietaryPreferences;
  List<String> selectedReligiousRestrictions = FieldInitialValues.initialReligiousRestrictions;
  List<String> selectedAppPurpose = FieldInitialValues.initialAppPurpose;
  String additionalInfo = FieldInitialValues.initialAdditionalInfo;
  // New state property to hold selected files
  bool _isLoading = false;
  List<PlatformFile> _selectedFiles = [];

  final TextEditingController ageController = TextEditingController(text: FieldInitialValues.initialAge.toString());
  final TextEditingController heightController = TextEditingController(text: FieldInitialValues.initialHeight.toString());
  final TextEditingController additionalInfoController = TextEditingController();
  final TextEditingController otherAllergiesController = TextEditingController();
  final TextEditingController otherDiseasesController = TextEditingController();
  void _checkAndNavigate() async {
    final doc = FirebaseFirestore.instance.collection('user_health_data').doc(FirebaseAuth.instance.currentUser!.uid);
    final docSnapshot = await doc.get();

    // Check if the 'formFilled' field exists and is true
    if (docSnapshot.exists && docSnapshot.data()?['formFilled'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(), // Or another page if the form is already filled
        ),
      );
    }
  }
  void _pickFiles() async {
    setState(() => _isLoading = true);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files);
        // Here, process the files if needed.
        _isLoading = false;
      });
    } else {
      // User canceled the picker
      setState(() => _isLoading = false);
    }
  }

  // Method to remove a selected file
  void _removeFile(PlatformFile file) {
    setState(() => _selectedFiles.remove(file));
  }

  // Method to build the list of selected files
  Widget _buildFileList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _selectedFiles.length,
      itemBuilder: (context, index) {
        final file = _selectedFiles[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(file.name),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: _isLoading ? null : () => _removeFile(file),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.healthInfoFormTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('About Us', style: Theme.of(context).textTheme.headline6),
              // Wrap "About Us" fields in a single Card
              Card(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MandatoryTextFormField(
                        label: AppLocalizations.of(context)!.ageLabel,
                        controller: ageController,
                        keyboardType: TextInputType.number,
                      ),
                      MandatoryDropdownFormField(
                        label: AppLocalizations.of(context)!.genderLabel,
                        value: gender,
                        optionsBuilder: FieldOptions.genderOptions,
                      ),
                      MandatoryTextFormField(
                        label: AppLocalizations.of(context)!.heightLabel,
                        controller: heightController,
                        keyboardType: TextInputType.number,
                      ),
                      MultiSelectChipField(
                        label: AppLocalizations.of(context)!.appPurposeLabel,
                        options: FieldOptions.appPurposeOptions(context),
                        selectedOptions: selectedAppPurpose,
                        onSelectionChanged: (newSelectedOptions) {
                          setState(() {
                            selectedAppPurpose = newSelectedOptions;
                          });
                        },
                      ),
                      MultiSelectChipField(
                        label: AppLocalizations.of(context)!.religiousDietaryLabel, // Make sure you add this in your localizations
                        options: FieldOptions.religiousDietaryRestrictions(context), // This should return the religious dietary options
                        selectedOptions: selectedReligiousRestrictions,
                        onSelectionChanged: (List<String> newSelectedOptions) {
                          setState(() {
                            selectedReligiousRestrictions = newSelectedOptions;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Medical Information', style: Theme.of(context).textTheme.headline6),
              // Wrap "Medical Information" fields in a single Card
              Card(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      OtherTextFormField(
                        label: AppLocalizations.of(context)!.allergiesLabel,
                        controller: otherAllergiesController,
                      ),
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
                      OtherTextFormField(
                        label: AppLocalizations.of(context)!.diseasesLabel,
                        controller: otherDiseasesController,
                      ),
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
                      TextFormField(
                        controller: additionalInfoController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.additionalInfo,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              // File picker section
              ElevatedButton(
                onPressed: _pickFiles,
                child: Text('Upload Files'),
              ),
              SizedBox(height: 10),
              _buildFileList(),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(AppLocalizations.of(context)!.submitButtonLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Combine the selected allergies with any additional ones entered by the user
      List<String> combinedAllergies = List.from(selectedAllergies);
      if (otherAllergiesController.text.trim().isNotEmpty) {
        combinedAllergies.add(otherAllergiesController.text.trim());
      }

      // Combine the selected diseases with any additional ones entered by the user
      List<String> combinedDiseases = List.from(selectedDiseases);
      if (otherDiseasesController.text.trim().isNotEmpty) {
        combinedDiseases.add(otherDiseasesController.text.trim());
      }

      final Map<String, dynamic> formData = {
        'age': int.parse(ageController.text),
        'gender': gender,
        'height': int.parse(heightController.text),
        'allergies': List.from(selectedAllergies)..addAll(otherAllergiesController.text.trim().split(',')),
        'diseases': List.from(selectedDiseases)..addAll(otherDiseasesController.text.trim().split(',')),
        'healthGoals': selectedHealthGoals,
        'activityLevel': activityLevel,
        'dietaryPreferences': selectedDietaryPreferences,
        'religiousDietaryRestrictions': selectedReligiousRestrictions, // Add this line
        'appPurpose': selectedAppPurpose,
        'additionalInfo': additionalInfoController.text,
        'formFilled': true,
      };

      FirebaseFirestore.instance
          .collection('user_health_data')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(formData, SetOptions(merge: true))
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.formSubmitSuccess))
        );
        // Navigate to the ProfilePage after successful submission
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );
      })
          .catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.formSubmitFail))
        );
      });
    }
  }
  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    additionalInfoController.dispose();
    super.dispose();
  }
}
