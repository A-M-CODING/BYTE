import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart'; // Ensure this is added if not already
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:byte_app/app_theme.dart';

class DocumentsPanel extends StatefulWidget {
  @override
  _DocumentsPanelState createState() => _DocumentsPanelState();
}

class _DocumentsPanelState extends State<DocumentsPanel> {
  List<String> fileNames = [];
  bool _isLoading = false;
  List<PlatformFile> _selectedFiles = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchFileNames();
  }

  Future<void> _fetchFileNames() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var docSnapshot = await FirebaseFirestore.instance
        .collection('user_health_data')
        .doc(userId)
        .get();

    if (docSnapshot.exists && docSnapshot.data()!.containsKey('fileNames')) {
      setState(() {
        fileNames = List.from(docSnapshot.data()!['fileNames']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Card(
        color: AppTheme.of(context).widgetBackground,
        elevation: 0,
        child: ExpansionTile(
          title: Text(
            AppLocalizations.of(context)!.documentsLabel,
            style: AppTheme.of(context).subtitle1,
          ),
          initiallyExpanded: false,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: fileNames.isEmpty
                  ? Center(
                      child: Text(
                          AppLocalizations.of(context)!.noDocumentsMessage),
                    )
                  : InputDecorator(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.documentsLabel,
                        border: OutlineInputBorder(),
                      ),
                      child: Wrap(
                        spacing: 8.0,
                        children: fileNames
                            .map((fileName) => Chip(
                                  label: Text(fileName),
                                  backgroundColor: Colors.grey.shade200,
                                ))
                            .toList(),
                      ),
                    ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 3, left: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: MaterialButton(
                minWidth: 200,
                height: 30,
                onPressed: _pickFiles,
                color: AppTheme.of(context).primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  AppLocalizations.of(context)!.uploadButtonLabel,
                  style: AppTheme.of(context).bodyText1.copyWith(
                        color: AppTheme.of(context).primaryBtnText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildFileList(),
            Container(
              padding: const EdgeInsets.only(top: 3, left: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
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
      ),
    );
  }

  void _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files);
      });
    }
  }

  Widget _buildFileList() {
    final theme =
        AppTheme.of(context); // Ensure to get the theme to access primaryColor

    return ListView.builder(
      shrinkWrap: true,
      physics:
          NeverScrollableScrollPhysics(), // Disables scrolling within the ListView
      itemCount: _selectedFiles.length,
      itemBuilder: (context, index) {
        final file = _selectedFiles[index];
        return Card(
          elevation: 0,
          margin: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                8), // Adjust the border radius as necessary
            side: BorderSide(
                color: theme.primaryColor,
                width: 1.5), // Border with primaryColor
          ),
          child: ListTile(
            title: Text(file.name),
          ),
        );
      },
    );
  }

  void _submitForm() async {
    _isLoading = true;
    setState(() {});

    try {
      if (FirebaseAuth.instance.currentUser == null) {
        throw Exception("User is not logged in.");
      }
      await FirebaseAuth.instance.currentUser!.reload();

      List<String> fileUrls = await _uploadFiles();
      List<String> newFileNames =
          _selectedFiles.map((file) => file.name).toList();

      var docRef = FirebaseFirestore.instance
          .collection('user_health_data')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      var doc = await docRef.get();
      List<String> existingFileNames =
          List.from(doc.data()?['fileNames'] ?? []);

      List<String> updatedFileNames = List.from(existingFileNames)
        ..addAll(newFileNames);

      final Map<String, dynamic> formData = {
        'files': fileUrls,
        'fileNames': updatedFileNames,
      };

      await docRef.set(formData, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Files uploaded successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      _isLoading = false;
      setState(() {});
    }
  }

  Future<List<String>> _uploadFiles() async {
    List<String> fileUrls = [];
    for (var file in _selectedFiles) {
      String fileUrl = await _uploadFile(file);
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
          await fileRef.putFile(
              uploadFile, SettableMetadata(contentType: 'application/pdf'));
        } else {
          throw Exception("File path is not available for upload.");
        }
      }

      return await fileRef.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception(
          "Upload failed for file: ${file.name} - Error: ${e.message}");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
