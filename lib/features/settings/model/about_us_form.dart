import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/features/form/model/form_widgets.dart';
import 'package:byte_app/features/form/model/health_form_field.dart';
import 'package:byte_app/app_theme.dart';

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
        selectedAppPurpose = List<String>.from(data['appPurpose'] ?? []);
        selectedReligiousRestrictions =
        List<String>.from(data['religiousDietaryRestrictions'] ?? []);
      }
    } catch (e) {
      _error = AppLocalizations.of(context)!.fetchDataError(e.toString());
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
            SnackBar(
                content: Text(AppLocalizations.of(context)!.formSubmitSuccess))
        );
        setState(() => _isExpanded = false);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)!.formSubmitFail))
        );
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
          AppLocalizations.of(context)!.aboutUs,
          style: theme.typography.subtitle1,
        ),
        trailing: _isExpanded && !_isEditing
            ? IconButton(icon: Icon(Icons.edit,color: theme.primaryColor), onPressed: _toggleEditing)
            : null,
        onExpansionChanged: (expanded) =>
            setState(() {
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
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.ageLabel,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme
                  .of(context)
                  .primaryColor),
            ),
          ),
          child: Text(
            _ageController.text,
            style: AppTheme
                .of(context)
                .bodyText1,
          ),
        ),
        SizedBox(height: 16),
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.genderLabel,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme
                  .of(context)
                  .primaryColor),
            ),
          ),
          child: Row(
            children: [
              Text(
                _gender,
                style: AppTheme
                    .of(context)
                    .bodyText1,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.heightLabel,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme
                  .of(context)
                  .primaryColor),
            ),
          ),
          child: Text(
            _heightController.text,
            style: AppTheme
                .of(context)
                .bodyText1,
          ),
        ),
        SizedBox(height: 16),
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.appPurposeLabel,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme
                  .of(context)
                  .primaryColor),
            ),
          ),
          child: Wrap(
            spacing: 8.0,
            children: selectedAppPurpose.map((purpose) =>
                Chip(
                  label: Text(
                    purpose,
                    style: AppTheme
                        .of(context)
                        .bodyText1
                        .copyWith(
                      color: AppTheme
                          .of(context)
                          .primaryBtnText,
                    ),
                  ),
                  backgroundColor: AppTheme
                      .of(context)
                      .primaryColor,
                )).toList(),
          ),
        ),
        SizedBox(height: 16),
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!
                .religiousDietaryRestrictionsLabel,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme
                  .of(context)
                  .primaryColor),
            ),
          ),
          child: Wrap(
            spacing: 8.0,
            children: selectedReligiousRestrictions.map((restriction) =>
                Chip(
                  label: Text(
                    restriction,
                    style: AppTheme
                        .of(context)
                        .bodyText1
                        .copyWith(
                      color: AppTheme
                          .of(context)
                          .primaryBtnText,
                    ),
                  ),
                  backgroundColor: AppTheme
                      .of(context)
                      .primaryColor,
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
        mainAxisAlignment: MainAxisAlignment.start, // Add this line
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.ageLabel,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.of(context).primaryColor),
              ),
            ),
            keyboardType: TextInputType.number,
            style: AppTheme.of(context).bodyText1,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField(
            value: _gender,
            items: <String>['Male', 'Female', 'Other'].map((String gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(
                  gender == 'Male' ? AppLocalizations.of(context)!.male :
                  gender == 'Female' ? AppLocalizations.of(context)!.female :
                  AppLocalizations.of(context)!.other,
                  style: AppTheme.of(context).bodyText1,
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) setState(() => _gender = newValue);
            },
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.genderLabel,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.of(context).primaryColor),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _heightController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.heightLabel,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.of(context).primaryColor),
              ),
            ),
            keyboardType: TextInputType.number,
            style: AppTheme.of(context).bodyText1,
          ),
          SizedBox(height: 16),
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
          SizedBox(height: 16),
          MultiSelectChipField(
            label: AppLocalizations.of(context)!.religiousDietaryRestrictionsLabel,
            options: FieldOptions.religiousDietaryRestrictions(context),
            selectedOptions: selectedReligiousRestrictions,
            onSelectionChanged: (newSelectedOptions) {
              setState(() {
                selectedReligiousRestrictions = newSelectedOptions;
              });
            },
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
    _ageController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}