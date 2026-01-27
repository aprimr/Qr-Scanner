enum QRType { text, url, email, call, sms, whatsApp, wifi }

class QRCodeModel {
  final String rawData;
  final QRType type;

  QRCodeModel({required this.rawData, required this.type});

  factory QRCodeModel.fromRaw(String raw) {
    final String clean = raw.trim();
    final String low = clean.toLowerCase();
    QRType detectedType = QRType.text;

    if (low.startsWith('wifi:')) {
      detectedType = QRType.wifi;
    } else if (low.startsWith('mailto:') || low.startsWith('matmsg:')) {
      detectedType = QRType.email;
    } else if (low.startsWith('tel:')) {
      detectedType = QRType.call;
    } else if (low.startsWith('smsto:') || low.startsWith('sms:')) {
      detectedType = QRType.sms;
    } else if (low.contains('wa.me')) {
      detectedType = QRType.whatsApp;
    } else if (low.startsWith('http')) {
      detectedType = QRType.url;
    }

    return QRCodeModel(rawData: clean, type: detectedType);
  }

  String get displayData {
    switch (type) {
      case QRType.wifi:
        return _parseWifi(rawData);
      case QRType.sms:
        return _parseSms(rawData);
      case QRType.email:
        return _parseEmail(rawData);
      case QRType.call:
        return "Phone: ${rawData.split(':').last}";
      default:
        return rawData;
    }
  }

  //----
  // Raw Data parsing
  //----
  String _parseWifi(String raw) {
    final String content = raw.substring(5);
    final Map<String, String> map = {};

    for (var part in content.split(';')) {
      if (part.contains(':')) {
        var kv = part.split(':');
        map[kv[0]] = kv[1];
      }
    }

    String ssid = map['S'] ?? 'Unknown';
    String pass = map['P'] ?? 'None';
    String security = map['T'] ?? 'Open';
    String hidden = map['H'] == 'true' ? "\nVisibility: Hidden" : "";

    return "SSID Name: $ssid\nPassword: $pass\nType: $security$hidden";
  }

  String _parseSms(String raw) {
    final parts = raw.split(':');
    if (parts.length >= 3) {
      return "Recipient: ${parts[1]}\nMessage: ${parts.sublist(2).join(':')}";
    }
    return "Recipient: ${parts.last}";
  }

  String _parseEmail(String raw) {
    final String cleanRaw = raw.trim();

    // Handle MATMSG format
    if (cleanRaw.toUpperCase().startsWith('MATMSG:')) {
      try {
        final email =
            RegExp(
              r'TO:(.*?);',
              caseSensitive: false,
            ).firstMatch(cleanRaw)?.group(1) ??
            "";
        final subject =
            RegExp(
              r'SUB:(.*?);',
              caseSensitive: false,
            ).firstMatch(cleanRaw)?.group(1) ??
            "";
        final body =
            RegExp(
              r'BODY:(.*?);',
              caseSensitive: false,
            ).firstMatch(cleanRaw)?.group(1) ??
            "";

        List<String> result = [];
        if (email.isNotEmpty) result.add("Email: $email");
        if (subject.isNotEmpty) result.add("Subject: $subject");
        if (body.isNotEmpty) result.add("Message: $body");

        String semiResult = result.isNotEmpty
            ? result.join(' \n').trim().toString()
            : cleanRaw;
        return semiResult.substring(0, semiResult.length - 2);
      } catch (e) {
        return cleanRaw;
      }
    }

    // Handle standard mailto format
    if (cleanRaw.toLowerCase().startsWith('mailto:')) {
      final uri = Uri.parse(cleanRaw);
      return "Email: ${uri.path}\nSubject: ${uri.queryParameters['subject'] ?? 'No Subject'}";
    }

    return cleanRaw;
  }
}
