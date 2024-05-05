import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploader extends StatefulWidget {
  final Function(Map<String, String>) onFilesUploaded;

  const FileUploader({
    Key? key,
    required this.onFilesUploaded,
  }) : super(key: key);

  @override
  _FileUploaderState createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  bool _isLoading = false;
  List<PlatformFile> _selectedFiles = [];

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
        // You can process the files here if needed
        _isLoading = false;
      });
    } else {
      // User canceled the picker
      setState(() => _isLoading = false);
    }
  }

  void _removeFile(PlatformFile file) {
    setState(() => _selectedFiles.remove(file));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _isLoading ? null : _pickFiles,
          child: Text('Upload Files'),
        ),
        if (_isLoading)
          CircularProgressIndicator(),
        Expanded(
          child: ListView.builder(
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
          ),
        ),
      ],
    );
  }
}
