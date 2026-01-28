import 'package:flutter/services.dart';

void copyToClipboard({required String data}) async {
  await Clipboard.setData(ClipboardData(text: data));
}
