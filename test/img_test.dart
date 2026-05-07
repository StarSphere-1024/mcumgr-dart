import 'package:mcumgr/img.dart';
import 'package:test/test.dart';

void main() {
  group('McuImage.decode', () {
    test('extracts SHA256 hash from image TLV', () {
      final hash = List<int>.generate(32, (i) => i);

      final image = McuImage.decode(_buildImageWithHashTlv(0x10, hash));

      expect(image.hash, hash);
    });

    test('extracts SHA512 hash from image TLV', () {
      final hash = List<int>.generate(64, (i) => i);

      final image = McuImage.decode(_buildImageWithHashTlv(0x12, hash));

      expect(image.hash, hash);
    });
  });
}

List<int> _buildImageWithHashTlv(int hashType, List<int> hashValue) {
  final header = List<int>.filled(32, 0);

  header[0] = 0x3d;
  header[1] = 0xb8;
  header[2] = 0xf3;
  header[3] = 0x96;

  header[8] = 32;
  header[9] = 0;

  final totalTlvLength = 4 + 4 + hashValue.length;

  final tlv = <int>[
    0x07,
    0x69,
    totalTlvLength & 0xff,
    (totalTlvLength >> 8) & 0xff,
    hashType,
    0x00,
    hashValue.length & 0xff,
    (hashValue.length >> 8) & 0xff,
    ...hashValue,
  ];

  return [...header, ...tlv];
}
