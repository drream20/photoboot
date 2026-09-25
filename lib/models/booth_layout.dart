class PhotoSlot {
  const PhotoSlot(this.x, this.y, this.width, this.height);

  final double x;
  final double y;
  final double width;
  final double height;
}

class PhotoBoothLayout {
  const PhotoBoothLayout({
    required this.id,
    required this.photoCount,
    required this.isStrip,
    required this.colorValue,
    required this.slots,
  });

  final String id;
  final int photoCount;
  final bool isStrip;
  final int colorValue;
  final List<PhotoSlot> slots;

  String get format => isStrip ? '6 × 2 strip' : '6 × 4 card';
  double get aspectRatio => isStrip ? 1 / 3 : 3 / 2;
  double get framedAspectRatio => aspectRatio;
}

const _verticalThree = [
  PhotoSlot(.11, .07, .78, .25),
  PhotoSlot(.11, .37, .78, .25),
  PhotoSlot(.11, .67, .78, .25),
];
const _verticalFour = [
  PhotoSlot(.11, .05, .78, .19),
  PhotoSlot(.11, .28, .78, .19),
  PhotoSlot(.11, .51, .78, .19),
  PhotoSlot(.11, .74, .78, .19),
];

const photoBoothLayouts = [
  PhotoBoothLayout(
    id: 'A',
    photoCount: 3,
    isStrip: true,
    colorValue: 0xFFF0D7DE,
    slots: _verticalThree,
  ),
  PhotoBoothLayout(
    id: 'B',
    photoCount: 3,
    isStrip: true,
    colorValue: 0xFFDFD8EB,
    slots: _verticalThree,
  ),
  PhotoBoothLayout(
    id: 'C',
    photoCount: 4,
    isStrip: true,
    colorValue: 0xFFE6D8C4,
    slots: _verticalFour,
  ),
  PhotoBoothLayout(
    id: 'D',
    photoCount: 4,
    isStrip: true,
    colorValue: 0xFFC6DBD2,
    slots: _verticalFour,
  ),
  PhotoBoothLayout(
    id: 'E',
    photoCount: 4,
    isStrip: false,
    colorValue: 0xFFF2E7C9,
    slots: [
      PhotoSlot(.07, .10, .41, .34),
      PhotoSlot(.52, .10, .41, .34),
      PhotoSlot(.07, .48, .41, .34),
      PhotoSlot(.52, .48, .41, .34),
    ],
  ),
  PhotoBoothLayout(
    id: 'F',
    photoCount: 4,
    isStrip: false,
    colorValue: 0xFFD0DAEA,
    slots: [
      PhotoSlot(.09, .12, .38, .31),
      PhotoSlot(.53, .12, .38, .31),
      PhotoSlot(.09, .50, .38, .31),
      PhotoSlot(.53, .50, .38, .31),
    ],
  ),
  PhotoBoothLayout(
    id: 'G',
    photoCount: 3,
    isStrip: false,
    colorValue: 0xFFE6D7E0,
    slots: [
      PhotoSlot(.07, .11, .53, .70),
      PhotoSlot(.64, .11, .29, .33),
      PhotoSlot(.64, .48, .29, .33),
    ],
  ),
  PhotoBoothLayout(
    id: 'H',
    photoCount: 3,
    isStrip: false,
    colorValue: 0xFFC8D8DD,
    slots: [
      PhotoSlot(.07, .10, .41, .34),
      PhotoSlot(.52, .10, .41, .34),
      PhotoSlot(.28, .50, .44, .32),
    ],
  ),
  PhotoBoothLayout(
    id: 'I',
    photoCount: 2,
    isStrip: false,
    colorValue: 0xFFF0D7DE,
    slots: [PhotoSlot(.07, .12, .41, .67), PhotoSlot(.52, .12, .41, .67)],
  ),
  PhotoBoothLayout(
    id: 'J',
    photoCount: 2,
    isStrip: false,
    colorValue: 0xFFDFD8EB,
    slots: [PhotoSlot(.08, .17, .84, .28), PhotoSlot(.08, .52, .84, .28)],
  ),
  PhotoBoothLayout(
    id: 'K',
    photoCount: 2,
    isStrip: false,
    colorValue: 0xFFE6D8C4,
    slots: [PhotoSlot(.09, .12, .36, .68), PhotoSlot(.55, .12, .36, .68)],
  ),
  PhotoBoothLayout(
    id: 'L',
    photoCount: 1,
    isStrip: false,
    colorValue: 0xFFC6DBD2,
    slots: [PhotoSlot(.10, .12, .80, .64)],
  ),
];
