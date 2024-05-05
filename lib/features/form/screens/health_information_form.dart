import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:byte_app/features/form/model/health_form_field.dart';
import 'package:byte_app/features/form/model/form_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:byte_app/features/community/screens/homedecider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:byte_app/app_theme.dart';


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
  List<String> selectedDietaryPreferences =
      FieldInitialValues.initialDietaryPreferences;
  List<String> selectedReligiousRestrictions =
      FieldInitialValues.initialReligiousRestrictions;
  List<String> selectedAppPurpose = FieldInitialValues.initialAppPurpose;
  String additionalInfo = FieldInitialValues.initialAdditionalInfo;
  // New state property to hold selected files
  bool _isLoading = false;
  List<PlatformFile> _selectedFiles = [];

  final TextEditingController ageController =
      TextEditingController(text: FieldInitialValues.initialAge.toString());
  final TextEditingController heightController =
      TextEditingController(text: FieldInitialValues.initialHeight.toString());
  final TextEditingController additionalInfoController =
      TextEditingController();
  final TextEditingController otherAllergiesController =
      TextEditingController();
  final TextEditingController otherDiseasesController = TextEditingController();
  void _checkAndNavigate() async {
    final doc = FirebaseFirestore.instance
        .collection('user_health_data')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final docSnapshot = await doc.get();

    // Check if the 'formFilled' field exists and is true
    if (docSnapshot.exists && docSnapshot.data()?['formFilled'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeDecider(), // Or another page if the form is already filled
        ),
      );
    }
  }

  Future<void> callCloudRunFunction(
      String userId, List<String> fileNames) async {
    const String cloudRunUrl =
        'https://file-insights-ascvqhdi6q-uc.a.run.app/process-pdf'; // Replace with your actual Cloud Run URL

    for (String fileName in fileNames) {
      try {
        final response = await http.post(
          Uri.parse(cloudRunUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'tenant_name': userId, 'file_name': fileName}),
        );

        if (response.statusCode == 200) {
          print('Cloud Run function called successfully for file: $fileName');
        } else {
          print('Failed to call Cloud Run function: ${response.body}');
        }
      } catch (e) {
        print('Error calling Cloud Run function: $e');
      }
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
    final theme = AppTheme.of(context); // Ensure to get the theme to access primaryColor

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // Disables scrolling within the ListView
      itemCount: _selectedFiles.length,
      itemBuilder: (context, index) {
        final file = _selectedFiles[index];
        return Card(
          elevation: 0,
          margin: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Adjust the border radius as necessary
            side: BorderSide(color: theme.primaryColor, width: 1.5), // Border with primaryColor
          ),
          child: ListTile(
            title: Text(file.name),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: theme.primaryColor),
              onPressed: _isLoading ? null : () => _removeFile(file),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.healthInfoForm,
          style: AppTheme.of(context).typography.title1,
        ),
        backgroundColor: theme.primaryBackground, // Setting app bar background from theme
        foregroundColor: theme.primaryText, // Setting app bar text color from theme
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.aboutUs,
                style: AppTheme.of(context).typography.subtitle1,
              ),
              // "About Us" fields in a single Card with theme styles
              Card(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: theme.widgetBackground, // Using the 'widgetBackground' for card color from theme
                elevation: 0, // Set elevation to zero
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
                      // Assuming you have a constructor that accepts the theme or you set it globally
                      MandatoryDropdownFormField(
                        label: AppLocalizations.of(context)!.genderLabel,
                        value: gender,
                        optionsBuilder: FieldOptions.genderOptions,
                        onValueChange: (String newValue) {
                          setState(() {
                            gender = newValue;
                          });
                        },
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
                        label: AppLocalizations.of(context)!.religiousDietaryLabel,
                        options: FieldOptions.religiousDietaryRestrictions(context),
                        selectedOptions: selectedReligiousRestrictions,
                        onSelectionChanged: (newSelectedOptions) {
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
              Text(
                AppLocalizations.of(context)!.medicalInformation,
                style: AppTheme.of(context).typography.subtitle1,
              ),
              // Wrap "Medical Information" fields in a single Card
              Card(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: theme.widgetBackground, // Use the 'widgetBackground' for card color from theme
                elevation: 0, // Set elevation to zero
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
                        label: AppLocalizations.of(context)!
                            .dietaryPreferencesLabel,
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
                          labelText:
                              AppLocalizations.of(context)!.additionalInfo,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              // File picker section
              FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: theme.lineColor),  // Use lineColor from AppTheme
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: _pickFiles,
                      color: theme.primaryColor,  // Use primaryColor from AppTheme
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Upload Files',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: theme.primaryBtnText,  // Use primaryBtnText for text color from AppTheme
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: _buildFileList(),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: theme.lineColor),  // Use lineColor from AppTheme
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: _submitForm,
                      color: theme.tertiary400,  // Use a different color for contrast, assuming tertiary400 is defined
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.submitButtonLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: theme.primaryBtnText,  // Ensure text is legible against the button background
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _isLoading = true;
      setState(() {});

      try {
        if (FirebaseAuth.instance.currentUser == null) {
          throw Exception("User is not logged in.");
        }
        await FirebaseAuth.instance.currentUser!.reload();
        List<String> combinedAllergies = List.from(selectedAllergies);
        if (otherAllergiesController.text.trim().isNotEmpty) {
          combinedAllergies.add(otherAllergiesController.text.trim());
        }

        List<String> combinedDiseases = List.from(selectedDiseases);
        if (otherDiseasesController.text.trim().isNotEmpty) {
          combinedDiseases.add(otherDiseasesController.text.trim());
        }

        // Attempt to upload files first
        List<String> fileUrls = await _uploadFiles();
        List<String> fileNames =
            _selectedFiles.map((file) => file.name).toList();

        // Create formData map including fileUrls
        final Map<String, dynamic> formData = {
          'age': int.parse(ageController.text),
          'gender': gender,
          'height': int.parse(heightController.text),
          'allergies': combinedAllergies,
          'diseases': combinedDiseases,
          'healthGoals': selectedHealthGoals,
          'activityLevel': activityLevel,
          'dietaryPreferences': selectedDietaryPreferences,
          'religiousDietaryRestrictions': selectedReligiousRestrictions,
          'appPurpose': selectedAppPurpose,
          'additionalInfo': additionalInfoController.text,
          'fileNames': fileNames, // Include file names in the form data
          'formFilled': true,
        };

        // Save data to Firestore
        await FirebaseFirestore.instance
            .collection('user_health_data')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(formData, SetOptions(merge: true));

        // Save data to Shared Preferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('age', int.parse(ageController.text));
        await prefs.setString('gender', gender);
        await prefs.setInt('height', int.parse(heightController.text));
        await prefs.setStringList('allergies', combinedAllergies);
        await prefs.setStringList('diseases', combinedDiseases);
        await prefs.setStringList('healthGoals', selectedHealthGoals);
        await prefs.setString('activityLevel', activityLevel);
        await prefs.setStringList(
            'dietaryPreferences', selectedDietaryPreferences);
        await prefs.setStringList(
            'religiousDietaryRestrictions', selectedReligiousRestrictions);
        await prefs.setStringList('appPurpose', selectedAppPurpose);
        await prefs.setString('additionalInfo', additionalInfoController.text);
        await prefs.setBool('formFilled', true);

        await callCloudRunFunction(
            FirebaseAuth.instance.currentUser!.uid, fileNames);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.formSubmitSuccess)));

        // Navigate to HomeDecider
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeDecider(),
          ),
        );
      } on FirebaseException catch (e) {
        // Specific error handling for Firebase Storage
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Firebase Storage Error: ${e.message}")));
      } catch (e) {
        // General error handling
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      } finally {
        _isLoading = false;
        setState(() {});
      }
    }
  }

  Future<List<String>> _uploadFiles() async {
    List<String> fileUrls = [];
    for (var file in _selectedFiles) {
      String fileUrl =
          await _uploadFile(file); // Upload each file and get the URL
      fileUrls.add(fileUrl);
    }
    return fileUrls;
  }

  Future<String> _uploadFile(PlatformFile file) async {
    try {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      var fileRef =
          FirebaseStorage.instance.ref('documents/$userId/${file.name}');

      if (kIsWeb) {
        if (file.bytes != null) {
          await fileRef.putData(
              file.bytes!, SettableMetadata(contentType: 'application/pdf'));
        } else {
          throw Exception("File data is not available for upload.");
        }
      } else {
        if (file.path != null) {
          File uploadFile = File(file.path!);
          await fileRef.putFile(uploadFile);
        } else {
          throw Exception("File path is not available for upload.");
        }
      }

      return await fileRef.getDownloadURL();
    } on FirebaseException catch (e) {
      // Handle FiRrebase-specific error for individual file upload
      print("Error uploading file: ${e.code} - ${e.message}");
      throw Exception("Upload failed for file: ${file.name}");
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
