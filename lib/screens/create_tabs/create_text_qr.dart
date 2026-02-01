import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code/utils/routes.dart';
import 'package:qr_code/widgets/buttons/primary_button.dart';

class CreateTextQr extends StatefulWidget {
  const CreateTextQr({super.key});

  @override
  State<CreateTextQr> createState() => _CreateTextQrState();
}

class _CreateTextQrState extends State<CreateTextQr> {
  final _formKey = GlobalKey<FormState>();

  // controllers for form input
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Submit form
  void submitForm() {
    if (_formKey.currentState!.validate()) {
      String text = _textController.text;
      // Navigate to Create Result Screen
      Navigator.pushNamed(
        context,
        AppRoutes.createResultRoute,
        arguments: text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _textController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (value.toString().length >= 1000) {
                          return "Maximum 1k characters allowed";
                        }
                        return null;
                      },
                      minLines: 7,
                      maxLines: 7,
                      cursorColor: Theme.of(context).colorScheme.inverseSurface,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        label: Text(
                          " Enter some text ",
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.error,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.3,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.3,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 28),
                    PrimaryButton(onSubmit: submitForm, label: "Create QR"),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(flex: 1, child: Container(color: Colors.red)),
      ],
    );
  }
}
