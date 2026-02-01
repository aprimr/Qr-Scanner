import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _audioPlayer = AudioPlayer();

void beep() async {
  await _audioPlayer.play(AssetSource('audio/beep.mp3'));
}
