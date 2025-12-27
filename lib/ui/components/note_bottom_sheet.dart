import 'package:flutter/material.dart';
import 'package:mood_jar_app/ui/components/button.dart';

Future<String?> showNoteBottomSheet({
  required BuildContext context,
  String? initialNote,
  String title = "Add note",
  String hintText = "Write how you feel and why you feel that",
  int maxLength = 200,
}) {
  final controller = TextEditingController(text: initialNote);

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLength: maxLength,
              autofocus: true,
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Button(
              text: "Save",
              onPressed: () {
                Navigator.pop(
                  context,
                  controller.text.trim(),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}
