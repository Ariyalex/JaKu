import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:jaku/main.dart';

part 'matkul.g.dart';

@HiveType(typeId: 1)
class Matkul extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String nameAbbreviation; //singkatan

  @HiveField(3)
  final String? lecturer1;

  @HiveField(4)
  final String? lecturer2;

  @HiveField(5)
  final int semester;

  const Matkul({
    required this.id,
    required this.name,
    required this.nameAbbreviation,
    this.lecturer1,
    this.lecturer2,
    required this.semester,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    nameAbbreviation,
    lecturer1,
    lecturer2,
    semester,
  ];

  factory Matkul.create({
    required String name,
    String? lecturer1,
    String? lecturer2,
    int? semester,
  }) {
    return Matkul(
      id: uuid.v4(),
      name: name,
      nameAbbreviation: matkulAbbreviation(name),
      lecturer1: lecturer1,
      lecturer2: lecturer2,
      semester: semester ?? -1,
    );
  }

  Matkul copyWith({
    String? id,
    String? name,
    String? lecturer1,
    String? lecturer2,
    String? nameAbbreviation,
    int? semester,
  }) {
    return Matkul(
      id: this.id,
      name: name ?? this.name,
      nameAbbreviation: nameAbbreviation ?? this.nameAbbreviation,
      lecturer1: lecturer1 ?? this.lecturer1,
      lecturer2: lecturer2 ?? this.lecturer2,
      semester: semester ?? this.semester,
    );
  }

  static String matkulAbbreviation(String name) {
    final List<String> conjunctions = [
      'dan',
      'atau',
      'dsb',
      'yang',
      'di',
      'ke',
      'dari',
      'untuk',
    ];
    final words = name
        .toLowerCase()
        .split(' ')
        .where((word) => word.isNotEmpty && !conjunctions.contains(word))
        .toList();

    if (words.length <= 2) {
      return name;
    }

    return words.map((word) => word[0].toUpperCase()).join();
  }
}
