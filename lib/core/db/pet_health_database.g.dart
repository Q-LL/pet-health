// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_health_database.dart';

// ignore_for_file: type=lint
class $PetsTable extends Pets with TableInfo<$PetsTable, PetRow> {
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
  @override
  late final GeneratedColumnWithTypeConverter<PetSex?, String> sex =
      GeneratedColumn<String>(
        'sex',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PetSex?>($PetsTable.$convertersexn);
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
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> birthDate =
      GeneratedColumn<String>(
        'birth_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($PetsTable.$converterbirthDaten);
  @override
  late final GeneratedColumnWithTypeConverter<BirthPrecision, String>
  birthPrecision = GeneratedColumn<String>(
    'birth_precision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('day'),
  ).withConverter<BirthPrecision>($PetsTable.$converterbirthPrecision);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> homeDate =
      GeneratedColumn<String>(
        'home_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($PetsTable.$converterhomeDaten);
  static const VerificationMeta _breedCodeMeta = const VerificationMeta(
    'breedCode',
  );
  @override
  late final GeneratedColumn<String> breedCode = GeneratedColumn<String>(
    'breed_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breedNameMeta = const VerificationMeta(
    'breedName',
  );
  @override
  late final GeneratedColumn<String> breedName = GeneratedColumn<String>(
    'breed_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BreedGroup, String> breedGroup =
      GeneratedColumn<String>(
        'breed_group',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('mixed'),
      ).withConverter<BreedGroup>($PetsTable.$converterbreedGroup);
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
    sex,
    neutered,
    birthDate,
    birthPrecision,
    homeDate,
    breedCode,
    breedName,
    breedGroup,
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
    Insertable<PetRow> instance, {
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
    if (data.containsKey('neutered')) {
      context.handle(
        _neuteredMeta,
        neutered.isAcceptableOrUnknown(data['neutered']!, _neuteredMeta),
      );
    }
    if (data.containsKey('breed_code')) {
      context.handle(
        _breedCodeMeta,
        breedCode.isAcceptableOrUnknown(data['breed_code']!, _breedCodeMeta),
      );
    }
    if (data.containsKey('breed_name')) {
      context.handle(
        _breedNameMeta,
        breedName.isAcceptableOrUnknown(data['breed_name']!, _breedNameMeta),
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
  PetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sex: $PetsTable.$convertersexn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sex'],
        ),
      ),
      neutered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}neutered'],
      ),
      birthDate: $PetsTable.$converterbirthDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}birth_date'],
        ),
      ),
      birthPrecision: $PetsTable.$converterbirthPrecision.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}birth_precision'],
        )!,
      ),
      homeDate: $PetsTable.$converterhomeDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}home_date'],
        ),
      ),
      breedCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breed_code'],
      ),
      breedName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breed_name'],
      ),
      breedGroup: $PetsTable.$converterbreedGroup.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}breed_group'],
        )!,
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
  $PetsTable createAlias(String alias) {
    return $PetsTable(attachedDatabase, alias);
  }

  static TypeConverter<PetSex, String> $convertersex = const CodedEnumConverter(
    PetSex.values,
  );
  static TypeConverter<PetSex?, String?> $convertersexn =
      NullAwareTypeConverter.wrap($convertersex);
  static TypeConverter<DateTime, String> $converterbirthDate =
      const LocalDateConverter();
  static TypeConverter<DateTime?, String?> $converterbirthDaten =
      NullAwareTypeConverter.wrap($converterbirthDate);
  static TypeConverter<BirthPrecision, String> $converterbirthPrecision =
      const CodedEnumConverter(BirthPrecision.values);
  static TypeConverter<DateTime, String> $converterhomeDate =
      const LocalDateConverter();
  static TypeConverter<DateTime?, String?> $converterhomeDaten =
      NullAwareTypeConverter.wrap($converterhomeDate);
  static TypeConverter<BreedGroup, String> $converterbreedGroup =
      const CodedEnumConverter(BreedGroup.values);
}

class PetRow extends DataClass implements Insertable<PetRow> {
  final String id;
  final String name;
  final PetSex? sex;
  final bool? neutered;
  final DateTime? birthDate;
  final BirthPrecision birthPrecision;
  final DateTime? homeDate;
  final String? breedCode;
  final String? breedName;
  final BreedGroup breedGroup;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PetRow({
    required this.id,
    required this.name,
    this.sex,
    this.neutered,
    this.birthDate,
    required this.birthPrecision,
    this.homeDate,
    this.breedCode,
    this.breedName,
    required this.breedGroup,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>($PetsTable.$convertersexn.toSql(sex));
    }
    if (!nullToAbsent || neutered != null) {
      map['neutered'] = Variable<bool>(neutered);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<String>(
        $PetsTable.$converterbirthDaten.toSql(birthDate),
      );
    }
    {
      map['birth_precision'] = Variable<String>(
        $PetsTable.$converterbirthPrecision.toSql(birthPrecision),
      );
    }
    if (!nullToAbsent || homeDate != null) {
      map['home_date'] = Variable<String>(
        $PetsTable.$converterhomeDaten.toSql(homeDate),
      );
    }
    if (!nullToAbsent || breedCode != null) {
      map['breed_code'] = Variable<String>(breedCode);
    }
    if (!nullToAbsent || breedName != null) {
      map['breed_name'] = Variable<String>(breedName);
    }
    {
      map['breed_group'] = Variable<String>(
        $PetsTable.$converterbreedGroup.toSql(breedGroup),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PetsCompanion toCompanion(bool nullToAbsent) {
    return PetsCompanion(
      id: Value(id),
      name: Value(name),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      neutered: neutered == null && nullToAbsent
          ? const Value.absent()
          : Value(neutered),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      birthPrecision: Value(birthPrecision),
      homeDate: homeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(homeDate),
      breedCode: breedCode == null && nullToAbsent
          ? const Value.absent()
          : Value(breedCode),
      breedName: breedName == null && nullToAbsent
          ? const Value.absent()
          : Value(breedName),
      breedGroup: Value(breedGroup),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PetRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sex: serializer.fromJson<PetSex?>(json['sex']),
      neutered: serializer.fromJson<bool?>(json['neutered']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      birthPrecision: serializer.fromJson<BirthPrecision>(
        json['birthPrecision'],
      ),
      homeDate: serializer.fromJson<DateTime?>(json['homeDate']),
      breedCode: serializer.fromJson<String?>(json['breedCode']),
      breedName: serializer.fromJson<String?>(json['breedName']),
      breedGroup: serializer.fromJson<BreedGroup>(json['breedGroup']),
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
      'sex': serializer.toJson<PetSex?>(sex),
      'neutered': serializer.toJson<bool?>(neutered),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'birthPrecision': serializer.toJson<BirthPrecision>(birthPrecision),
      'homeDate': serializer.toJson<DateTime?>(homeDate),
      'breedCode': serializer.toJson<String?>(breedCode),
      'breedName': serializer.toJson<String?>(breedName),
      'breedGroup': serializer.toJson<BreedGroup>(breedGroup),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PetRow copyWith({
    String? id,
    String? name,
    Value<PetSex?> sex = const Value.absent(),
    Value<bool?> neutered = const Value.absent(),
    Value<DateTime?> birthDate = const Value.absent(),
    BirthPrecision? birthPrecision,
    Value<DateTime?> homeDate = const Value.absent(),
    Value<String?> breedCode = const Value.absent(),
    Value<String?> breedName = const Value.absent(),
    BreedGroup? breedGroup,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PetRow(
    id: id ?? this.id,
    name: name ?? this.name,
    sex: sex.present ? sex.value : this.sex,
    neutered: neutered.present ? neutered.value : this.neutered,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    birthPrecision: birthPrecision ?? this.birthPrecision,
    homeDate: homeDate.present ? homeDate.value : this.homeDate,
    breedCode: breedCode.present ? breedCode.value : this.breedCode,
    breedName: breedName.present ? breedName.value : this.breedName,
    breedGroup: breedGroup ?? this.breedGroup,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PetRow copyWithCompanion(PetsCompanion data) {
    return PetRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sex: data.sex.present ? data.sex.value : this.sex,
      neutered: data.neutered.present ? data.neutered.value : this.neutered,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      birthPrecision: data.birthPrecision.present
          ? data.birthPrecision.value
          : this.birthPrecision,
      homeDate: data.homeDate.present ? data.homeDate.value : this.homeDate,
      breedCode: data.breedCode.present ? data.breedCode.value : this.breedCode,
      breedName: data.breedName.present ? data.breedName.value : this.breedName,
      breedGroup: data.breedGroup.present
          ? data.breedGroup.value
          : this.breedGroup,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PetRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sex: $sex, ')
          ..write('neutered: $neutered, ')
          ..write('birthDate: $birthDate, ')
          ..write('birthPrecision: $birthPrecision, ')
          ..write('homeDate: $homeDate, ')
          ..write('breedCode: $breedCode, ')
          ..write('breedName: $breedName, ')
          ..write('breedGroup: $breedGroup, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    sex,
    neutered,
    birthDate,
    birthPrecision,
    homeDate,
    breedCode,
    breedName,
    breedGroup,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PetRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.sex == this.sex &&
          other.neutered == this.neutered &&
          other.birthDate == this.birthDate &&
          other.birthPrecision == this.birthPrecision &&
          other.homeDate == this.homeDate &&
          other.breedCode == this.breedCode &&
          other.breedName == this.breedName &&
          other.breedGroup == this.breedGroup &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PetsCompanion extends UpdateCompanion<PetRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<PetSex?> sex;
  final Value<bool?> neutered;
  final Value<DateTime?> birthDate;
  final Value<BirthPrecision> birthPrecision;
  final Value<DateTime?> homeDate;
  final Value<String?> breedCode;
  final Value<String?> breedName;
  final Value<BreedGroup> breedGroup;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sex = const Value.absent(),
    this.neutered = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.birthPrecision = const Value.absent(),
    this.homeDate = const Value.absent(),
    this.breedCode = const Value.absent(),
    this.breedName = const Value.absent(),
    this.breedGroup = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PetsCompanion.insert({
    required String id,
    required String name,
    this.sex = const Value.absent(),
    this.neutered = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.birthPrecision = const Value.absent(),
    this.homeDate = const Value.absent(),
    this.breedCode = const Value.absent(),
    this.breedName = const Value.absent(),
    this.breedGroup = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PetRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? sex,
    Expression<bool>? neutered,
    Expression<String>? birthDate,
    Expression<String>? birthPrecision,
    Expression<String>? homeDate,
    Expression<String>? breedCode,
    Expression<String>? breedName,
    Expression<String>? breedGroup,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sex != null) 'sex': sex,
      if (neutered != null) 'neutered': neutered,
      if (birthDate != null) 'birth_date': birthDate,
      if (birthPrecision != null) 'birth_precision': birthPrecision,
      if (homeDate != null) 'home_date': homeDate,
      if (breedCode != null) 'breed_code': breedCode,
      if (breedName != null) 'breed_name': breedName,
      if (breedGroup != null) 'breed_group': breedGroup,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PetsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<PetSex?>? sex,
    Value<bool?>? neutered,
    Value<DateTime?>? birthDate,
    Value<BirthPrecision>? birthPrecision,
    Value<DateTime?>? homeDate,
    Value<String?>? breedCode,
    Value<String?>? breedName,
    Value<BreedGroup>? breedGroup,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sex: sex ?? this.sex,
      neutered: neutered ?? this.neutered,
      birthDate: birthDate ?? this.birthDate,
      birthPrecision: birthPrecision ?? this.birthPrecision,
      homeDate: homeDate ?? this.homeDate,
      breedCode: breedCode ?? this.breedCode,
      breedName: breedName ?? this.breedName,
      breedGroup: breedGroup ?? this.breedGroup,
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
    if (sex.present) {
      map['sex'] = Variable<String>($PetsTable.$convertersexn.toSql(sex.value));
    }
    if (neutered.present) {
      map['neutered'] = Variable<bool>(neutered.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(
        $PetsTable.$converterbirthDaten.toSql(birthDate.value),
      );
    }
    if (birthPrecision.present) {
      map['birth_precision'] = Variable<String>(
        $PetsTable.$converterbirthPrecision.toSql(birthPrecision.value),
      );
    }
    if (homeDate.present) {
      map['home_date'] = Variable<String>(
        $PetsTable.$converterhomeDaten.toSql(homeDate.value),
      );
    }
    if (breedCode.present) {
      map['breed_code'] = Variable<String>(breedCode.value);
    }
    if (breedName.present) {
      map['breed_name'] = Variable<String>(breedName.value);
    }
    if (breedGroup.present) {
      map['breed_group'] = Variable<String>(
        $PetsTable.$converterbreedGroup.toSql(breedGroup.value),
      );
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
          ..write('sex: $sex, ')
          ..write('neutered: $neutered, ')
          ..write('birthDate: $birthDate, ')
          ..write('birthPrecision: $birthPrecision, ')
          ..write('homeDate: $homeDate, ')
          ..write('breedCode: $breedCode, ')
          ..write('breedName: $breedName, ')
          ..write('breedGroup: $breedGroup, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PetPresetsTable extends PetPresets
    with TableInfo<$PetPresetsTable, PetPresetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetPresetsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _mealAmountMeta = const VerificationMeta(
    'mealAmount',
  );
  @override
  late final GeneratedColumn<double> mealAmount = GeneratedColumn<double>(
    'meal_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PortionUnit?, String> mealUnit =
      GeneratedColumn<String>(
        'meal_unit',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PortionUnit?>($PetPresetsTable.$convertermealUnitn);
  static const VerificationMeta _mealsPerDayMeta = const VerificationMeta(
    'mealsPerDay',
  );
  @override
  late final GeneratedColumn<int> mealsPerDay = GeneratedColumn<int>(
    'meals_per_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bowlMlMeta = const VerificationMeta('bowlMl');
  @override
  late final GeneratedColumn<double> bowlMl = GeneratedColumn<double>(
    'bowl_ml',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WeightCadence, String>
  weightCadence = GeneratedColumn<String>(
    'weight_cadence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('monthly'),
  ).withConverter<WeightCadence>($PetPresetsTable.$converterweightCadence);
  @override
  late final GeneratedColumnWithTypeConverter<List<EntryType>, String>
  quickTypes = GeneratedColumn<String>(
    'quick_types',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('["meal","water","potty","brushing"]'),
  ).withConverter<List<EntryType>>($PetPresetsTable.$converterquickTypes);
  @override
  List<GeneratedColumn> get $columns => [
    petId,
    mealAmount,
    mealUnit,
    mealsPerDay,
    bowlMl,
    weightCadence,
    quickTypes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pet_presets';
  @override
  VerificationContext validateIntegrity(
    Insertable<PetPresetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pet_id')) {
      context.handle(
        _petIdMeta,
        petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta),
      );
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('meal_amount')) {
      context.handle(
        _mealAmountMeta,
        mealAmount.isAcceptableOrUnknown(data['meal_amount']!, _mealAmountMeta),
      );
    }
    if (data.containsKey('meals_per_day')) {
      context.handle(
        _mealsPerDayMeta,
        mealsPerDay.isAcceptableOrUnknown(
          data['meals_per_day']!,
          _mealsPerDayMeta,
        ),
      );
    }
    if (data.containsKey('bowl_ml')) {
      context.handle(
        _bowlMlMeta,
        bowlMl.isAcceptableOrUnknown(data['bowl_ml']!, _bowlMlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {petId};
  @override
  PetPresetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PetPresetRow(
      petId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_id'],
      )!,
      mealAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}meal_amount'],
      ),
      mealUnit: $PetPresetsTable.$convertermealUnitn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}meal_unit'],
        ),
      ),
      mealsPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meals_per_day'],
      ),
      bowlMl: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bowl_ml'],
      ),
      weightCadence: $PetPresetsTable.$converterweightCadence.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}weight_cadence'],
        )!,
      ),
      quickTypes: $PetPresetsTable.$converterquickTypes.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}quick_types'],
        )!,
      ),
    );
  }

  @override
  $PetPresetsTable createAlias(String alias) {
    return $PetPresetsTable(attachedDatabase, alias);
  }

  static TypeConverter<PortionUnit, String> $convertermealUnit =
      const CodedEnumConverter(PortionUnit.values);
  static TypeConverter<PortionUnit?, String?> $convertermealUnitn =
      NullAwareTypeConverter.wrap($convertermealUnit);
  static TypeConverter<WeightCadence, String> $converterweightCadence =
      const CodedEnumConverter(WeightCadence.values);
  static TypeConverter<List<EntryType>, String> $converterquickTypes =
      const CodedEnumListConverter(EntryType.values);
}

class PetPresetRow extends DataClass implements Insertable<PetPresetRow> {
  final String petId;
  final double? mealAmount;
  final PortionUnit? mealUnit;
  final int? mealsPerDay;

  /// 水碗容量，一律按 ml 存。
  final double? bowlMl;
  final WeightCadence weightCadence;

  /// 首页一键记录的类型与顺序。
  final List<EntryType> quickTypes;
  const PetPresetRow({
    required this.petId,
    this.mealAmount,
    this.mealUnit,
    this.mealsPerDay,
    this.bowlMl,
    required this.weightCadence,
    required this.quickTypes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pet_id'] = Variable<String>(petId);
    if (!nullToAbsent || mealAmount != null) {
      map['meal_amount'] = Variable<double>(mealAmount);
    }
    if (!nullToAbsent || mealUnit != null) {
      map['meal_unit'] = Variable<String>(
        $PetPresetsTable.$convertermealUnitn.toSql(mealUnit),
      );
    }
    if (!nullToAbsent || mealsPerDay != null) {
      map['meals_per_day'] = Variable<int>(mealsPerDay);
    }
    if (!nullToAbsent || bowlMl != null) {
      map['bowl_ml'] = Variable<double>(bowlMl);
    }
    {
      map['weight_cadence'] = Variable<String>(
        $PetPresetsTable.$converterweightCadence.toSql(weightCadence),
      );
    }
    {
      map['quick_types'] = Variable<String>(
        $PetPresetsTable.$converterquickTypes.toSql(quickTypes),
      );
    }
    return map;
  }

  PetPresetsCompanion toCompanion(bool nullToAbsent) {
    return PetPresetsCompanion(
      petId: Value(petId),
      mealAmount: mealAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(mealAmount),
      mealUnit: mealUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(mealUnit),
      mealsPerDay: mealsPerDay == null && nullToAbsent
          ? const Value.absent()
          : Value(mealsPerDay),
      bowlMl: bowlMl == null && nullToAbsent
          ? const Value.absent()
          : Value(bowlMl),
      weightCadence: Value(weightCadence),
      quickTypes: Value(quickTypes),
    );
  }

  factory PetPresetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PetPresetRow(
      petId: serializer.fromJson<String>(json['petId']),
      mealAmount: serializer.fromJson<double?>(json['mealAmount']),
      mealUnit: serializer.fromJson<PortionUnit?>(json['mealUnit']),
      mealsPerDay: serializer.fromJson<int?>(json['mealsPerDay']),
      bowlMl: serializer.fromJson<double?>(json['bowlMl']),
      weightCadence: serializer.fromJson<WeightCadence>(json['weightCadence']),
      quickTypes: serializer.fromJson<List<EntryType>>(json['quickTypes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'petId': serializer.toJson<String>(petId),
      'mealAmount': serializer.toJson<double?>(mealAmount),
      'mealUnit': serializer.toJson<PortionUnit?>(mealUnit),
      'mealsPerDay': serializer.toJson<int?>(mealsPerDay),
      'bowlMl': serializer.toJson<double?>(bowlMl),
      'weightCadence': serializer.toJson<WeightCadence>(weightCadence),
      'quickTypes': serializer.toJson<List<EntryType>>(quickTypes),
    };
  }

  PetPresetRow copyWith({
    String? petId,
    Value<double?> mealAmount = const Value.absent(),
    Value<PortionUnit?> mealUnit = const Value.absent(),
    Value<int?> mealsPerDay = const Value.absent(),
    Value<double?> bowlMl = const Value.absent(),
    WeightCadence? weightCadence,
    List<EntryType>? quickTypes,
  }) => PetPresetRow(
    petId: petId ?? this.petId,
    mealAmount: mealAmount.present ? mealAmount.value : this.mealAmount,
    mealUnit: mealUnit.present ? mealUnit.value : this.mealUnit,
    mealsPerDay: mealsPerDay.present ? mealsPerDay.value : this.mealsPerDay,
    bowlMl: bowlMl.present ? bowlMl.value : this.bowlMl,
    weightCadence: weightCadence ?? this.weightCadence,
    quickTypes: quickTypes ?? this.quickTypes,
  );
  PetPresetRow copyWithCompanion(PetPresetsCompanion data) {
    return PetPresetRow(
      petId: data.petId.present ? data.petId.value : this.petId,
      mealAmount: data.mealAmount.present
          ? data.mealAmount.value
          : this.mealAmount,
      mealUnit: data.mealUnit.present ? data.mealUnit.value : this.mealUnit,
      mealsPerDay: data.mealsPerDay.present
          ? data.mealsPerDay.value
          : this.mealsPerDay,
      bowlMl: data.bowlMl.present ? data.bowlMl.value : this.bowlMl,
      weightCadence: data.weightCadence.present
          ? data.weightCadence.value
          : this.weightCadence,
      quickTypes: data.quickTypes.present
          ? data.quickTypes.value
          : this.quickTypes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PetPresetRow(')
          ..write('petId: $petId, ')
          ..write('mealAmount: $mealAmount, ')
          ..write('mealUnit: $mealUnit, ')
          ..write('mealsPerDay: $mealsPerDay, ')
          ..write('bowlMl: $bowlMl, ')
          ..write('weightCadence: $weightCadence, ')
          ..write('quickTypes: $quickTypes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    petId,
    mealAmount,
    mealUnit,
    mealsPerDay,
    bowlMl,
    weightCadence,
    quickTypes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PetPresetRow &&
          other.petId == this.petId &&
          other.mealAmount == this.mealAmount &&
          other.mealUnit == this.mealUnit &&
          other.mealsPerDay == this.mealsPerDay &&
          other.bowlMl == this.bowlMl &&
          other.weightCadence == this.weightCadence &&
          other.quickTypes == this.quickTypes);
}

class PetPresetsCompanion extends UpdateCompanion<PetPresetRow> {
  final Value<String> petId;
  final Value<double?> mealAmount;
  final Value<PortionUnit?> mealUnit;
  final Value<int?> mealsPerDay;
  final Value<double?> bowlMl;
  final Value<WeightCadence> weightCadence;
  final Value<List<EntryType>> quickTypes;
  final Value<int> rowid;
  const PetPresetsCompanion({
    this.petId = const Value.absent(),
    this.mealAmount = const Value.absent(),
    this.mealUnit = const Value.absent(),
    this.mealsPerDay = const Value.absent(),
    this.bowlMl = const Value.absent(),
    this.weightCadence = const Value.absent(),
    this.quickTypes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PetPresetsCompanion.insert({
    required String petId,
    this.mealAmount = const Value.absent(),
    this.mealUnit = const Value.absent(),
    this.mealsPerDay = const Value.absent(),
    this.bowlMl = const Value.absent(),
    this.weightCadence = const Value.absent(),
    this.quickTypes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : petId = Value(petId);
  static Insertable<PetPresetRow> custom({
    Expression<String>? petId,
    Expression<double>? mealAmount,
    Expression<String>? mealUnit,
    Expression<int>? mealsPerDay,
    Expression<double>? bowlMl,
    Expression<String>? weightCadence,
    Expression<String>? quickTypes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (petId != null) 'pet_id': petId,
      if (mealAmount != null) 'meal_amount': mealAmount,
      if (mealUnit != null) 'meal_unit': mealUnit,
      if (mealsPerDay != null) 'meals_per_day': mealsPerDay,
      if (bowlMl != null) 'bowl_ml': bowlMl,
      if (weightCadence != null) 'weight_cadence': weightCadence,
      if (quickTypes != null) 'quick_types': quickTypes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PetPresetsCompanion copyWith({
    Value<String>? petId,
    Value<double?>? mealAmount,
    Value<PortionUnit?>? mealUnit,
    Value<int?>? mealsPerDay,
    Value<double?>? bowlMl,
    Value<WeightCadence>? weightCadence,
    Value<List<EntryType>>? quickTypes,
    Value<int>? rowid,
  }) {
    return PetPresetsCompanion(
      petId: petId ?? this.petId,
      mealAmount: mealAmount ?? this.mealAmount,
      mealUnit: mealUnit ?? this.mealUnit,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      bowlMl: bowlMl ?? this.bowlMl,
      weightCadence: weightCadence ?? this.weightCadence,
      quickTypes: quickTypes ?? this.quickTypes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (petId.present) {
      map['pet_id'] = Variable<String>(petId.value);
    }
    if (mealAmount.present) {
      map['meal_amount'] = Variable<double>(mealAmount.value);
    }
    if (mealUnit.present) {
      map['meal_unit'] = Variable<String>(
        $PetPresetsTable.$convertermealUnitn.toSql(mealUnit.value),
      );
    }
    if (mealsPerDay.present) {
      map['meals_per_day'] = Variable<int>(mealsPerDay.value);
    }
    if (bowlMl.present) {
      map['bowl_ml'] = Variable<double>(bowlMl.value);
    }
    if (weightCadence.present) {
      map['weight_cadence'] = Variable<String>(
        $PetPresetsTable.$converterweightCadence.toSql(weightCadence.value),
      );
    }
    if (quickTypes.present) {
      map['quick_types'] = Variable<String>(
        $PetPresetsTable.$converterquickTypes.toSql(quickTypes.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetPresetsCompanion(')
          ..write('petId: $petId, ')
          ..write('mealAmount: $mealAmount, ')
          ..write('mealUnit: $mealUnit, ')
          ..write('mealsPerDay: $mealsPerDay, ')
          ..write('bowlMl: $bowlMl, ')
          ..write('weightCadence: $weightCadence, ')
          ..write('quickTypes: $quickTypes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlansTable extends Plans with TableInfo<$PlansTable, PlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlansTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<EntryType, String> entryType =
      GeneratedColumn<String>(
        'entry_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EntryType>($PlansTable.$converterentryType);
  static const VerificationMeta _entryKindMeta = const VerificationMeta(
    'entryKind',
  );
  @override
  late final GeneratedColumn<String> entryKind = GeneratedColumn<String>(
    'entry_kind',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PlanScheduleKind, String>
  schedule = GeneratedColumn<String>(
    'schedule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PlanScheduleKind>($PlansTable.$converterschedule);
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<int> weekdays = GeneratedColumn<int>(
    'weekdays',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notifyMinuteMeta = const VerificationMeta(
    'notifyMinute',
  );
  @override
  late final GeneratedColumn<int> notifyMinute = GeneratedColumn<int>(
    'notify_minute',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _snoozedUntilMeta = const VerificationMeta(
    'snoozedUntil',
  );
  @override
  late final GeneratedColumn<DateTime> snoozedUntil = GeneratedColumn<DateTime>(
    'snoozed_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  @override
  late final GeneratedColumnWithTypeConverter<PlanSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('user'),
      ).withConverter<PlanSource>($PlansTable.$convertersource);
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
    entryType,
    entryKind,
    title,
    schedule,
    intervalDays,
    weekdays,
    dueAt,
    notifyMinute,
    snoozedUntil,
    notificationId,
    source,
    paused,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanRow> instance, {
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
    if (data.containsKey('entry_kind')) {
      context.handle(
        _entryKindMeta,
        entryKind.isAcceptableOrUnknown(data['entry_kind']!, _entryKindMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('notify_minute')) {
      context.handle(
        _notifyMinuteMeta,
        notifyMinute.isAcceptableOrUnknown(
          data['notify_minute']!,
          _notifyMinuteMeta,
        ),
      );
    }
    if (data.containsKey('snoozed_until')) {
      context.handle(
        _snoozedUntilMeta,
        snoozedUntil.isAcceptableOrUnknown(
          data['snoozed_until']!,
          _snoozedUntilMeta,
        ),
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
  PlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      petId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_id'],
      )!,
      entryType: $PlansTable.$converterentryType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entry_type'],
        )!,
      ),
      entryKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_kind'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      schedule: $PlansTable.$converterschedule.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}schedule'],
        )!,
      ),
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      ),
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekdays'],
      ),
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      notifyMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notify_minute'],
      ),
      snoozedUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}snoozed_until'],
      ),
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      ),
      source: $PlansTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
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
  $PlansTable createAlias(String alias) {
    return $PlansTable(attachedDatabase, alias);
  }

  static TypeConverter<EntryType, String> $converterentryType =
      const CodedEnumConverter(EntryType.values);
  static TypeConverter<PlanScheduleKind, String> $converterschedule =
      const CodedEnumConverter(PlanScheduleKind.values);
  static TypeConverter<PlanSource, String> $convertersource =
      const CodedEnumConverter(PlanSource.values);
}

class PlanRow extends DataClass implements Insertable<PlanRow> {
  final String id;
  final String petId;
  final EntryType entryType;

  /// 细分到具体项，比如 other_care 下的 nails。
  final String? entryKind;

  /// 只有 custom 计划才填；内置类型的名称来自翻译文件。
  final String? title;
  final PlanScheduleKind schedule;
  final int? intervalDays;

  /// 星期几位掩码，见 Weekdays。
  final int? weekdays;

  /// 一次性事项的时间。
  final DateTime? dueAt;

  /// 当天几点提醒，按距离零点的分钟数存；为空表示不发通知。
  final int? notifyMinute;
  final DateTime? snoozedUntil;
  final int? notificationId;
  final PlanSource source;
  final bool paused;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PlanRow({
    required this.id,
    required this.petId,
    required this.entryType,
    this.entryKind,
    this.title,
    required this.schedule,
    this.intervalDays,
    this.weekdays,
    this.dueAt,
    this.notifyMinute,
    this.snoozedUntil,
    this.notificationId,
    required this.source,
    required this.paused,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pet_id'] = Variable<String>(petId);
    {
      map['entry_type'] = Variable<String>(
        $PlansTable.$converterentryType.toSql(entryType),
      );
    }
    if (!nullToAbsent || entryKind != null) {
      map['entry_kind'] = Variable<String>(entryKind);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    {
      map['schedule'] = Variable<String>(
        $PlansTable.$converterschedule.toSql(schedule),
      );
    }
    if (!nullToAbsent || intervalDays != null) {
      map['interval_days'] = Variable<int>(intervalDays);
    }
    if (!nullToAbsent || weekdays != null) {
      map['weekdays'] = Variable<int>(weekdays);
    }
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    if (!nullToAbsent || notifyMinute != null) {
      map['notify_minute'] = Variable<int>(notifyMinute);
    }
    if (!nullToAbsent || snoozedUntil != null) {
      map['snoozed_until'] = Variable<DateTime>(snoozedUntil);
    }
    if (!nullToAbsent || notificationId != null) {
      map['notification_id'] = Variable<int>(notificationId);
    }
    {
      map['source'] = Variable<String>(
        $PlansTable.$convertersource.toSql(source),
      );
    }
    map['paused'] = Variable<bool>(paused);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlansCompanion toCompanion(bool nullToAbsent) {
    return PlansCompanion(
      id: Value(id),
      petId: Value(petId),
      entryType: Value(entryType),
      entryKind: entryKind == null && nullToAbsent
          ? const Value.absent()
          : Value(entryKind),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      schedule: Value(schedule),
      intervalDays: intervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalDays),
      weekdays: weekdays == null && nullToAbsent
          ? const Value.absent()
          : Value(weekdays),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      notifyMinute: notifyMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(notifyMinute),
      snoozedUntil: snoozedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozedUntil),
      notificationId: notificationId == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationId),
      source: Value(source),
      paused: Value(paused),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanRow(
      id: serializer.fromJson<String>(json['id']),
      petId: serializer.fromJson<String>(json['petId']),
      entryType: serializer.fromJson<EntryType>(json['entryType']),
      entryKind: serializer.fromJson<String?>(json['entryKind']),
      title: serializer.fromJson<String?>(json['title']),
      schedule: serializer.fromJson<PlanScheduleKind>(json['schedule']),
      intervalDays: serializer.fromJson<int?>(json['intervalDays']),
      weekdays: serializer.fromJson<int?>(json['weekdays']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      notifyMinute: serializer.fromJson<int?>(json['notifyMinute']),
      snoozedUntil: serializer.fromJson<DateTime?>(json['snoozedUntil']),
      notificationId: serializer.fromJson<int?>(json['notificationId']),
      source: serializer.fromJson<PlanSource>(json['source']),
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
      'entryType': serializer.toJson<EntryType>(entryType),
      'entryKind': serializer.toJson<String?>(entryKind),
      'title': serializer.toJson<String?>(title),
      'schedule': serializer.toJson<PlanScheduleKind>(schedule),
      'intervalDays': serializer.toJson<int?>(intervalDays),
      'weekdays': serializer.toJson<int?>(weekdays),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'notifyMinute': serializer.toJson<int?>(notifyMinute),
      'snoozedUntil': serializer.toJson<DateTime?>(snoozedUntil),
      'notificationId': serializer.toJson<int?>(notificationId),
      'source': serializer.toJson<PlanSource>(source),
      'paused': serializer.toJson<bool>(paused),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlanRow copyWith({
    String? id,
    String? petId,
    EntryType? entryType,
    Value<String?> entryKind = const Value.absent(),
    Value<String?> title = const Value.absent(),
    PlanScheduleKind? schedule,
    Value<int?> intervalDays = const Value.absent(),
    Value<int?> weekdays = const Value.absent(),
    Value<DateTime?> dueAt = const Value.absent(),
    Value<int?> notifyMinute = const Value.absent(),
    Value<DateTime?> snoozedUntil = const Value.absent(),
    Value<int?> notificationId = const Value.absent(),
    PlanSource? source,
    bool? paused,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PlanRow(
    id: id ?? this.id,
    petId: petId ?? this.petId,
    entryType: entryType ?? this.entryType,
    entryKind: entryKind.present ? entryKind.value : this.entryKind,
    title: title.present ? title.value : this.title,
    schedule: schedule ?? this.schedule,
    intervalDays: intervalDays.present ? intervalDays.value : this.intervalDays,
    weekdays: weekdays.present ? weekdays.value : this.weekdays,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    notifyMinute: notifyMinute.present ? notifyMinute.value : this.notifyMinute,
    snoozedUntil: snoozedUntil.present ? snoozedUntil.value : this.snoozedUntil,
    notificationId: notificationId.present
        ? notificationId.value
        : this.notificationId,
    source: source ?? this.source,
    paused: paused ?? this.paused,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlanRow copyWithCompanion(PlansCompanion data) {
    return PlanRow(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      entryType: data.entryType.present ? data.entryType.value : this.entryType,
      entryKind: data.entryKind.present ? data.entryKind.value : this.entryKind,
      title: data.title.present ? data.title.value : this.title,
      schedule: data.schedule.present ? data.schedule.value : this.schedule,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      notifyMinute: data.notifyMinute.present
          ? data.notifyMinute.value
          : this.notifyMinute,
      snoozedUntil: data.snoozedUntil.present
          ? data.snoozedUntil.value
          : this.snoozedUntil,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      source: data.source.present ? data.source.value : this.source,
      paused: data.paused.present ? data.paused.value : this.paused,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanRow(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('entryType: $entryType, ')
          ..write('entryKind: $entryKind, ')
          ..write('title: $title, ')
          ..write('schedule: $schedule, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('weekdays: $weekdays, ')
          ..write('dueAt: $dueAt, ')
          ..write('notifyMinute: $notifyMinute, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('notificationId: $notificationId, ')
          ..write('source: $source, ')
          ..write('paused: $paused, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    petId,
    entryType,
    entryKind,
    title,
    schedule,
    intervalDays,
    weekdays,
    dueAt,
    notifyMinute,
    snoozedUntil,
    notificationId,
    source,
    paused,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanRow &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.entryType == this.entryType &&
          other.entryKind == this.entryKind &&
          other.title == this.title &&
          other.schedule == this.schedule &&
          other.intervalDays == this.intervalDays &&
          other.weekdays == this.weekdays &&
          other.dueAt == this.dueAt &&
          other.notifyMinute == this.notifyMinute &&
          other.snoozedUntil == this.snoozedUntil &&
          other.notificationId == this.notificationId &&
          other.source == this.source &&
          other.paused == this.paused &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlansCompanion extends UpdateCompanion<PlanRow> {
  final Value<String> id;
  final Value<String> petId;
  final Value<EntryType> entryType;
  final Value<String?> entryKind;
  final Value<String?> title;
  final Value<PlanScheduleKind> schedule;
  final Value<int?> intervalDays;
  final Value<int?> weekdays;
  final Value<DateTime?> dueAt;
  final Value<int?> notifyMinute;
  final Value<DateTime?> snoozedUntil;
  final Value<int?> notificationId;
  final Value<PlanSource> source;
  final Value<bool> paused;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlansCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.entryType = const Value.absent(),
    this.entryKind = const Value.absent(),
    this.title = const Value.absent(),
    this.schedule = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.notifyMinute = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.source = const Value.absent(),
    this.paused = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlansCompanion.insert({
    required String id,
    required String petId,
    required EntryType entryType,
    this.entryKind = const Value.absent(),
    this.title = const Value.absent(),
    required PlanScheduleKind schedule,
    this.intervalDays = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.notifyMinute = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.source = const Value.absent(),
    this.paused = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       petId = Value(petId),
       entryType = Value(entryType),
       schedule = Value(schedule),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PlanRow> custom({
    Expression<String>? id,
    Expression<String>? petId,
    Expression<String>? entryType,
    Expression<String>? entryKind,
    Expression<String>? title,
    Expression<String>? schedule,
    Expression<int>? intervalDays,
    Expression<int>? weekdays,
    Expression<DateTime>? dueAt,
    Expression<int>? notifyMinute,
    Expression<DateTime>? snoozedUntil,
    Expression<int>? notificationId,
    Expression<String>? source,
    Expression<bool>? paused,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (entryType != null) 'entry_type': entryType,
      if (entryKind != null) 'entry_kind': entryKind,
      if (title != null) 'title': title,
      if (schedule != null) 'schedule': schedule,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (weekdays != null) 'weekdays': weekdays,
      if (dueAt != null) 'due_at': dueAt,
      if (notifyMinute != null) 'notify_minute': notifyMinute,
      if (snoozedUntil != null) 'snoozed_until': snoozedUntil,
      if (notificationId != null) 'notification_id': notificationId,
      if (source != null) 'source': source,
      if (paused != null) 'paused': paused,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlansCompanion copyWith({
    Value<String>? id,
    Value<String>? petId,
    Value<EntryType>? entryType,
    Value<String?>? entryKind,
    Value<String?>? title,
    Value<PlanScheduleKind>? schedule,
    Value<int?>? intervalDays,
    Value<int?>? weekdays,
    Value<DateTime?>? dueAt,
    Value<int?>? notifyMinute,
    Value<DateTime?>? snoozedUntil,
    Value<int?>? notificationId,
    Value<PlanSource>? source,
    Value<bool>? paused,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlansCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      entryType: entryType ?? this.entryType,
      entryKind: entryKind ?? this.entryKind,
      title: title ?? this.title,
      schedule: schedule ?? this.schedule,
      intervalDays: intervalDays ?? this.intervalDays,
      weekdays: weekdays ?? this.weekdays,
      dueAt: dueAt ?? this.dueAt,
      notifyMinute: notifyMinute ?? this.notifyMinute,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      notificationId: notificationId ?? this.notificationId,
      source: source ?? this.source,
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
    if (entryType.present) {
      map['entry_type'] = Variable<String>(
        $PlansTable.$converterentryType.toSql(entryType.value),
      );
    }
    if (entryKind.present) {
      map['entry_kind'] = Variable<String>(entryKind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (schedule.present) {
      map['schedule'] = Variable<String>(
        $PlansTable.$converterschedule.toSql(schedule.value),
      );
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<int>(weekdays.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (notifyMinute.present) {
      map['notify_minute'] = Variable<int>(notifyMinute.value);
    }
    if (snoozedUntil.present) {
      map['snoozed_until'] = Variable<DateTime>(snoozedUntil.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $PlansTable.$convertersource.toSql(source.value),
      );
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
    return (StringBuffer('PlansCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('entryType: $entryType, ')
          ..write('entryKind: $entryKind, ')
          ..write('title: $title, ')
          ..write('schedule: $schedule, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('weekdays: $weekdays, ')
          ..write('dueAt: $dueAt, ')
          ..write('notifyMinute: $notifyMinute, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('notificationId: $notificationId, ')
          ..write('source: $source, ')
          ..write('paused: $paused, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntriesTable extends Entries with TableInfo<$EntriesTable, EntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntriesTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<EntryType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EntryType>($EntriesTable.$convertertype);
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
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plans (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PortionUnit?, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PortionUnit?>($EntriesTable.$converterunitn);
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
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMMeta = const VerificationMeta(
    'distanceM',
  );
  @override
  late final GeneratedColumn<double> distanceM = GeneratedColumn<double>(
    'distance_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  details = GeneratedColumn<String>(
    'details',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, Object?>>($EntriesTable.$converterdetails);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    planId,
    amount,
    unit,
    startedAt,
    endedAt,
    durationSec,
    distanceM,
    details,
    label,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntryRow> instance, {
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
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
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
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('distance_m')) {
      context.handle(
        _distanceMMeta,
        distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
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
  EntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      petId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_id'],
      )!,
      type: $EntriesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
      unit: $EntriesTable.$converterunitn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        ),
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      ),
      distanceM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_m'],
      ),
      details: $EntriesTable.$converterdetails.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}details'],
        )!,
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
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
  $EntriesTable createAlias(String alias) {
    return $EntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<EntryType, String> $convertertype =
      const CodedEnumConverter(EntryType.values);
  static TypeConverter<PortionUnit, String> $converterunit =
      const CodedEnumConverter(PortionUnit.values);
  static TypeConverter<PortionUnit?, String?> $converterunitn =
      NullAwareTypeConverter.wrap($converterunit);
  static TypeConverter<Map<String, Object?>, String> $converterdetails =
      const JsonMapConverter();
}

class EntryRow extends DataClass implements Insertable<EntryRow> {
  final String id;
  final String petId;
  final EntryType type;
  final DateTime occurredAt;

  /// 完成了哪个计划；计划删除后记录保留，只是不再关联。
  final String? planId;

  /// 能换算的量按标准单位存（体重 kg、饮水 ml），此时 [unit] 为空；
  /// 饮食和用药按用户选的单位原样存。
  final double? amount;
  final PortionUnit? unit;
  final DateTime? startedAt;

  /// 遛狗为空表示正在进行。
  final DateTime? endedAt;
  final int? durationSec;
  final double? distanceM;

  /// 只存 code，见 EntryDetails。
  final Map<String, Object?> details;

  /// 用户填写的名称：药品、疫苗、自定义事项。引擎不读取。
  final String? label;

  /// 用户写的备注。引擎不读取。
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const EntryRow({
    required this.id,
    required this.petId,
    required this.type,
    required this.occurredAt,
    this.planId,
    this.amount,
    this.unit,
    this.startedAt,
    this.endedAt,
    this.durationSec,
    this.distanceM,
    required this.details,
    this.label,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pet_id'] = Variable<String>(petId);
    {
      map['type'] = Variable<String>($EntriesTable.$convertertype.toSql(type));
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<String>(planId);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>($EntriesTable.$converterunitn.toSql(unit));
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || durationSec != null) {
      map['duration_sec'] = Variable<int>(durationSec);
    }
    if (!nullToAbsent || distanceM != null) {
      map['distance_m'] = Variable<double>(distanceM);
    }
    {
      map['details'] = Variable<String>(
        $EntriesTable.$converterdetails.toSql(details),
      );
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EntriesCompanion toCompanion(bool nullToAbsent) {
    return EntriesCompanion(
      id: Value(id),
      petId: Value(petId),
      type: Value(type),
      occurredAt: Value(occurredAt),
      planId: planId == null && nullToAbsent
          ? const Value.absent()
          : Value(planId),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      durationSec: durationSec == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSec),
      distanceM: distanceM == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceM),
      details: Value(details),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      note: Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntryRow(
      id: serializer.fromJson<String>(json['id']),
      petId: serializer.fromJson<String>(json['petId']),
      type: serializer.fromJson<EntryType>(json['type']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      planId: serializer.fromJson<String?>(json['planId']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<PortionUnit?>(json['unit']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      durationSec: serializer.fromJson<int?>(json['durationSec']),
      distanceM: serializer.fromJson<double?>(json['distanceM']),
      details: serializer.fromJson<Map<String, Object?>>(json['details']),
      label: serializer.fromJson<String?>(json['label']),
      note: serializer.fromJson<String>(json['note']),
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
      'type': serializer.toJson<EntryType>(type),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'planId': serializer.toJson<String?>(planId),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<PortionUnit?>(unit),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'durationSec': serializer.toJson<int?>(durationSec),
      'distanceM': serializer.toJson<double?>(distanceM),
      'details': serializer.toJson<Map<String, Object?>>(details),
      'label': serializer.toJson<String?>(label),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EntryRow copyWith({
    String? id,
    String? petId,
    EntryType? type,
    DateTime? occurredAt,
    Value<String?> planId = const Value.absent(),
    Value<double?> amount = const Value.absent(),
    Value<PortionUnit?> unit = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> endedAt = const Value.absent(),
    Value<int?> durationSec = const Value.absent(),
    Value<double?> distanceM = const Value.absent(),
    Map<String, Object?>? details,
    Value<String?> label = const Value.absent(),
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EntryRow(
    id: id ?? this.id,
    petId: petId ?? this.petId,
    type: type ?? this.type,
    occurredAt: occurredAt ?? this.occurredAt,
    planId: planId.present ? planId.value : this.planId,
    amount: amount.present ? amount.value : this.amount,
    unit: unit.present ? unit.value : this.unit,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    durationSec: durationSec.present ? durationSec.value : this.durationSec,
    distanceM: distanceM.present ? distanceM.value : this.distanceM,
    details: details ?? this.details,
    label: label.present ? label.value : this.label,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EntryRow copyWithCompanion(EntriesCompanion data) {
    return EntryRow(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      type: data.type.present ? data.type.value : this.type,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      planId: data.planId.present ? data.planId.value : this.planId,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      details: data.details.present ? data.details.value : this.details,
      label: data.label.present ? data.label.value : this.label,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntryRow(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('type: $type, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('planId: $planId, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSec: $durationSec, ')
          ..write('distanceM: $distanceM, ')
          ..write('details: $details, ')
          ..write('label: $label, ')
          ..write('note: $note, ')
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
    planId,
    amount,
    unit,
    startedAt,
    endedAt,
    durationSec,
    distanceM,
    details,
    label,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntryRow &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.type == this.type &&
          other.occurredAt == this.occurredAt &&
          other.planId == this.planId &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSec == this.durationSec &&
          other.distanceM == this.distanceM &&
          other.details == this.details &&
          other.label == this.label &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EntriesCompanion extends UpdateCompanion<EntryRow> {
  final Value<String> id;
  final Value<String> petId;
  final Value<EntryType> type;
  final Value<DateTime> occurredAt;
  final Value<String?> planId;
  final Value<double?> amount;
  final Value<PortionUnit?> unit;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int?> durationSec;
  final Value<double?> distanceM;
  final Value<Map<String, Object?>> details;
  final Value<String?> label;
  final Value<String> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EntriesCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.type = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.planId = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.details = const Value.absent(),
    this.label = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntriesCompanion.insert({
    required String id,
    required String petId,
    required EntryType type,
    required DateTime occurredAt,
    this.planId = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.details = const Value.absent(),
    this.label = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       petId = Value(petId),
       type = Value(type),
       occurredAt = Value(occurredAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<EntryRow> custom({
    Expression<String>? id,
    Expression<String>? petId,
    Expression<String>? type,
    Expression<DateTime>? occurredAt,
    Expression<String>? planId,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationSec,
    Expression<double>? distanceM,
    Expression<String>? details,
    Expression<String>? label,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (type != null) 'type': type,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (planId != null) 'plan_id': planId,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSec != null) 'duration_sec': durationSec,
      if (distanceM != null) 'distance_m': distanceM,
      if (details != null) 'details': details,
      if (label != null) 'label': label,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? petId,
    Value<EntryType>? type,
    Value<DateTime>? occurredAt,
    Value<String?>? planId,
    Value<double?>? amount,
    Value<PortionUnit?>? unit,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int?>? durationSec,
    Value<double?>? distanceM,
    Value<Map<String, Object?>>? details,
    Value<String?>? label,
    Value<String>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return EntriesCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      type: type ?? this.type,
      occurredAt: occurredAt ?? this.occurredAt,
      planId: planId ?? this.planId,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSec: durationSec ?? this.durationSec,
      distanceM: distanceM ?? this.distanceM,
      details: details ?? this.details,
      label: label ?? this.label,
      note: note ?? this.note,
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
      map['type'] = Variable<String>(
        $EntriesTable.$convertertype.toSql(type.value),
      );
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $EntriesTable.$converterunitn.toSql(unit.value),
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<double>(distanceM.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(
        $EntriesTable.$converterdetails.toSql(details.value),
      );
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
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
    return (StringBuffer('EntriesCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('type: $type, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('planId: $planId, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSec: $durationSec, ')
          ..write('distanceM: $distanceM, ')
          ..write('details: $details, ')
          ..write('label: $label, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardHistoryTable extends CardHistory
    with TableInfo<$CardHistoryTable, CardHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardHistoryTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> day =
      GeneratedColumn<String>(
        'day',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($CardHistoryTable.$converterday);
  static const VerificationMeta _cardKeyMeta = const VerificationMeta(
    'cardKey',
  );
  @override
  late final GeneratedColumn<String> cardKey = GeneratedColumn<String>(
    'card_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CardCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CardCategory>($CardHistoryTable.$convertercategory);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  params = GeneratedColumn<String>(
    'params',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, Object?>>($CardHistoryTable.$converterparams);
  static const VerificationMeta _dismissedMeta = const VerificationMeta(
    'dismissed',
  );
  @override
  late final GeneratedColumn<bool> dismissed = GeneratedColumn<bool>(
    'dismissed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dismissed" IN (0, 1))',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    petId,
    day,
    cardKey,
    category,
    params,
    dismissed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardHistoryRow> instance, {
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
    if (data.containsKey('card_key')) {
      context.handle(
        _cardKeyMeta,
        cardKey.isAcceptableOrUnknown(data['card_key']!, _cardKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cardKeyMeta);
    }
    if (data.containsKey('dismissed')) {
      context.handle(
        _dismissedMeta,
        dismissed.isAcceptableOrUnknown(data['dismissed']!, _dismissedMeta),
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
  CardHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      petId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_id'],
      )!,
      day: $CardHistoryTable.$converterday.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}day'],
        )!,
      ),
      cardKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_key'],
      )!,
      category: $CardHistoryTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      params: $CardHistoryTable.$converterparams.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}params'],
        )!,
      ),
      dismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dismissed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CardHistoryTable createAlias(String alias) {
    return $CardHistoryTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterday =
      const LocalDateConverter();
  static TypeConverter<CardCategory, String> $convertercategory =
      const CodedEnumConverter(CardCategory.values);
  static TypeConverter<Map<String, Object?>, String> $converterparams =
      const JsonMapConverter();
}

class CardHistoryRow extends DataClass implements Insertable<CardHistoryRow> {
  final String id;
  final String petId;
  final DateTime day;
  final String cardKey;
  final CardCategory category;
  final Map<String, Object?> params;
  final bool dismissed;
  final DateTime createdAt;
  const CardHistoryRow({
    required this.id,
    required this.petId,
    required this.day,
    required this.cardKey,
    required this.category,
    required this.params,
    required this.dismissed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pet_id'] = Variable<String>(petId);
    {
      map['day'] = Variable<String>($CardHistoryTable.$converterday.toSql(day));
    }
    map['card_key'] = Variable<String>(cardKey);
    {
      map['category'] = Variable<String>(
        $CardHistoryTable.$convertercategory.toSql(category),
      );
    }
    {
      map['params'] = Variable<String>(
        $CardHistoryTable.$converterparams.toSql(params),
      );
    }
    map['dismissed'] = Variable<bool>(dismissed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CardHistoryCompanion toCompanion(bool nullToAbsent) {
    return CardHistoryCompanion(
      id: Value(id),
      petId: Value(petId),
      day: Value(day),
      cardKey: Value(cardKey),
      category: Value(category),
      params: Value(params),
      dismissed: Value(dismissed),
      createdAt: Value(createdAt),
    );
  }

  factory CardHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardHistoryRow(
      id: serializer.fromJson<String>(json['id']),
      petId: serializer.fromJson<String>(json['petId']),
      day: serializer.fromJson<DateTime>(json['day']),
      cardKey: serializer.fromJson<String>(json['cardKey']),
      category: serializer.fromJson<CardCategory>(json['category']),
      params: serializer.fromJson<Map<String, Object?>>(json['params']),
      dismissed: serializer.fromJson<bool>(json['dismissed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'petId': serializer.toJson<String>(petId),
      'day': serializer.toJson<DateTime>(day),
      'cardKey': serializer.toJson<String>(cardKey),
      'category': serializer.toJson<CardCategory>(category),
      'params': serializer.toJson<Map<String, Object?>>(params),
      'dismissed': serializer.toJson<bool>(dismissed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CardHistoryRow copyWith({
    String? id,
    String? petId,
    DateTime? day,
    String? cardKey,
    CardCategory? category,
    Map<String, Object?>? params,
    bool? dismissed,
    DateTime? createdAt,
  }) => CardHistoryRow(
    id: id ?? this.id,
    petId: petId ?? this.petId,
    day: day ?? this.day,
    cardKey: cardKey ?? this.cardKey,
    category: category ?? this.category,
    params: params ?? this.params,
    dismissed: dismissed ?? this.dismissed,
    createdAt: createdAt ?? this.createdAt,
  );
  CardHistoryRow copyWithCompanion(CardHistoryCompanion data) {
    return CardHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      day: data.day.present ? data.day.value : this.day,
      cardKey: data.cardKey.present ? data.cardKey.value : this.cardKey,
      category: data.category.present ? data.category.value : this.category,
      params: data.params.present ? data.params.value : this.params,
      dismissed: data.dismissed.present ? data.dismissed.value : this.dismissed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardHistoryRow(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('day: $day, ')
          ..write('cardKey: $cardKey, ')
          ..write('category: $category, ')
          ..write('params: $params, ')
          ..write('dismissed: $dismissed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    petId,
    day,
    cardKey,
    category,
    params,
    dismissed,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardHistoryRow &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.day == this.day &&
          other.cardKey == this.cardKey &&
          other.category == this.category &&
          other.params == this.params &&
          other.dismissed == this.dismissed &&
          other.createdAt == this.createdAt);
}

class CardHistoryCompanion extends UpdateCompanion<CardHistoryRow> {
  final Value<String> id;
  final Value<String> petId;
  final Value<DateTime> day;
  final Value<String> cardKey;
  final Value<CardCategory> category;
  final Value<Map<String, Object?>> params;
  final Value<bool> dismissed;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CardHistoryCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.day = const Value.absent(),
    this.cardKey = const Value.absent(),
    this.category = const Value.absent(),
    this.params = const Value.absent(),
    this.dismissed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardHistoryCompanion.insert({
    required String id,
    required String petId,
    required DateTime day,
    required String cardKey,
    required CardCategory category,
    this.params = const Value.absent(),
    this.dismissed = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       petId = Value(petId),
       day = Value(day),
       cardKey = Value(cardKey),
       category = Value(category),
       createdAt = Value(createdAt);
  static Insertable<CardHistoryRow> custom({
    Expression<String>? id,
    Expression<String>? petId,
    Expression<String>? day,
    Expression<String>? cardKey,
    Expression<String>? category,
    Expression<String>? params,
    Expression<bool>? dismissed,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (day != null) 'day': day,
      if (cardKey != null) 'card_key': cardKey,
      if (category != null) 'category': category,
      if (params != null) 'params': params,
      if (dismissed != null) 'dismissed': dismissed,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardHistoryCompanion copyWith({
    Value<String>? id,
    Value<String>? petId,
    Value<DateTime>? day,
    Value<String>? cardKey,
    Value<CardCategory>? category,
    Value<Map<String, Object?>>? params,
    Value<bool>? dismissed,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CardHistoryCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      day: day ?? this.day,
      cardKey: cardKey ?? this.cardKey,
      category: category ?? this.category,
      params: params ?? this.params,
      dismissed: dismissed ?? this.dismissed,
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
    if (petId.present) {
      map['pet_id'] = Variable<String>(petId.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(
        $CardHistoryTable.$converterday.toSql(day.value),
      );
    }
    if (cardKey.present) {
      map['card_key'] = Variable<String>(cardKey.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $CardHistoryTable.$convertercategory.toSql(category.value),
      );
    }
    if (params.present) {
      map['params'] = Variable<String>(
        $CardHistoryTable.$converterparams.toSql(params.value),
      );
    }
    if (dismissed.present) {
      map['dismissed'] = Variable<bool>(dismissed.value);
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
    return (StringBuffer('CardHistoryCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('day: $day, ')
          ..write('cardKey: $cardKey, ')
          ..write('category: $category, ')
          ..write('params: $params, ')
          ..write('dismissed: $dismissed, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeatherDaysTable extends WeatherDays
    with TableInfo<$WeatherDaysTable, WeatherDayRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeatherDaysTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> day =
      GeneratedColumn<String>(
        'day',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($WeatherDaysTable.$converterday);
  static const VerificationMeta _maxCMeta = const VerificationMeta('maxC');
  @override
  late final GeneratedColumn<double> maxC = GeneratedColumn<double>(
    'max_c',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minCMeta = const VerificationMeta('minC');
  @override
  late final GeneratedColumn<double> minC = GeneratedColumn<double>(
    'min_c',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precipProbMeta = const VerificationMeta(
    'precipProb',
  );
  @override
  late final GeneratedColumn<int> precipProb = GeneratedColumn<int>(
    'precip_prob',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uvMaxMeta = const VerificationMeta('uvMax');
  @override
  late final GeneratedColumn<double> uvMax = GeneratedColumn<double>(
    'uv_max',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    day,
    maxC,
    minC,
    precipProb,
    uvMax,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weather_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeatherDayRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('max_c')) {
      context.handle(
        _maxCMeta,
        maxC.isAcceptableOrUnknown(data['max_c']!, _maxCMeta),
      );
    } else if (isInserting) {
      context.missing(_maxCMeta);
    }
    if (data.containsKey('min_c')) {
      context.handle(
        _minCMeta,
        minC.isAcceptableOrUnknown(data['min_c']!, _minCMeta),
      );
    } else if (isInserting) {
      context.missing(_minCMeta);
    }
    if (data.containsKey('precip_prob')) {
      context.handle(
        _precipProbMeta,
        precipProb.isAcceptableOrUnknown(data['precip_prob']!, _precipProbMeta),
      );
    } else if (isInserting) {
      context.missing(_precipProbMeta);
    }
    if (data.containsKey('uv_max')) {
      context.handle(
        _uvMaxMeta,
        uvMax.isAcceptableOrUnknown(data['uv_max']!, _uvMaxMeta),
      );
    } else if (isInserting) {
      context.missing(_uvMaxMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  WeatherDayRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeatherDayRow(
      day: $WeatherDaysTable.$converterday.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}day'],
        )!,
      ),
      maxC: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_c'],
      )!,
      minC: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_c'],
      )!,
      precipProb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}precip_prob'],
      )!,
      uvMax: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}uv_max'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $WeatherDaysTable createAlias(String alias) {
    return $WeatherDaysTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterday =
      const LocalDateConverter();
}

class WeatherDayRow extends DataClass implements Insertable<WeatherDayRow> {
  final DateTime day;
  final double maxC;
  final double minC;
  final int precipProb;
  final double uvMax;
  final DateTime fetchedAt;
  const WeatherDayRow({
    required this.day,
    required this.maxC,
    required this.minC,
    required this.precipProb,
    required this.uvMax,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['day'] = Variable<String>($WeatherDaysTable.$converterday.toSql(day));
    }
    map['max_c'] = Variable<double>(maxC);
    map['min_c'] = Variable<double>(minC);
    map['precip_prob'] = Variable<int>(precipProb);
    map['uv_max'] = Variable<double>(uvMax);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  WeatherDaysCompanion toCompanion(bool nullToAbsent) {
    return WeatherDaysCompanion(
      day: Value(day),
      maxC: Value(maxC),
      minC: Value(minC),
      precipProb: Value(precipProb),
      uvMax: Value(uvMax),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory WeatherDayRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeatherDayRow(
      day: serializer.fromJson<DateTime>(json['day']),
      maxC: serializer.fromJson<double>(json['maxC']),
      minC: serializer.fromJson<double>(json['minC']),
      precipProb: serializer.fromJson<int>(json['precipProb']),
      uvMax: serializer.fromJson<double>(json['uvMax']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<DateTime>(day),
      'maxC': serializer.toJson<double>(maxC),
      'minC': serializer.toJson<double>(minC),
      'precipProb': serializer.toJson<int>(precipProb),
      'uvMax': serializer.toJson<double>(uvMax),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  WeatherDayRow copyWith({
    DateTime? day,
    double? maxC,
    double? minC,
    int? precipProb,
    double? uvMax,
    DateTime? fetchedAt,
  }) => WeatherDayRow(
    day: day ?? this.day,
    maxC: maxC ?? this.maxC,
    minC: minC ?? this.minC,
    precipProb: precipProb ?? this.precipProb,
    uvMax: uvMax ?? this.uvMax,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  WeatherDayRow copyWithCompanion(WeatherDaysCompanion data) {
    return WeatherDayRow(
      day: data.day.present ? data.day.value : this.day,
      maxC: data.maxC.present ? data.maxC.value : this.maxC,
      minC: data.minC.present ? data.minC.value : this.minC,
      precipProb: data.precipProb.present
          ? data.precipProb.value
          : this.precipProb,
      uvMax: data.uvMax.present ? data.uvMax.value : this.uvMax,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeatherDayRow(')
          ..write('day: $day, ')
          ..write('maxC: $maxC, ')
          ..write('minC: $minC, ')
          ..write('precipProb: $precipProb, ')
          ..write('uvMax: $uvMax, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(day, maxC, minC, precipProb, uvMax, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherDayRow &&
          other.day == this.day &&
          other.maxC == this.maxC &&
          other.minC == this.minC &&
          other.precipProb == this.precipProb &&
          other.uvMax == this.uvMax &&
          other.fetchedAt == this.fetchedAt);
}

class WeatherDaysCompanion extends UpdateCompanion<WeatherDayRow> {
  final Value<DateTime> day;
  final Value<double> maxC;
  final Value<double> minC;
  final Value<int> precipProb;
  final Value<double> uvMax;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const WeatherDaysCompanion({
    this.day = const Value.absent(),
    this.maxC = const Value.absent(),
    this.minC = const Value.absent(),
    this.precipProb = const Value.absent(),
    this.uvMax = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeatherDaysCompanion.insert({
    required DateTime day,
    required double maxC,
    required double minC,
    required int precipProb,
    required double uvMax,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : day = Value(day),
       maxC = Value(maxC),
       minC = Value(minC),
       precipProb = Value(precipProb),
       uvMax = Value(uvMax),
       fetchedAt = Value(fetchedAt);
  static Insertable<WeatherDayRow> custom({
    Expression<String>? day,
    Expression<double>? maxC,
    Expression<double>? minC,
    Expression<int>? precipProb,
    Expression<double>? uvMax,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (maxC != null) 'max_c': maxC,
      if (minC != null) 'min_c': minC,
      if (precipProb != null) 'precip_prob': precipProb,
      if (uvMax != null) 'uv_max': uvMax,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeatherDaysCompanion copyWith({
    Value<DateTime>? day,
    Value<double>? maxC,
    Value<double>? minC,
    Value<int>? precipProb,
    Value<double>? uvMax,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return WeatherDaysCompanion(
      day: day ?? this.day,
      maxC: maxC ?? this.maxC,
      minC: minC ?? this.minC,
      precipProb: precipProb ?? this.precipProb,
      uvMax: uvMax ?? this.uvMax,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<String>(
        $WeatherDaysTable.$converterday.toSql(day.value),
      );
    }
    if (maxC.present) {
      map['max_c'] = Variable<double>(maxC.value);
    }
    if (minC.present) {
      map['min_c'] = Variable<double>(minC.value);
    }
    if (precipProb.present) {
      map['precip_prob'] = Variable<int>(precipProb.value);
    }
    if (uvMax.present) {
      map['uv_max'] = Variable<double>(uvMax.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeatherDaysCompanion(')
          ..write('day: $day, ')
          ..write('maxC: $maxC, ')
          ..write('minC: $minC, ')
          ..write('precipProb: $precipProb, ')
          ..write('uvMax: $uvMax, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, SettingRow> {
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
    Insertable<SettingRow> instance, {
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
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
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

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const SettingRow({
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

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
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

  SettingRow copyWith({String? key, String? value, DateTime? updatedAt}) =>
      SettingRow(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SettingRow copyWithCompanion(AppSettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
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
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<SettingRow> {
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
  static Insertable<SettingRow> custom({
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
    with TableInfo<$PetPhotosTable, PetPhotoRow> {
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
    Insertable<PetPhotoRow> instance, {
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
  PetPhotoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PetPhotoRow(
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

class PetPhotoRow extends DataClass implements Insertable<PetPhotoRow> {
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
  const PetPhotoRow({
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

  factory PetPhotoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PetPhotoRow(
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

  PetPhotoRow copyWith({
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
  }) => PetPhotoRow(
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
  PetPhotoRow copyWithCompanion(PetPhotosCompanion data) {
    return PetPhotoRow(
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
    return (StringBuffer('PetPhotoRow(')
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
      (other is PetPhotoRow &&
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

class PetPhotosCompanion extends UpdateCompanion<PetPhotoRow> {
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
  static Insertable<PetPhotoRow> custom({
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
    with TableInfo<$MemoryEntriesTable, MemoryEntryRow> {
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
    Insertable<MemoryEntryRow> instance, {
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
  MemoryEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryEntryRow(
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

class MemoryEntryRow extends DataClass implements Insertable<MemoryEntryRow> {
  final String id;
  final String petId;
  final DateTime occurredAt;
  final String note;
  final String? moodEmoji;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MemoryEntryRow({
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

  factory MemoryEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryEntryRow(
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

  MemoryEntryRow copyWith({
    String? id,
    String? petId,
    DateTime? occurredAt,
    String? note,
    Value<String?> moodEmoji = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MemoryEntryRow(
    id: id ?? this.id,
    petId: petId ?? this.petId,
    occurredAt: occurredAt ?? this.occurredAt,
    note: note ?? this.note,
    moodEmoji: moodEmoji.present ? moodEmoji.value : this.moodEmoji,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MemoryEntryRow copyWithCompanion(MemoryEntriesCompanion data) {
    return MemoryEntryRow(
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
    return (StringBuffer('MemoryEntryRow(')
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
      (other is MemoryEntryRow &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.occurredAt == this.occurredAt &&
          other.note == this.note &&
          other.moodEmoji == this.moodEmoji &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MemoryEntriesCompanion extends UpdateCompanion<MemoryEntryRow> {
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
  static Insertable<MemoryEntryRow> custom({
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
    with TableInfo<$MemoryMediaRefsTable, MemoryMediaRefRow> {
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
    Insertable<MemoryMediaRefRow> instance, {
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
  MemoryMediaRefRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryMediaRefRow(
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

class MemoryMediaRefRow extends DataClass
    implements Insertable<MemoryMediaRefRow> {
  final String id;
  final String entryId;
  final String kind;
  final String platformRef;
  final int position;
  final int? width;
  final int? height;
  final int? durationMs;
  final DateTime? capturedAt;
  const MemoryMediaRefRow({
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

  factory MemoryMediaRefRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryMediaRefRow(
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

  MemoryMediaRefRow copyWith({
    String? id,
    String? entryId,
    String? kind,
    String? platformRef,
    int? position,
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<DateTime?> capturedAt = const Value.absent(),
  }) => MemoryMediaRefRow(
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
  MemoryMediaRefRow copyWithCompanion(MemoryMediaRefsCompanion data) {
    return MemoryMediaRefRow(
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
    return (StringBuffer('MemoryMediaRefRow(')
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
      (other is MemoryMediaRefRow &&
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

class MemoryMediaRefsCompanion extends UpdateCompanion<MemoryMediaRefRow> {
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
  static Insertable<MemoryMediaRefRow> custom({
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

abstract class _$PetHealthDatabase extends GeneratedDatabase {
  _$PetHealthDatabase(QueryExecutor e) : super(e);
  $PetHealthDatabaseManager get managers => $PetHealthDatabaseManager(this);
  late final $PetsTable pets = $PetsTable(this);
  late final $PetPresetsTable petPresets = $PetPresetsTable(this);
  late final $PlansTable plans = $PlansTable(this);
  late final $EntriesTable entries = $EntriesTable(this);
  late final $CardHistoryTable cardHistory = $CardHistoryTable(this);
  late final $WeatherDaysTable weatherDays = $WeatherDaysTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $PetPhotosTable petPhotos = $PetPhotosTable(this);
  late final $MemoryEntriesTable memoryEntries = $MemoryEntriesTable(this);
  late final $MemoryMediaRefsTable memoryMediaRefs = $MemoryMediaRefsTable(
    this,
  );
  late final Index entriesPetOccurred = Index(
    'entries_pet_occurred',
    'CREATE INDEX entries_pet_occurred ON entries (pet_id, occurred_at)',
  );
  late final Index entriesPetTypeOccurred = Index(
    'entries_pet_type_occurred',
    'CREATE INDEX entries_pet_type_occurred ON entries (pet_id, type, occurred_at)',
  );
  late final Index entriesPlan = Index(
    'entries_plan',
    'CREATE INDEX entries_plan ON entries (plan_id)',
  );
  late final Index oneActiveWalkPerPet = Index(
    'one_active_walk_per_pet',
    'CREATE UNIQUE INDEX one_active_walk_per_pet ON entries (pet_id) WHERE type = \'walk\' AND ended_at IS NULL',
  );
  late final Index plansPet = Index(
    'plans_pet',
    'CREATE INDEX plans_pet ON plans (pet_id)',
  );
  late final Index cardHistoryPetDayKey = Index(
    'card_history_pet_day_key',
    'CREATE UNIQUE INDEX card_history_pet_day_key ON card_history (pet_id, day, card_key)',
  );
  late final Index petPhotosPetCreated = Index(
    'pet_photos_pet_created',
    'CREATE INDEX pet_photos_pet_created ON pet_photos (pet_id, created_at)',
  );
  late final Index oneAvatarPerPet = Index(
    'one_avatar_per_pet',
    'CREATE UNIQUE INDEX one_avatar_per_pet ON pet_photos (pet_id) WHERE is_avatar = 1',
  );
  late final Index memoryEntriesPetOccurred = Index(
    'memory_entries_pet_occurred',
    'CREATE INDEX memory_entries_pet_occurred ON memory_entries (pet_id, occurred_at)',
  );
  late final Index memoryMediaEntryPosition = Index(
    'memory_media_entry_position',
    'CREATE INDEX memory_media_entry_position ON memory_media_refs (entry_id, position)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pets,
    petPresets,
    plans,
    entries,
    cardHistory,
    weatherDays,
    appSettings,
    petPhotos,
    memoryEntries,
    memoryMediaRefs,
    entriesPetOccurred,
    entriesPetTypeOccurred,
    entriesPlan,
    oneActiveWalkPerPet,
    plansPet,
    cardHistoryPetDayKey,
    petPhotosPetCreated,
    oneAvatarPerPet,
    memoryEntriesPetOccurred,
    memoryMediaEntryPosition,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pet_presets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('plans', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('entries', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('card_history', kind: UpdateKind.delete)],
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
  ]);
}

typedef $$PetsTableCreateCompanionBuilder =
    PetsCompanion Function({
      required String id,
      required String name,
      Value<PetSex?> sex,
      Value<bool?> neutered,
      Value<DateTime?> birthDate,
      Value<BirthPrecision> birthPrecision,
      Value<DateTime?> homeDate,
      Value<String?> breedCode,
      Value<String?> breedName,
      Value<BreedGroup> breedGroup,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PetsTableUpdateCompanionBuilder =
    PetsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<PetSex?> sex,
      Value<bool?> neutered,
      Value<DateTime?> birthDate,
      Value<BirthPrecision> birthPrecision,
      Value<DateTime?> homeDate,
      Value<String?> breedCode,
      Value<String?> breedName,
      Value<BreedGroup> breedGroup,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PetsTableReferences
    extends BaseReferences<_$PetHealthDatabase, $PetsTable, PetRow> {
  $$PetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PetPresetsTable, List<PetPresetRow>>
  _petPresetsRefsTable(_$PetHealthDatabase db) => MultiTypedResultKey.fromTable(
    db.petPresets,
    aliasName: 'pets__id__pet_presets__pet_id',
  );

  $$PetPresetsTableProcessedTableManager get petPresetsRefs {
    final manager = $$PetPresetsTableTableManager(
      $_db,
      $_db.petPresets,
    ).filter((f) => f.petId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_petPresetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlansTable, List<PlanRow>> _plansRefsTable(
    _$PetHealthDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.plans,
    aliasName: 'pets__id__plans__pet_id',
  );

  $$PlansTableProcessedTableManager get plansRefs {
    final manager = $$PlansTableTableManager(
      $_db,
      $_db.plans,
    ).filter((f) => f.petId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_plansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EntriesTable, List<EntryRow>> _entriesRefsTable(
    _$PetHealthDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.entries,
    aliasName: 'pets__id__entries__pet_id',
  );

  $$EntriesTableProcessedTableManager get entriesRefs {
    final manager = $$EntriesTableTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.petId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CardHistoryTable, List<CardHistoryRow>>
  _cardHistoryRefsTable(_$PetHealthDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cardHistory,
        aliasName: 'pets__id__card_history__pet_id',
      );

  $$CardHistoryTableProcessedTableManager get cardHistoryRefs {
    final manager = $$CardHistoryTableTableManager(
      $_db,
      $_db.cardHistory,
    ).filter((f) => f.petId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardHistoryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PetPhotosTable, List<PetPhotoRow>>
  _petPhotosRefsTable(_$PetHealthDatabase db) => MultiTypedResultKey.fromTable(
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

  static MultiTypedResultKey<$MemoryEntriesTable, List<MemoryEntryRow>>
  _memoryEntriesRefsTable(_$PetHealthDatabase db) =>
      MultiTypedResultKey.fromTable(
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
}

class $$PetsTableFilterComposer
    extends Composer<_$PetHealthDatabase, $PetsTable> {
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

  ColumnWithTypeConverterFilters<PetSex?, PetSex, String> get sex =>
      $composableBuilder(
        column: $table.sex,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get neutered => $composableBuilder(
    column: $table.neutered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String> get birthDate =>
      $composableBuilder(
        column: $table.birthDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<BirthPrecision, BirthPrecision, String>
  get birthPrecision => $composableBuilder(
    column: $table.birthPrecision,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String> get homeDate =>
      $composableBuilder(
        column: $table.homeDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get breedCode => $composableBuilder(
    column: $table.breedCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breedName => $composableBuilder(
    column: $table.breedName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BreedGroup, BreedGroup, String>
  get breedGroup => $composableBuilder(
    column: $table.breedGroup,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> petPresetsRefs(
    Expression<bool> Function($$PetPresetsTableFilterComposer f) f,
  ) {
    final $$PetPresetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.petPresets,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetPresetsTableFilterComposer(
            $db: $db,
            $table: $db.petPresets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> plansRefs(
    Expression<bool> Function($$PlansTableFilterComposer f) f,
  ) {
    final $$PlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableFilterComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> entriesRefs(
    Expression<bool> Function($$EntriesTableFilterComposer f) f,
  ) {
    final $$EntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cardHistoryRefs(
    Expression<bool> Function($$CardHistoryTableFilterComposer f) f,
  ) {
    final $$CardHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardHistory,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardHistoryTableFilterComposer(
            $db: $db,
            $table: $db.cardHistory,
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
}

class $$PetsTableOrderingComposer
    extends Composer<_$PetHealthDatabase, $PetsTable> {
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

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get neutered => $composableBuilder(
    column: $table.neutered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthPrecision => $composableBuilder(
    column: $table.birthPrecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get homeDate => $composableBuilder(
    column: $table.homeDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breedCode => $composableBuilder(
    column: $table.breedCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breedName => $composableBuilder(
    column: $table.breedName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breedGroup => $composableBuilder(
    column: $table.breedGroup,
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
    extends Composer<_$PetHealthDatabase, $PetsTable> {
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

  GeneratedColumnWithTypeConverter<PetSex?, String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<bool> get neutered =>
      $composableBuilder(column: $table.neutered, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BirthPrecision, String> get birthPrecision =>
      $composableBuilder(
        column: $table.birthPrecision,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DateTime?, String> get homeDate =>
      $composableBuilder(column: $table.homeDate, builder: (column) => column);

  GeneratedColumn<String> get breedCode =>
      $composableBuilder(column: $table.breedCode, builder: (column) => column);

  GeneratedColumn<String> get breedName =>
      $composableBuilder(column: $table.breedName, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BreedGroup, String> get breedGroup =>
      $composableBuilder(
        column: $table.breedGroup,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> petPresetsRefs<T extends Object>(
    Expression<T> Function($$PetPresetsTableAnnotationComposer a) f,
  ) {
    final $$PetPresetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.petPresets,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetPresetsTableAnnotationComposer(
            $db: $db,
            $table: $db.petPresets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> plansRefs<T extends Object>(
    Expression<T> Function($$PlansTableAnnotationComposer a) f,
  ) {
    final $$PlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableAnnotationComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> entriesRefs<T extends Object>(
    Expression<T> Function($$EntriesTableAnnotationComposer a) f,
  ) {
    final $$EntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cardHistoryRefs<T extends Object>(
    Expression<T> Function($$CardHistoryTableAnnotationComposer a) f,
  ) {
    final $$CardHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardHistory,
      getReferencedColumn: (t) => t.petId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.cardHistory,
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
}

class $$PetsTableTableManager
    extends
        RootTableManager<
          _$PetHealthDatabase,
          $PetsTable,
          PetRow,
          $$PetsTableFilterComposer,
          $$PetsTableOrderingComposer,
          $$PetsTableAnnotationComposer,
          $$PetsTableCreateCompanionBuilder,
          $$PetsTableUpdateCompanionBuilder,
          (PetRow, $$PetsTableReferences),
          PetRow,
          PrefetchHooks Function({
            bool petPresetsRefs,
            bool plansRefs,
            bool entriesRefs,
            bool cardHistoryRefs,
            bool petPhotosRefs,
            bool memoryEntriesRefs,
          })
        > {
  $$PetsTableTableManager(_$PetHealthDatabase db, $PetsTable table)
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
                Value<PetSex?> sex = const Value.absent(),
                Value<bool?> neutered = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<BirthPrecision> birthPrecision = const Value.absent(),
                Value<DateTime?> homeDate = const Value.absent(),
                Value<String?> breedCode = const Value.absent(),
                Value<String?> breedName = const Value.absent(),
                Value<BreedGroup> breedGroup = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PetsCompanion(
                id: id,
                name: name,
                sex: sex,
                neutered: neutered,
                birthDate: birthDate,
                birthPrecision: birthPrecision,
                homeDate: homeDate,
                breedCode: breedCode,
                breedName: breedName,
                breedGroup: breedGroup,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<PetSex?> sex = const Value.absent(),
                Value<bool?> neutered = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<BirthPrecision> birthPrecision = const Value.absent(),
                Value<DateTime?> homeDate = const Value.absent(),
                Value<String?> breedCode = const Value.absent(),
                Value<String?> breedName = const Value.absent(),
                Value<BreedGroup> breedGroup = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PetsCompanion.insert(
                id: id,
                name: name,
                sex: sex,
                neutered: neutered,
                birthDate: birthDate,
                birthPrecision: birthPrecision,
                homeDate: homeDate,
                breedCode: breedCode,
                breedName: breedName,
                breedGroup: breedGroup,
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
                petPresetsRefs = false,
                plansRefs = false,
                entriesRefs = false,
                cardHistoryRefs = false,
                petPhotosRefs = false,
                memoryEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (petPresetsRefs) db.petPresets,
                    if (plansRefs) db.plans,
                    if (entriesRefs) db.entries,
                    if (cardHistoryRefs) db.cardHistory,
                    if (petPhotosRefs) db.petPhotos,
                    if (memoryEntriesRefs) db.memoryEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (petPresetsRefs)
                        await $_getPrefetchedData<
                          PetRow,
                          $PetsTable,
                          PetPresetRow
                        >(
                          currentTable: table,
                          referencedTable: $$PetsTableReferences
                              ._petPresetsRefsTable(db),
                          managerFromTypedResult: (p0) => $$PetsTableReferences(
                            db,
                            table,
                            p0,
                          ).petPresetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.petId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (plansRefs)
                        await $_getPrefetchedData<PetRow, $PetsTable, PlanRow>(
                          currentTable: table,
                          referencedTable: $$PetsTableReferences
                              ._plansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PetsTableReferences(db, table, p0).plansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.petId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (entriesRefs)
                        await $_getPrefetchedData<PetRow, $PetsTable, EntryRow>(
                          currentTable: table,
                          referencedTable: $$PetsTableReferences
                              ._entriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PetsTableReferences(db, table, p0).entriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.petId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cardHistoryRefs)
                        await $_getPrefetchedData<
                          PetRow,
                          $PetsTable,
                          CardHistoryRow
                        >(
                          currentTable: table,
                          referencedTable: $$PetsTableReferences
                              ._cardHistoryRefsTable(db),
                          managerFromTypedResult: (p0) => $$PetsTableReferences(
                            db,
                            table,
                            p0,
                          ).cardHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.petId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (petPhotosRefs)
                        await $_getPrefetchedData<
                          PetRow,
                          $PetsTable,
                          PetPhotoRow
                        >(
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
                        await $_getPrefetchedData<
                          PetRow,
                          $PetsTable,
                          MemoryEntryRow
                        >(
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
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PetsTableProcessedTableManager =
    ProcessedTableManager<
      _$PetHealthDatabase,
      $PetsTable,
      PetRow,
      $$PetsTableFilterComposer,
      $$PetsTableOrderingComposer,
      $$PetsTableAnnotationComposer,
      $$PetsTableCreateCompanionBuilder,
      $$PetsTableUpdateCompanionBuilder,
      (PetRow, $$PetsTableReferences),
      PetRow,
      PrefetchHooks Function({
        bool petPresetsRefs,
        bool plansRefs,
        bool entriesRefs,
        bool cardHistoryRefs,
        bool petPhotosRefs,
        bool memoryEntriesRefs,
      })
    >;
typedef $$PetPresetsTableCreateCompanionBuilder =
    PetPresetsCompanion Function({
      required String petId,
      Value<double?> mealAmount,
      Value<PortionUnit?> mealUnit,
      Value<int?> mealsPerDay,
      Value<double?> bowlMl,
      Value<WeightCadence> weightCadence,
      Value<List<EntryType>> quickTypes,
      Value<int> rowid,
    });
typedef $$PetPresetsTableUpdateCompanionBuilder =
    PetPresetsCompanion Function({
      Value<String> petId,
      Value<double?> mealAmount,
      Value<PortionUnit?> mealUnit,
      Value<int?> mealsPerDay,
      Value<double?> bowlMl,
      Value<WeightCadence> weightCadence,
      Value<List<EntryType>> quickTypes,
      Value<int> rowid,
    });

final class $$PetPresetsTableReferences
    extends
        BaseReferences<_$PetHealthDatabase, $PetPresetsTable, PetPresetRow> {
  $$PetPresetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PetsTable _petIdTable(_$PetHealthDatabase db) =>
      db.pets.createAlias('pet_presets__pet_id__pets__id');

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

class $$PetPresetsTableFilterComposer
    extends Composer<_$PetHealthDatabase, $PetPresetsTable> {
  $$PetPresetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get mealAmount => $composableBuilder(
    column: $table.mealAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PortionUnit?, PortionUnit, String>
  get mealUnit => $composableBuilder(
    column: $table.mealUnit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get mealsPerDay => $composableBuilder(
    column: $table.mealsPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bowlMl => $composableBuilder(
    column: $table.bowlMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WeightCadence, WeightCadence, String>
  get weightCadence => $composableBuilder(
    column: $table.weightCadence,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<EntryType>, List<EntryType>, String>
  get quickTypes => $composableBuilder(
    column: $table.quickTypes,
    builder: (column) => ColumnWithTypeConverterFilters(column),
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

class $$PetPresetsTableOrderingComposer
    extends Composer<_$PetHealthDatabase, $PetPresetsTable> {
  $$PetPresetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get mealAmount => $composableBuilder(
    column: $table.mealAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealUnit => $composableBuilder(
    column: $table.mealUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mealsPerDay => $composableBuilder(
    column: $table.mealsPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bowlMl => $composableBuilder(
    column: $table.bowlMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weightCadence => $composableBuilder(
    column: $table.weightCadence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quickTypes => $composableBuilder(
    column: $table.quickTypes,
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

class $$PetPresetsTableAnnotationComposer
    extends Composer<_$PetHealthDatabase, $PetPresetsTable> {
  $$PetPresetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get mealAmount => $composableBuilder(
    column: $table.mealAmount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PortionUnit?, String> get mealUnit =>
      $composableBuilder(column: $table.mealUnit, builder: (column) => column);

  GeneratedColumn<int> get mealsPerDay => $composableBuilder(
    column: $table.mealsPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bowlMl =>
      $composableBuilder(column: $table.bowlMl, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WeightCadence, String> get weightCadence =>
      $composableBuilder(
        column: $table.weightCadence,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<EntryType>, String> get quickTypes =>
      $composableBuilder(
        column: $table.quickTypes,
        builder: (column) => column,
      );

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

class $$PetPresetsTableTableManager
    extends
        RootTableManager<
          _$PetHealthDatabase,
          $PetPresetsTable,
          PetPresetRow,
          $$PetPresetsTableFilterComposer,
          $$PetPresetsTableOrderingComposer,
          $$PetPresetsTableAnnotationComposer,
          $$PetPresetsTableCreateCompanionBuilder,
          $$PetPresetsTableUpdateCompanionBuilder,
          (PetPresetRow, $$PetPresetsTableReferences),
          PetPresetRow,
          PrefetchHooks Function({bool petId})
        > {
  $$PetPresetsTableTableManager(_$PetHealthDatabase db, $PetPresetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetPresetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetPresetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetPresetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> petId = const Value.absent(),
                Value<double?> mealAmount = const Value.absent(),
                Value<PortionUnit?> mealUnit = const Value.absent(),
                Value<int?> mealsPerDay = const Value.absent(),
                Value<double?> bowlMl = const Value.absent(),
                Value<WeightCadence> weightCadence = const Value.absent(),
                Value<List<EntryType>> quickTypes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PetPresetsCompanion(
                petId: petId,
                mealAmount: mealAmount,
                mealUnit: mealUnit,
                mealsPerDay: mealsPerDay,
                bowlMl: bowlMl,
                weightCadence: weightCadence,
                quickTypes: quickTypes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String petId,
                Value<double?> mealAmount = const Value.absent(),
                Value<PortionUnit?> mealUnit = const Value.absent(),
                Value<int?> mealsPerDay = const Value.absent(),
                Value<double?> bowlMl = const Value.absent(),
                Value<WeightCadence> weightCadence = const Value.absent(),
                Value<List<EntryType>> quickTypes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PetPresetsCompanion.insert(
                petId: petId,
                mealAmount: mealAmount,
                mealUnit: mealUnit,
                mealsPerDay: mealsPerDay,
                bowlMl: bowlMl,
                weightCadence: weightCadence,
                quickTypes: quickTypes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PetPresetsTableReferences(db, table, e),
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
                                referencedTable: $$PetPresetsTableReferences
                                    ._petIdTable(db),
                                referencedColumn: $$PetPresetsTableReferences
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

typedef $$PetPresetsTableProcessedTableManager =
    ProcessedTableManager<
      _$PetHealthDatabase,
      $PetPresetsTable,
      PetPresetRow,
      $$PetPresetsTableFilterComposer,
      $$PetPresetsTableOrderingComposer,
      $$PetPresetsTableAnnotationComposer,
      $$PetPresetsTableCreateCompanionBuilder,
      $$PetPresetsTableUpdateCompanionBuilder,
      (PetPresetRow, $$PetPresetsTableReferences),
      PetPresetRow,
      PrefetchHooks Function({bool petId})
    >;
typedef $$PlansTableCreateCompanionBuilder =
    PlansCompanion Function({
      required String id,
      required String petId,
      required EntryType entryType,
      Value<String?> entryKind,
      Value<String?> title,
      required PlanScheduleKind schedule,
      Value<int?> intervalDays,
      Value<int?> weekdays,
      Value<DateTime?> dueAt,
      Value<int?> notifyMinute,
      Value<DateTime?> snoozedUntil,
      Value<int?> notificationId,
      Value<PlanSource> source,
      Value<bool> paused,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PlansTableUpdateCompanionBuilder =
    PlansCompanion Function({
      Value<String> id,
      Value<String> petId,
      Value<EntryType> entryType,
      Value<String?> entryKind,
      Value<String?> title,
      Value<PlanScheduleKind> schedule,
      Value<int?> intervalDays,
      Value<int?> weekdays,
      Value<DateTime?> dueAt,
      Value<int?> notifyMinute,
      Value<DateTime?> snoozedUntil,
      Value<int?> notificationId,
      Value<PlanSource> source,
      Value<bool> paused,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PlansTableReferences
    extends BaseReferences<_$PetHealthDatabase, $PlansTable, PlanRow> {
  $$PlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PetsTable _petIdTable(_$PetHealthDatabase db) =>
      db.pets.createAlias('plans__pet_id__pets__id');

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

  static MultiTypedResultKey<$EntriesTable, List<EntryRow>> _entriesRefsTable(
    _$PetHealthDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.entries,
    aliasName: 'plans__id__entries__plan_id',
  );

  $$EntriesTableProcessedTableManager get entriesRefs {
    final manager = $$EntriesTableTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlansTableFilterComposer
    extends Composer<_$PetHealthDatabase, $PlansTable> {
  $$PlansTableFilterComposer({
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

  ColumnWithTypeConverterFilters<EntryType, EntryType, String> get entryType =>
      $composableBuilder(
        column: $table.entryType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get entryKind => $composableBuilder(
    column: $table.entryKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PlanScheduleKind, PlanScheduleKind, String>
  get schedule => $composableBuilder(
    column: $table.schedule,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notifyMinute => $composableBuilder(
    column: $table.notifyMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PlanSource, PlanSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
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

  Expression<bool> entriesRefs(
    Expression<bool> Function($$EntriesTableFilterComposer f) f,
  ) {
    final $$EntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlansTableOrderingComposer
    extends Composer<_$PetHealthDatabase, $PlansTable> {
  $$PlansTableOrderingComposer({
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

  ColumnOrderings<String> get entryType => $composableBuilder(
    column: $table.entryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryKind => $composableBuilder(
    column: $table.entryKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schedule => $composableBuilder(
    column: $table.schedule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notifyMinute => $composableBuilder(
    column: $table.notifyMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
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

class $$PlansTableAnnotationComposer
    extends Composer<_$PetHealthDatabase, $PlansTable> {
  $$PlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EntryType, String> get entryType =>
      $composableBuilder(column: $table.entryType, builder: (column) => column);

  GeneratedColumn<String> get entryKind =>
      $composableBuilder(column: $table.entryKind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PlanScheduleKind, String> get schedule =>
      $composableBuilder(column: $table.schedule, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get notifyMinute => $composableBuilder(
    column: $table.notifyMinute,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PlanSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

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

  Expression<T> entriesRefs<T extends Object>(
    Expression<T> Function($$EntriesTableAnnotationComposer a) f,
  ) {
    final $$EntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlansTableTableManager
    extends
        RootTableManager<
          _$PetHealthDatabase,
          $PlansTable,
          PlanRow,
          $$PlansTableFilterComposer,
          $$PlansTableOrderingComposer,
          $$PlansTableAnnotationComposer,
          $$PlansTableCreateCompanionBuilder,
          $$PlansTableUpdateCompanionBuilder,
          (PlanRow, $$PlansTableReferences),
          PlanRow,
          PrefetchHooks Function({bool petId, bool entriesRefs})
        > {
  $$PlansTableTableManager(_$PetHealthDatabase db, $PlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> petId = const Value.absent(),
                Value<EntryType> entryType = const Value.absent(),
                Value<String?> entryKind = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<PlanScheduleKind> schedule = const Value.absent(),
                Value<int?> intervalDays = const Value.absent(),
                Value<int?> weekdays = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<int?> notifyMinute = const Value.absent(),
                Value<DateTime?> snoozedUntil = const Value.absent(),
                Value<int?> notificationId = const Value.absent(),
                Value<PlanSource> source = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlansCompanion(
                id: id,
                petId: petId,
                entryType: entryType,
                entryKind: entryKind,
                title: title,
                schedule: schedule,
                intervalDays: intervalDays,
                weekdays: weekdays,
                dueAt: dueAt,
                notifyMinute: notifyMinute,
                snoozedUntil: snoozedUntil,
                notificationId: notificationId,
                source: source,
                paused: paused,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String petId,
                required EntryType entryType,
                Value<String?> entryKind = const Value.absent(),
                Value<String?> title = const Value.absent(),
                required PlanScheduleKind schedule,
                Value<int?> intervalDays = const Value.absent(),
                Value<int?> weekdays = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<int?> notifyMinute = const Value.absent(),
                Value<DateTime?> snoozedUntil = const Value.absent(),
                Value<int?> notificationId = const Value.absent(),
                Value<PlanSource> source = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlansCompanion.insert(
                id: id,
                petId: petId,
                entryType: entryType,
                entryKind: entryKind,
                title: title,
                schedule: schedule,
                intervalDays: intervalDays,
                weekdays: weekdays,
                dueAt: dueAt,
                notifyMinute: notifyMinute,
                snoozedUntil: snoozedUntil,
                notificationId: notificationId,
                source: source,
                paused: paused,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PlansTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({petId = false, entriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (entriesRefs) db.entries],
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
                                referencedTable: $$PlansTableReferences
                                    ._petIdTable(db),
                                referencedColumn: $$PlansTableReferences
                                    ._petIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entriesRefs)
                    await $_getPrefetchedData<PlanRow, $PlansTable, EntryRow>(
                      currentTable: table,
                      referencedTable: $$PlansTableReferences._entriesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$PlansTableReferences(db, table, p0).entriesRefs,
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

typedef $$PlansTableProcessedTableManager =
    ProcessedTableManager<
      _$PetHealthDatabase,
      $PlansTable,
      PlanRow,
      $$PlansTableFilterComposer,
      $$PlansTableOrderingComposer,
      $$PlansTableAnnotationComposer,
      $$PlansTableCreateCompanionBuilder,
      $$PlansTableUpdateCompanionBuilder,
      (PlanRow, $$PlansTableReferences),
      PlanRow,
      PrefetchHooks Function({bool petId, bool entriesRefs})
    >;
typedef $$EntriesTableCreateCompanionBuilder =
    EntriesCompanion Function({
      required String id,
      required String petId,
      required EntryType type,
      required DateTime occurredAt,
      Value<String?> planId,
      Value<double?> amount,
      Value<PortionUnit?> unit,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<int?> durationSec,
      Value<double?> distanceM,
      Value<Map<String, Object?>> details,
      Value<String?> label,
      Value<String> note,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$EntriesTableUpdateCompanionBuilder =
    EntriesCompanion Function({
      Value<String> id,
      Value<String> petId,
      Value<EntryType> type,
      Value<DateTime> occurredAt,
      Value<String?> planId,
      Value<double?> amount,
      Value<PortionUnit?> unit,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<int?> durationSec,
      Value<double?> distanceM,
      Value<Map<String, Object?>> details,
      Value<String?> label,
      Value<String> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$EntriesTableReferences
    extends BaseReferences<_$PetHealthDatabase, $EntriesTable, EntryRow> {
  $$EntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PetsTable _petIdTable(_$PetHealthDatabase db) =>
      db.pets.createAlias('entries__pet_id__pets__id');

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

  static $PlansTable _planIdTable(_$PetHealthDatabase db) =>
      db.plans.createAlias('entries__plan_id__plans__id');

  $$PlansTableProcessedTableManager? get planId {
    final $_column = $_itemColumn<String>('plan_id');
    if ($_column == null) return null;
    final manager = $$PlansTableTableManager(
      $_db,
      $_db.plans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EntriesTableFilterComposer
    extends Composer<_$PetHealthDatabase, $EntriesTable> {
  $$EntriesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<EntryType, EntryType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PortionUnit?, PortionUnit, String> get unit =>
      $composableBuilder(
        column: $table.unit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
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

  $$PlansTableFilterComposer get planId {
    final $$PlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableFilterComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntriesTableOrderingComposer
    extends Composer<_$PetHealthDatabase, $EntriesTable> {
  $$EntriesTableOrderingComposer({
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

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
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

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
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

  $$PlansTableOrderingComposer get planId {
    final $$PlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableOrderingComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntriesTableAnnotationComposer
    extends Composer<_$PetHealthDatabase, $EntriesTable> {
  $$EntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EntryType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PortionUnit?, String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

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

  $$PlansTableAnnotationComposer get planId {
    final $$PlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableAnnotationComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntriesTableTableManager
    extends
        RootTableManager<
          _$PetHealthDatabase,
          $EntriesTable,
          EntryRow,
          $$EntriesTableFilterComposer,
          $$EntriesTableOrderingComposer,
          $$EntriesTableAnnotationComposer,
          $$EntriesTableCreateCompanionBuilder,
          $$EntriesTableUpdateCompanionBuilder,
          (EntryRow, $$EntriesTableReferences),
          EntryRow,
          PrefetchHooks Function({bool petId, bool planId})
        > {
  $$EntriesTableTableManager(_$PetHealthDatabase db, $EntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> petId = const Value.absent(),
                Value<EntryType> type = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String?> planId = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<PortionUnit?> unit = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<double?> distanceM = const Value.absent(),
                Value<Map<String, Object?>> details = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntriesCompanion(
                id: id,
                petId: petId,
                type: type,
                occurredAt: occurredAt,
                planId: planId,
                amount: amount,
                unit: unit,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSec: durationSec,
                distanceM: distanceM,
                details: details,
                label: label,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String petId,
                required EntryType type,
                required DateTime occurredAt,
                Value<String?> planId = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<PortionUnit?> unit = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<double?> distanceM = const Value.absent(),
                Value<Map<String, Object?>> details = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String> note = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => EntriesCompanion.insert(
                id: id,
                petId: petId,
                type: type,
                occurredAt: occurredAt,
                planId: planId,
                amount: amount,
                unit: unit,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSec: durationSec,
                distanceM: distanceM,
                details: details,
                label: label,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({petId = false, planId = false}) {
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
                                referencedTable: $$EntriesTableReferences
                                    ._petIdTable(db),
                                referencedColumn: $$EntriesTableReferences
                                    ._petIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (planId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.planId,
                                referencedTable: $$EntriesTableReferences
                                    ._planIdTable(db),
                                referencedColumn: $$EntriesTableReferences
                                    ._planIdTable(db)
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

typedef $$EntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$PetHealthDatabase,
      $EntriesTable,
      EntryRow,
      $$EntriesTableFilterComposer,
      $$EntriesTableOrderingComposer,
      $$EntriesTableAnnotationComposer,
      $$EntriesTableCreateCompanionBuilder,
      $$EntriesTableUpdateCompanionBuilder,
      (EntryRow, $$EntriesTableReferences),
      EntryRow,
      PrefetchHooks Function({bool petId, bool planId})
    >;
typedef $$CardHistoryTableCreateCompanionBuilder =
    CardHistoryCompanion Function({
      required String id,
      required String petId,
      required DateTime day,
      required String cardKey,
      required CardCategory category,
      Value<Map<String, Object?>> params,
      Value<bool> dismissed,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CardHistoryTableUpdateCompanionBuilder =
    CardHistoryCompanion Function({
      Value<String> id,
      Value<String> petId,
      Value<DateTime> day,
      Value<String> cardKey,
      Value<CardCategory> category,
      Value<Map<String, Object?>> params,
      Value<bool> dismissed,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CardHistoryTableReferences
    extends
        BaseReferences<_$PetHealthDatabase, $CardHistoryTable, CardHistoryRow> {
  $$CardHistoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PetsTable _petIdTable(_$PetHealthDatabase db) =>
      db.pets.createAlias('card_history__pet_id__pets__id');

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

class $$CardHistoryTableFilterComposer
    extends Composer<_$PetHealthDatabase, $CardHistoryTable> {
  $$CardHistoryTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get day =>
      $composableBuilder(
        column: $table.day,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get cardKey => $composableBuilder(
    column: $table.cardKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CardCategory, CardCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get params => $composableBuilder(
    column: $table.params,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get dismissed => $composableBuilder(
    column: $table.dismissed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

class $$CardHistoryTableOrderingComposer
    extends Composer<_$PetHealthDatabase, $CardHistoryTable> {
  $$CardHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardKey => $composableBuilder(
    column: $table.cardKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get params => $composableBuilder(
    column: $table.params,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dismissed => $composableBuilder(
    column: $table.dismissed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

class $$CardHistoryTableAnnotationComposer
    extends Composer<_$PetHealthDatabase, $CardHistoryTable> {
  $$CardHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get cardKey =>
      $composableBuilder(column: $table.cardKey, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CardCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get params =>
      $composableBuilder(column: $table.params, builder: (column) => column);

  GeneratedColumn<bool> get dismissed =>
      $composableBuilder(column: $table.dismissed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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

class $$CardHistoryTableTableManager
    extends
        RootTableManager<
          _$PetHealthDatabase,
          $CardHistoryTable,
          CardHistoryRow,
          $$CardHistoryTableFilterComposer,
          $$CardHistoryTableOrderingComposer,
          $$CardHistoryTableAnnotationComposer,
          $$CardHistoryTableCreateCompanionBuilder,
          $$CardHistoryTableUpdateCompanionBuilder,
          (CardHistoryRow, $$CardHistoryTableReferences),
          CardHistoryRow,
          PrefetchHooks Function({bool petId})
        > {
  $$CardHistoryTableTableManager(
    _$PetHealthDatabase db,
    $CardHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> petId = const Value.absent(),
                Value<DateTime> day = const Value.absent(),
                Value<String> cardKey = const Value.absent(),
                Value<CardCategory> category = const Value.absent(),
                Value<Map<String, Object?>> params = const Value.absent(),
                Value<bool> dismissed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardHistoryCompanion(
                id: id,
                petId: petId,
                day: day,
                cardKey: cardKey,
                category: category,
                params: params,
                dismissed: dismissed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String petId,
                required DateTime day,
                required String cardKey,
                required CardCategory category,
                Value<Map<String, Object?>> params = const Value.absent(),
                Value<bool> dismissed = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CardHistoryCompanion.insert(
                id: id,
                petId: petId,
                day: day,
                cardKey: cardKey,
                category: category,
                params: params,
                dismissed: dismissed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CardHistoryTableReferences(db, table, e),
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
                                referencedTable: $$CardHistoryTableReferences
                                    ._petIdTable(db),
                                referencedColumn: $$CardHistoryTableReferences
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

typedef $$CardHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$PetHealthDatabase,
      $CardHistoryTable,
      CardHistoryRow,
      $$CardHistoryTableFilterComposer,
      $$CardHistoryTableOrderingComposer,
      $$CardHistoryTableAnnotationComposer,
      $$CardHistoryTableCreateCompanionBuilder,
      $$CardHistoryTableUpdateCompanionBuilder,
      (CardHistoryRow, $$CardHistoryTableReferences),
      CardHistoryRow,
      PrefetchHooks Function({bool petId})
    >;
typedef $$WeatherDaysTableCreateCompanionBuilder =
    WeatherDaysCompanion Function({
      required DateTime day,
      required double maxC,
      required double minC,
      required int precipProb,
      required double uvMax,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$WeatherDaysTableUpdateCompanionBuilder =
    WeatherDaysCompanion Function({
      Value<DateTime> day,
      Value<double> maxC,
      Value<double> minC,
      Value<int> precipProb,
      Value<double> uvMax,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$WeatherDaysTableFilterComposer
    extends Composer<_$PetHealthDatabase, $WeatherDaysTable> {
  $$WeatherDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get day =>
      $composableBuilder(
        column: $table.day,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get maxC => $composableBuilder(
    column: $table.maxC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minC => $composableBuilder(
    column: $table.minC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get precipProb => $composableBuilder(
    column: $table.precipProb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get uvMax => $composableBuilder(
    column: $table.uvMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeatherDaysTableOrderingComposer
    extends Composer<_$PetHealthDatabase, $WeatherDaysTable> {
  $$WeatherDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxC => $composableBuilder(
    column: $table.maxC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minC => $composableBuilder(
    column: $table.minC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get precipProb => $composableBuilder(
    column: $table.precipProb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get uvMax => $composableBuilder(
    column: $table.uvMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeatherDaysTableAnnotationComposer
    extends Composer<_$PetHealthDatabase, $WeatherDaysTable> {
  $$WeatherDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<DateTime, String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<double> get maxC =>
      $composableBuilder(column: $table.maxC, builder: (column) => column);

  GeneratedColumn<double> get minC =>
      $composableBuilder(column: $table.minC, builder: (column) => column);

  GeneratedColumn<int> get precipProb => $composableBuilder(
    column: $table.precipProb,
    builder: (column) => column,
  );

  GeneratedColumn<double> get uvMax =>
      $composableBuilder(column: $table.uvMax, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$WeatherDaysTableTableManager
    extends
        RootTableManager<
          _$PetHealthDatabase,
          $WeatherDaysTable,
          WeatherDayRow,
          $$WeatherDaysTableFilterComposer,
          $$WeatherDaysTableOrderingComposer,
          $$WeatherDaysTableAnnotationComposer,
          $$WeatherDaysTableCreateCompanionBuilder,
          $$WeatherDaysTableUpdateCompanionBuilder,
          (
            WeatherDayRow,
            BaseReferences<
              _$PetHealthDatabase,
              $WeatherDaysTable,
              WeatherDayRow
            >,
          ),
          WeatherDayRow,
          PrefetchHooks Function()
        > {
  $$WeatherDaysTableTableManager(
    _$PetHealthDatabase db,
    $WeatherDaysTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeatherDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeatherDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeatherDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> day = const Value.absent(),
                Value<double> maxC = const Value.absent(),
                Value<double> minC = const Value.absent(),
                Value<int> precipProb = const Value.absent(),
                Value<double> uvMax = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeatherDaysCompanion(
                day: day,
                maxC: maxC,
                minC: minC,
                precipProb: precipProb,
                uvMax: uvMax,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime day,
                required double maxC,
                required double minC,
                required int precipProb,
                required double uvMax,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => WeatherDaysCompanion.insert(
                day: day,
                maxC: maxC,
                minC: minC,
                precipProb: precipProb,
                uvMax: uvMax,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeatherDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$PetHealthDatabase,
      $WeatherDaysTable,
      WeatherDayRow,
      $$WeatherDaysTableFilterComposer,
      $$WeatherDaysTableOrderingComposer,
      $$WeatherDaysTableAnnotationComposer,
      $$WeatherDaysTableCreateCompanionBuilder,
      $$WeatherDaysTableUpdateCompanionBuilder,
      (
        WeatherDayRow,
        BaseReferences<_$PetHealthDatabase, $WeatherDaysTable, WeatherDayRow>,
      ),
      WeatherDayRow,
      PrefetchHooks Function()
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
    extends Composer<_$PetHealthDatabase, $AppSettingsTable> {
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
    extends Composer<_$PetHealthDatabase, $AppSettingsTable> {
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
    extends Composer<_$PetHealthDatabase, $AppSettingsTable> {
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
          _$PetHealthDatabase,
          $AppSettingsTable,
          SettingRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$PetHealthDatabase, $AppSettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(
    _$PetHealthDatabase db,
    $AppSettingsTable table,
  ) : super(
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
      _$PetHealthDatabase,
      $AppSettingsTable,
      SettingRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        SettingRow,
        BaseReferences<_$PetHealthDatabase, $AppSettingsTable, SettingRow>,
      ),
      SettingRow,
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
    extends BaseReferences<_$PetHealthDatabase, $PetPhotosTable, PetPhotoRow> {
  $$PetPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PetsTable _petIdTable(_$PetHealthDatabase db) =>
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
    extends Composer<_$PetHealthDatabase, $PetPhotosTable> {
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
    extends Composer<_$PetHealthDatabase, $PetPhotosTable> {
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
    extends Composer<_$PetHealthDatabase, $PetPhotosTable> {
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
          _$PetHealthDatabase,
          $PetPhotosTable,
          PetPhotoRow,
          $$PetPhotosTableFilterComposer,
          $$PetPhotosTableOrderingComposer,
          $$PetPhotosTableAnnotationComposer,
          $$PetPhotosTableCreateCompanionBuilder,
          $$PetPhotosTableUpdateCompanionBuilder,
          (PetPhotoRow, $$PetPhotosTableReferences),
          PetPhotoRow,
          PrefetchHooks Function({bool petId})
        > {
  $$PetPhotosTableTableManager(_$PetHealthDatabase db, $PetPhotosTable table)
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
      _$PetHealthDatabase,
      $PetPhotosTable,
      PetPhotoRow,
      $$PetPhotosTableFilterComposer,
      $$PetPhotosTableOrderingComposer,
      $$PetPhotosTableAnnotationComposer,
      $$PetPhotosTableCreateCompanionBuilder,
      $$PetPhotosTableUpdateCompanionBuilder,
      (PetPhotoRow, $$PetPhotosTableReferences),
      PetPhotoRow,
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
    extends
        BaseReferences<
          _$PetHealthDatabase,
          $MemoryEntriesTable,
          MemoryEntryRow
        > {
  $$MemoryEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PetsTable _petIdTable(_$PetHealthDatabase db) =>
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

  static MultiTypedResultKey<$MemoryMediaRefsTable, List<MemoryMediaRefRow>>
  _memoryMediaRefsRefsTable(_$PetHealthDatabase db) =>
      MultiTypedResultKey.fromTable(
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
    extends Composer<_$PetHealthDatabase, $MemoryEntriesTable> {
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
    extends Composer<_$PetHealthDatabase, $MemoryEntriesTable> {
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
    extends Composer<_$PetHealthDatabase, $MemoryEntriesTable> {
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
          _$PetHealthDatabase,
          $MemoryEntriesTable,
          MemoryEntryRow,
          $$MemoryEntriesTableFilterComposer,
          $$MemoryEntriesTableOrderingComposer,
          $$MemoryEntriesTableAnnotationComposer,
          $$MemoryEntriesTableCreateCompanionBuilder,
          $$MemoryEntriesTableUpdateCompanionBuilder,
          (MemoryEntryRow, $$MemoryEntriesTableReferences),
          MemoryEntryRow,
          PrefetchHooks Function({bool petId, bool memoryMediaRefsRefs})
        > {
  $$MemoryEntriesTableTableManager(
    _$PetHealthDatabase db,
    $MemoryEntriesTable table,
  ) : super(
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
                          MemoryEntryRow,
                          $MemoryEntriesTable,
                          MemoryMediaRefRow
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
      _$PetHealthDatabase,
      $MemoryEntriesTable,
      MemoryEntryRow,
      $$MemoryEntriesTableFilterComposer,
      $$MemoryEntriesTableOrderingComposer,
      $$MemoryEntriesTableAnnotationComposer,
      $$MemoryEntriesTableCreateCompanionBuilder,
      $$MemoryEntriesTableUpdateCompanionBuilder,
      (MemoryEntryRow, $$MemoryEntriesTableReferences),
      MemoryEntryRow,
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
        BaseReferences<
          _$PetHealthDatabase,
          $MemoryMediaRefsTable,
          MemoryMediaRefRow
        > {
  $$MemoryMediaRefsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MemoryEntriesTable _entryIdTable(_$PetHealthDatabase db) => db
      .memoryEntries
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
    extends Composer<_$PetHealthDatabase, $MemoryMediaRefsTable> {
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
    extends Composer<_$PetHealthDatabase, $MemoryMediaRefsTable> {
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
    extends Composer<_$PetHealthDatabase, $MemoryMediaRefsTable> {
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
          _$PetHealthDatabase,
          $MemoryMediaRefsTable,
          MemoryMediaRefRow,
          $$MemoryMediaRefsTableFilterComposer,
          $$MemoryMediaRefsTableOrderingComposer,
          $$MemoryMediaRefsTableAnnotationComposer,
          $$MemoryMediaRefsTableCreateCompanionBuilder,
          $$MemoryMediaRefsTableUpdateCompanionBuilder,
          (MemoryMediaRefRow, $$MemoryMediaRefsTableReferences),
          MemoryMediaRefRow,
          PrefetchHooks Function({bool entryId})
        > {
  $$MemoryMediaRefsTableTableManager(
    _$PetHealthDatabase db,
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
      _$PetHealthDatabase,
      $MemoryMediaRefsTable,
      MemoryMediaRefRow,
      $$MemoryMediaRefsTableFilterComposer,
      $$MemoryMediaRefsTableOrderingComposer,
      $$MemoryMediaRefsTableAnnotationComposer,
      $$MemoryMediaRefsTableCreateCompanionBuilder,
      $$MemoryMediaRefsTableUpdateCompanionBuilder,
      (MemoryMediaRefRow, $$MemoryMediaRefsTableReferences),
      MemoryMediaRefRow,
      PrefetchHooks Function({bool entryId})
    >;

class $PetHealthDatabaseManager {
  final _$PetHealthDatabase _db;
  $PetHealthDatabaseManager(this._db);
  $$PetsTableTableManager get pets => $$PetsTableTableManager(_db, _db.pets);
  $$PetPresetsTableTableManager get petPresets =>
      $$PetPresetsTableTableManager(_db, _db.petPresets);
  $$PlansTableTableManager get plans =>
      $$PlansTableTableManager(_db, _db.plans);
  $$EntriesTableTableManager get entries =>
      $$EntriesTableTableManager(_db, _db.entries);
  $$CardHistoryTableTableManager get cardHistory =>
      $$CardHistoryTableTableManager(_db, _db.cardHistory);
  $$WeatherDaysTableTableManager get weatherDays =>
      $$WeatherDaysTableTableManager(_db, _db.weatherDays);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$PetPhotosTableTableManager get petPhotos =>
      $$PetPhotosTableTableManager(_db, _db.petPhotos);
  $$MemoryEntriesTableTableManager get memoryEntries =>
      $$MemoryEntriesTableTableManager(_db, _db.memoryEntries);
  $$MemoryMediaRefsTableTableManager get memoryMediaRefs =>
      $$MemoryMediaRefsTableTableManager(_db, _db.memoryMediaRefs);
}
