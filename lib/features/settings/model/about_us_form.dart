import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/features/form/model/form_widgets.dart';
import 'package:byte_app/features/form/model/health_form_field.dart';

class AboutUsForm extends StatefulWidget {
  @override
  _AboutUsFormState createState() => _AboutUsFormState();
}

class _AboutUsFormState extends State<AboutUsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isExpanded = false;
  bool _isEditing = false;
  TextEditingController _ageController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  String _gender = 'Male';
  List<String> _genders = ['Male', 'Female', 'Other'];
  List<String> selectedAppPurpose = [];
  List<String> selectedReligiousRestrictions = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
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
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        _ageController.text = data['age'].toString();
        _gender = data['gender'] ?? 'Male';
        _heightController.text = data['height'].toString();
        // Initialize the selectedAppPurpose with data from Firestore if it exists
        selectedAppPurpose = List<String>.from(data['appPurpose'] ?? []);
        selectedReligiousRestrictions = List<String>.from(data['religiousDietaryRestrictions'] ?? []);
      }
    } catch (e) {
      _error = "Failed to load data: $e";
    } finally {
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
        'age': int.parse(_ageController.text),
        'gender': _gender,
        'height': int.parse(_heightController.text),
        'formFilled': true,
        'appPurpose': selectedAppPurpose,
      };

      FirebaseFirestore.instance
          .collection('user_health_data')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(formData, SetOptions(merge: true))
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.formSubmitSuccess))
        );
        setState(() => _isExpanded = false);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.formSubmitFail))
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(AppLocalizations.of(context)!.aboutUs),
        trailing: _isExpanded && !_isEditing
            ? IconButton(icon: Icon(Icons.edit), onPressed: _toggleEditing)
            : null,
        onExpansionChanged: (expanded) => setState(() {
          _isExpanded = expanded;
          if (!expanded) _isEditing = false;
        }),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Age display
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.ageLabel,
            border: OutlineInputBorder(),
          ),
          child: Text(_ageController.text),
        ),
        SizedBox(height: 16),

        // Gender display
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.genderLabel,
            border: OutlineInputBorder(),
          ),
          child: Text(_gender),
        ),
        SizedBox(height: 16),

        // Height display
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.heightLabel,
            border: OutlineInputBorder(),
          ),
          child: Text(_heightController.text),
        ),
        SizedBox(height: 16),

        // App Purpose display
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.appPurposeLabel,
            border: OutlineInputBorder(),
          ),
          child: Wrap(
            spacing: 8.0,
            children: selectedAppPurpose.map((purpose) => Chip(
              label: Text(purpose),
              backgroundColor: Colors.grey.shade200,
            )).toList(),
          ),
        ),
        SizedBox(height: 16),  // Increased spacing before Religious Dietary Restrictions

        // Religious Dietary Restrictions display
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.religiousDietaryRestrictionsLabel,
            border: OutlineInputBorder(),
          ),
          child: Wrap(
            spacing: 8.0,
            children: selectedReligiousRestrictions.map((restriction) => Chip(
              label: Text(restriction),
              backgroundColor: Colors.grey.shade200,
            )).toList(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEditableForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.ageLabel),
            keyboardType: TextInputType.number,
          ),
          DropdownButtonFormField(
            value: _gender,
            items: _genders.map((String gender) {
              return DropdownMenuItem(value: gender, child: Text(gender));
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) setState(() => _gender = newValue);
            },
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.genderLabel),
          ),
          TextFormField(
            controller: _heightController,
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.heightLabel),
            keyboardType: TextInputType.number,
          ),
          // Add a MultiSelectChipField for selecting app purposes
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
            label: AppLocalizations.of(context)!.religiousDietaryRestrictionsLabel,
            options: FieldOptions.religiousDietaryRestrictions(context), // Ensure this method is implemented
            selectedOptions: selectedReligiousRestrictions,
            onSelectionChanged: (newSelectedOptions) {
              setState(() {
                selectedReligiousRestrictions = newSelectedOptions;
              });
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(AppLocalizations.of(context)!.submitButtonLabel),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}
