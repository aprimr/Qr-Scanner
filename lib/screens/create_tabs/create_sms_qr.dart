import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code/utils/routes.dart';
import 'package:qr_code/widgets/buttons/primary_button.dart';
import 'package:qr_code/widgets/google_ads/banner_ad_widget.dart';
import 'package:qr_code/widgets/number_code_picker.dart';

class CreateSmsQr extends StatefulWidget {
  const CreateSmsQr({super.key});

  @override
  State<CreateSmsQr> createState() => _CreateSmsQrState();
}

class _CreateSmsQrState extends State<CreateSmsQr> {
  final _formKey = GlobalKey<FormState>();

  // controllers for form input
  String selectedCountryCode = "+977";
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Submit form
  void submitForm() {
    if (_formKey.currentState!.validate()) {
      String code = selectedCountryCode;
      String phone = _phoneController.text;
      String message = _messageController.text;

      // Create QR CodeData
      String qrData = "SMSTO:$code$phone:$message";

      // Navigate to Create Result Screen
      Navigator.pushNamed(
        context,
        AppRoutes.createResultRoute,
        arguments: qrData,
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
                    NumberCodePicker(
                      onCodeChanged: (code) {
                        setState(() {
                          selectedCountryCode = code;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        if (value.toString().length >= 500) {
                          return "Maximum 500 characters allowed";
                        }
                        return null;
                      },
                      cursorColor: Theme.of(context).colorScheme.inverseSurface,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        label: Text(
                          " Enter phone number ",
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
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _messageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter message';
                        }
                        if (value.toString().length >= 3000) {
                          return "Maximum 3k characters allowed";
                        }
                        return null;
                      },
                      minLines: 7,
                      maxLines: 7,
                      cursorColor: Theme.of(context).colorScheme.inverseSurface,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        label: Text(
                          " Enter message ",
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
                    PrimaryButton(
                      onSubmit: submitForm,
                      label: "Create QR Code",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        BannerAdWidget(),
      ],
    );
  }
}
