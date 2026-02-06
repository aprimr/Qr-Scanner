import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/provider/settings_provider.dart';
import 'package:qr_code/services/snackbar.dart';
import 'package:qr_code/widgets/buttons/primary_button.dart';
import 'package:qr_code/widgets/google_ads/banner_ad_widget.dart';
import 'package:qr_code/widgets/number_code_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class MyQrCode extends StatefulWidget {
  const MyQrCode({super.key});

  @override
  State<MyQrCode> createState() => _MyQrCodeState();
}

class _MyQrCodeState extends State<MyQrCode> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _qrCodeKey = GlobalKey();

  // VCard fields
  String selectedCountryCode = "";
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Submit form
  void submitForm(SettingsProvider settingsMethod) {
    if (_formKey.currentState!.validate()) {
      // Collect all inputs
      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();
      String phone = _phoneController.text.trim();
      String email = _emailController.text.trim();
      String company = _companyController.text.trim();
      String jobTitle = _jobTitleController.text.trim();
      String website = _websiteController.text.trim();
      String address = _addressController.text.trim();
      String notes = _notesController.text.trim();

      // Create VCard QR string
      List<String> vCardLines = [
        'BEGIN:VCARD',
        'VERSION:3.0',
        'N:$lastName;$firstName;;;',
        if (company.trim().isNotEmpty) 'ORG:$company',
        if (jobTitle.trim().isNotEmpty) 'TITLE:$jobTitle',
        if (phone.trim().isNotEmpty) 'TEL;TYPE=CELL:$phone',
        if (email.trim().isNotEmpty) 'EMAIL;TYPE=INTERNET:$email',
        if (address.trim().isNotEmpty) 'ADR;TYPE=HOME:;;$address',
        if (website.trim().isNotEmpty) 'URL:$website',
        if (notes.trim().isNotEmpty) 'NOTE:$notes',
        'END:VCARD',
      ];

      String qrData = vCardLines.join('\n');

      settingsMethod.setMyQrCode(qrData);
    }
  }

  //---- Functions ----

  Future<Uint8List> _qrWidgetToImage() async {
    // convert widget to image
    final boundary =
        _qrCodeKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  Future<void> _saveQrImage() async {
    // request permission
    await Gal.requestAccess();
    // Qr Widet to image
    Uint8List pngBytes = await _qrWidgetToImage();
    // save
    await Gal.putImageBytes(pngBytes, name: "my_qr_code");
    if (mounted) {
      showSnackbar(context, message: "Image saved to gallery");
    }
  }

  Future<void> _share() async {
    // Qr Widet to image
    Uint8List pngBytes = await _qrWidgetToImage();
    // save to temp file
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/qr_code.png').create();
    await file.writeAsBytes(pngBytes);

    // Share
    await SharePlus.instance.share(
      ShareParams(
        title: 'QR Code',
        text: 'Here is my QR Code',
        files: [XFile(file.path)],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsData = context.watch<SettingsProvider>();
    final settingsMethod = context.read<SettingsProvider>();

    // return qr code if qr code is not empty
    if (settingsData.myQrCode.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          title: Text(
            "My QR Code",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                settingsMethod.unsetMyQrCode();
              },
              icon: HugeIcon(
                size: 22,
                icon: HugeIcons.strokeRoundedCancelSquare,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
        body: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: RepaintBoundary(
                          key: _qrCodeKey,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: QrImageView(
                              data: settingsData.myQrCode,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                              eyeStyle: QrEyeStyle(
                                eyeShape: settingsData.isRoundedEyes
                                    ? QrEyeShape.circle
                                    : QrEyeShape.square,
                                color: Theme.of(
                                  context,
                                ).colorScheme.inverseSurface,
                              ),
                              dataModuleStyle: QrDataModuleStyle(
                                dataModuleShape: settingsData.isRoundedDots
                                    ? QrDataModuleShape.circle
                                    : QrDataModuleShape.square,
                                color: Theme.of(
                                  context,
                                ).colorScheme.inverseSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      ActionBar(saveImage: _saveQrImage, share: _share),
                    ],
                  ),
                ),
              ),
              BannerAdWidget(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          "My QR Code",
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      _buildTextField(
                        _firstNameController,
                        "First Name",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'First Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _lastNameController,
                        "Last Name",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Last Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      NumberCodePicker(
                        onCodeChanged: (code) {
                          setState(() {
                            selectedCountryCode = code;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(_phoneController, "Phone"),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _emailController,
                        "Email",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email cannot be empty';
                          }
                          final emailPattern = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailPattern.hasMatch(value.trim())) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(_companyController, "Company"),
                      const SizedBox(height: 16),
                      _buildTextField(_jobTitleController, "Job Title"),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _websiteController,
                        "Website/URL",
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final urlPattern = RegExp(
                              r'^(https?:\/\/)?'
                              r'([\w\d\-]+\.)+[\w\d]{2,}'
                              r'(\/[\w\d\-._~:/?#[\]@!$&\*+,;=]*)?$',
                              caseSensitive: false,
                            );
                            if (!urlPattern.hasMatch(value.trim())) {
                              return 'Enter a valid URL';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _addressController,
                        "Address",
                        minLines: 3,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _notesController,
                        "Notes",
                        minLines: 3,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 28),
                      PrimaryButton(
                        label: "Create QR Code",
                        onSubmit: () {
                          submitForm(settingsMethod);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            BannerAdWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int minLines = 1,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      cursorColor: theme.colorScheme.primary,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: theme.colorScheme.outline),
        errorStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: theme.colorScheme.error,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.3),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        alignLabelWithHint: true,
      ),
    );
  }
}

class ActionBar extends StatelessWidget {
  final Future<void> Function() saveImage;
  final Future<void> Function() share;
  const ActionBar({super.key, required this.saveImage, required this.share});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            saveImage();
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  size: 30,
                  icon: HugeIcons.strokeRoundedDownloadSquare01,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.outline,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            share();
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  size: 30,
                  icon: HugeIcons.strokeRoundedShare01,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Share",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.outline,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
