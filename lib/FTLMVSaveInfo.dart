class FTLMVSaveInfo {
  final String name;
  final String img;
  final String ship;
  final String fileName;
  final String filePath;
  final DateTime dateTime;
  final String hash;

  const FTLMVSaveInfo({
    required this.name,
    required this.ship,
    required this.img,
    required this.fileName,
    required this.filePath,
    required this.dateTime,
    required this.hash
  });

  static FTLMVSaveInfo empty() => FTLMVSaveInfo(name: "NAME", ship: "SHIP", img: 'assets/ships/mupv_stealth_a_base.png', fileName: "filename.sav", filePath: "fullpath", dateTime: DateTime.now(), hash: "ABCDE");
}