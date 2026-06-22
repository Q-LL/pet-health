import 'package:flutter/foundation.dart';

@immutable
class PetProfile {
  const PetProfile({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.species,
    this.breed,
    this.sex,
    this.birthday,
    this.neutered,
    this.allergies = '',
    this.chronicConditions = '',
    this.avatarPath,
    this.isPlaceholder = false,
  });

  final String id;
  final String name;
  final String? species;
  final String? breed;
  final String? sex;
  final DateTime? birthday;
  final bool? neutered;
  final String allergies;
  final String chronicConditions;
  final String? avatarPath;
  final bool isPlaceholder;
  final DateTime createdAt;
  final DateTime updatedAt;
}

@immutable
class PetDraft {
  const PetDraft({
    required this.name,
    this.species,
    this.breed,
    this.sex,
    this.birthday,
    this.neutered,
    this.allergies = '',
    this.chronicConditions = '',
    this.avatarPath,
  });

  final String name;
  final String? species;
  final String? breed;
  final String? sex;
  final DateTime? birthday;
  final bool? neutered;
  final String allergies;
  final String chronicConditions;
  final String? avatarPath;
}
