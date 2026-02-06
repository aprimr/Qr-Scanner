import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class FAQData {
  static List<FAQItem> getFAQItems() {
    return [
      FAQItem(
        question: "What types of codes can ScanIt scan?",
        answer:
            "ScanIt supports all standard QR codes including URLs, text, WiFi, contacts (vCard), email, phone numbers, and more.",
      ),
      FAQItem(
        question: "Can I generate my own QR codes?",
        answer:
            "Yes. You can create QR codes for text, URLs, WiFi, contacts, and more. Generated codes can be saved and shared easily.",
      ),
      FAQItem(
        question: "Does the app work offline?",
        answer:
            "Yes. All scanning and QR generation features work completely offline. Internet is only required for displaying ads.",
      ),
      FAQItem(
        question: "Does ScanIt save scan history?",
        answer:
            "Scan history is saved locally on your device by default. You can disable history saving anytime in the settings for complete privacy.",
      ),
      FAQItem(
        question: "Is my data safe?",
        answer:
            "Yes. ScanIt does not collect or upload personal data. Everything stays on your device.",
      ),
      FAQItem(
        question: "Can I scan QR codes from my gallery?",
        answer:
            "Yes. You can import an image from your gallery and ScanIt will detect QR codes inside it.",
      ),
      FAQItem(
        question: "Can I connect to WiFi using a QR code?",
        answer:
            "Yes. When scanning a WiFi QR code, ScanIt opens the system WiFi connection screen for quick setup.",
      ),
      FAQItem(
        question: "Does the scanner work in low light?",
        answer:
            "Yes. You can enable the flashlight manually for better scanning in dark environments.",
      ),
      FAQItem(
        question: "Can I control vibration and sound feedback?",
        answer:
            "Yes. Vibration and beep feedback can be turned on or off from the settings.",
      ),
      FAQItem(
        question: "Does ScanIt show ads?",
        answer:
            "Yes. ScanIt uses Google AdMob ads to support development while keeping the app free to use.",
      ),
      FAQItem(
        question: "What makes ScanIt different?",
        answer:
            "ScanIt is lightweight, fast, privacy-focused, and combines all essential QR features in one clean, easy-to-use app without unnecessary bloat.",
      ),
    ];
  }
}

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final faqItems = FAQData.getFAQItems();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title: Text(
          "FAQ",
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          final item = faqItems[index];
          final isExpanded = expandedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                expandedIndex = isExpanded ? null : index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.question,
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Text(
                        item.answer,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 1.6,
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
