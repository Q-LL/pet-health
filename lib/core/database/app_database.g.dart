// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PetsTable extends Pets with TableInfo<$PetsTable, Pet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speciesMeta = const VerificationMeta(
    'species',
  );
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
    'species',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breedMeta = const VerificationMeta('breed');
  @override
  late final GeneratedColumn<String> breed = GeneratedColumn<String>(
    'breed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthdayMeta = const VerificationMeta(
    'birthday',
  );
  @override
  late final GeneratedColumn<DateTime> birthday = GeneratedColumn<DateTime>(
    'birthday',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _neuteredMeta = const VerificationMeta(
    'neutered',
  );
  @override
  late final GeneratedColumn<bool> neutered = GeneratedColumn<bool>(
    'neutered',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("neutered" IN (0, 1))',
    ),
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _chronicConditionsMeta = const VerificationMeta(
    'chronicConditions',
  );
  @override
  late final GeneratedColumn<String> chronicConditions =
      GeneratedColumn<String>(
        'chronic_conditions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPlaceholderMeta = const VerificationMeta(
    'isPlaceholder',
  );
  @override
  late final GeneratedColumn<bool> isPlaceholder = GeneratedColumn<bool>(
    'is_placeholder',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_placeholder" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    species,
    breed,
    sex,
    birthday,
    neutered,
    allergies,
    chronicConditions,
    avatarPath,
    isPlaceholder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('species')) {
      context.handle(
        _speciesMeta,
        species.isAcceptableOrUnknown(data['species']!, _speciesMeta),
      );
    }
    if (data.containsKey('breed')) {
      context.handle(
        _breedMeta,
        breed.isAcceptableOrUnknown(data['breed']!, _breedMeta),
      );
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    }
    if (data.containsKey('birthday')) {
      context.handle(
        _birthdayMeta,
        birthday.isAcceptableOrUnknown(data['birthday']!, _birthdayMeta),
      );
    }
    if (data.containsKey('neutered')) {
      context.handle(
        _neuteredMeta,
        neutered.isAcceptableOrUnknown(data['neutered']!, _neuteredMeta),
      );
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    }
    if (data.containsKey('chronic_conditions')) {
      context.handle(
        _chronicConditionsMeta,
        chronicConditions.isAcceptableOrUnknown(
          data['chronic_conditions']!,
          _chronicConditionsMeta,
        ),
      );
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('is_placeholder')) {
      context.handle(
        _isPlaceholderMeta,
        isPlaceholder.isAcceptableOrUnknown(
          data['is_placeholder']!,
          _isPlaceholderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      species: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species'],
      ),
      breed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breed'],
      ),
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      ),
      birthday: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birthday'],
      ),
      neutered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}neutered'],
      ),
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      )!,
      chronicConditions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chronic_conditions'],
      )!,
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      isPlaceholder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_placeholder'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PetsTable createAlias(String alias) {
    return $PetsTable(attachedDatabase, alias);
  }
}

class Pet extends DataClass implements Insertable<Pet> {
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
  const Pet({
    required this.id,
    required this.name,
    this.species,
    this.breed,
    this.sex,
    this.birthday,
    this.neutered,
    required this.allergies,
    required this.chronicConditions,
    this.avatarPath,
    required this.isPlaceholder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || species != null) {
      map['species'] = Variable<String>(species);
    }
    if (!nullToAbsent || breed != null) {
      map['breed'] = Variable<String>(breed);
    }
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>(sex);
    }
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<DateTime>(birthday);
    }
    if (!nullToAbsent || neutered != null) {
      map['neutered'] = Variable<bool>(neutered);
    }
    map['allergies'] = Variable<String>(allergies);
    map['chronic_conditions'] = Variable<String>(chronicConditions);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['is_placeholder'] = Variable<bool>(isPlaceholder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PetsCompanion toCompanion(bool nullToAbsent) {
    return PetsCompanion(
      id: Value(id),
      name: Value(name),
      species: species == null && nullToAbsent
          ? const Value.absent()
          : Value(species),
      breed: breed == null && nullToAbsent
          ? const Value.absent()
          : Value(breed),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
      neutered: neutered == null && nullToAbsent
          ? const Value.absent()
          : Value(neutered),
      allergies: Value(allergies),
      chronicConditions: Value(chronicConditions),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      isPlaceholder: Value(isPlaceholder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Pet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pet(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      species: serializer.fromJson<String?>(json['species']),
      breed: serializer.fromJson<String?>(json['breed']),
      sex: serializer.fromJson<String?>(json['sex']),
      birthday: serializer.fromJson<DateTime?>(json['birthday']),
      neutered: serializer.fromJson<bool?>(json['neutered']),
      allergies: serializer.fromJson<String>(json['allergies']),
      chronicConditions: serializer.fromJson<String>(json['chronicConditions']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      isPlaceholder: serializer.fromJson<bool>(json['isPlaceholder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'species': serializer.toJson<String?>(species),
      'breed': serializer.toJson<String?>(breed),
      'sex': serializer.toJson<String?>(sex),
      'birthday': serializer.toJson<DateTime?>(birthday),
      'neutered': serializer.toJson<bool?>(neutered),
      'allergies': serializer.toJson<String>(allergies),
      'chronicConditions': serializer.toJson<String>(chronicConditions),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'isPlaceholder': serializer.toJson<bool>(isPlaceholder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Pet copyWith({
    String? id,
    String? name,
    Value<String?> species = const Value.absent(),
    Value<String?> breed = const Value.absent(),
    Value<String?> sex = const Value.absent(),
    Value<DateTime?> birthday = const Value.absent(),
    Value<bool?> neutered = const Value.absent(),
    String? allergies,
    String? chronicConditions,
    Value<String?> avatarPath = const Value.absent(),
    bool? isPlaceholder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Pet(
    id: id ?? this.id,
    name: name ?? this.name,
    species: species.present ? species.value : this.species,
    breed: breed.present ? breed.value : this.breed,
    sex: sex.present ? sex.value : this.sex,
    birthday: birthday.present ? birthday.value : this.birthday,
    neutered: neutered.present ? neutered.value : this.neutered,
    allergies: allergies ?? this.allergies,
    chronicConditions: chronicConditions ?? this.chronicConditions,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    isPlaceholder: isPlaceholder ?? this.isPlaceholder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Pet copyWithCompanion(PetsCompanion data) {
    return Pet(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      species: data.species.present ? data.species.value : this.species,
      breed: data.breed.present ? data.breed.value : this.breed,
      sex: data.sex.present ? data.sex.value : this.sex,
      birthday: data.birthday.present ? data.birthday.value : this.birthday,
      neutered: data.neutered.present ? data.neutered.value : this.neutered,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      chronicConditions: data.chronicConditions.present
          ? data.chronicConditions.value
          : this.chronicConditions,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      isPlaceholder: data.isPlaceholder.present
          ? data.isPlaceholder.value
          : this.isPlaceholder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pet(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('species: $species, ')
          ..write('breed: $breed, ')
          ..write('sex: $sex, ')
          ..write('birthday: $birthday, ')
          ..write('neutered: $neutered, ')
          ..write('allergies: $allergies, ')
          ..write('chronicConditions: $chronicConditions, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('isPlaceholder: $isPlaceholder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    species,
    breed,
    sex,
    birthday,
    neutered,
    allergies,
    chronicConditions,
    avatarPath,
    isPlaceholder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pet &&
          other.id == this.id &&
          other.name == this.name &&
          other.species == this.species &&
          other.breed == this.breed &&
          other.sex == this.sex &&
          other.birthday == this.birthday &&
          other.neutered == this.neutered &&
          other.allergies == this.allergies &&
          other.chronicConditions == this.chronicConditions &&
          other.avatarPath == this.avatarPath &&
          other.isPlaceholder == this.isPlaceholder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PetsCompanion extends UpdateCompanion<Pet> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> species;
  final Value<String?> breed;
  final Value<String?> sex;
  final Value<DateTime?> birthday;
  final Value<bool?> neutered;
  final Value<String> allergies;
  final Value<String> chronicConditions;
  final Value<String?> avatarPath;
  final Value<bool> isPlaceholder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.species = const Value.absent(),
    this.breed = const Value.absent(),
    this.sex = const Value.absent(),
    this.birthday = const Value.absent(),
    this.neutered = const Value.absent(),
    this.allergies = const Value.absent(),
    this.chronicConditions = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.isPlaceholder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PetsCompanion.insert({
    required String id,
    required String name,
    this.species = const Value.absent(),
    this.breed = const Value.absent(),
    this.sex = const Value.absent(),
    this.birthday = const Value.absent(),
    this.neutered = const Value.absent(),
    this.allergies = const Value.absent(),
    this.chronicConditions = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.isPlaceholder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Pet> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? species,
    Expression<String>? breed,
    Expression<String>? sex,
    Expression<DateTime>? birthday,
    Expression<bool>? neutered,
    Expression<String>? allergies,
    Expression<String>? chronicConditions,
    Expression<String>? avatarPath,
    Expression<bool>? isPlaceholder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (species != null) 'species': species,
      if (breed != null) 'breed': breed,
      if (sex != null) 'sex': sex,
      if (birthday != null) 'birthday': birthday,
      if (neutered != null) 'neutered': neutered,
      if (allergies != null) 'allergies': allergies,
      if (chronicConditions != null) 'chronic_conditions': chronicConditions,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (isPlaceholder != null) 'is_placeholder': isPlaceholder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PetsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? species,
    Value<String?>? breed,
    Value<String?>? sex,
    Value<DateTime?>? birthday,
    Value<bool?>? neutered,
    Value<String>? allergies,
    Value<String>? chronicConditions,
    Value<String?>? avatarPath,
    Value<bool>? isPlaceholder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      sex: sex ?? this.sex,
      birthday: birthday ?? this.birthday,
      neutered: neutered ?? this.neutered,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      avatarPath: avatarPath ?? this.avatarPath,
      isPlaceholder: isPlaceholder ?? this.isPlaceholder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (breed.present) {
      map['breed'] = Variable<String>(breed.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<DateTime>(birthday.value);
    }
    if (neutered.present) {
      map['neutered'] = Variable<bool>(neutered.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (chronicConditions.present) {
      map['chronic_conditions'] = Variable<String>(chronicConditions.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (isPlaceholder.present) {
      map['is_placeholder'] = Variable<bool>(isPlaceholder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('species: $species, ')
          ..write('breed: $breed, ')
          ..write('sex: $sex, ')
          ..write('birthday: $birthday, ')
          ..write('neutered: $neutered, ')
          ..write('allergies: $allergies, ')
          ..write('chronicConditions: $chronicConditions, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('isPlaceholder: $isPlaceholder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CareActivitiesTable extends CareActivities
    with TableInfo<$CareActivitiesTable, CareActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<String> petId = GeneratedColumn<String>(
    'pet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
    'place',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _detailsJsonMeta = const VerificationMeta(
    'detailsJson',
  );
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
    'details_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _routeFilePathMeta = const VerificationMeta(
    'routeFilePath',
  );
  @override
  late final GeneratedColumn<String> routeFilePath = GeneratedColumn<String>(
    'route_file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    petId,
    type,
    occurredAt,
    startedAt,
    endedAt,
    durationSeconds,
    place,
    note,
    detailsJson,
    routeFilePath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<CareActivity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pet_id')) {
      context.handle(
        _petIdMeta,
        petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta),
      );
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('place')) {
      context.handle(
        _placeMeta,
        place.isAcceptableOrUnknown(data['place']!, _placeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('details_json')) {
      context.handle(
        _detailsJsonMeta,
        detailsJson.isAcceptableOrUnknown(
          data['details_json']!,
          _detailsJsonMeta,
        ),
      );
    }
    if (data.containsKey('route_file_path')) {
      context.handle(
        _routeFilePathMeta,
        routeFilePath.isAcceptableOrUnknown(
          data['route_file_path']!,
          _routeFilePathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareActivity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      petId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      place: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      detailsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details_json'],
      )!,
      routeFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_file_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CareActivitiesTable createAlias(String alias) {
    return $CareActivitiesTable(attachedDatabase, alias);
  }
}

class CareActivity extends DataClass implements Insertable<CareActivity> {
  final String id;
  final String petId;
  final String type;
  final DateTime occurredAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? durationSeconds;
  final String place;
  final String note;
  final String detailsJson;
  final String? routeFilePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CareActivity({
    required this.id,
    required this.petId,
    required this.type,
    required this.occurredAt,
    this.startedAt,
    this.endedAt,
    this.durationSeconds,
    required this.place,
    required this.note,
    required this.detailsJson,
    this.routeFilePath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pet_id'] = Variable<String>(petId);
    map['type'] = Variable<String>(type);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    map['place'] = Variable<String>(place);
    map['note'] = Variable<String>(note);
    map['details_json'] = Variable<String>(detailsJson);
    if (!nullToAbsent || routeFilePath != null) {
      map['route_file_path'] = Variable<String>(routeFilePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CareActivitiesCompanion toCompanion(bool nullToAbsent) {
    return CareActivitiesCompanion(
      id: Value(id),
      petId: Value(petId),
      type: Value(type),
      occurredAt: Value(occurredAt),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      place: Value(place),
      note: Value(note),
      detailsJson: Value(detailsJson),
      routeFilePath: routeFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(routeFilePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CareActivity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareActivity(
      id: serializer.fromJson<String>(json['id']),
      petId: serializer.fromJson<String>(json['petId']),
      type: serializer.fromJson<String>(json['type']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      place: serializer.fromJson<String>(json['place']),
      note: serializer.fromJson<String>(json['note']),
      detailsJson: serializer.fromJson<String>(json['detailsJson']),
      routeFilePath: serializer.fromJson<String?>(json['routeFilePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'petId': serializer.toJson<String>(petId),
      'type': serializer.toJson<String>(type),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'place': serializer.toJson<String>(place),
      'note': serializer.toJson<String>(note),
      'detailsJson': serializer.toJson<String>(detailsJson),
      'routeFilePath': serializer.toJson<String?>(routeFilePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CareActivity copyWith({
    String? id,
    String? petId,
    String? type,
    DateTime? occurredAt,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> endedAt = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    String? place,
    String? note,
    String? detailsJson,
    Value<String?> routeFilePath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CareActivity(
    id: id ?? this.id,
    petId: petId ?? this.petId,
    type: type ?? this.type,
    occurredAt: occurredAt ?? this.occurredAt,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    place: place ?? this.place,
    note: note ?? this.note,
    detailsJson: detailsJson ?? this.detailsJson,
    routeFilePath: routeFilePath.present
        ? routeFilePath.value
        : this.routeFilePath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CareActivity copyWithCompanion(CareActivitiesCompanion data) {
    return CareActivity(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      type: data.type.present ? data.type.value : this.type,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      place: data.place.present ? data.place.value : this.place,
      note: data.note.present ? data.note.value : this.note,
      detailsJson: data.detailsJson.present
          ? data.detailsJson.value
          : this.detailsJson,
      routeFilePath: data.routeFilePath.present
          ? data.routeFilePath.value
          : this.routeFilePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CareActivity(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('type: $type, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('place: $place, ')
          ..write('note: $note, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('routeFilePath: $routeFilePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    petId,
    type,
    occurredAt,
    startedAt,
    endedAt,
    durationSeconds,
    place,
    note,
    detailsJson,
    routeFilePath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareActivity &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.type == this.type &&
          other.occurredAt == this.occurredAt &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.place == this.place &&
          other.note == this.note &&
          other.detailsJson == this.detailsJson &&
          other.routeFilePath == this.routeFilePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CareActivitiesCompanion extends UpdateCompanion<CareActivity> {
  final Value<String> id;
  final Value<String> petId;
  final Value<String> type;
  final Value<DateTime> occurredAt;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int?> durationSeconds;
  final Value<String> place;
  final Value<String> note;
  final Value<String> detailsJson;
  final Value<String?> routeFilePath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CareActivitiesCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.type = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.place = const Value.absent(),
    this.note = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.routeFilePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CareActivitiesCompanion.insert({
    required String id,
    required String petId,
    required String type,
    required DateTime occurredAt,
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.place = const Value.absent(),
    this.note = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.routeFilePath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       petId = Value(petId),
       type = Value(type),
       occurredAt = Value(occurredAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CareActivity> custom({
    Expression<String>? id,
    Expression<String>? petId,
    Expression<String>? type,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationSeconds,
    Expression<String>? place,
    Expression<String>? note,
    Expression<String>? detailsJson,
    Expression<String>? routeFilePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (type != null) 'type': type,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (place != null) 'place': place,
      if (note != null) 'note': note,
      if (detailsJson != null) 'details_json': detailsJson,
      if (routeFilePath != null) 'route_file_path': routeFilePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CareActivitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? petId,
    Value<String>? type,
    Value<DateTime>? occurredAt,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int?>? durationSeconds,
    Value<String>? place,
    Value<String>? note,
    Value<String>? detailsJson,
    Value<String?>? routeFilePath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CareActivitiesCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      type: type ?? this.type,
      occurredAt: occurredAt ?? this.occurredAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      place: place ?? this.place,
      note: note ?? this.note,
      detailsJson: detailsJson ?? this.detailsJson,
      routeFilePath: routeFilePath ?? this.routeFilePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<String>(petId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (detailsJson.present) {
      map['details_json'] = Variable<String>(detailsJson.value);
    }
    if (routeFilePath.present) {
      map['route_file_path'] = Variable<String>(routeFilePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('type: $type, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('place: $place, ')
          ..write('note: $note, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('routeFilePath: $routeFilePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthRecordsTable extends HealthRecords
    with TableInfo<$HealthRecordsTable, HealthRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<String> petId = GeneratedColumn<String>(
    'pet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _numericValueMeta = const VerificationMeta(
    'numericValue',
  );
  @override
  late final GeneratedColumn<double> numericValue = GeneratedColumn<double>(
    'numeric_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<int> severity = GeneratedColumn<int>(
    'severity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailsJsonMeta = const VerificationMeta(
    'detailsJson',
  );
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
    'details_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    petId,
    type,
    occurredAt,
    title,
    note,
    numericValue,
    unit,
    severity,
    detailsJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pet_id')) {
      context.handle(
        _petIdMeta,
        petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta),
      );
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('numeric_value')) {
      context.handle(
        _numericValueMeta,
        numericValue.isAcceptableOrUnknown(
          data['numeric_value']!,
          _numericValueMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    }
    if (data.containsKey('details_json')) {
      context.handle(
        _detailsJsonMeta,
        detailsJson.isAcceptableOrUnknown(
          data['details_json']!,
          _detailsJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      petId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      numericValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}numeric_value'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}severity'],
      ),
      detailsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HealthRecordsTable createAlias(String alias) {
    return $HealthRecordsTable(attachedDatabase, alias);
  }
}

class HealthRecord extends DataClass implements Insertable<HealthRecord> {
  final String id;
  final String petId;
  final String type;
  final DateTime occurredAt;
  final String title;
  final String note;
  final double? numericValue;
  final String? unit;
  final int? severity;
  final String detailsJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const HealthRecord({
    required this.id,
    required this.petId,
    required this.type,
    required this.occurredAt,
    required this.title,
    required this.note,
    this.numericValue,
    this.unit,
    this.severity,
    required this.detailsJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pet_id'] = Variable<String>(petId);
    map['type'] = Variable<String>(type);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['title'] = Variable<String>(title);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || numericValue != null) {
      map['numeric_value'] = Variable<double>(numericValue);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || severity != null) {
      map['severity'] = Variable<int>(severity);
    }
    map['details_json'] = Variable<String>(detailsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HealthRecordsCompanion toCompanion(bool nullToAbsent) {
    return HealthRecordsCompanion(
      id: Value(id),
      petId: Value(petId),
      type: Value(type),
      occurredAt: Value(occurredAt),
      title: Value(title),
      note: Value(note),
      numericValue: numericValue == null && nullToAbsent
          ? const Value.absent()
          : Value(numericValue),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      severity: severity == null && nullToAbsent
          ? const Value.absent()
          : Value(severity),
      detailsJson: Value(detailsJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HealthRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthRecord(
      id: serializer.fromJson<String>(json['id']),
      petId: serializer.fromJson<String>(json['petId']),
      type: serializer.fromJson<String>(json['type']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String>(json['note']),
      numericValue: serializer.fromJson<double?>(json['numericValue']),
      unit: serializer.fromJson<String?>(json['unit']),
      severity: serializer.fromJson<int?>(json['severity']),
      detailsJson: serializer.fromJson<String>(json['detailsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'petId': serializer.toJson<String>(petId),
      'type': serializer.toJson<String>(type),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String>(note),
      'numericValue': serializer.toJson<double?>(numericValue),
      'unit': serializer.toJson<String?>(unit),
      'severity': serializer.toJson<int?>(severity),
      'detailsJson': serializer.toJson<String>(detailsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HealthRecord copyWith({
    String? id,
    String? petId,
    String? type,
    DateTime? occurredAt,
    String? title,
    String? note,
    Value<double?> numericValue = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<int?> severity = const Value.absent(),
    String? detailsJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HealthRecord(
    id: id ?? this.id,
    petId: petId ?? this.petId,
    type: type ?? this.type,
    occurredAt: occurredAt ?? this.occurredAt,
    title: title ?? this.title,
    note: note ?? this.note,
    numericValue: numericValue.present ? numericValue.value : this.numericValue,
    unit: unit.present ? unit.value : this.unit,
    severity: severity.present ? severity.value : this.severity,
    detailsJson: detailsJson ?? this.detailsJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HealthRecord copyWithCompanion(HealthRecordsCompanion data) {
    return HealthRecord(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      type: data.type.present ? data.type.value : this.type,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      numericValue: data.numericValue.present
          ? data.numericValue.value
          : this.numericValue,
      unit: data.unit.present ? data.unit.value : this.unit,
      severity: data.severity.present ? data.severity.value : this.severity,
      detailsJson: data.detailsJson.present
          ? data.detailsJson.value
          : this.detailsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecord(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('type: $type, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('numericValue: $numericValue, ')
          ..write('unit: $unit, ')
          ..write('severity: $severity, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    petId,
    type,
    occurredAt,
    title,
    note,
    numericValue,
    unit,
    severity,
    detailsJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthRecord &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.type == this.type &&
          other.occurredAt == this.occurredAt &&
          other.title == this.title &&
          other.note == this.note &&
          other.numericValue == this.numericValue &&
          other.unit == this.unit &&
          other.severity == this.severity &&
          other.detailsJson == this.detailsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HealthRecordsCompanion extends UpdateCompanion<HealthRecord> {
  final Value<String> id;
  final Value<String> petId;
  final Value<String> type;
  final Value<DateTime> occurredAt;
  final Value<String> title;
  final Value<String> note;
  final Value<double?> numericValue;
  final Value<String?> unit;
  final Value<int?> severity;
  final Value<String> detailsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HealthRecordsCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.type = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.numericValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.severity = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthRecordsCompanion.insert({
    required String id,
    required String petId,
    required String type,
    required DateTime occurredAt,
    required String title,
    this.note = const Value.absent(),
    this.numericValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.severity = const Value.absent(),
    this.detailsJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       petId = Value(petId),
       type = Value(type),
       occurredAt = Value(occurredAt),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HealthRecord> custom({
    Expression<String>? id,
    Expression<String>? petId,
    Expression<String>? type,
    Expression<DateTime>? occurredAt,
    Expression<String>? title,
    Expression<String>? note,
    Expression<double>? numericValue,
    Expression<String>? unit,
    Expression<int>? severity,
    Expression<String>? detailsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (type != null) 'type': type,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (numericValue != null) 'numeric_value': numericValue,
      if (unit != null) 'unit': unit,
      if (severity != null) 'severity': severity,
      if (detailsJson != null) 'details_json': detailsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? petId,
    Value<String>? type,
    Value<DateTime>? occurredAt,
    Value<String>? title,
    Value<String>? note,
    Value<double?>? numericValue,
    Value<String?>? unit,
    Value<int?>? severity,
    Value<String>? detailsJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HealthRecordsCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      type: type ?? this.type,
      occurredAt: occurredAt ?? this.occurredAt,
      title: title ?? this.title,
      note: note ?? this.note,
      numericValue: numericValue ?? this.numericValue,
      unit: unit ?? this.unit,
      severity: severity ?? this.severity,
      detailsJson: detailsJson ?? this.detailsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<String>(petId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (numericValue.present) {
      map['numeric_value'] = Variable<double>(numericValue.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (severity.present) {
      map['severity'] = Variable<int>(severity.value);
    }
    if (detailsJson.present) {
      map['details_json'] = Variable<String>(detailsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecordsCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('type: $type, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('numericValue: $numericValue, ')
          ..write('unit: $unit, ')
          ..write('severity: $severity, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppSetting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PetPhotosTable extends PetPhotos
    with TableInfo<$PetPhotosTable, PetPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<String> petId = GeneratedColumn<String>(
    'pet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bytesMeta = const VerificationMeta('bytes');
  @override
  late final GeneratedColumn<Uint8List> bytes = GeneratedColumn<Uint8List>(
    'bytes',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalNameMeta = const VerificationMeta(
    'originalName',
  );
  @override
  late final GeneratedColumn<String> originalName = GeneratedColumn<String>(
    'original_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAvatarMeta = const VerificationMeta(
    'isAvatar',
  );
  @override
  late final GeneratedColumn<bool> isAvatar = GeneratedColumn<bool>(
    'is_avatar',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_avatar" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    petId,
    filePath,
    bytes,
    originalName,
    mediaType,
    caption,
    capturedAt,
    isAvatar,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pet_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<PetPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pet_id')) {
      context.handle(
        _petIdMeta,
        petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta),
      );
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('bytes')) {
      context.handle(
        _bytesMeta,
        bytes.isAcceptableOrUnknown(data['bytes']!, _bytesMeta),
      );
    }
    if (data.containsKey('original_name')) {
      context.handle(
        _originalNameMeta,
        originalName.isAcceptableOrUnknown(
          data['original_name']!,
          _originalNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalNameMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    }
    if (data.containsKey('is_avatar')) {
      context.handle(
        _isAvatarMeta,
        isAvatar.isAcceptableOrUnknown(data['is_avatar']!, _isAvatarMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PetPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PetPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      petId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}bytes'],
      ),
      originalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_name'],
      )!,
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      ),
      isAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_avatar'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PetPhotosTable createAlias(String alias) {
    return $PetPhotosTable(attachedDatabase, alias);
  }
}

class PetPhoto extends DataClass implements Insertable<PetPhoto> {
  final String id;
  final String petId;
  final String? filePath;
  final Uint8List? bytes;
  final String originalName;
  final String mediaType;
  final String caption;
  final DateTime? capturedAt;
  final bool isAvatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PetPhoto({
    required this.id,
    required this.petId,
    this.filePath,
    this.bytes,
    required this.originalName,
    required this.mediaType,
    required this.caption,
    this.capturedAt,
    required this.isAvatar,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pet_id'] = Variable<String>(petId);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || bytes != null) {
      map['bytes'] = Variable<Uint8List>(bytes);
    }
    map['original_name'] = Variable<String>(originalName);
    map['media_type'] = Variable<String>(mediaType);
    map['caption'] = Variable<String>(caption);
    if (!nullToAbsent || capturedAt != null) {
      map['captured_at'] = Variable<DateTime>(capturedAt);
    }
    map['is_avatar'] = Variable<bool>(isAvatar);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PetPhotosCompanion toCompanion(bool nullToAbsent) {
    return PetPhotosCompanion(
      id: Value(id),
      petId: Value(petId),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      bytes: bytes == null && nullToAbsent
          ? const Value.absent()
          : Value(bytes),
      originalName: Value(originalName),
      mediaType: Value(mediaType),
      caption: Value(caption),
      capturedAt: capturedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(capturedAt),
      isAvatar: Value(isAvatar),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PetPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PetPhoto(
      id: serializer.fromJson<String>(json['id']),
      petId: serializer.fromJson<String>(json['petId']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      bytes: serializer.fromJson<Uint8List?>(json['bytes']),
      originalName: serializer.fromJson<String>(json['originalName']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      caption: serializer.fromJson<String>(json['caption']),
      capturedAt: serializer.fromJson<DateTime?>(json['capturedAt']),
      isAvatar: serializer.fromJson<bool>(json['isAvatar']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'petId': serializer.toJson<String>(petId),
      'filePath': serializer.toJson<String?>(filePath),
      'bytes': serializer.toJson<Uint8List?>(bytes),
      'originalName': serializer.toJson<String>(originalName),
      'mediaType': serializer.toJson<String>(mediaType),
      'caption': serializer.toJson<String>(caption),
      'capturedAt': serializer.toJson<DateTime?>(capturedAt),
      'isAvatar': serializer.toJson<bool>(isAvatar),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PetPhoto copyWith({
    String? id,
    String? petId,
    Value<String?> filePath = const Value.absent(),
    Value<Uint8List?> bytes = const Value.absent(),
    String? originalName,
    String? mediaType,
    String? caption,
    Value<DateTime?> capturedAt = const Value.absent(),
    bool? isAvatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PetPhoto(
    id: id ?? this.id,
    petId: petId ?? this.petId,
    filePath: filePath.present ? filePath.value : this.filePath,
    bytes: bytes.present ? bytes.value : this.bytes,
    originalName: originalName ?? this.originalName,
    mediaType: mediaType ?? this.mediaType,
    caption: caption ?? this.caption,
    capturedAt: capturedAt.present ? capturedAt.value : this.capturedAt,
    isAvatar: isAvatar ?? this.isAvatar,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PetPhoto copyWithCompanion(PetPhotosCompanion data) {
    return PetPhoto(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
      originalName: data.originalName.present
          ? data.originalName.value
          : this.originalName,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      caption: data.caption.present ? data.caption.value : this.caption,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      isAvatar: data.isAvatar.present ? data.isAvatar.value : this.isAvatar,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PetPhoto(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('filePath: $filePath, ')
          ..write('bytes: $bytes, ')
          ..write('originalName: $originalName, ')
          ..write('mediaType: $mediaType, ')
          ..write('caption: $caption, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('isAvatar: $isAvatar, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    petId,
    filePath,
    $driftBlobEquality.hash(bytes),
    originalName,
    mediaType,
    caption,
    capturedAt,
    isAvatar,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PetPhoto &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.filePath == this.filePath &&
          $driftBlobEquality.equals(other.bytes, this.bytes) &&
          other.originalName == this.originalName &&
          other.mediaType == this.mediaType &&
          other.caption == this.caption &&
          other.capturedAt == this.capturedAt &&
          other.isAvatar == this.isAvatar &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PetPhotosCompanion extends UpdateCompanion<PetPhoto> {
  final Value<String> id;
  final Value<String> petId;
  final Value<String?> filePath;
  final Value<Uint8List?> bytes;
  final Value<String> originalName;
  final Value<String> mediaType;
  final Value<String> caption;
  final Value<DateTime?> capturedAt;
  final Value<bool> isAvatar;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PetPhotosCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.bytes = const Value.absent(),
    this.originalName = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.caption = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.isAvatar = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PetPhotosCompanion.insert({
    required String id,
    required String petId,
    this.filePath = const Value.absent(),
    this.bytes = const Value.absent(),
    required String originalName,
    required String mediaType,
    this.caption = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.isAvatar = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       petId = Value(petId),
       originalName = Value(originalName),
       mediaType = Value(mediaType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PetPhoto> custom({
    Expression<String>? id,
    Expression<String>? petId,
    Expression<String>? filePath,
    Expression<Uint8List>? bytes,
    Expression<String>? originalName,
    Expression<String>? mediaType,
    Expression<String>? caption,
    Expression<DateTime>? capturedAt,
    Expression<bool>? isAvatar,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (filePath != null) 'file_path': filePath,
      if (bytes != null) 'bytes': bytes,
      if (originalName != null) 'original_name': originalName,
      if (mediaType != null) 'media_type': mediaType,
      if (caption != null) 'caption': caption,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (isAvatar != null) 'is_avatar': isAvatar,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PetPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? petId,
    Value<String?>? filePath,
    Value<Uint8List?>? bytes,
    Value<String>? originalName,
    Value<String>? mediaType,
    Value<String>? caption,
    Value<DateTime?>? capturedAt,
    Value<bool>? isAvatar,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PetPhotosCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      filePath: filePath ?? this.filePath,
      bytes: bytes ?? this.bytes,
      originalName: originalName ?? this.originalName,
      mediaType: mediaType ?? this.mediaType,
      caption: caption ?? this.caption,
      capturedAt: capturedAt ?? this.capturedAt,
      isAvatar: isAvatar ?? this.isAvatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<String>(petId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (bytes.present) {
      map['bytes'] = Variable<Uint8List>(bytes.value);
    }
    if (originalName.present) {
      map['original_name'] = Variable<String>(originalName.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (isAvatar.present) {
      map['is_avatar'] = Variable<bool>(isAvatar.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetPhotosCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('filePath: $filePath, ')
          ..write('bytes: $bytes, ')
          ..write('originalName: $originalName, ')
          ..write('mediaType: $mediaType, ')
          ..write('caption: $caption, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('isAvatar: $isAvatar, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemoryEntriesTable extends MemoryEntries
    with TableInfo<$MemoryEntriesTable, MemoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<String> petId = GeneratedColumn<String>(
    'pet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _moodEmojiMeta = const VerificationMeta(
    'moodEmoji',
  );
  @override
  late final GeneratedColumn<String> moodEmoji = GeneratedColumn<String>(
    'mood_emoji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    petId,
    occurredAt,
    note,
    moodEmoji,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pet_id')) {
      context.handle(
        _petIdMeta,
        petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta),
      );
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('mood_emoji')) {
      context.handle(
        _moodEmojiMeta,
        moodEmoji.isAcceptableOrUnknown(data['mood_emoji']!, _moodEmojiMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      petId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      moodEmoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood_emoji'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MemoryEntriesTable createAlias(String alias) {
    return $MemoryEntriesTable(attachedDatabase, alias);
  }
}

class MemoryEntry extends DataClass implements Insertable<MemoryEntry> {
  final String id;
  final String petId;
  final DateTime occurredAt;
  final String note;
  final String? moodEmoji;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MemoryEntry({
    required this.id,
    required this.petId,
    required this.occurredAt,
    required this.note,
    this.moodEmoji,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pet_id'] = Variable<String>(petId);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || moodEmoji != null) {
      map['mood_emoji'] = Variable<String>(moodEmoji);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MemoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return MemoryEntriesCompanion(
      id: Value(id),
      petId: Value(petId),
      occurredAt: Value(occurredAt),
      note: Value(note),
      moodEmoji: moodEmoji == null && nullToAbsent
          ? const Value.absent()
          : Value(moodEmoji),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MemoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryEntry(
      id: serializer.fromJson<String>(json['id']),
      petId: serializer.fromJson<String>(json['petId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      note: serializer.fromJson<String>(json['note']),
      moodEmoji: serializer.fromJson<String?>(json['moodEmoji']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'petId': serializer.toJson<String>(petId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'note': serializer.toJson<String>(note),
      'moodEmoji': serializer.toJson<String?>(moodEmoji),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MemoryEntry copyWith({
    String? id,
    String? petId,
    DateTime? occurredAt,
    String? note,
    Value<String?> moodEmoji = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MemoryEntry(
    id: id ?? this.id,
    petId: petId ?? this.petId,
    occurredAt: occurredAt ?? this.occurredAt,
    note: note ?? this.note,
    moodEmoji: moodEmoji.present ? moodEmoji.value : this.moodEmoji,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MemoryEntry copyWithCompanion(MemoryEntriesCompanion data) {
    return MemoryEntry(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      note: data.note.present ? data.note.value : this.note,
      moodEmoji: data.moodEmoji.present ? data.moodEmoji.value : this.moodEmoji,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryEntry(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('moodEmoji: $moodEmoji, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, petId, occurredAt, note, moodEmoji, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryEntry &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.occurredAt == this.occurredAt &&
          other.note == this.note &&
          other.moodEmoji == this.moodEmoji &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MemoryEntriesCompanion extends UpdateCompanion<MemoryEntry> {
  final Value<String> id;
  final Value<String> petId;
  final Value<DateTime> occurredAt;
  final Value<String> note;
  final Value<String?> moodEmoji;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MemoryEntriesCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.note = const Value.absent(),
    this.moodEmoji = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoryEntriesCompanion.insert({
    required String id,
    required String petId,
    required DateTime occurredAt,
    this.note = const Value.absent(),
    this.moodEmoji = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       petId = Value(petId),
       occurredAt = Value(occurredAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MemoryEntry> custom({
    Expression<String>? id,
    Expression<String>? petId,
    Expression<DateTime>? occurredAt,
    Expression<String>? note,
    Expression<String>? moodEmoji,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (note != null) 'note': note,
      if (moodEmoji != null) 'mood_emoji': moodEmoji,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoryEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? petId,
    Value<DateTime>? occurredAt,
    Value<String>? note,
    Value<String?>? moodEmoji,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MemoryEntriesCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      occurredAt: occurredAt ?? this.occurredAt,
      note: note ?? this.note,
      moodEmoji: moodEmoji ?? this.moodEmoji,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<String>(petId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (moodEmoji.present) {
      map['mood_emoji'] = Variable<String>(moodEmoji.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('moodEmoji: $moodEmoji, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemoryMediaRefsTable extends MemoryMediaRefs
    with TableInfo<$MemoryMediaRefsTable, MemoryMediaRef> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryMediaRefsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES memory_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformRefMeta = const VerificationMeta(
    'platformRef',
  );
  @override
  late final GeneratedColumn<String> platformRef = GeneratedColumn<String>(
    'platform_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entryId,
    kind,
    platformRef,
    position,
    width,
    height,
    durationMs,
    capturedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_media_refs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryMediaRef> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('platform_ref')) {
      context.handle(
        _platformRefMeta,
        platformRef.isAcceptableOrUnknown(
          data['platform_ref']!,
          _platformRefMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_platformRefMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryMediaRef map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryMediaRef(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      platformRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_ref'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      ),
    );
  }

  @override
  $MemoryMediaRefsTable createAlias(String alias) {
    return $MemoryMediaRefsTable(attachedDatabase, alias);
  }
}

class MemoryMediaRef extends DataClass implements Insertable<MemoryMediaRef> {
  final String id;
  final String entryId;
  final String kind;
  final String platformRef;
  final int position;
  final int? width;
  final int? height;
  final int? durationMs;
  final DateTime? capturedAt;
  const MemoryMediaRef({
    required this.id,
    required this.entryId,
    required this.kind,
    required this.platformRef,
    required this.position,
    this.width,
    this.height,
    this.durationMs,
    this.capturedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_id'] = Variable<String>(entryId);
    map['kind'] = Variable<String>(kind);
    map['platform_ref'] = Variable<String>(platformRef);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || capturedAt != null) {
      map['captured_at'] = Variable<DateTime>(capturedAt);
    }
    return map;
  }

  MemoryMediaRefsCompanion toCompanion(bool nullToAbsent) {
    return MemoryMediaRefsCompanion(
      id: Value(id),
      entryId: Value(entryId),
      kind: Value(kind),
      platformRef: Value(platformRef),
      position: Value(position),
      width: width == null && nullToAbsent
          ? const Value.absent()
          : Value(width),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      capturedAt: capturedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(capturedAt),
    );
  }

  factory MemoryMediaRef.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryMediaRef(
      id: serializer.fromJson<String>(json['id']),
      entryId: serializer.fromJson<String>(json['entryId']),
      kind: serializer.fromJson<String>(json['kind']),
      platformRef: serializer.fromJson<String>(json['platformRef']),
      position: serializer.fromJson<int>(json['position']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      capturedAt: serializer.fromJson<DateTime?>(json['capturedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entryId': serializer.toJson<String>(entryId),
      'kind': serializer.toJson<String>(kind),
      'platformRef': serializer.toJson<String>(platformRef),
      'position': serializer.toJson<int>(position),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'durationMs': serializer.toJson<int?>(durationMs),
      'capturedAt': serializer.toJson<DateTime?>(capturedAt),
    };
  }

  MemoryMediaRef copyWith({
    String? id,
    String? entryId,
    String? kind,
    String? platformRef,
    int? position,
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<DateTime?> capturedAt = const Value.absent(),
  }) => MemoryMediaRef(
    id: id ?? this.id,
    entryId: entryId ?? this.entryId,
    kind: kind ?? this.kind,
    platformRef: platformRef ?? this.platformRef,
    position: position ?? this.position,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    capturedAt: capturedAt.present ? capturedAt.value : this.capturedAt,
  );
  MemoryMediaRef copyWithCompanion(MemoryMediaRefsCompanion data) {
    return MemoryMediaRef(
      id: data.id.present ? data.id.value : this.id,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      kind: data.kind.present ? data.kind.value : this.kind,
      platformRef: data.platformRef.present
          ? data.platformRef.value
          : this.platformRef,
      position: data.position.present ? data.position.value : this.position,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryMediaRef(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('kind: $kind, ')
          ..write('platformRef: $platformRef, ')
          ..write('position: $position, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('durationMs: $durationMs, ')
          ..write('capturedAt: $capturedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entryId,
    kind,
    platformRef,
    position,
    width,
    height,
    durationMs,
    capturedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryMediaRef &&
          other.id == this.id &&
          other.entryId == this.entryId &&
          other.kind == this.kind &&
          other.platformRef == this.platformRef &&
          other.position == this.position &&
          other.width == this.width &&
          other.height == this.height &&
          other.durationMs == this.durationMs &&
          other.capturedAt == this.capturedAt);
}

class MemoryMediaRefsCompanion extends UpdateCompanion<MemoryMediaRef> {
  final Value<String> id;
  final Value<String> entryId;
  final Value<String> kind;
  final Value<String> platformRef;
  final Value<int> position;
  final Value<int?> width;
  final Value<int?> height;
  final Value<int?> durationMs;
  final Value<DateTime?> capturedAt;
  final Value<int> rowid;
  const MemoryMediaRefsCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.kind = const Value.absent(),
    this.platformRef = const Value.absent(),
    this.position = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoryMediaRefsCompanion.insert({
    required String id,
    required String entryId,
    required String kind,
    required String platformRef,
    required int position,
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entryId = Value(entryId),
       kind = Value(kind),
       platformRef = Value(platformRef),
       position = Value(position);
  static Insertable<MemoryMediaRef> custom({
    Expression<String>? id,
    Expression<String>? entryId,
    Expression<String>? kind,
    Expression<String>? platformRef,
    Expression<int>? position,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? durationMs,
    Expression<DateTime>? capturedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (kind != null) 'kind': kind,
      if (platformRef != null) 'platform_ref': platformRef,
      if (position != null) 'position': position,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (durationMs != null) 'duration_ms': durationMs,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoryMediaRefsCompanion copyWith({
    Value<String>? id,
    Value<String>? entryId,
    Value<String>? kind,
    Value<String>? platformRef,
    Value<int>? position,
    Value<int?>? width,
    Value<int?>? height,
    Value<int?>? durationMs,
    Value<DateTime?>? capturedAt,
    Value<int>? rowid,
  }) {
    return MemoryMediaRefsCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      kind: kind ?? this.kind,
      platformRef: platformRef ?? this.platformRef,
      position: position ?? this.position,
      width: width ?? this.width,
      height: height ?? this.height,
      durationMs: durationMs ?? this.durationMs,
      capturedAt: capturedAt ?? this.capturedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (platformRef.present) {
      map['platform_ref'] = Variable<String>(platformRef.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryMediaRefsCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('kind: $kind, ')
          ..write('platformRef: $platformRef, ')
          ..write('position: $position, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('durationMs: $durationMs, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CarePlansTable extends CarePlans
    with TableInfo<$CarePlansTable, CarePlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarePlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<String> petId = GeneratedColumn<String>(
    'pet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _candidateIdMeta = const VerificationMeta(
    'candidateId',
  );
  @override
  late final GeneratedColumn<String> candidateId = GeneratedColumn<String>(
    'candidate_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _careTypeMeta = const VerificationMeta(
    'careType',
  );
  @override
  late final GeneratedColumn<String> careType = GeneratedColumn<String>(
    'care_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduleRuleMeta = const VerificationMeta(
    'scheduleRule',
  );
  @override
  late final GeneratedColumn<String> scheduleRule = GeneratedColumn<String>(
    'schedule_rule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDueAtMeta = const VerificationMeta(
    'nextDueAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextDueAt = GeneratedColumn<DateTime>(
    'next_due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _pausedMeta = const VerificationMeta('paused');
  @override
  late final GeneratedColumn<bool> paused = GeneratedColumn<bool>(
    'paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reasonSnapshotMeta = const VerificationMeta(
    'reasonSnapshot',
  );
  @override
  late final GeneratedColumn<String> reasonSnapshot = GeneratedColumn<String>(
    'reason_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<String> ruleId = GeneratedColumn<String>(
    'rule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ruleVersionMeta = const VerificationMeta(
    'ruleVersion',
  );
  @override
  late final GeneratedColumn<String> ruleVersion = GeneratedColumn<String>(
    'rule_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    petId,
    candidateId,
    careType,
    title,
    scheduleRule,
    nextDueAt,
    enabled,
    paused,
    reasonSnapshot,
    ruleId,
    ruleVersion,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<CarePlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pet_id')) {
      context.handle(
        _petIdMeta,
        petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta),
      );
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('candidate_id')) {
      context.handle(
        _candidateIdMeta,
        candidateId.isAcceptableOrUnknown(
          data['candidate_id']!,
          _candidateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_candidateIdMeta);
    }
    if (data.containsKey('care_type')) {
      context.handle(
        _careTypeMeta,
        careType.isAcceptableOrUnknown(data['care_type']!, _careTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_careTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('schedule_rule')) {
      context.handle(
        _scheduleRuleMeta,
        scheduleRule.isAcceptableOrUnknown(
          data['schedule_rule']!,
          _scheduleRuleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduleRuleMeta);
    }
    if (data.containsKey('next_due_at')) {
      context.handle(
        _nextDueAtMeta,
        nextDueAt.isAcceptableOrUnknown(data['next_due_at']!, _nextDueAtMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('paused')) {
      context.handle(
        _pausedMeta,
        paused.isAcceptableOrUnknown(data['paused']!, _pausedMeta),
      );
    }
    if (data.containsKey('reason_snapshot')) {
      context.handle(
        _reasonSnapshotMeta,
        reasonSnapshot.isAcceptableOrUnknown(
          data['reason_snapshot']!,
          _reasonSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    }
    if (data.containsKey('rule_version')) {
      context.handle(
        _ruleVersionMeta,
        ruleVersion.isAcceptableOrUnknown(
          data['rule_version']!,
          _ruleVersionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CarePlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarePlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      petId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_id'],
      )!,
      candidateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidate_id'],
      )!,
      careType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}care_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      scheduleRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_rule'],
      )!,
      nextDueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_due_at'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      paused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paused'],
      )!,
      reasonSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_snapshot'],
      )!,
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_id'],
      ),
      ruleVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_version'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CarePlansTable createAlias(String alias) {
    return $CarePlansTable(attachedDatabase, alias);
  }
}

class CarePlan extends DataClass implements Insertable<CarePlan> {
  final String id;
  final String petId;
  final String candidateId;
  final String careType;
  final String title;
  final String scheduleRule;
  final DateTime? nextDueAt;
  final bool enabled;
  final bool paused;
  final String reasonSnapshot;
  final String? ruleId;
  final String? ruleVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CarePlan({
    required this.id,
    required this.petId,
    required this.candidateId,
    required this.careType,
    required this.title,
    required this.scheduleRule,
    this.nextDueAt,
    required this.enabled,
    required this.paused,
    required this.reasonSnapshot,
    this.ruleId,
    this.ruleVersion,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pet_id'] = Variable<String>(petId);
    map['candidate_id'] = Variable<String>(candidateId);
    map['care_type'] = Variable<String>(careType);
    map['title'] = Variable<String>(title);
    map['schedule_rule'] = Variable<String>(scheduleRule);
    if (!nullToAbsent || nextDueAt != null) {
      map['next_due_at'] = Variable<DateTime>(nextDueAt);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['paused'] = Variable<bool>(paused);
    map['reason_snapshot'] = Variable<String>(reasonSnapshot);
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<String>(ruleId);
    }
    if (!nullToAbsent || ruleVersion != null) {
      map['rule_version'] = Variable<String>(ruleVersion);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CarePlansCompanion toCompanion(bool nullToAbsent) {
    return CarePlansCompanion(
      id: Value(id),
      petId: Value(petId),
      candidateId: Value(candidateId),
      careType: Value(careType),
      title: Value(title),
      scheduleRule: Value(scheduleRule),
      nextDueAt: nextDueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDueAt),
      enabled: Value(enabled),
      paused: Value(paused),
      reasonSnapshot: Value(reasonSnapshot),
      ruleId: ruleId == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleId),
      ruleVersion: ruleVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleVersion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CarePlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarePlan(
      id: serializer.fromJson<String>(json['id']),
      petId: serializer.fromJson<String>(json['petId']),
      candidateId: serializer.fromJson<String>(json['candidateId']),
      careType: serializer.fromJson<String>(json['careType']),
      title: serializer.fromJson<String>(json['title']),
      scheduleRule: serializer.fromJson<String>(json['scheduleRule']),
      nextDueAt: serializer.fromJson<DateTime?>(json['nextDueAt']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      paused: serializer.fromJson<bool>(json['paused']),
      reasonSnapshot: serializer.fromJson<String>(json['reasonSnapshot']),
      ruleId: serializer.fromJson<String?>(json['ruleId']),
      ruleVersion: serializer.fromJson<String?>(json['ruleVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'petId': serializer.toJson<String>(petId),
      'candidateId': serializer.toJson<String>(candidateId),
      'careType': serializer.toJson<String>(careType),
      'title': serializer.toJson<String>(title),
      'scheduleRule': serializer.toJson<String>(scheduleRule),
      'nextDueAt': serializer.toJson<DateTime?>(nextDueAt),
      'enabled': serializer.toJson<bool>(enabled),
      'paused': serializer.toJson<bool>(paused),
      'reasonSnapshot': serializer.toJson<String>(reasonSnapshot),
      'ruleId': serializer.toJson<String?>(ruleId),
      'ruleVersion': serializer.toJson<String?>(ruleVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CarePlan copyWith({
    String? id,
    String? petId,
    String? candidateId,
    String? careType,
    String? title,
    String? scheduleRule,
    Value<DateTime?> nextDueAt = const Value.absent(),
    bool? enabled,
    bool? paused,
    String? reasonSnapshot,
    Value<String?> ruleId = const Value.absent(),
    Value<String?> ruleVersion = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CarePlan(
    id: id ?? this.id,
    petId: petId ?? this.petId,
    candidateId: candidateId ?? this.candidateId,
    careType: careType ?? this.careType,
    title: title ?? this.title,
    scheduleRule: scheduleRule ?? this.scheduleRule,
    nextDueAt: nextDueAt.present ? nextDueAt.value : this.nextDueAt,
    enabled: enabled ?? this.enabled,
    paused: paused ?? this.paused,
    reasonSnapshot: reasonSnapshot ?? this.reasonSnapshot,
    ruleId: ruleId.present ? ruleId.value : this.ruleId,
    ruleVersion: ruleVersion.present ? ruleVersion.value : this.ruleVersion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CarePlan copyWithCompanion(CarePlansCompanion data) {
    return CarePlan(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      candidateId: data.candidateId.present
          ? data.candidateId.value
          : this.candidateId,
      careType: data.careType.present ? data.careType.value : this.careType,
      title: data.title.present ? data.title.value : this.title,
      scheduleRule: data.scheduleRule.present
          ? data.scheduleRule.value
          : this.scheduleRule,
      nextDueAt: data.nextDueAt.present ? data.nextDueAt.value : this.nextDueAt,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      paused: data.paused.present ? data.paused.value : this.paused,
      reasonSnapshot: data.reasonSnapshot.present
          ? data.reasonSnapshot.value
          : this.reasonSnapshot,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      ruleVersion: data.ruleVersion.present
          ? data.ruleVersion.value
          : this.ruleVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarePlan(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('candidateId: $candidateId, ')
          ..write('careType: $careType, ')
          ..write('title: $title, ')
          ..write('scheduleRule: $scheduleRule, ')
          ..write('nextDueAt: $nextDueAt, ')
          ..write('enabled: $enabled, ')
          ..write('paused: $paused, ')
          ..write('reasonSnapshot: $reasonSnapshot, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleVersion: $ruleVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    petId,
    candidateId,
    careType,
    title,
    scheduleRule,
    nextDueAt,
    enabled,
    paused,
    reasonSnapshot,
    ruleId,
    ruleVersion,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarePlan &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.candidateId == this.candidateId &&
          other.careType == this.careType &&
          other.title == this.title &&
          other.scheduleRule == this.scheduleRule &&
          other.nextDueAt == this.nextDueAt &&
          other.enabled == this.enabled &&
          other.paused == this.paused &&
          other.reasonSnapshot == this.reasonSnapshot &&
          other.ruleId == this.ruleId &&
          other.ruleVersion == this.ruleVersion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CarePlansCompanion extends UpdateCompanion<CarePlan> {
  final Value<String> id;
  final Value<String> petId;
  final Value<String> candidateId;
  final Value<String> careType;
  final Value<String> title;
  final Value<String> scheduleRule;
  final Value<DateTime?> nextDueAt;
  final Value<bool> enabled;
  final Value<bool> paused;
  final Value<String> reasonSnapshot;
  final Value<String?> ruleId;
  final Value<String?> ruleVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CarePlansCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.candidateId = const Value.absent(),
    this.careType = const Value.absent(),
    this.title = const Value.absent(),
    this.scheduleRule = const Value.absent(),
    this.nextDueAt = const Value.absent(),
    this.enabled = const Value.absent(),
    this.paused = const Value.absent(),
    this.reasonSnapshot = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CarePlansCompanion.insert({
    required String id,
    required String petId,
    required String candidateId,
    required String careType,
    required String title,
    required String scheduleRule,
    this.nextDueAt = const Value.absent(),
    this.enabled = const Value.absent(),
    this.paused = const Value.absent(),
    this.reasonSnapshot = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleVersion = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       petId = Value(petId),
       candidateId = Value(candidateId),
       careType = Value(careType),
       title = Value(title),
       scheduleRule = Value(scheduleRule),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CarePlan> custom({
    Expression<String>? id,
    Expression<String>? petId,
    Expression<String>? candidateId,
    Expression<String>? careType,
    Expression<String>? title,
    Expression<String>? scheduleRule,
    Expression<DateTime>? nextDueAt,
    Expression<bool>? enabled,
    Expression<bool>? paused,
    Expression<String>? reasonSnapshot,
    Expression<String>? ruleId,
    Expression<String>? ruleVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (candidateId != null) 'candidate_id': candidateId,
      if (careType != null) 'care_type': careType,
      if (title != null) 'title': title,
      if (scheduleRule != null) 'schedule_rule': scheduleRule,
      if (nextDueAt != null) 'next_due_at': nextDueAt,
      if (enabled != null) 'enabled': enabled,
      if (paused != null) 'paused': paused,
      if (reasonSnapshot != null) 'reason_snapshot': reasonSnapshot,
      if (ruleId != null) 'rule_id': ruleId,
      if (ruleVersion != null) 'rule_version': ruleVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CarePlansCompanion copyWith({
    Value<String>? id,
    Value<String>? petId,
    Value<String>? candidateId,
    Value<String>? careType,
    Value<String>? title,
    Value<String>? scheduleRule,
    Value<DateTime?>? nextDueAt,
    Value<bool>? enabled,
    Value<bool>? paused,
    Value<String>? reasonSnapshot,
    Value<String?>? ruleId,
    Value<String?>? ruleVersion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CarePlansCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      candidateId: candidateId ?? this.candidateId,
      careType: careType ?? this.careType,
      title: title ?? this.title,
      scheduleRule: scheduleRule ?? this.scheduleRule,
      nextDueAt: nextDueAt ?? this.nextDueAt,
      enabled: enabled ?? this.enabled,
      paused: paused ?? this.paused,
      reasonSnapshot: reasonSnapshot ?? this.reasonSnapshot,
      ruleId: ruleId ?? this.ruleId,
      ruleVersion: ruleVersion ?? this.ruleVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<String>(petId.value);
    }
    if (candidateId.present) {
      map['candidate_id'] = Variable<String>(candidateId.value);
    }
    if (careType.present) {
      map['care_type'] = Variable<String>(careType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (scheduleRule.present) {
      map['schedule_rule'] = Variable<String>(scheduleRule.value);
    }
    if (nextDueAt.present) {
      map['next_due_at'] = Variable<DateTime>(nextDueAt.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (paused.present) {
      map['paused'] = Variable<bool>(paused.value);
    }
    if (reasonSnapshot.present) {
      map['reason_snapshot'] = Variable<String>(reasonSnapshot.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<String>(ruleId.value);
    }
    if (ruleVersion.present) {
      map['rule_version'] = Variable<String>(ruleVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarePlansCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('candidateId: $candidateId, ')
          ..write('careType: $careType, ')
          ..write('title: $title, ')
          ..write('scheduleRule: $scheduleRule, ')
          ..write('nextDueAt: $nextDueAt, ')
          ..write('enabled: $enabled, ')
          ..write('paused: $paused, ')
          ..write('reasonSnapshot: $reasonSnapshot, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleVersion: $ruleVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CarePlanLogsTable extends CarePlanLogs
    with TableInfo<$CarePlanLogsTable, CarePlanLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarePlanLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES care_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<String> petId = GeneratedColumn<String>(
    'pet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    petId,
    occurredAt,
    action,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_plan_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CarePlanLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('pet_id')) {
      context.handle(
        _petIdMeta,
        petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta),
      );
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CarePlanLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarePlanLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      petId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CarePlanLogsTable createAlias(String alias) {
    return $CarePlanLogsTable(attachedDatabase, alias);
  }
}

class CarePlanLog extends DataClass implements Insertable<CarePlanLog> {
  final String id;
  final String planId;
  final String petId;
  final DateTime occurredAt;
  final String action;
  final String note;
  final DateTime createdAt;
  const CarePlanLog({
    required this.id,
    required this.planId,
    required this.petId,
    required this.occurredAt,
    required this.action,
    required this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_id'] = Variable<String>(planId);
    map['pet_id'] = Variable<String>(petId);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['action'] = Variable<String>(action);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CarePlanLogsCompanion toCompanion(bool nullToAbsent) {
    return CarePlanLogsCompanion(
      id: Value(id),
      planId: Value(planId),
      petId: Value(petId),
      occurredAt: Value(occurredAt),
      action: Value(action),
      note: Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory CarePlanLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarePlanLog(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      petId: serializer.fromJson<String>(json['petId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      action: serializer.fromJson<String>(json['action']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String>(planId),
      'petId': serializer.toJson<String>(petId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'action': serializer.toJson<String>(action),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CarePlanLog copyWith({
    String? id,
    String? planId,
    String? petId,
    DateTime? occurredAt,
    String? action,
    String? note,
    DateTime? createdAt,
  }) => CarePlanLog(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    petId: petId ?? this.petId,
    occurredAt: occurredAt ?? this.occurredAt,
    action: action ?? this.action,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  CarePlanLog copyWithCompanion(CarePlanLogsCompanion data) {
    return CarePlanLog(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      petId: data.petId.present ? data.petId.value : this.petId,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      action: data.action.present ? data.action.value : this.action,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarePlanLog(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('petId: $petId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('action: $action, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, planId, petId, occurredAt, action, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarePlanLog &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.petId == this.petId &&
          other.occurredAt == this.occurredAt &&
          other.action == this.action &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class CarePlanLogsCompanion extends UpdateCompanion<CarePlanLog> {
  final Value<String> id;
  final Value<String> planId;
  final Value<String> petId;
  final Value<DateTime> occurredAt;
  final Value<String> action;
  final Value<String> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CarePlanLogsCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.petId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.action = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CarePlanLogsCompanion.insert({
    required String id,
    required String planId,
    required String petId,
    required DateTime occurredAt,
    required String action,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       planId = Value(planId),
       petId = Value(petId),
       occurredAt = Value(occurredAt),
       action = Value(action),
       createdAt = Value(createdAt);
  static Insertable<CarePlanLog> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<String>? petId,
    Expression<DateTime>? occurredAt,
    Expression<String>? action,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (petId != null) 'pet_id': petId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (action != null) 'action': action,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CarePlanLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? planId,
    Value<String>? petId,
    Value<DateTime>? occurredAt,
    Value<String>? action,
    Value<String>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CarePlanLogsCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      petId: petId ?? this.petId,
      occurredAt: occurredAt ?? this.occurredAt,
      action: action ?? this.action,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<String>(petId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarePlanLogsCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('petId: $petId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('action: $action, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<String> petId = GeneratedColumn<String>(
    'pet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatRuleMeta = const VerificationMeta(
    'repeatRule',
  );
  @override
  late final GeneratedColumn<String> repeatRule = GeneratedColumn<String>(
    'repeat_rule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completionModeMeta = const VerificationMeta(
    'completionMode',
  );
  @override
  late final GeneratedColumn<String> completionMode = GeneratedColumn<String>(
    'completion_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _completionTargetMeta = const VerificationMeta(
    'completionTarget',
  );
  @override
  late final GeneratedColumn<String> completionTarget = GeneratedColumn<String>(
    'completion_target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('health'),
  );
  static const VerificationMeta _recordTypeMeta = const VerificationMeta(
    'recordType',
  );
  @override
  late final GeneratedColumn<String> recordType = GeneratedColumn<String>(
    'record_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordTitleMeta = const VerificationMeta(
    'recordTitle',
  );
  @override
  late final GeneratedColumn<String> recordTitle = GeneratedColumn<String>(
    'record_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordNumericValueMeta =
      const VerificationMeta('recordNumericValue');
  @override
  late final GeneratedColumn<double> recordNumericValue =
      GeneratedColumn<double>(
        'record_numeric_value',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _recordUnitMeta = const VerificationMeta(
    'recordUnit',
  );
  @override
  late final GeneratedColumn<String> recordUnit = GeneratedColumn<String>(
    'record_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordNoteMeta = const VerificationMeta(
    'recordNote',
  );
  @override
  late final GeneratedColumn<String> recordNote = GeneratedColumn<String>(
    'record_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _recordDetailsJsonMeta = const VerificationMeta(
    'recordDetailsJson',
  );
  @override
  late final GeneratedColumn<String> recordDetailsJson =
      GeneratedColumn<String>(
        'record_details_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _careTypeMeta = const VerificationMeta(
    'careType',
  );
  @override
  late final GeneratedColumn<String> careType = GeneratedColumn<String>(
    'care_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carePlaceMeta = const VerificationMeta(
    'carePlace',
  );
  @override
  late final GeneratedColumn<String> carePlace = GeneratedColumn<String>(
    'care_place',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _careNoteMeta = const VerificationMeta(
    'careNote',
  );
  @override
  late final GeneratedColumn<String> careNote = GeneratedColumn<String>(
    'care_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _careDetailsJsonMeta = const VerificationMeta(
    'careDetailsJson',
  );
  @override
  late final GeneratedColumn<String> careDetailsJson = GeneratedColumn<String>(
    'care_details_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _pausedMeta = const VerificationMeta('paused');
  @override
  late final GeneratedColumn<bool> paused = GeneratedColumn<bool>(
    'paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    petId,
    sourceType,
    sourceId,
    title,
    scheduledAt,
    repeatRule,
    notificationId,
    completionMode,
    completionTarget,
    recordType,
    recordTitle,
    recordNumericValue,
    recordUnit,
    recordNote,
    recordDetailsJson,
    careType,
    carePlace,
    careNote,
    careDetailsJson,
    enabled,
    paused,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pet_id')) {
      context.handle(
        _petIdMeta,
        petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta),
      );
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('repeat_rule')) {
      context.handle(
        _repeatRuleMeta,
        repeatRule.isAcceptableOrUnknown(data['repeat_rule']!, _repeatRuleMeta),
      );
    }
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    }
    if (data.containsKey('completion_mode')) {
      context.handle(
        _completionModeMeta,
        completionMode.isAcceptableOrUnknown(
          data['completion_mode']!,
          _completionModeMeta,
        ),
      );
    }
    if (data.containsKey('completion_target')) {
      context.handle(
        _completionTargetMeta,
        completionTarget.isAcceptableOrUnknown(
          data['completion_target']!,
          _completionTargetMeta,
        ),
      );
    }
    if (data.containsKey('record_type')) {
      context.handle(
        _recordTypeMeta,
        recordType.isAcceptableOrUnknown(data['record_type']!, _recordTypeMeta),
      );
    }
    if (data.containsKey('record_title')) {
      context.handle(
        _recordTitleMeta,
        recordTitle.isAcceptableOrUnknown(
          data['record_title']!,
          _recordTitleMeta,
        ),
      );
    }
    if (data.containsKey('record_numeric_value')) {
      context.handle(
        _recordNumericValueMeta,
        recordNumericValue.isAcceptableOrUnknown(
          data['record_numeric_value']!,
          _recordNumericValueMeta,
        ),
      );
    }
    if (data.containsKey('record_unit')) {
      context.handle(
        _recordUnitMeta,
        recordUnit.isAcceptableOrUnknown(data['record_unit']!, _recordUnitMeta),
      );
    }
    if (data.containsKey('record_note')) {
      context.handle(
        _recordNoteMeta,
        recordNote.isAcceptableOrUnknown(data['record_note']!, _recordNoteMeta),
      );
    }
    if (data.containsKey('record_details_json')) {
      context.handle(
        _recordDetailsJsonMeta,
        recordDetailsJson.isAcceptableOrUnknown(
          data['record_details_json']!,
          _recordDetailsJsonMeta,
        ),
      );
    }
    if (data.containsKey('care_type')) {
      context.handle(
        _careTypeMeta,
        careType.isAcceptableOrUnknown(data['care_type']!, _careTypeMeta),
      );
    }
    if (data.containsKey('care_place')) {
      context.handle(
        _carePlaceMeta,
        carePlace.isAcceptableOrUnknown(data['care_place']!, _carePlaceMeta),
      );
    }
    if (data.containsKey('care_note')) {
      context.handle(
        _careNoteMeta,
        careNote.isAcceptableOrUnknown(data['care_note']!, _careNoteMeta),
      );
    }
    if (data.containsKey('care_details_json')) {
      context.handle(
        _careDetailsJsonMeta,
        careDetailsJson.isAcceptableOrUnknown(
          data['care_details_json']!,
          _careDetailsJsonMeta,
        ),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('paused')) {
      context.handle(
        _pausedMeta,
        paused.isAcceptableOrUnknown(data['paused']!, _pausedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      petId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_id'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      repeatRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_rule'],
      ),
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      ),
      completionMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion_mode'],
      )!,
      completionTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion_target'],
      )!,
      recordType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_type'],
      ),
      recordTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_title'],
      ),
      recordNumericValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}record_numeric_value'],
      ),
      recordUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_unit'],
      ),
      recordNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_note'],
      )!,
      recordDetailsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_details_json'],
      )!,
      careType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}care_type'],
      ),
      carePlace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}care_place'],
      )!,
      careNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}care_note'],
      )!,
      careDetailsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}care_details_json'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      paused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paused'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String petId;
  final String sourceType;
  final String? sourceId;
  final String title;
  final DateTime scheduledAt;
  final String? repeatRule;
  final int? notificationId;
  final String completionMode;
  final String completionTarget;
  final String? recordType;
  final String? recordTitle;
  final double? recordNumericValue;
  final String? recordUnit;
  final String recordNote;
  final String recordDetailsJson;
  final String? careType;
  final String carePlace;
  final String careNote;
  final String careDetailsJson;
  final bool enabled;
  final bool paused;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Reminder({
    required this.id,
    required this.petId,
    required this.sourceType,
    this.sourceId,
    required this.title,
    required this.scheduledAt,
    this.repeatRule,
    this.notificationId,
    required this.completionMode,
    required this.completionTarget,
    this.recordType,
    this.recordTitle,
    this.recordNumericValue,
    this.recordUnit,
    required this.recordNote,
    required this.recordDetailsJson,
    this.careType,
    required this.carePlace,
    required this.careNote,
    required this.careDetailsJson,
    required this.enabled,
    required this.paused,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pet_id'] = Variable<String>(petId);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    map['title'] = Variable<String>(title);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || repeatRule != null) {
      map['repeat_rule'] = Variable<String>(repeatRule);
    }
    if (!nullToAbsent || notificationId != null) {
      map['notification_id'] = Variable<int>(notificationId);
    }
    map['completion_mode'] = Variable<String>(completionMode);
    map['completion_target'] = Variable<String>(completionTarget);
    if (!nullToAbsent || recordType != null) {
      map['record_type'] = Variable<String>(recordType);
    }
    if (!nullToAbsent || recordTitle != null) {
      map['record_title'] = Variable<String>(recordTitle);
    }
    if (!nullToAbsent || recordNumericValue != null) {
      map['record_numeric_value'] = Variable<double>(recordNumericValue);
    }
    if (!nullToAbsent || recordUnit != null) {
      map['record_unit'] = Variable<String>(recordUnit);
    }
    map['record_note'] = Variable<String>(recordNote);
    map['record_details_json'] = Variable<String>(recordDetailsJson);
    if (!nullToAbsent || careType != null) {
      map['care_type'] = Variable<String>(careType);
    }
    map['care_place'] = Variable<String>(carePlace);
    map['care_note'] = Variable<String>(careNote);
    map['care_details_json'] = Variable<String>(careDetailsJson);
    map['enabled'] = Variable<bool>(enabled);
    map['paused'] = Variable<bool>(paused);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      petId: Value(petId),
      sourceType: Value(sourceType),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      title: Value(title),
      scheduledAt: Value(scheduledAt),
      repeatRule: repeatRule == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatRule),
      notificationId: notificationId == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationId),
      completionMode: Value(completionMode),
      completionTarget: Value(completionTarget),
      recordType: recordType == null && nullToAbsent
          ? const Value.absent()
          : Value(recordType),
      recordTitle: recordTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(recordTitle),
      recordNumericValue: recordNumericValue == null && nullToAbsent
          ? const Value.absent()
          : Value(recordNumericValue),
      recordUnit: recordUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(recordUnit),
      recordNote: Value(recordNote),
      recordDetailsJson: Value(recordDetailsJson),
      careType: careType == null && nullToAbsent
          ? const Value.absent()
          : Value(careType),
      carePlace: Value(carePlace),
      careNote: Value(careNote),
      careDetailsJson: Value(careDetailsJson),
      enabled: Value(enabled),
      paused: Value(paused),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      petId: serializer.fromJson<String>(json['petId']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      title: serializer.fromJson<String>(json['title']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      repeatRule: serializer.fromJson<String?>(json['repeatRule']),
      notificationId: serializer.fromJson<int?>(json['notificationId']),
      completionMode: serializer.fromJson<String>(json['completionMode']),
      completionTarget: serializer.fromJson<String>(json['completionTarget']),
      recordType: serializer.fromJson<String?>(json['recordType']),
      recordTitle: serializer.fromJson<String?>(json['recordTitle']),
      recordNumericValue: serializer.fromJson<double?>(
        json['recordNumericValue'],
      ),
      recordUnit: serializer.fromJson<String?>(json['recordUnit']),
      recordNote: serializer.fromJson<String>(json['recordNote']),
      recordDetailsJson: serializer.fromJson<String>(json['recordDetailsJson']),
      careType: serializer.fromJson<String?>(json['careType']),
      carePlace: serializer.fromJson<String>(json['carePlace']),
      careNote: serializer.fromJson<String>(json['careNote']),
      careDetailsJson: serializer.fromJson<String>(json['careDetailsJson']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      paused: serializer.fromJson<bool>(json['paused']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'petId': serializer.toJson<String>(petId),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String?>(sourceId),
      'title': serializer.toJson<String>(title),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'repeatRule': serializer.toJson<String?>(repeatRule),
      'notificationId': serializer.toJson<int?>(notificationId),
      'completionMode': serializer.toJson<String>(completionMode),
      'completionTarget': serializer.toJson<String>(completionTarget),
      'recordType': serializer.toJson<String?>(recordType),
      'recordTitle': serializer.toJson<String?>(recordTitle),
      'recordNumericValue': serializer.toJson<double?>(recordNumericValue),
      'recordUnit': serializer.toJson<String?>(recordUnit),
      'recordNote': serializer.toJson<String>(recordNote),
      'recordDetailsJson': serializer.toJson<String>(recordDetailsJson),
      'careType': serializer.toJson<String?>(careType),
      'carePlace': serializer.toJson<String>(carePlace),
      'careNote': serializer.toJson<String>(careNote),
      'careDetailsJson': serializer.toJson<String>(careDetailsJson),
      'enabled': serializer.toJson<bool>(enabled),
      'paused': serializer.toJson<bool>(paused),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Reminder copyWith({
    String? id,
    String? petId,
    String? sourceType,
    Value<String?> sourceId = const Value.absent(),
    String? title,
    DateTime? scheduledAt,
    Value<String?> repeatRule = const Value.absent(),
    Value<int?> notificationId = const Value.absent(),
    String? completionMode,
    String? completionTarget,
    Value<String?> recordType = const Value.absent(),
    Value<String?> recordTitle = const Value.absent(),
    Value<double?> recordNumericValue = const Value.absent(),
    Value<String?> recordUnit = const Value.absent(),
    String? recordNote,
    String? recordDetailsJson,
    Value<String?> careType = const Value.absent(),
    String? carePlace,
    String? careNote,
    String? careDetailsJson,
    bool? enabled,
    bool? paused,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Reminder(
    id: id ?? this.id,
    petId: petId ?? this.petId,
    sourceType: sourceType ?? this.sourceType,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    title: title ?? this.title,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    repeatRule: repeatRule.present ? repeatRule.value : this.repeatRule,
    notificationId: notificationId.present
        ? notificationId.value
        : this.notificationId,
    completionMode: completionMode ?? this.completionMode,
    completionTarget: completionTarget ?? this.completionTarget,
    recordType: recordType.present ? recordType.value : this.recordType,
    recordTitle: recordTitle.present ? recordTitle.value : this.recordTitle,
    recordNumericValue: recordNumericValue.present
        ? recordNumericValue.value
        : this.recordNumericValue,
    recordUnit: recordUnit.present ? recordUnit.value : this.recordUnit,
    recordNote: recordNote ?? this.recordNote,
    recordDetailsJson: recordDetailsJson ?? this.recordDetailsJson,
    careType: careType.present ? careType.value : this.careType,
    carePlace: carePlace ?? this.carePlace,
    careNote: careNote ?? this.careNote,
    careDetailsJson: careDetailsJson ?? this.careDetailsJson,
    enabled: enabled ?? this.enabled,
    paused: paused ?? this.paused,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      title: data.title.present ? data.title.value : this.title,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      repeatRule: data.repeatRule.present
          ? data.repeatRule.value
          : this.repeatRule,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      completionMode: data.completionMode.present
          ? data.completionMode.value
          : this.completionMode,
      completionTarget: data.completionTarget.present
          ? data.completionTarget.value
          : this.completionTarget,
      recordType: data.recordType.present
          ? data.recordType.value
          : this.recordType,
      recordTitle: data.recordTitle.present
          ? data.recordTitle.value
          : this.recordTitle,
      recordNumericValue: data.recordNumericValue.present
          ? data.recordNumericValue.value
          : this.recordNumericValue,
      recordUnit: data.recordUnit.present
          ? data.recordUnit.value
          : this.recordUnit,
      recordNote: data.recordNote.present
          ? data.recordNote.value
          : this.recordNote,
      recordDetailsJson: data.recordDetailsJson.present
          ? data.recordDetailsJson.value
          : this.recordDetailsJson,
      careType: data.careType.present ? data.careType.value : this.careType,
      carePlace: data.carePlace.present ? data.carePlace.value : this.carePlace,
      careNote: data.careNote.present ? data.careNote.value : this.careNote,
      careDetailsJson: data.careDetailsJson.present
          ? data.careDetailsJson.value
          : this.careDetailsJson,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      paused: data.paused.present ? data.paused.value : this.paused,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('notificationId: $notificationId, ')
          ..write('completionMode: $completionMode, ')
          ..write('completionTarget: $completionTarget, ')
          ..write('recordType: $recordType, ')
          ..write('recordTitle: $recordTitle, ')
          ..write('recordNumericValue: $recordNumericValue, ')
          ..write('recordUnit: $recordUnit, ')
          ..write('recordNote: $recordNote, ')
          ..write('recordDetailsJson: $recordDetailsJson, ')
          ..write('careType: $careType, ')
          ..write('carePlace: $carePlace, ')
          ..write('careNote: $careNote, ')
          ..write('careDetailsJson: $careDetailsJson, ')
          ..write('enabled: $enabled, ')
          ..write('paused: $paused, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    petId,
    sourceType,
    sourceId,
    title,
    scheduledAt,
    repeatRule,
    notificationId,
    completionMode,
    completionTarget,
    recordType,
    recordTitle,
    recordNumericValue,
    recordUnit,
    recordNote,
    recordDetailsJson,
    careType,
    carePlace,
    careNote,
    careDetailsJson,
    enabled,
    paused,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.title == this.title &&
          other.scheduledAt == this.scheduledAt &&
          other.repeatRule == this.repeatRule &&
          other.notificationId == this.notificationId &&
          other.completionMode == this.completionMode &&
          other.completionTarget == this.completionTarget &&
          other.recordType == this.recordType &&
          other.recordTitle == this.recordTitle &&
          other.recordNumericValue == this.recordNumericValue &&
          other.recordUnit == this.recordUnit &&
          other.recordNote == this.recordNote &&
          other.recordDetailsJson == this.recordDetailsJson &&
          other.careType == this.careType &&
          other.carePlace == this.carePlace &&
          other.careNote == this.careNote &&
          other.careDetailsJson == this.careDetailsJson &&
          other.enabled == this.enabled &&
          other.paused == this.paused &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> petId;
  final Value<String> sourceType;
  final Value<String?> sourceId;
  final Value<String> title;
  final Value<DateTime> scheduledAt;
  final Value<String?> repeatRule;
  final Value<int?> notificationId;
  final Value<String> completionMode;
  final Value<String> completionTarget;
  final Value<String?> recordType;
  final Value<String?> recordTitle;
  final Value<double?> recordNumericValue;
  final Value<String?> recordUnit;
  final Value<String> recordNote;
  final Value<String> recordDetailsJson;
  final Value<String?> careType;
  final Value<String> carePlace;
  final Value<String> careNote;
  final Value<String> careDetailsJson;
  final Value<bool> enabled;
  final Value<bool> paused;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.title = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.completionMode = const Value.absent(),
    this.completionTarget = const Value.absent(),
    this.recordType = const Value.absent(),
    this.recordTitle = const Value.absent(),
    this.recordNumericValue = const Value.absent(),
    this.recordUnit = const Value.absent(),
    this.recordNote = const Value.absent(),
    this.recordDetailsJson = const Value.absent(),
    this.careType = const Value.absent(),
    this.carePlace = const Value.absent(),
    this.careNote = const Value.absent(),
    this.careDetailsJson = const Value.absent(),
    this.enabled = const Value.absent(),
    this.paused = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String petId,
    required String sourceType,
    this.sourceId = const Value.absent(),
    required String title,
    required DateTime scheduledAt,
    this.repeatRule = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.completionMode = const Value.absent(),
    this.completionTarget = const Value.absent(),
    this.recordType = const Value.absent(),
    this.recordTitle = const Value.absent(),
    this.recordNumericValue = const Value.absent(),
    this.recordUnit = const Value.absent(),
    this.recordNote = const Value.absent(),
    this.recordDetailsJson = const Value.absent(),
    this.careType = const Value.absent(),
    this.carePlace = const Value.absent(),
    this.careNote = const Value.absent(),
    this.careDetailsJson = const Value.absent(),
    this.enabled = const Value.absent(),
    this.paused = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       petId = Value(petId),
       sourceType = Value(sourceType),
       title = Value(title),
       scheduledAt = Value(scheduledAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? petId,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<String>? title,
    Expression<DateTime>? scheduledAt,
    Expression<String>? repeatRule,
    Expression<int>? notificationId,
    Expression<String>? completionMode,
    Expression<String>? completionTarget,
    Expression<String>? recordType,
    Expression<String>? recordTitle,
    Expression<double>? recordNumericValue,
    Expression<String>? recordUnit,
    Expression<String>? recordNote,
    Expression<String>? recordDetailsJson,
    Expression<String>? careType,
    Expression<String>? carePlace,
    Expression<String>? careNote,
    Expression<String>? careDetailsJson,
    Expression<bool>? enabled,
    Expression<bool>? paused,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (title != null) 'title': title,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (repeatRule != null) 'repeat_rule': repeatRule,
      if (notificationId != null) 'notification_id': notificationId,
      if (completionMode != null) 'completion_mode': completionMode,
      if (completionTarget != null) 'completion_target': completionTarget,
      if (recordType != null) 'record_type': recordType,
      if (recordTitle != null) 'record_title': recordTitle,
      if (recordNumericValue != null)
        'record_numeric_value': recordNumericValue,
      if (recordUnit != null) 'record_unit': recordUnit,
      if (recordNote != null) 'record_note': recordNote,
      if (recordDetailsJson != null) 'record_details_json': recordDetailsJson,
      if (careType != null) 'care_type': careType,
      if (carePlace != null) 'care_place': carePlace,
      if (careNote != null) 'care_note': careNote,
      if (careDetailsJson != null) 'care_details_json': careDetailsJson,
      if (enabled != null) 'enabled': enabled,
      if (paused != null) 'paused': paused,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? petId,
    Value<String>? sourceType,
    Value<String?>? sourceId,
    Value<String>? title,
    Value<DateTime>? scheduledAt,
    Value<String?>? repeatRule,
    Value<int?>? notificationId,
    Value<String>? completionMode,
    Value<String>? completionTarget,
    Value<String?>? recordType,
    Value<String?>? recordTitle,
    Value<double?>? recordNumericValue,
    Value<String?>? recordUnit,
    Value<String>? recordNote,
    Value<String>? recordDetailsJson,
    Value<String?>? careType,
    Value<String>? carePlace,
    Value<String>? careNote,
    Value<String>? careDetailsJson,
    Value<bool>? enabled,
    Value<bool>? paused,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      repeatRule: repeatRule ?? this.repeatRule,
      notificationId: notificationId ?? this.notificationId,
      completionMode: completionMode ?? this.completionMode,
      completionTarget: completionTarget ?? this.completionTarget,
      recordType: recordType ?? this.recordType,
      recordTitle: recordTitle ?? this.recordTitle,
      recordNumericValue: recordNumericValue ?? this.recordNumericValue,
      recordUnit: recordUnit ?? this.recordUnit,
      recordNote: recordNote ?? this.recordNote,
      recordDetailsJson: recordDetailsJson ?? this.recordDetailsJson,
      careType: careType ?? this.careType,
      carePlace: carePlace ?? this.carePlace,
      careNote: careNote ?? this.careNote,
      careDetailsJson: careDetailsJson ?? this.careDetailsJson,
      enabled: enabled ?? this.enabled,
      paused: paused ?? this.paused,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<String>(petId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (repeatRule.present) {
      map['repeat_rule'] = Variable<String>(repeatRule.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (completionMode.present) {
      map['completion_mode'] = Variable<String>(completionMode.value);
    }
    if (completionTarget.present) {
      map['completion_target'] = Variable<String>(completionTarget.value);
    }
    if (recordType.present) {
      map['record_type'] = Variable<String>(recordType.value);
    }
    if (recordTitle.present) {
      map['record_title'] = Variable<String>(recordTitle.value);
    }
    if (recordNumericValue.present) {
      map['record_numeric_value'] = Variable<double>(recordNumericValue.value);
    }
    if (recordUnit.present) {
      map['record_unit'] = Variable<String>(recordUnit.value);
    }
    if (recordNote.present) {
      map['record_note'] = Variable<String>(recordNote.value);
    }
    if (recordDetailsJson.present) {
      map['record_details_json'] = Variable<String>(recordDetailsJson.value);
    }
    if (careType.present) {
      map['care_type'] = Variable<String>(careType.value);
    }
    if (carePlace.present) {
      map['care_place'] = Variable<String>(carePlace.value);
    }
    if (careNote.present) {
      map['care_note'] = Variable<String>(careNote.value);
    }
    if (careDetailsJson.present) {
      map['care_details_json'] = Variable<String>(careDetailsJson.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (paused.present) {
      map['paused'] = Variable<bool>(paused.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('notificationId: $notificationId, ')
          ..write('completionMode: $completionMode, ')
          ..write('completionTarget: $completionTarget, ')
          ..write('recordType: $recordType, ')
          ..write('recordTitle: $recordTitle, ')
          ..write('recordNumericValue: $recordNumericValue, ')
          ..write('recordUnit: $recordUnit, ')
          ..write('recordNote: $recordNote, ')
          ..write('recordDetailsJson: $recordDetailsJson, ')
          ..write('careType: $careType, ')
          ..write('carePlace: $carePlace, ')
          ..write('careNote: $careNote, ')
          ..write('careDetailsJson: $careDetailsJson, ')
          ..write('enabled: $enabled, ')
          ..write('paused: $paused, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderLogsTable extends ReminderLogs
    with TableInfo<$ReminderLogsTable, ReminderLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderIdMeta = const VerificationMeta(
    'reminderId',
  );
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
    'reminder_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reminders (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reminderId,
    occurredAt,
    action,
    result,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
        _reminderIdMeta,
        reminderId.isAcceptableOrUnknown(data['reminder_id']!, _reminderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reminderIdMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      reminderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReminderLogsTable createAlias(String alias) {
    return $ReminderLogsTable(attachedDatabase, alias);
  }
}

class ReminderLog extends DataClass implements Insertable<ReminderLog> {
  final String id;
  final String reminderId;
  final DateTime occurredAt;
  final String action;
  final String result;
  final DateTime createdAt;
  const ReminderLog({
    required this.id,
    required this.reminderId,
    required this.occurredAt,
    required this.action,
    required this.result,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['reminder_id'] = Variable<String>(reminderId);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['action'] = Variable<String>(action);
    map['result'] = Variable<String>(result);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReminderLogsCompanion toCompanion(bool nullToAbsent) {
    return ReminderLogsCompanion(
      id: Value(id),
      reminderId: Value(reminderId),
      occurredAt: Value(occurredAt),
      action: Value(action),
      result: Value(result),
      createdAt: Value(createdAt),
    );
  }

  factory ReminderLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderLog(
      id: serializer.fromJson<String>(json['id']),
      reminderId: serializer.fromJson<String>(json['reminderId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      action: serializer.fromJson<String>(json['action']),
      result: serializer.fromJson<String>(json['result']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reminderId': serializer.toJson<String>(reminderId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'action': serializer.toJson<String>(action),
      'result': serializer.toJson<String>(result),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReminderLog copyWith({
    String? id,
    String? reminderId,
    DateTime? occurredAt,
    String? action,
    String? result,
    DateTime? createdAt,
  }) => ReminderLog(
    id: id ?? this.id,
    reminderId: reminderId ?? this.reminderId,
    occurredAt: occurredAt ?? this.occurredAt,
    action: action ?? this.action,
    result: result ?? this.result,
    createdAt: createdAt ?? this.createdAt,
  );
  ReminderLog copyWithCompanion(ReminderLogsCompanion data) {
    return ReminderLog(
      id: data.id.present ? data.id.value : this.id,
      reminderId: data.reminderId.present
          ? data.reminderId.value
          : this.reminderId,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      action: data.action.present ? data.action.value : this.action,
      result: data.result.present ? data.result.value : this.result,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderLog(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('action: $action, ')
          ..write('result: $result, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, reminderId, occurredAt, action, result, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderLog &&
          other.id == this.id &&
          other.reminderId == this.reminderId &&
          other.occurredAt == this.occurredAt &&
          other.action == this.action &&
          other.result == this.result &&
          other.createdAt == this.createdAt);
}

class ReminderLogsCompanion extends UpdateCompanion<ReminderLog> {
  final Value<String> id;
  final Value<String> reminderId;
  final Value<DateTime> occurredAt;
  final Value<String> action;
  final Value<String> result;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReminderLogsCompanion({
    this.id = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.action = const Value.absent(),
    this.result = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderLogsCompanion.insert({
    required String id,
    required String reminderId,
    required DateTime occurredAt,
    required String action,
    this.result = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       reminderId = Value(reminderId),
       occurredAt = Value(occurredAt),
       action = Value(action),
       createdAt = Value(createdAt);
  static Insertable<ReminderLog> custom({
    Expression<String>? id,
    Expression<String>? reminderId,
    Expression<DateTime>? occurredAt,
    Expression<String>? action,
    Expression<String>? result,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reminderId != null) 'reminder_id': reminderId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (action != null) 'action': action,
      if (result != null) 'result': result,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? reminderId,
    Value<DateTime>? occurredAt,
    Value<String>? action,
    Value<String>? result,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReminderLogsCompanion(
      id: id ?? this.id,
      reminderId: reminderId ?? this.reminderId,
      occurredAt: occurredAt ?? this.occurredAt,
      action: action ?? this.action,
      result: result ?? this.result,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderLogsCompanion(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('action: $action, ')
          ..write('result: $result, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PetsTable pets = $PetsTable(this);
  late final $CareActivitiesTable careActivities = $CareActivitiesTable(this);
  late final $HealthRecordsTable healthRecords = $HealthRecordsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $PetPhotosTable petPhotos = $PetPhotosTable(this);
  late final $MemoryEntriesTable memoryEntries = $MemoryEntriesTable(this);
  late final $MemoryMediaRefsTable memoryMediaRefs = $MemoryMediaRefsTable(
    this,
  );
  late final $CarePlansTable carePlans = $CarePlansTable(this);
  late final $CarePlanLogsTable carePlanLogs = $CarePlanLogsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $ReminderLogsTable reminderLogs = $ReminderLogsTable(this);
  late final Index carePetOccurredAt = Index(
    'care_pet_occurred_at',
    'CREATE INDEX care_pet_occurred_at ON care_activities (pet_id, occurred_at)',
  );
  late final Index carePetType = Index(
    'care_pet_type',
    'CREATE INDEX care_pet_type ON care_activities (pet_id, type)',
  );
  late final Index memoryEntriesPetOccurred = Index(
    'memory_entries_pet_occurred',
    'CREATE INDEX memory_entries_pet_occurred ON memory_entries (pet_id, occurred_at)',
  );
  late final Index memoryMediaEntryPosition = Index(
    'memory_media_entry_position',
    'CREATE INDEX memory_media_entry_position ON memory_media_refs (entry_id, position)',
  );
  late final Index carePlansPetCandidateUnique = Index(
    'care_plans_pet_candidate_unique',
    'CREATE UNIQUE INDEX care_plans_pet_candidate_unique ON care_plans (pet_id, candidate_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pets,
    careActivities,
    healthRecords,
    appSettings,
    petPhotos,
    memoryEntries,
    memoryMediaRefs,
    carePlans,
    carePlanLogs,
    reminders,
    reminderLogs,
    carePetOccurredAt,
    carePetType,
    memoryEntriesPetOccurred,
    memoryMediaEntryPosition,
    carePlansPetCandidateUnique,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('care_activities', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('health_records', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pet_photos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('memory_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'memory_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('memory_media_refs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('care_plans', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'care_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('care_plan_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('care_plan_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'reminders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminder_logs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PetsTableCreateCompanionBuilder =
    PetsCompanion Function({
      required String id,
      required String name,
      Value<String?> species,
      Value<String?> breed,
      Value<String?> sex,
      Value<DateTime?> birthday,
      Value<bool?> neutered,
      Value<String> allergies,
      Value<String> chronicConditions,
      Value<String?> avatarPath,
      Value<bool> isPlaceholder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PetsTableUpdateCompanionBuilder =
    PetsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> species,
      Value<String?> breed,
      Value<String?> sex,
      Value<DateTime?> birthday,
      Value<bool?> neutered,
      Value<String> allergies,
      Value<String> chronicConditions,
      Value<String?> avatarPath,
      Value<bool> isPlaceholder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PetsTableReferences
    extends BaseReferences<_$AppDatabase, $PetsTable, Pet> {
  $$PetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CareActivitiesTable, List<CareActivity>>
  _careActivitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.careActivities,
    aliasName: 'pets__id__care_activities__pet_id',
  );

  $$CareActivitiesTableProcessedTableManager get careActivitiesRefs {
    final manager = $$CareActivitiesTableTableManager(
      $_db,
      $_db.careActivities,
    ).filter((f) => f.petId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_careActivitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HealthRecordsTable, List<HealthRecord>>
  _healthRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.healthRecords,
    aliasName: 'pets__id__health_records__pet_id',
  );

  $$HealthRecordsTableProcessedTableManager get healthRecordsRefs {
    final manager = $$HealthRecordsTableTableManager(
      $_db,
      $_db.healthRecords,
    ).filter((f) => f.petId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_healthRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PetPhotosTable, List<PetPhoto>>
  _petPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.petPhotos,
    aliasName: 'pets__id__pet_photos__pet_id',
  );

  $$PetPhotosTableProcessedTableManager get petPhotosRefs {
    final manager = $$PetPhotosTableTableManager(
      $_db,
      $_db.petPhotos,
    ).filter((f) => f.petId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_petPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MemoryEntriesTable, List<MemoryEntry>>
  _memoryEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memoryEntries,
    aliasName: 'pets__id__memory_entries__pet_id',
  );

  $$MemoryEntriesTableProcessedTableManager get memoryEntriesRefs {
    final manager = $$MemoryEntriesTableTableManager(
      $_db,
      $_db.memoryEntries,
    ).filter((f) => f.petId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_memoryEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CarePlansTable, List<CarePlan>>
  _carePlansRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.carePlans,
    aliasName: 'pets__id__care_plans__pet_id',
  );

  $$CarePlansTableProcessedTableManager get carePlansRefs {
    final manager = $$CarePlansTableTableManager(
      $_db,
      $_db.carePlans,
    ).filter((f) => f.petId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_carePlansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CarePlanLogsTable, List<CarePlanLog>>
  _carePlanLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.carePlanLogs,
    aliasName: 'pets__id__care_plan_logs__pet_id',
  );

  $$CarePlanLogsTableProcessedTableManager get carePlanLogsRefs {
    final manager = $$CarePlanLogsTableTableManager(
      $_db,
      $_db.carePlanLogs,
    ).filter((f) => f.petId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_carePlanLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'pets__id__reminders__pet_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.petId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PetsTableFilterComposer extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breed => $composableBuilder(
    column: $table.breed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get neutered => $composableBuilder(
    column: $table.neutered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chronicConditions => $composableBuilder(
    column: $table.chronicConditions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPlaceholder => $composableBuilder(
    column: $table.isPlaceholder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> careActivitiesRefs(
    Expression<bool> Function($$CareActivitiesTableFilterComposer f) f,
  ) {
    final $$CareActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.careActivities,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.careActivities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> healthRecordsRefs(
    Expression<bool> Function($$HealthRecordsTableFilterComposer f) f,
  ) {
    final $$HealthRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.healthRecords,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HealthRecordsTableFilterComposer(
            $db: $db,
            $table: $db.healthRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> petPhotosRefs(
    Expression<bool> Function($$PetPhotosTableFilterComposer f) f,
  ) {
    final $$PetPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.petPhotos,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetPhotosTableFilterComposer(
            $db: $db,
            $table: $db.petPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memoryEntriesRefs(
    Expression<bool> Function($$MemoryEntriesTableFilterComposer f) f,
  ) {
    final $$MemoryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoryEntries,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.memoryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> carePlansRefs(
    Expression<bool> Function($$CarePlansTableFilterComposer f) f,
  ) {
    final $$CarePlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carePlans,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarePlansTableFilterComposer(
            $db: $db,
            $table: $db.carePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> carePlanLogsRefs(
    Expression<bool> Function($$CarePlanLogsTableFilterComposer f) f,
  ) {
    final $$CarePlanLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carePlanLogs,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarePlanLogsTableFilterComposer(
            $db: $db,
            $table: $db.carePlanLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PetsTableOrderingComposer extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breed => $composableBuilder(
    column: $table.breed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get neutered => $composableBuilder(
    column: $table.neutered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chronicConditions => $composableBuilder(
    column: $table.chronicConditions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPlaceholder => $composableBuilder(
    column: $table.isPlaceholder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<DateTime> get birthday =>
      $composableBuilder(column: $table.birthday, builder: (column) => column);

  GeneratedColumn<bool> get neutered =>
      $composableBuilder(column: $table.neutered, builder: (column) => column);

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get chronicConditions => $composableBuilder(
    column: $table.chronicConditions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPlaceholder => $composableBuilder(
    column: $table.isPlaceholder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> careActivitiesRefs<T extends Object>(
    Expression<T> Function($$CareActivitiesTableAnnotationComposer a) f,
  ) {
    final $$CareActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.careActivities,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.careActivities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> healthRecordsRefs<T extends Object>(
    Expression<T> Function($$HealthRecordsTableAnnotationComposer a) f,
  ) {
    final $$HealthRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.healthRecords,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HealthRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.healthRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> petPhotosRefs<T extends Object>(
    Expression<T> Function($$PetPhotosTableAnnotationComposer a) f,
  ) {
    final $$PetPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.petPhotos,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.petPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> memoryEntriesRefs<T extends Object>(
    Expression<T> Function($$MemoryEntriesTableAnnotationComposer a) f,
  ) {
    final $$MemoryEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoryEntries,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.memoryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> carePlansRefs<T extends Object>(
    Expression<T> Function($$CarePlansTableAnnotationComposer a) f,
  ) {
    final $$CarePlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carePlans,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarePlansTableAnnotationComposer(
            $db: $db,
            $table: $db.carePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> carePlanLogsRefs<T extends Object>(
    Expression<T> Function($$CarePlanLogsTableAnnotationComposer a) f,
  ) {
    final $$CarePlanLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carePlanLogs,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarePlanLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.carePlanLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PetsTable,
          Pet,
          $$PetsTableFilterComposer,
          $$PetsTableOrderingComposer,
          $$PetsTableAnnotationComposer,
          $$PetsTableCreateCompanionBuilder,
          $$PetsTableUpdateCompanionBuilder,
          (Pet, $$PetsTableReferences),
          Pet,
          PrefetchHooks Function({
            bool careActivitiesRefs,
            bool healthRecordsRefs,
            bool petPhotosRefs,
            bool memoryEntriesRefs,
            bool carePlansRefs,
            bool carePlanLogsRefs,
            bool remindersRefs,
          })
        > {
  $$PetsTableTableManager(_$AppDatabase db, $PetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> species = const Value.absent(),
                Value<String?> breed = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<DateTime?> birthday = const Value.absent(),
                Value<bool?> neutered = const Value.absent(),
                Value<String> allergies = const Value.absent(),
                Value<String> chronicConditions = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<bool> isPlaceholder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PetsCompanion(
                id: id,
                name: name,
                species: species,
                breed: breed,
                sex: sex,
                birthday: birthday,
                neutered: neutered,
                allergies: allergies,
                chronicConditions: chronicConditions,
                avatarPath: avatarPath,
                isPlaceholder: isPlaceholder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> species = const Value.absent(),
                Value<String?> breed = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<DateTime?> birthday = const Value.absent(),
                Value<bool?> neutered = const Value.absent(),
                Value<String> allergies = const Value.absent(),
                Value<String> chronicConditions = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<bool> isPlaceholder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PetsCompanion.insert(
                id: id,
                name: name,
                species: species,
                breed: breed,
                sex: sex,
                birthday: birthday,
                neutered: neutered,
                allergies: allergies,
                chronicConditions: chronicConditions,
                avatarPath: avatarPath,
                isPlaceholder: isPlaceholder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PetsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                careActivitiesRefs = false,
                healthRecordsRefs = false,
                petPhotosRefs = false,
                memoryEntriesRefs = false,
                carePlansRefs = false,
                carePlanLogsRefs = false,
                remindersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (careActivitiesRefs) db.careActivities,
                    if (healthRecordsRefs) db.healthRecords,
                    if (petPhotosRefs) db.petPhotos,
                    if (memoryEntriesRefs) db.memoryEntries,
                    if (carePlansRefs) db.carePlans,
                    if (carePlanLogsRefs) db.carePlanLogs,
                    if (remindersRefs) db.reminders,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (careActivitiesRefs)
                        await $_getPrefetchedData<
                          Pet,
                          $PetsTable,
                          CareActivity
                        >(
                          currentTable: table,
                          referencedTable: $$PetsTableReferences
                              ._careActivitiesRefsTable(db),
                          managerFromTypedResult: (p0) => $$PetsTableReferences(
                            db,
                            table,
                            p0,
                          ).careActivitiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.petId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (healthRecordsRefs)
                        await $_getPrefetchedData<
                          Pet,
                          $PetsTable,
                          HealthRecord
                        >(
                          currentTable: table,
                          referencedTable: $$PetsTableReferences
                              ._healthRecordsRefsTable(db),
                          managerFromTypedResult: (p0) => $$PetsTableReferences(
                            db,
                            table,
                            p0,
                          ).healthRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.petId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (petPhotosRefs)
                        await $_getPrefetchedData<Pet, $PetsTable, PetPhoto>(
                          currentTable: table,
                          referencedTable: $$PetsTableReferences
                              ._petPhotosRefsTable(db),
                          managerFromTypedResult: (p0) => $$PetsTableReferences(
                            db,
                            table,
                            p0,
                          ).petPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.petId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (memoryEntriesRefs)
                        await $_getPrefetchedData<Pet, $PetsTable, MemoryEntry>(
                          currentTable: table,
                          referencedTable: $$PetsTableReferences
                              ._memoryEntriesRefsTable(db),
                          managerFromTypedResult: (p0) => $$PetsTableReferences(
                            db,
                            table,
                            p0,
                          ).memoryEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.petId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (carePlansRefs)
                        await $_getPrefetchedData<Pet, $PetsTable, CarePlan>(
                          currentTable: table,
                          referencedTable: $$PetsTableReferences
                              ._carePlansRefsTable(db),
                          managerFromTypedResult: (p0) => $$PetsTableReferences(
                            db,
                            table,
                            p0,
                          ).carePlansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.petId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (carePlanLogsRefs)
                        await $_getPrefetchedData<Pet, $PetsTable, CarePlanLog>(
                          currentTable: table,
                          referencedTable: $$PetsTableReferences
                              ._carePlanLogsRefsTable(db),
                          managerFromTypedResult: (p0) => $$PetsTableReferences(
                            db,
                            table,
                            p0,
                          ).carePlanLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.petId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedData<Pet, $PetsTable, Reminder>(
                          currentTable: table,
                          referencedTable: $$PetsTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) => $$PetsTableReferences(
                            db,
                            table,
                            p0,
                          ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.petId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PetsTable,
      Pet,
      $$PetsTableFilterComposer,
      $$PetsTableOrderingComposer,
      $$PetsTableAnnotationComposer,
      $$PetsTableCreateCompanionBuilder,
      $$PetsTableUpdateCompanionBuilder,
      (Pet, $$PetsTableReferences),
      Pet,
      PrefetchHooks Function({
        bool careActivitiesRefs,
        bool healthRecordsRefs,
        bool petPhotosRefs,
        bool memoryEntriesRefs,
        bool carePlansRefs,
        bool carePlanLogsRefs,
        bool remindersRefs,
      })
    >;
typedef $$CareActivitiesTableCreateCompanionBuilder =
    CareActivitiesCompanion Function({
      required String id,
      required String petId,
      required String type,
      required DateTime occurredAt,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<int?> durationSeconds,
      Value<String> place,
      Value<String> note,
      Value<String> detailsJson,
      Value<String?> routeFilePath,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CareActivitiesTableUpdateCompanionBuilder =
    CareActivitiesCompanion Function({
      Value<String> id,
      Value<String> petId,
      Value<String> type,
      Value<DateTime> occurredAt,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<int?> durationSeconds,
      Value<String> place,
      Value<String> note,
      Value<String> detailsJson,
      Value<String?> routeFilePath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CareActivitiesTableReferences
    extends BaseReferences<_$AppDatabase, $CareActivitiesTable, CareActivity> {
  $$CareActivitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PetsTable _petIdTable(_$AppDatabase db) =>
      db.pets.createAlias('care_activities__pet_id__pets__id');

  $$PetsTableProcessedTableManager get petId {
    final $_column = $_itemColumn<String>('pet_id')!;

    final manager = $$PetsTableTableManager(
      $_db,
      $_db.pets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_petIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CareActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $CareActivitiesTable> {
  $$CareActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routeFilePath => $composableBuilder(
    column: $table.routeFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PetsTableFilterComposer get petId {
    final $$PetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableFilterComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CareActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $CareActivitiesTable> {
  $$CareActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routeFilePath => $composableBuilder(
    column: $table.routeFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PetsTableOrderingComposer get petId {
    final $$PetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableOrderingComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CareActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareActivitiesTable> {
  $$CareActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get routeFilePath => $composableBuilder(
    column: $table.routeFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PetsTableAnnotationComposer get petId {
    final $$PetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableAnnotationComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CareActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CareActivitiesTable,
          CareActivity,
          $$CareActivitiesTableFilterComposer,
          $$CareActivitiesTableOrderingComposer,
          $$CareActivitiesTableAnnotationComposer,
          $$CareActivitiesTableCreateCompanionBuilder,
          $$CareActivitiesTableUpdateCompanionBuilder,
          (CareActivity, $$CareActivitiesTableReferences),
          CareActivity,
          PrefetchHooks Function({bool petId})
        > {
  $$CareActivitiesTableTableManager(
    _$AppDatabase db,
    $CareActivitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CareActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> petId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String> place = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> detailsJson = const Value.absent(),
                Value<String?> routeFilePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CareActivitiesCompanion(
                id: id,
                petId: petId,
                type: type,
                occurredAt: occurredAt,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                place: place,
                note: note,
                detailsJson: detailsJson,
                routeFilePath: routeFilePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String petId,
                required String type,
                required DateTime occurredAt,
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String> place = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> detailsJson = const Value.absent(),
                Value<String?> routeFilePath = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CareActivitiesCompanion.insert(
                id: id,
                petId: petId,
                type: type,
                occurredAt: occurredAt,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                place: place,
                note: note,
                detailsJson: detailsJson,
                routeFilePath: routeFilePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CareActivitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({petId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (petId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.petId,
                                referencedTable: $$CareActivitiesTableReferences
                                    ._petIdTable(db),
                                referencedColumn:
                                    $$CareActivitiesTableReferences
                                        ._petIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CareActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CareActivitiesTable,
      CareActivity,
      $$CareActivitiesTableFilterComposer,
      $$CareActivitiesTableOrderingComposer,
      $$CareActivitiesTableAnnotationComposer,
      $$CareActivitiesTableCreateCompanionBuilder,
      $$CareActivitiesTableUpdateCompanionBuilder,
      (CareActivity, $$CareActivitiesTableReferences),
      CareActivity,
      PrefetchHooks Function({bool petId})
    >;
typedef $$HealthRecordsTableCreateCompanionBuilder =
    HealthRecordsCompanion Function({
      required String id,
      required String petId,
      required String type,
      required DateTime occurredAt,
      required String title,
      Value<String> note,
      Value<double?> numericValue,
      Value<String?> unit,
      Value<int?> severity,
      Value<String> detailsJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$HealthRecordsTableUpdateCompanionBuilder =
    HealthRecordsCompanion Function({
      Value<String> id,
      Value<String> petId,
      Value<String> type,
      Value<DateTime> occurredAt,
      Value<String> title,
      Value<String> note,
      Value<double?> numericValue,
      Value<String?> unit,
      Value<int?> severity,
      Value<String> detailsJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$HealthRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $HealthRecordsTable, HealthRecord> {
  $$HealthRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PetsTable _petIdTable(_$AppDatabase db) =>
      db.pets.createAlias('health_records__pet_id__pets__id');

  $$PetsTableProcessedTableManager get petId {
    final $_column = $_itemColumn<String>('pet_id')!;

    final manager = $$PetsTableTableManager(
      $_db,
      $_db.pets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_petIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HealthRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HealthRecordsTable> {
  $$HealthRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get numericValue => $composableBuilder(
    column: $table.numericValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PetsTableFilterComposer get petId {
    final $$PetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableFilterComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HealthRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthRecordsTable> {
  $$HealthRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get numericValue => $composableBuilder(
    column: $table.numericValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PetsTableOrderingComposer get petId {
    final $$PetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableOrderingComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HealthRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthRecordsTable> {
  $$HealthRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<double> get numericValue => $composableBuilder(
    column: $table.numericValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PetsTableAnnotationComposer get petId {
    final $$PetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableAnnotationComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HealthRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthRecordsTable,
          HealthRecord,
          $$HealthRecordsTableFilterComposer,
          $$HealthRecordsTableOrderingComposer,
          $$HealthRecordsTableAnnotationComposer,
          $$HealthRecordsTableCreateCompanionBuilder,
          $$HealthRecordsTableUpdateCompanionBuilder,
          (HealthRecord, $$HealthRecordsTableReferences),
          HealthRecord,
          PrefetchHooks Function({bool petId})
        > {
  $$HealthRecordsTableTableManager(_$AppDatabase db, $HealthRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> petId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<double?> numericValue = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<int?> severity = const Value.absent(),
                Value<String> detailsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HealthRecordsCompanion(
                id: id,
                petId: petId,
                type: type,
                occurredAt: occurredAt,
                title: title,
                note: note,
                numericValue: numericValue,
                unit: unit,
                severity: severity,
                detailsJson: detailsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String petId,
                required String type,
                required DateTime occurredAt,
                required String title,
                Value<String> note = const Value.absent(),
                Value<double?> numericValue = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<int?> severity = const Value.absent(),
                Value<String> detailsJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HealthRecordsCompanion.insert(
                id: id,
                petId: petId,
                type: type,
                occurredAt: occurredAt,
                title: title,
                note: note,
                numericValue: numericValue,
                unit: unit,
                severity: severity,
                detailsJson: detailsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HealthRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({petId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (petId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.petId,
                                referencedTable: $$HealthRecordsTableReferences
                                    ._petIdTable(db),
                                referencedColumn: $$HealthRecordsTableReferences
                                    ._petIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HealthRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthRecordsTable,
      HealthRecord,
      $$HealthRecordsTableFilterComposer,
      $$HealthRecordsTableOrderingComposer,
      $$HealthRecordsTableAnnotationComposer,
      $$HealthRecordsTableCreateCompanionBuilder,
      $$HealthRecordsTableUpdateCompanionBuilder,
      (HealthRecord, $$HealthRecordsTableReferences),
      HealthRecord,
      PrefetchHooks Function({bool petId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$PetPhotosTableCreateCompanionBuilder =
    PetPhotosCompanion Function({
      required String id,
      required String petId,
      Value<String?> filePath,
      Value<Uint8List?> bytes,
      required String originalName,
      required String mediaType,
      Value<String> caption,
      Value<DateTime?> capturedAt,
      Value<bool> isAvatar,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PetPhotosTableUpdateCompanionBuilder =
    PetPhotosCompanion Function({
      Value<String> id,
      Value<String> petId,
      Value<String?> filePath,
      Value<Uint8List?> bytes,
      Value<String> originalName,
      Value<String> mediaType,
      Value<String> caption,
      Value<DateTime?> capturedAt,
      Value<bool> isAvatar,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PetPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $PetPhotosTable, PetPhoto> {
  $$PetPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PetsTable _petIdTable(_$AppDatabase db) =>
      db.pets.createAlias('pet_photos__pet_id__pets__id');

  $$PetsTableProcessedTableManager get petId {
    final $_column = $_itemColumn<String>('pet_id')!;

    final manager = $$PetsTableTableManager(
      $_db,
      $_db.pets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_petIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PetPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $PetPhotosTable> {
  $$PetPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvatar => $composableBuilder(
    column: $table.isAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PetsTableFilterComposer get petId {
    final $$PetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableFilterComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PetPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PetPhotosTable> {
  $$PetPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvatar => $composableBuilder(
    column: $table.isAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PetsTableOrderingComposer get petId {
    final $$PetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableOrderingComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PetPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PetPhotosTable> {
  $$PetPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<Uint8List> get bytes =>
      $composableBuilder(column: $table.bytes, builder: (column) => column);

  GeneratedColumn<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAvatar =>
      $composableBuilder(column: $table.isAvatar, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PetsTableAnnotationComposer get petId {
    final $$PetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableAnnotationComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PetPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PetPhotosTable,
          PetPhoto,
          $$PetPhotosTableFilterComposer,
          $$PetPhotosTableOrderingComposer,
          $$PetPhotosTableAnnotationComposer,
          $$PetPhotosTableCreateCompanionBuilder,
          $$PetPhotosTableUpdateCompanionBuilder,
          (PetPhoto, $$PetPhotosTableReferences),
          PetPhoto,
          PrefetchHooks Function({bool petId})
        > {
  $$PetPhotosTableTableManager(_$AppDatabase db, $PetPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> petId = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<Uint8List?> bytes = const Value.absent(),
                Value<String> originalName = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String> caption = const Value.absent(),
                Value<DateTime?> capturedAt = const Value.absent(),
                Value<bool> isAvatar = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PetPhotosCompanion(
                id: id,
                petId: petId,
                filePath: filePath,
                bytes: bytes,
                originalName: originalName,
                mediaType: mediaType,
                caption: caption,
                capturedAt: capturedAt,
                isAvatar: isAvatar,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String petId,
                Value<String?> filePath = const Value.absent(),
                Value<Uint8List?> bytes = const Value.absent(),
                required String originalName,
                required String mediaType,
                Value<String> caption = const Value.absent(),
                Value<DateTime?> capturedAt = const Value.absent(),
                Value<bool> isAvatar = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PetPhotosCompanion.insert(
                id: id,
                petId: petId,
                filePath: filePath,
                bytes: bytes,
                originalName: originalName,
                mediaType: mediaType,
                caption: caption,
                capturedAt: capturedAt,
                isAvatar: isAvatar,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PetPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({petId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (petId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.petId,
                                referencedTable: $$PetPhotosTableReferences
                                    ._petIdTable(db),
                                referencedColumn: $$PetPhotosTableReferences
                                    ._petIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PetPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PetPhotosTable,
      PetPhoto,
      $$PetPhotosTableFilterComposer,
      $$PetPhotosTableOrderingComposer,
      $$PetPhotosTableAnnotationComposer,
      $$PetPhotosTableCreateCompanionBuilder,
      $$PetPhotosTableUpdateCompanionBuilder,
      (PetPhoto, $$PetPhotosTableReferences),
      PetPhoto,
      PrefetchHooks Function({bool petId})
    >;
typedef $$MemoryEntriesTableCreateCompanionBuilder =
    MemoryEntriesCompanion Function({
      required String id,
      required String petId,
      required DateTime occurredAt,
      Value<String> note,
      Value<String?> moodEmoji,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MemoryEntriesTableUpdateCompanionBuilder =
    MemoryEntriesCompanion Function({
      Value<String> id,
      Value<String> petId,
      Value<DateTime> occurredAt,
      Value<String> note,
      Value<String?> moodEmoji,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$MemoryEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $MemoryEntriesTable, MemoryEntry> {
  $$MemoryEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PetsTable _petIdTable(_$AppDatabase db) =>
      db.pets.createAlias('memory_entries__pet_id__pets__id');

  $$PetsTableProcessedTableManager get petId {
    final $_column = $_itemColumn<String>('pet_id')!;

    final manager = $$PetsTableTableManager(
      $_db,
      $_db.pets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_petIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MemoryMediaRefsTable, List<MemoryMediaRef>>
  _memoryMediaRefsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memoryMediaRefs,
    aliasName: 'memory_entries__id__memory_media_refs__entry_id',
  );

  $$MemoryMediaRefsTableProcessedTableManager get memoryMediaRefsRefs {
    final manager = $$MemoryMediaRefsTableTableManager(
      $_db,
      $_db.memoryMediaRefs,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _memoryMediaRefsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MemoryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryEntriesTable> {
  $$MemoryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moodEmoji => $composableBuilder(
    column: $table.moodEmoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PetsTableFilterComposer get petId {
    final $$PetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableFilterComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> memoryMediaRefsRefs(
    Expression<bool> Function($$MemoryMediaRefsTableFilterComposer f) f,
  ) {
    final $$MemoryMediaRefsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoryMediaRefs,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryMediaRefsTableFilterComposer(
            $db: $db,
            $table: $db.memoryMediaRefs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemoryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryEntriesTable> {
  $$MemoryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moodEmoji => $composableBuilder(
    column: $table.moodEmoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PetsTableOrderingComposer get petId {
    final $$PetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableOrderingComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryEntriesTable> {
  $$MemoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get moodEmoji =>
      $composableBuilder(column: $table.moodEmoji, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PetsTableAnnotationComposer get petId {
    final $$PetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableAnnotationComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> memoryMediaRefsRefs<T extends Object>(
    Expression<T> Function($$MemoryMediaRefsTableAnnotationComposer a) f,
  ) {
    final $$MemoryMediaRefsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoryMediaRefs,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryMediaRefsTableAnnotationComposer(
            $db: $db,
            $table: $db.memoryMediaRefs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemoryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoryEntriesTable,
          MemoryEntry,
          $$MemoryEntriesTableFilterComposer,
          $$MemoryEntriesTableOrderingComposer,
          $$MemoryEntriesTableAnnotationComposer,
          $$MemoryEntriesTableCreateCompanionBuilder,
          $$MemoryEntriesTableUpdateCompanionBuilder,
          (MemoryEntry, $$MemoryEntriesTableReferences),
          MemoryEntry,
          PrefetchHooks Function({bool petId, bool memoryMediaRefsRefs})
        > {
  $$MemoryEntriesTableTableManager(_$AppDatabase db, $MemoryEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> petId = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String?> moodEmoji = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryEntriesCompanion(
                id: id,
                petId: petId,
                occurredAt: occurredAt,
                note: note,
                moodEmoji: moodEmoji,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String petId,
                required DateTime occurredAt,
                Value<String> note = const Value.absent(),
                Value<String?> moodEmoji = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MemoryEntriesCompanion.insert(
                id: id,
                petId: petId,
                occurredAt: occurredAt,
                note: note,
                moodEmoji: moodEmoji,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemoryEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({petId = false, memoryMediaRefsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (memoryMediaRefsRefs) db.memoryMediaRefs,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (petId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.petId,
                                    referencedTable:
                                        $$MemoryEntriesTableReferences
                                            ._petIdTable(db),
                                    referencedColumn:
                                        $$MemoryEntriesTableReferences
                                            ._petIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (memoryMediaRefsRefs)
                        await $_getPrefetchedData<
                          MemoryEntry,
                          $MemoryEntriesTable,
                          MemoryMediaRef
                        >(
                          currentTable: table,
                          referencedTable: $$MemoryEntriesTableReferences
                              ._memoryMediaRefsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MemoryEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).memoryMediaRefsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MemoryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoryEntriesTable,
      MemoryEntry,
      $$MemoryEntriesTableFilterComposer,
      $$MemoryEntriesTableOrderingComposer,
      $$MemoryEntriesTableAnnotationComposer,
      $$MemoryEntriesTableCreateCompanionBuilder,
      $$MemoryEntriesTableUpdateCompanionBuilder,
      (MemoryEntry, $$MemoryEntriesTableReferences),
      MemoryEntry,
      PrefetchHooks Function({bool petId, bool memoryMediaRefsRefs})
    >;
typedef $$MemoryMediaRefsTableCreateCompanionBuilder =
    MemoryMediaRefsCompanion Function({
      required String id,
      required String entryId,
      required String kind,
      required String platformRef,
      required int position,
      Value<int?> width,
      Value<int?> height,
      Value<int?> durationMs,
      Value<DateTime?> capturedAt,
      Value<int> rowid,
    });
typedef $$MemoryMediaRefsTableUpdateCompanionBuilder =
    MemoryMediaRefsCompanion Function({
      Value<String> id,
      Value<String> entryId,
      Value<String> kind,
      Value<String> platformRef,
      Value<int> position,
      Value<int?> width,
      Value<int?> height,
      Value<int?> durationMs,
      Value<DateTime?> capturedAt,
      Value<int> rowid,
    });

final class $$MemoryMediaRefsTableReferences
    extends
        BaseReferences<_$AppDatabase, $MemoryMediaRefsTable, MemoryMediaRef> {
  $$MemoryMediaRefsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MemoryEntriesTable _entryIdTable(_$AppDatabase db) => db.memoryEntries
      .createAlias('memory_media_refs__entry_id__memory_entries__id');

  $$MemoryEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<String>('entry_id')!;

    final manager = $$MemoryEntriesTableTableManager(
      $_db,
      $_db.memoryEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemoryMediaRefsTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryMediaRefsTable> {
  $$MemoryMediaRefsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platformRef => $composableBuilder(
    column: $table.platformRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MemoryEntriesTableFilterComposer get entryId {
    final $$MemoryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.memoryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.memoryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoryMediaRefsTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryMediaRefsTable> {
  $$MemoryMediaRefsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platformRef => $composableBuilder(
    column: $table.platformRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MemoryEntriesTableOrderingComposer get entryId {
    final $$MemoryEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.memoryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.memoryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoryMediaRefsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryMediaRefsTable> {
  $$MemoryMediaRefsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get platformRef => $composableBuilder(
    column: $table.platformRef,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  $$MemoryEntriesTableAnnotationComposer get entryId {
    final $$MemoryEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.memoryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.memoryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoryMediaRefsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoryMediaRefsTable,
          MemoryMediaRef,
          $$MemoryMediaRefsTableFilterComposer,
          $$MemoryMediaRefsTableOrderingComposer,
          $$MemoryMediaRefsTableAnnotationComposer,
          $$MemoryMediaRefsTableCreateCompanionBuilder,
          $$MemoryMediaRefsTableUpdateCompanionBuilder,
          (MemoryMediaRef, $$MemoryMediaRefsTableReferences),
          MemoryMediaRef,
          PrefetchHooks Function({bool entryId})
        > {
  $$MemoryMediaRefsTableTableManager(
    _$AppDatabase db,
    $MemoryMediaRefsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryMediaRefsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryMediaRefsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryMediaRefsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entryId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> platformRef = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<DateTime?> capturedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryMediaRefsCompanion(
                id: id,
                entryId: entryId,
                kind: kind,
                platformRef: platformRef,
                position: position,
                width: width,
                height: height,
                durationMs: durationMs,
                capturedAt: capturedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entryId,
                required String kind,
                required String platformRef,
                required int position,
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<DateTime?> capturedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryMediaRefsCompanion.insert(
                id: id,
                entryId: entryId,
                kind: kind,
                platformRef: platformRef,
                position: position,
                width: width,
                height: height,
                durationMs: durationMs,
                capturedAt: capturedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemoryMediaRefsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.entryId,
                                referencedTable:
                                    $$MemoryMediaRefsTableReferences
                                        ._entryIdTable(db),
                                referencedColumn:
                                    $$MemoryMediaRefsTableReferences
                                        ._entryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MemoryMediaRefsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoryMediaRefsTable,
      MemoryMediaRef,
      $$MemoryMediaRefsTableFilterComposer,
      $$MemoryMediaRefsTableOrderingComposer,
      $$MemoryMediaRefsTableAnnotationComposer,
      $$MemoryMediaRefsTableCreateCompanionBuilder,
      $$MemoryMediaRefsTableUpdateCompanionBuilder,
      (MemoryMediaRef, $$MemoryMediaRefsTableReferences),
      MemoryMediaRef,
      PrefetchHooks Function({bool entryId})
    >;
typedef $$CarePlansTableCreateCompanionBuilder =
    CarePlansCompanion Function({
      required String id,
      required String petId,
      required String candidateId,
      required String careType,
      required String title,
      required String scheduleRule,
      Value<DateTime?> nextDueAt,
      Value<bool> enabled,
      Value<bool> paused,
      Value<String> reasonSnapshot,
      Value<String?> ruleId,
      Value<String?> ruleVersion,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CarePlansTableUpdateCompanionBuilder =
    CarePlansCompanion Function({
      Value<String> id,
      Value<String> petId,
      Value<String> candidateId,
      Value<String> careType,
      Value<String> title,
      Value<String> scheduleRule,
      Value<DateTime?> nextDueAt,
      Value<bool> enabled,
      Value<bool> paused,
      Value<String> reasonSnapshot,
      Value<String?> ruleId,
      Value<String?> ruleVersion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CarePlansTableReferences
    extends BaseReferences<_$AppDatabase, $CarePlansTable, CarePlan> {
  $$CarePlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PetsTable _petIdTable(_$AppDatabase db) =>
      db.pets.createAlias('care_plans__pet_id__pets__id');

  $$PetsTableProcessedTableManager get petId {
    final $_column = $_itemColumn<String>('pet_id')!;

    final manager = $$PetsTableTableManager(
      $_db,
      $_db.pets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_petIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CarePlanLogsTable, List<CarePlanLog>>
  _carePlanLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.carePlanLogs,
    aliasName: 'care_plans__id__care_plan_logs__plan_id',
  );

  $$CarePlanLogsTableProcessedTableManager get carePlanLogsRefs {
    final manager = $$CarePlanLogsTableTableManager(
      $_db,
      $_db.carePlanLogs,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_carePlanLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CarePlansTableFilterComposer
    extends Composer<_$AppDatabase, $CarePlansTable> {
  $$CarePlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get candidateId => $composableBuilder(
    column: $table.candidateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get careType => $composableBuilder(
    column: $table.careType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleRule => $composableBuilder(
    column: $table.scheduleRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDueAt => $composableBuilder(
    column: $table.nextDueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonSnapshot => $composableBuilder(
    column: $table.reasonSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleVersion => $composableBuilder(
    column: $table.ruleVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PetsTableFilterComposer get petId {
    final $$PetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableFilterComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> carePlanLogsRefs(
    Expression<bool> Function($$CarePlanLogsTableFilterComposer f) f,
  ) {
    final $$CarePlanLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carePlanLogs,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarePlanLogsTableFilterComposer(
            $db: $db,
            $table: $db.carePlanLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CarePlansTableOrderingComposer
    extends Composer<_$AppDatabase, $CarePlansTable> {
  $$CarePlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get candidateId => $composableBuilder(
    column: $table.candidateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get careType => $composableBuilder(
    column: $table.careType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleRule => $composableBuilder(
    column: $table.scheduleRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDueAt => $composableBuilder(
    column: $table.nextDueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonSnapshot => $composableBuilder(
    column: $table.reasonSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleVersion => $composableBuilder(
    column: $table.ruleVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PetsTableOrderingComposer get petId {
    final $$PetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableOrderingComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarePlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarePlansTable> {
  $$CarePlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get candidateId => $composableBuilder(
    column: $table.candidateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get careType =>
      $composableBuilder(column: $table.careType, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get scheduleRule => $composableBuilder(
    column: $table.scheduleRule,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextDueAt =>
      $composableBuilder(column: $table.nextDueAt, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get paused =>
      $composableBuilder(column: $table.paused, builder: (column) => column);

  GeneratedColumn<String> get reasonSnapshot => $composableBuilder(
    column: $table.reasonSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ruleId =>
      $composableBuilder(column: $table.ruleId, builder: (column) => column);

  GeneratedColumn<String> get ruleVersion => $composableBuilder(
    column: $table.ruleVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PetsTableAnnotationComposer get petId {
    final $$PetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableAnnotationComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> carePlanLogsRefs<T extends Object>(
    Expression<T> Function($$CarePlanLogsTableAnnotationComposer a) f,
  ) {
    final $$CarePlanLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carePlanLogs,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarePlanLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.carePlanLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CarePlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarePlansTable,
          CarePlan,
          $$CarePlansTableFilterComposer,
          $$CarePlansTableOrderingComposer,
          $$CarePlansTableAnnotationComposer,
          $$CarePlansTableCreateCompanionBuilder,
          $$CarePlansTableUpdateCompanionBuilder,
          (CarePlan, $$CarePlansTableReferences),
          CarePlan,
          PrefetchHooks Function({bool petId, bool carePlanLogsRefs})
        > {
  $$CarePlansTableTableManager(_$AppDatabase db, $CarePlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarePlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarePlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarePlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> petId = const Value.absent(),
                Value<String> candidateId = const Value.absent(),
                Value<String> careType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> scheduleRule = const Value.absent(),
                Value<DateTime?> nextDueAt = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<String> reasonSnapshot = const Value.absent(),
                Value<String?> ruleId = const Value.absent(),
                Value<String?> ruleVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarePlansCompanion(
                id: id,
                petId: petId,
                candidateId: candidateId,
                careType: careType,
                title: title,
                scheduleRule: scheduleRule,
                nextDueAt: nextDueAt,
                enabled: enabled,
                paused: paused,
                reasonSnapshot: reasonSnapshot,
                ruleId: ruleId,
                ruleVersion: ruleVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String petId,
                required String candidateId,
                required String careType,
                required String title,
                required String scheduleRule,
                Value<DateTime?> nextDueAt = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<String> reasonSnapshot = const Value.absent(),
                Value<String?> ruleId = const Value.absent(),
                Value<String?> ruleVersion = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CarePlansCompanion.insert(
                id: id,
                petId: petId,
                candidateId: candidateId,
                careType: careType,
                title: title,
                scheduleRule: scheduleRule,
                nextDueAt: nextDueAt,
                enabled: enabled,
                paused: paused,
                reasonSnapshot: reasonSnapshot,
                ruleId: ruleId,
                ruleVersion: ruleVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CarePlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({petId = false, carePlanLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (carePlanLogsRefs) db.carePlanLogs],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (petId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.petId,
                                referencedTable: $$CarePlansTableReferences
                                    ._petIdTable(db),
                                referencedColumn: $$CarePlansTableReferences
                                    ._petIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (carePlanLogsRefs)
                    await $_getPrefetchedData<
                      CarePlan,
                      $CarePlansTable,
                      CarePlanLog
                    >(
                      currentTable: table,
                      referencedTable: $$CarePlansTableReferences
                          ._carePlanLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CarePlansTableReferences(
                            db,
                            table,
                            p0,
                          ).carePlanLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.planId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CarePlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarePlansTable,
      CarePlan,
      $$CarePlansTableFilterComposer,
      $$CarePlansTableOrderingComposer,
      $$CarePlansTableAnnotationComposer,
      $$CarePlansTableCreateCompanionBuilder,
      $$CarePlansTableUpdateCompanionBuilder,
      (CarePlan, $$CarePlansTableReferences),
      CarePlan,
      PrefetchHooks Function({bool petId, bool carePlanLogsRefs})
    >;
typedef $$CarePlanLogsTableCreateCompanionBuilder =
    CarePlanLogsCompanion Function({
      required String id,
      required String planId,
      required String petId,
      required DateTime occurredAt,
      required String action,
      Value<String> note,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CarePlanLogsTableUpdateCompanionBuilder =
    CarePlanLogsCompanion Function({
      Value<String> id,
      Value<String> planId,
      Value<String> petId,
      Value<DateTime> occurredAt,
      Value<String> action,
      Value<String> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CarePlanLogsTableReferences
    extends BaseReferences<_$AppDatabase, $CarePlanLogsTable, CarePlanLog> {
  $$CarePlanLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CarePlansTable _planIdTable(_$AppDatabase db) =>
      db.carePlans.createAlias('care_plan_logs__plan_id__care_plans__id');

  $$CarePlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager = $$CarePlansTableTableManager(
      $_db,
      $_db.carePlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PetsTable _petIdTable(_$AppDatabase db) =>
      db.pets.createAlias('care_plan_logs__pet_id__pets__id');

  $$PetsTableProcessedTableManager get petId {
    final $_column = $_itemColumn<String>('pet_id')!;

    final manager = $$PetsTableTableManager(
      $_db,
      $_db.pets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_petIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CarePlanLogsTableFilterComposer
    extends Composer<_$AppDatabase, $CarePlanLogsTable> {
  $$CarePlanLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CarePlansTableFilterComposer get planId {
    final $$CarePlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.carePlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarePlansTableFilterComposer(
            $db: $db,
            $table: $db.carePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PetsTableFilterComposer get petId {
    final $$PetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableFilterComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarePlanLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $CarePlanLogsTable> {
  $$CarePlanLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CarePlansTableOrderingComposer get planId {
    final $$CarePlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.carePlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarePlansTableOrderingComposer(
            $db: $db,
            $table: $db.carePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PetsTableOrderingComposer get petId {
    final $$PetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableOrderingComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarePlanLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarePlanLogsTable> {
  $$CarePlanLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CarePlansTableAnnotationComposer get planId {
    final $$CarePlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.carePlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarePlansTableAnnotationComposer(
            $db: $db,
            $table: $db.carePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PetsTableAnnotationComposer get petId {
    final $$PetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableAnnotationComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarePlanLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarePlanLogsTable,
          CarePlanLog,
          $$CarePlanLogsTableFilterComposer,
          $$CarePlanLogsTableOrderingComposer,
          $$CarePlanLogsTableAnnotationComposer,
          $$CarePlanLogsTableCreateCompanionBuilder,
          $$CarePlanLogsTableUpdateCompanionBuilder,
          (CarePlanLog, $$CarePlanLogsTableReferences),
          CarePlanLog,
          PrefetchHooks Function({bool planId, bool petId})
        > {
  $$CarePlanLogsTableTableManager(_$AppDatabase db, $CarePlanLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarePlanLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarePlanLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarePlanLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<String> petId = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarePlanLogsCompanion(
                id: id,
                planId: planId,
                petId: petId,
                occurredAt: occurredAt,
                action: action,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String planId,
                required String petId,
                required DateTime occurredAt,
                required String action,
                Value<String> note = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CarePlanLogsCompanion.insert(
                id: id,
                planId: planId,
                petId: petId,
                occurredAt: occurredAt,
                action: action,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CarePlanLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planId = false, petId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (planId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.planId,
                                referencedTable: $$CarePlanLogsTableReferences
                                    ._planIdTable(db),
                                referencedColumn: $$CarePlanLogsTableReferences
                                    ._planIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (petId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.petId,
                                referencedTable: $$CarePlanLogsTableReferences
                                    ._petIdTable(db),
                                referencedColumn: $$CarePlanLogsTableReferences
                                    ._petIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CarePlanLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarePlanLogsTable,
      CarePlanLog,
      $$CarePlanLogsTableFilterComposer,
      $$CarePlanLogsTableOrderingComposer,
      $$CarePlanLogsTableAnnotationComposer,
      $$CarePlanLogsTableCreateCompanionBuilder,
      $$CarePlanLogsTableUpdateCompanionBuilder,
      (CarePlanLog, $$CarePlanLogsTableReferences),
      CarePlanLog,
      PrefetchHooks Function({bool planId, bool petId})
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      required String id,
      required String petId,
      required String sourceType,
      Value<String?> sourceId,
      required String title,
      required DateTime scheduledAt,
      Value<String?> repeatRule,
      Value<int?> notificationId,
      Value<String> completionMode,
      Value<String> completionTarget,
      Value<String?> recordType,
      Value<String?> recordTitle,
      Value<double?> recordNumericValue,
      Value<String?> recordUnit,
      Value<String> recordNote,
      Value<String> recordDetailsJson,
      Value<String?> careType,
      Value<String> carePlace,
      Value<String> careNote,
      Value<String> careDetailsJson,
      Value<bool> enabled,
      Value<bool> paused,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> id,
      Value<String> petId,
      Value<String> sourceType,
      Value<String?> sourceId,
      Value<String> title,
      Value<DateTime> scheduledAt,
      Value<String?> repeatRule,
      Value<int?> notificationId,
      Value<String> completionMode,
      Value<String> completionTarget,
      Value<String?> recordType,
      Value<String?> recordTitle,
      Value<double?> recordNumericValue,
      Value<String?> recordUnit,
      Value<String> recordNote,
      Value<String> recordDetailsJson,
      Value<String?> careType,
      Value<String> carePlace,
      Value<String> careNote,
      Value<String> careDetailsJson,
      Value<bool> enabled,
      Value<bool> paused,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PetsTable _petIdTable(_$AppDatabase db) =>
      db.pets.createAlias('reminders__pet_id__pets__id');

  $$PetsTableProcessedTableManager get petId {
    final $_column = $_itemColumn<String>('pet_id')!;

    final manager = $$PetsTableTableManager(
      $_db,
      $_db.pets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_petIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReminderLogsTable, List<ReminderLog>>
  _reminderLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminderLogs,
    aliasName: 'reminders__id__reminder_logs__reminder_id',
  );

  $$ReminderLogsTableProcessedTableManager get reminderLogsRefs {
    final manager = $$ReminderLogsTableTableManager(
      $_db,
      $_db.reminderLogs,
    ).filter((f) => f.reminderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reminderLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completionMode => $composableBuilder(
    column: $table.completionMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completionTarget => $composableBuilder(
    column: $table.completionTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordTitle => $composableBuilder(
    column: $table.recordTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get recordNumericValue => $composableBuilder(
    column: $table.recordNumericValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordUnit => $composableBuilder(
    column: $table.recordUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordNote => $composableBuilder(
    column: $table.recordNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordDetailsJson => $composableBuilder(
    column: $table.recordDetailsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get careType => $composableBuilder(
    column: $table.careType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get carePlace => $composableBuilder(
    column: $table.carePlace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get careNote => $composableBuilder(
    column: $table.careNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get careDetailsJson => $composableBuilder(
    column: $table.careDetailsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PetsTableFilterComposer get petId {
    final $$PetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableFilterComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> reminderLogsRefs(
    Expression<bool> Function($$ReminderLogsTableFilterComposer f) f,
  ) {
    final $$ReminderLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderLogs,
      getReferencedColumn: (t) => t.reminderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderLogsTableFilterComposer(
            $db: $db,
            $table: $db.reminderLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completionMode => $composableBuilder(
    column: $table.completionMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completionTarget => $composableBuilder(
    column: $table.completionTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordTitle => $composableBuilder(
    column: $table.recordTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get recordNumericValue => $composableBuilder(
    column: $table.recordNumericValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordUnit => $composableBuilder(
    column: $table.recordUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordNote => $composableBuilder(
    column: $table.recordNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordDetailsJson => $composableBuilder(
    column: $table.recordDetailsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get careType => $composableBuilder(
    column: $table.careType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get carePlace => $composableBuilder(
    column: $table.carePlace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get careNote => $composableBuilder(
    column: $table.careNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get careDetailsJson => $composableBuilder(
    column: $table.careDetailsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PetsTableOrderingComposer get petId {
    final $$PetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableOrderingComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completionMode => $composableBuilder(
    column: $table.completionMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completionTarget => $composableBuilder(
    column: $table.completionTarget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordTitle => $composableBuilder(
    column: $table.recordTitle,
    builder: (column) => column,
  );

  GeneratedColumn<double> get recordNumericValue => $composableBuilder(
    column: $table.recordNumericValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordUnit => $composableBuilder(
    column: $table.recordUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordNote => $composableBuilder(
    column: $table.recordNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordDetailsJson => $composableBuilder(
    column: $table.recordDetailsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get careType =>
      $composableBuilder(column: $table.careType, builder: (column) => column);

  GeneratedColumn<String> get carePlace =>
      $composableBuilder(column: $table.carePlace, builder: (column) => column);

  GeneratedColumn<String> get careNote =>
      $composableBuilder(column: $table.careNote, builder: (column) => column);

  GeneratedColumn<String> get careDetailsJson => $composableBuilder(
    column: $table.careDetailsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get paused =>
      $composableBuilder(column: $table.paused, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PetsTableAnnotationComposer get petId {
    final $$PetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.petId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableAnnotationComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> reminderLogsRefs<T extends Object>(
    Expression<T> Function($$ReminderLogsTableAnnotationComposer a) f,
  ) {
    final $$ReminderLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderLogs,
      getReferencedColumn: (t) => t.reminderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.reminderLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, $$RemindersTableReferences),
          Reminder,
          PrefetchHooks Function({bool petId, bool reminderLogsRefs})
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> petId = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<String?> repeatRule = const Value.absent(),
                Value<int?> notificationId = const Value.absent(),
                Value<String> completionMode = const Value.absent(),
                Value<String> completionTarget = const Value.absent(),
                Value<String?> recordType = const Value.absent(),
                Value<String?> recordTitle = const Value.absent(),
                Value<double?> recordNumericValue = const Value.absent(),
                Value<String?> recordUnit = const Value.absent(),
                Value<String> recordNote = const Value.absent(),
                Value<String> recordDetailsJson = const Value.absent(),
                Value<String?> careType = const Value.absent(),
                Value<String> carePlace = const Value.absent(),
                Value<String> careNote = const Value.absent(),
                Value<String> careDetailsJson = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                petId: petId,
                sourceType: sourceType,
                sourceId: sourceId,
                title: title,
                scheduledAt: scheduledAt,
                repeatRule: repeatRule,
                notificationId: notificationId,
                completionMode: completionMode,
                completionTarget: completionTarget,
                recordType: recordType,
                recordTitle: recordTitle,
                recordNumericValue: recordNumericValue,
                recordUnit: recordUnit,
                recordNote: recordNote,
                recordDetailsJson: recordDetailsJson,
                careType: careType,
                carePlace: carePlace,
                careNote: careNote,
                careDetailsJson: careDetailsJson,
                enabled: enabled,
                paused: paused,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String petId,
                required String sourceType,
                Value<String?> sourceId = const Value.absent(),
                required String title,
                required DateTime scheduledAt,
                Value<String?> repeatRule = const Value.absent(),
                Value<int?> notificationId = const Value.absent(),
                Value<String> completionMode = const Value.absent(),
                Value<String> completionTarget = const Value.absent(),
                Value<String?> recordType = const Value.absent(),
                Value<String?> recordTitle = const Value.absent(),
                Value<double?> recordNumericValue = const Value.absent(),
                Value<String?> recordUnit = const Value.absent(),
                Value<String> recordNote = const Value.absent(),
                Value<String> recordDetailsJson = const Value.absent(),
                Value<String?> careType = const Value.absent(),
                Value<String> carePlace = const Value.absent(),
                Value<String> careNote = const Value.absent(),
                Value<String> careDetailsJson = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                petId: petId,
                sourceType: sourceType,
                sourceId: sourceId,
                title: title,
                scheduledAt: scheduledAt,
                repeatRule: repeatRule,
                notificationId: notificationId,
                completionMode: completionMode,
                completionTarget: completionTarget,
                recordType: recordType,
                recordTitle: recordTitle,
                recordNumericValue: recordNumericValue,
                recordUnit: recordUnit,
                recordNote: recordNote,
                recordDetailsJson: recordDetailsJson,
                careType: careType,
                carePlace: carePlace,
                careNote: careNote,
                careDetailsJson: careDetailsJson,
                enabled: enabled,
                paused: paused,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({petId = false, reminderLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (reminderLogsRefs) db.reminderLogs],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (petId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.petId,
                                referencedTable: $$RemindersTableReferences
                                    ._petIdTable(db),
                                referencedColumn: $$RemindersTableReferences
                                    ._petIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reminderLogsRefs)
                    await $_getPrefetchedData<
                      Reminder,
                      $RemindersTable,
                      ReminderLog
                    >(
                      currentTable: table,
                      referencedTable: $$RemindersTableReferences
                          ._reminderLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RemindersTableReferences(
                            db,
                            table,
                            p0,
                          ).reminderLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.reminderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, $$RemindersTableReferences),
      Reminder,
      PrefetchHooks Function({bool petId, bool reminderLogsRefs})
    >;
typedef $$ReminderLogsTableCreateCompanionBuilder =
    ReminderLogsCompanion Function({
      required String id,
      required String reminderId,
      required DateTime occurredAt,
      required String action,
      Value<String> result,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ReminderLogsTableUpdateCompanionBuilder =
    ReminderLogsCompanion Function({
      Value<String> id,
      Value<String> reminderId,
      Value<DateTime> occurredAt,
      Value<String> action,
      Value<String> result,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ReminderLogsTableReferences
    extends BaseReferences<_$AppDatabase, $ReminderLogsTable, ReminderLog> {
  $$ReminderLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RemindersTable _reminderIdTable(_$AppDatabase db) =>
      db.reminders.createAlias('reminder_logs__reminder_id__reminders__id');

  $$RemindersTableProcessedTableManager get reminderId {
    final $_column = $_itemColumn<String>('reminder_id')!;

    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reminderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReminderLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderLogsTable> {
  $$ReminderLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RemindersTableFilterComposer get reminderId {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderLogsTable> {
  $$ReminderLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RemindersTableOrderingComposer get reminderId {
    final $$RemindersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableOrderingComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderLogsTable> {
  $$ReminderLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RemindersTableAnnotationComposer get reminderId {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderLogsTable,
          ReminderLog,
          $$ReminderLogsTableFilterComposer,
          $$ReminderLogsTableOrderingComposer,
          $$ReminderLogsTableAnnotationComposer,
          $$ReminderLogsTableCreateCompanionBuilder,
          $$ReminderLogsTableUpdateCompanionBuilder,
          (ReminderLog, $$ReminderLogsTableReferences),
          ReminderLog,
          PrefetchHooks Function({bool reminderId})
        > {
  $$ReminderLogsTableTableManager(_$AppDatabase db, $ReminderLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> reminderId = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderLogsCompanion(
                id: id,
                reminderId: reminderId,
                occurredAt: occurredAt,
                action: action,
                result: result,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String reminderId,
                required DateTime occurredAt,
                required String action,
                Value<String> result = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ReminderLogsCompanion.insert(
                id: id,
                reminderId: reminderId,
                occurredAt: occurredAt,
                action: action,
                result: result,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReminderLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reminderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (reminderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.reminderId,
                                referencedTable: $$ReminderLogsTableReferences
                                    ._reminderIdTable(db),
                                referencedColumn: $$ReminderLogsTableReferences
                                    ._reminderIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReminderLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderLogsTable,
      ReminderLog,
      $$ReminderLogsTableFilterComposer,
      $$ReminderLogsTableOrderingComposer,
      $$ReminderLogsTableAnnotationComposer,
      $$ReminderLogsTableCreateCompanionBuilder,
      $$ReminderLogsTableUpdateCompanionBuilder,
      (ReminderLog, $$ReminderLogsTableReferences),
      ReminderLog,
      PrefetchHooks Function({bool reminderId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PetsTableTableManager get pets => $$PetsTableTableManager(_db, _db.pets);
  $$CareActivitiesTableTableManager get careActivities =>
      $$CareActivitiesTableTableManager(_db, _db.careActivities);
  $$HealthRecordsTableTableManager get healthRecords =>
      $$HealthRecordsTableTableManager(_db, _db.healthRecords);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$PetPhotosTableTableManager get petPhotos =>
      $$PetPhotosTableTableManager(_db, _db.petPhotos);
  $$MemoryEntriesTableTableManager get memoryEntries =>
      $$MemoryEntriesTableTableManager(_db, _db.memoryEntries);
  $$MemoryMediaRefsTableTableManager get memoryMediaRefs =>
      $$MemoryMediaRefsTableTableManager(_db, _db.memoryMediaRefs);
  $$CarePlansTableTableManager get carePlans =>
      $$CarePlansTableTableManager(_db, _db.carePlans);
  $$CarePlanLogsTableTableManager get carePlanLogs =>
      $$CarePlanLogsTableTableManager(_db, _db.carePlanLogs);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$ReminderLogsTableTableManager get reminderLogs =>
      $$ReminderLogsTableTableManager(_db, _db.reminderLogs);
}
