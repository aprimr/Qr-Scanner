import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code/utils/routes.dart';
import 'package:qr_code/widgets/buttons/primary_button.dart';

class CreateWifiQr extends StatefulWidget {
  const CreateWifiQr({super.key});

  @override
  State<CreateWifiQr> createState() => _CreateUrlQrState();
}

class _CreateUrlQrState extends State<CreateWifiQr> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _encryption = ['WPA', 'WPA/WAP2'];
  // controllers for form input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedEncryption;
  bool isHidden = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Submit form
  void submitForm() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String password = _passwordController.text;

      // create QrData and pass in result
      String qrData =
          "WIFI:T:$_selectedEncryption;S:$name;P:$password;H:${isHidden ? "true" : "false"};;";
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
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter network name';
                        }
                        if (value.toString().length >= 1000) {
                          return "Maximum 1k characters allowed";
                        }
                        return null;
                      },
                      cursorColor: Theme.of(context).colorScheme.inverseSurface,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        label: Text(
                          " Enter SSID Name ",
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1.3,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _selectedEncryption,
                          hint: Text(
                            "Select encryption",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                          items: _encryption.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              _selectedEncryption = newVal!;
                            });
                          },
                          isExpanded: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.toString().length >= 1000) {
                          return "Maximum 1k characters allowed";
                        }
                        return null;
                      },
                      cursorColor: Theme.of(context).colorScheme.inverseSurface,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        label: Text(
                          " Enter Password ",
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
                    SizedBox(height: 10),
                    CheckboxListTile(
                      value: isHidden,
                      onChanged: (value) {
                        setState(() {
                          isHidden = !isHidden;
                        });
                      },
                      title: Text(
                        "Hidden Network",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.outline,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 2,
                      ),
                      checkboxScaleFactor: 1.15,
                      dense: true,
                      activeColor: Theme.of(context).colorScheme.primary,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
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
