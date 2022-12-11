import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// It hides the current snackbar, if any, and shows a new snackbar with the given text
///
/// Args:
///   context (BuildContext): The context of the widget that you want to show the snackbar on.
///   text (String): The text to display in the snackbar.
void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  return image;
}
