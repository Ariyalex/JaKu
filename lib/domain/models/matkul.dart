import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

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

  @HiveField(6)
  final String? room;

  const Matkul({
    required this.id,
    required this.name,
    required this.nameAbbreviation,
    this.lecturer1,
    this.lecturer2,
    this.className,
    this.room,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    nameAbbreviation,
    lecturer1,
    lecturer2,
    className,
    room,
  ];
}
