import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Uint8List sequenceToWav(List<List<int>> sequence) {
  const sampleRate = 44100;
  const channels = 1;
  const bitsPerSample = 16;

  final samples = <int>[];

  for (final note in sequence) {
    final frequency = note[0];
    final durationMs = note[1];

    final sampleCount = (sampleRate * durationMs / 1000).round();

    for (var i = 0; i < sampleCount; i++) {
      if (frequency == 0) {
        samples.add(0);
        continue;
      }

      final t = i / sampleRate;

      // Sine wave, amplitude ~50%.
      final value = sin(2 * pi * frequency * t) * 16384;

      samples.add(value.round());
    }
  }

  final dataSize = samples.length * 2;
  final fileSize = 44 + dataSize;

  final bytes = ByteData(fileSize);

  // RIFF header
  bytes.setUint8(0, 0x52); // R
  bytes.setUint8(1, 0x49); // I
  bytes.setUint8(2, 0x46); // F
  bytes.setUint8(3, 0x46); // F
  bytes.setUint32(4, fileSize - 8, Endian.little);

  // WAVE
  bytes.setUint8(8, 0x57); // W
  bytes.setUint8(9, 0x41); // A
  bytes.setUint8(10, 0x56); // V
  bytes.setUint8(11, 0x45); // E

  // fmt chunk
  bytes.setUint8(12, 0x66); // f
  bytes.setUint8(13, 0x6d); // m
  bytes.setUint8(14, 0x74); // t
  bytes.setUint8(15, 0x20); // space

  bytes.setUint32(16, 16, Endian.little); // chunk size
  bytes.setUint16(20, 1, Endian.little); // PCM
  bytes.setUint16(22, channels, Endian.little);
  bytes.setUint32(24, sampleRate, Endian.little);

  final byteRate = sampleRate * channels * bitsPerSample ~/ 8;
  final blockAlign = channels * bitsPerSample ~/ 8;

  bytes.setUint32(28, byteRate, Endian.little);
  bytes.setUint16(32, blockAlign, Endian.little);
  bytes.setUint16(34, bitsPerSample, Endian.little);

  // data chunk
  bytes.setUint8(36, 0x64); // d
  bytes.setUint8(37, 0x61); // a
  bytes.setUint8(38, 0x74); // t
  bytes.setUint8(39, 0x61); // a
  bytes.setUint32(40, dataSize, Endian.little);

  // PCM samples
  var offset = 44;

  for (final sample in samples) {
    bytes.setInt16(offset, sample, Endian.little);
    offset += 2;
  }

  return bytes.buffer.asUint8List();
}

Future<Directory> _getdir() async {
  return await getApplicationDocumentsDirectory();
}

Future<Directory> _addFolder() async {
  Directory base = await _getdir();
  Directory appFolder = Directory(
    "${base.path}${Platform.pathSeparator}MusicMaster",
  );
  return appFolder;
}

Future<File> _makeFile(String filename) async {
  Directory base = await _addFolder();
  if (!base.existsSync()) {
    base.createSync();
  }
  return File("${base.path}${Platform.pathSeparator}$filename.wav");
}

Future<void> writeFile(String filename, List<List<int>> sequence) async {
  File file = await _makeFile(filename);
  file.writeAsBytes(sequenceToWav(sequence));
}
