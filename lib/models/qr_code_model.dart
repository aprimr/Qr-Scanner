enum QRType { text, url, email, call, sms, vCard, whatsApp, wifi, other }

class QRCodeModel {
  final String data;
  final QRType type;

  QRCodeModel({required this.data, required this.type});
}
