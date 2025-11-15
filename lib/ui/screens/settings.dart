import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  FilePickerResult? result;

  void pickFile() async {
    FilePickerResult? res = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: true);
    if (res != null) {
      setState(() {
        result = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        spacing: 8,
        children: [
          ElevatedButton(onPressed: pickFile, child: Text("Pick a File")),
          if (result != null) ...result!.paths.map((e) => Text(e!)),
        ],
      ),
    );
  }
}
