import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

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
  final String? className;

  const Matkul({
    required this.id,
    required this.name,
    required this.nameAbbreviation,
    this.lecturer1,
    this.lecturer2,
    this.className,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    nameAbbreviation,
    lecturer1,
    lecturer2,
    className,
  ];

  factory Matkul.create({
    required String name,
    required String nameAbbreviation,
    String? lecturer1,
    String? lecturer2,
    String? className,
  }) {
    const uuid = Uuid();
    return Matkul(
      id: uuid.v4(),
      name: name,
      nameAbbreviation: nameAbbreviation,
      lecturer1: lecturer1,
      lecturer2: lecturer2,
      className: className,
    );
  }
}
