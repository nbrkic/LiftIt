// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MuscleGroup, String>
  primaryMuscleGroup = GeneratedColumn<String>(
    'primary_muscle_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<MuscleGroup>($ExercisesTable.$converterprimaryMuscleGroup);
  @override
  late final GeneratedColumnWithTypeConverter<Equipment, String> equipment =
      GeneratedColumn<String>(
        'equipment',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Equipment>($ExercisesTable.$converterequipment);
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    primaryMuscleGroup,
    equipment,
    isCustom,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      primaryMuscleGroup: $ExercisesTable.$converterprimaryMuscleGroup.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}primary_muscle_group'],
        )!,
      ),
      equipment: $ExercisesTable.$converterequipment.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}equipment'],
        )!,
      ),
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MuscleGroup, String, String>
  $converterprimaryMuscleGroup = const EnumNameConverter<MuscleGroup>(
    MuscleGroup.values,
  );
  static JsonTypeConverter2<Equipment, String, String> $converterequipment =
      const EnumNameConverter<Equipment>(Equipment.values);
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  final MuscleGroup primaryMuscleGroup;
  final Equipment equipment;
  final bool isCustom;
  final String? notes;
  const Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscleGroup,
    required this.equipment,
    required this.isCustom,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['primary_muscle_group'] = Variable<String>(
        $ExercisesTable.$converterprimaryMuscleGroup.toSql(primaryMuscleGroup),
      );
    }
    {
      map['equipment'] = Variable<String>(
        $ExercisesTable.$converterequipment.toSql(equipment),
      );
    }
    map['is_custom'] = Variable<bool>(isCustom);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      primaryMuscleGroup: Value(primaryMuscleGroup),
      equipment: Value(equipment),
      isCustom: Value(isCustom),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      primaryMuscleGroup: $ExercisesTable.$converterprimaryMuscleGroup.fromJson(
        serializer.fromJson<String>(json['primaryMuscleGroup']),
      ),
      equipment: $ExercisesTable.$converterequipment.fromJson(
        serializer.fromJson<String>(json['equipment']),
      ),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'primaryMuscleGroup': serializer.toJson<String>(
        $ExercisesTable.$converterprimaryMuscleGroup.toJson(primaryMuscleGroup),
      ),
      'equipment': serializer.toJson<String>(
        $ExercisesTable.$converterequipment.toJson(equipment),
      ),
      'isCustom': serializer.toJson<bool>(isCustom),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Exercise copyWith({
    int? id,
    String? name,
    MuscleGroup? primaryMuscleGroup,
    Equipment? equipment,
    bool? isCustom,
    Value<String?> notes = const Value.absent(),
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    primaryMuscleGroup: primaryMuscleGroup ?? this.primaryMuscleGroup,
    equipment: equipment ?? this.equipment,
    isCustom: isCustom ?? this.isCustom,
    notes: notes.present ? notes.value : this.notes,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      primaryMuscleGroup: data.primaryMuscleGroup.present
          ? data.primaryMuscleGroup.value
          : this.primaryMuscleGroup,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primaryMuscleGroup: $primaryMuscleGroup, ')
          ..write('equipment: $equipment, ')
          ..write('isCustom: $isCustom, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, primaryMuscleGroup, equipment, isCustom, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.primaryMuscleGroup == this.primaryMuscleGroup &&
          other.equipment == this.equipment &&
          other.isCustom == this.isCustom &&
          other.notes == this.notes);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<MuscleGroup> primaryMuscleGroup;
  final Value<Equipment> equipment;
  final Value<bool> isCustom;
  final Value<String?> notes;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.primaryMuscleGroup = const Value.absent(),
    this.equipment = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required MuscleGroup primaryMuscleGroup,
    required Equipment equipment,
    this.isCustom = const Value.absent(),
    this.notes = const Value.absent(),
  }) : name = Value(name),
       primaryMuscleGroup = Value(primaryMuscleGroup),
       equipment = Value(equipment);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? primaryMuscleGroup,
    Expression<String>? equipment,
    Expression<bool>? isCustom,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (primaryMuscleGroup != null)
        'primary_muscle_group': primaryMuscleGroup,
      if (equipment != null) 'equipment': equipment,
      if (isCustom != null) 'is_custom': isCustom,
      if (notes != null) 'notes': notes,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<MuscleGroup>? primaryMuscleGroup,
    Value<Equipment>? equipment,
    Value<bool>? isCustom,
    Value<String?>? notes,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryMuscleGroup: primaryMuscleGroup ?? this.primaryMuscleGroup,
      equipment: equipment ?? this.equipment,
      isCustom: isCustom ?? this.isCustom,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (primaryMuscleGroup.present) {
      map['primary_muscle_group'] = Variable<String>(
        $ExercisesTable.$converterprimaryMuscleGroup.toSql(
          primaryMuscleGroup.value,
        ),
      );
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(
        $ExercisesTable.$converterequipment.toSql(equipment.value),
      );
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primaryMuscleGroup: $primaryMuscleGroup, ')
          ..write('equipment: $equipment, ')
          ..write('isCustom: $isCustom, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SplitsTable extends Splits with TableInfo<$SplitsTable, Split> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SplitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'splits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Split> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Split map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Split(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $SplitsTable createAlias(String alias) {
    return $SplitsTable(attachedDatabase, alias);
  }
}

class Split extends DataClass implements Insertable<Split> {
  final int id;
  final String name;
  final String? description;
  const Split({required this.id, required this.name, this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  SplitsCompanion toCompanion(bool nullToAbsent) {
    return SplitsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Split.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Split(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
    };
  }

  Split copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
  }) => Split(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
  );
  Split copyWithCompanion(SplitsCompanion data) {
    return Split(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Split(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Split &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description);
}

class SplitsCompanion extends UpdateCompanion<Split> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  const SplitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
  });
  SplitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Split> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });
  }

  SplitsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
  }) {
    return SplitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SplitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $SplitDaysTable extends SplitDays
    with TableInfo<$SplitDaysTable, SplitDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SplitDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _splitIdMeta = const VerificationMeta(
    'splitId',
  );
  @override
  late final GeneratedColumn<int> splitId = GeneratedColumn<int>(
    'split_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES splits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOrderMeta = const VerificationMeta(
    'dayOrder',
  );
  @override
  late final GeneratedColumn<int> dayOrder = GeneratedColumn<int>(
    'day_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, splitId, name, dayOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'split_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<SplitDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('split_id')) {
      context.handle(
        _splitIdMeta,
        splitId.isAcceptableOrUnknown(data['split_id']!, _splitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_splitIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('day_order')) {
      context.handle(
        _dayOrderMeta,
        dayOrder.isAcceptableOrUnknown(data['day_order']!, _dayOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SplitDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SplitDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      splitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}split_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_order'],
      )!,
    );
  }

  @override
  $SplitDaysTable createAlias(String alias) {
    return $SplitDaysTable(attachedDatabase, alias);
  }
}

class SplitDay extends DataClass implements Insertable<SplitDay> {
  final int id;
  final int splitId;
  final String name;
  final int dayOrder;
  const SplitDay({
    required this.id,
    required this.splitId,
    required this.name,
    required this.dayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['split_id'] = Variable<int>(splitId);
    map['name'] = Variable<String>(name);
    map['day_order'] = Variable<int>(dayOrder);
    return map;
  }

  SplitDaysCompanion toCompanion(bool nullToAbsent) {
    return SplitDaysCompanion(
      id: Value(id),
      splitId: Value(splitId),
      name: Value(name),
      dayOrder: Value(dayOrder),
    );
  }

  factory SplitDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SplitDay(
      id: serializer.fromJson<int>(json['id']),
      splitId: serializer.fromJson<int>(json['splitId']),
      name: serializer.fromJson<String>(json['name']),
      dayOrder: serializer.fromJson<int>(json['dayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'splitId': serializer.toJson<int>(splitId),
      'name': serializer.toJson<String>(name),
      'dayOrder': serializer.toJson<int>(dayOrder),
    };
  }

  SplitDay copyWith({int? id, int? splitId, String? name, int? dayOrder}) =>
      SplitDay(
        id: id ?? this.id,
        splitId: splitId ?? this.splitId,
        name: name ?? this.name,
        dayOrder: dayOrder ?? this.dayOrder,
      );
  SplitDay copyWithCompanion(SplitDaysCompanion data) {
    return SplitDay(
      id: data.id.present ? data.id.value : this.id,
      splitId: data.splitId.present ? data.splitId.value : this.splitId,
      name: data.name.present ? data.name.value : this.name,
      dayOrder: data.dayOrder.present ? data.dayOrder.value : this.dayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SplitDay(')
          ..write('id: $id, ')
          ..write('splitId: $splitId, ')
          ..write('name: $name, ')
          ..write('dayOrder: $dayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, splitId, name, dayOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SplitDay &&
          other.id == this.id &&
          other.splitId == this.splitId &&
          other.name == this.name &&
          other.dayOrder == this.dayOrder);
}

class SplitDaysCompanion extends UpdateCompanion<SplitDay> {
  final Value<int> id;
  final Value<int> splitId;
  final Value<String> name;
  final Value<int> dayOrder;
  const SplitDaysCompanion({
    this.id = const Value.absent(),
    this.splitId = const Value.absent(),
    this.name = const Value.absent(),
    this.dayOrder = const Value.absent(),
  });
  SplitDaysCompanion.insert({
    this.id = const Value.absent(),
    required int splitId,
    required String name,
    required int dayOrder,
  }) : splitId = Value(splitId),
       name = Value(name),
       dayOrder = Value(dayOrder);
  static Insertable<SplitDay> custom({
    Expression<int>? id,
    Expression<int>? splitId,
    Expression<String>? name,
    Expression<int>? dayOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (splitId != null) 'split_id': splitId,
      if (name != null) 'name': name,
      if (dayOrder != null) 'day_order': dayOrder,
    });
  }

  SplitDaysCompanion copyWith({
    Value<int>? id,
    Value<int>? splitId,
    Value<String>? name,
    Value<int>? dayOrder,
  }) {
    return SplitDaysCompanion(
      id: id ?? this.id,
      splitId: splitId ?? this.splitId,
      name: name ?? this.name,
      dayOrder: dayOrder ?? this.dayOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (splitId.present) {
      map['split_id'] = Variable<int>(splitId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dayOrder.present) {
      map['day_order'] = Variable<int>(dayOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SplitDaysCompanion(')
          ..write('id: $id, ')
          ..write('splitId: $splitId, ')
          ..write('name: $name, ')
          ..write('dayOrder: $dayOrder')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  static const VerificationMeta _splitDayIdMeta = const VerificationMeta(
    'splitDayId',
  );
  @override
  late final GeneratedColumn<int> splitDayId = GeneratedColumn<int>(
    'split_day_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES split_days (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    endedAt,
    splitDayId,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('split_day_id')) {
      context.handle(
        _splitDayIdMeta,
        splitDayId.isAcceptableOrUnknown(
          data['split_day_id']!,
          _splitDayIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      splitDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}split_day_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final int id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? splitDayId;
  final String? notes;
  const WorkoutSession({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.splitDayId,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || splitDayId != null) {
      map['split_day_id'] = Variable<int>(splitDayId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      splitDayId: splitDayId == null && nullToAbsent
          ? const Value.absent()
          : Value(splitDayId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      splitDayId: serializer.fromJson<int?>(json['splitDayId']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'splitDayId': serializer.toJson<int?>(splitDayId),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WorkoutSession copyWith({
    int? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<int?> splitDayId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => WorkoutSession(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    splitDayId: splitDayId.present ? splitDayId.value : this.splitDayId,
    notes: notes.present ? notes.value : this.notes,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      splitDayId: data.splitDayId.present
          ? data.splitDayId.value
          : this.splitDayId,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('splitDayId: $splitDayId, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, endedAt, splitDayId, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.splitDayId == this.splitDayId &&
          other.notes == this.notes);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int?> splitDayId;
  final Value<String?> notes;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.splitDayId = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.splitDayId = const Value.absent(),
    this.notes = const Value.absent(),
  }) : startedAt = Value(startedAt);
  static Insertable<WorkoutSession> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? splitDayId,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (splitDayId != null) 'split_day_id': splitDayId,
      if (notes != null) 'notes': notes,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int?>? splitDayId,
    Value<String?>? notes,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      splitDayId: splitDayId ?? this.splitDayId,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (splitDayId.present) {
      map['split_day_id'] = Variable<int>(splitDayId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('splitDayId: $splitDayId, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workoutSessionIdMeta = const VerificationMeta(
    'workoutSessionId',
  );
  @override
  late final GeneratedColumn<int> workoutSessionId = GeneratedColumn<int>(
    'workout_session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isWarmupMeta = const VerificationMeta(
    'isWarmup',
  );
  @override
  late final GeneratedColumn<bool> isWarmup = GeneratedColumn<bool>(
    'is_warmup',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_warmup" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutSessionId,
    exerciseId,
    setNumber,
    weight,
    reps,
    rpe,
    isWarmup,
    completedAt,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_session_id')) {
      context.handle(
        _workoutSessionIdMeta,
        workoutSessionId.isAcceptableOrUnknown(
          data['workout_session_id']!,
          _workoutSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutSessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('is_warmup')) {
      context.handle(
        _isWarmupMeta,
        isWarmup.isAcceptableOrUnknown(data['is_warmup']!, _isWarmupMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workoutSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe'],
      ),
      isWarmup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_warmup'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final int id;
  final int workoutSessionId;
  final int exerciseId;
  final int setNumber;
  final double weight;
  final int reps;
  final double? rpe;
  final bool isWarmup;
  final DateTime completedAt;
  final String? notes;
  const WorkoutSet({
    required this.id,
    required this.workoutSessionId,
    required this.exerciseId,
    required this.setNumber,
    required this.weight,
    required this.reps,
    this.rpe,
    required this.isWarmup,
    required this.completedAt,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_session_id'] = Variable<int>(workoutSessionId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['set_number'] = Variable<int>(setNumber);
    map['weight'] = Variable<double>(weight);
    map['reps'] = Variable<int>(reps);
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    map['is_warmup'] = Variable<bool>(isWarmup);
    map['completed_at'] = Variable<DateTime>(completedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      workoutSessionId: Value(workoutSessionId),
      exerciseId: Value(exerciseId),
      setNumber: Value(setNumber),
      weight: Value(weight),
      reps: Value(reps),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      isWarmup: Value(isWarmup),
      completedAt: Value(completedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory WorkoutSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<int>(json['id']),
      workoutSessionId: serializer.fromJson<int>(json['workoutSessionId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      weight: serializer.fromJson<double>(json['weight']),
      reps: serializer.fromJson<int>(json['reps']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      isWarmup: serializer.fromJson<bool>(json['isWarmup']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutSessionId': serializer.toJson<int>(workoutSessionId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'weight': serializer.toJson<double>(weight),
      'reps': serializer.toJson<int>(reps),
      'rpe': serializer.toJson<double?>(rpe),
      'isWarmup': serializer.toJson<bool>(isWarmup),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WorkoutSet copyWith({
    int? id,
    int? workoutSessionId,
    int? exerciseId,
    int? setNumber,
    double? weight,
    int? reps,
    Value<double?> rpe = const Value.absent(),
    bool? isWarmup,
    DateTime? completedAt,
    Value<String?> notes = const Value.absent(),
  }) => WorkoutSet(
    id: id ?? this.id,
    workoutSessionId: workoutSessionId ?? this.workoutSessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    setNumber: setNumber ?? this.setNumber,
    weight: weight ?? this.weight,
    reps: reps ?? this.reps,
    rpe: rpe.present ? rpe.value : this.rpe,
    isWarmup: isWarmup ?? this.isWarmup,
    completedAt: completedAt ?? this.completedAt,
    notes: notes.present ? notes.value : this.notes,
  );
  WorkoutSet copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSet(
      id: data.id.present ? data.id.value : this.id,
      workoutSessionId: data.workoutSessionId.present
          ? data.workoutSessionId.value
          : this.workoutSessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      weight: data.weight.present ? data.weight.value : this.weight,
      reps: data.reps.present ? data.reps.value : this.reps,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      isWarmup: data.isWarmup.present ? data.isWarmup.value : this.isWarmup,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('workoutSessionId: $workoutSessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('isWarmup: $isWarmup, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutSessionId,
    exerciseId,
    setNumber,
    weight,
    reps,
    rpe,
    isWarmup,
    completedAt,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.workoutSessionId == this.workoutSessionId &&
          other.exerciseId == this.exerciseId &&
          other.setNumber == this.setNumber &&
          other.weight == this.weight &&
          other.reps == this.reps &&
          other.rpe == this.rpe &&
          other.isWarmup == this.isWarmup &&
          other.completedAt == this.completedAt &&
          other.notes == this.notes);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<int> id;
  final Value<int> workoutSessionId;
  final Value<int> exerciseId;
  final Value<int> setNumber;
  final Value<double> weight;
  final Value<int> reps;
  final Value<double?> rpe;
  final Value<bool> isWarmup;
  final Value<DateTime> completedAt;
  final Value<String?> notes;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.workoutSessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.rpe = const Value.absent(),
    this.isWarmup = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    this.id = const Value.absent(),
    required int workoutSessionId,
    required int exerciseId,
    required int setNumber,
    required double weight,
    required int reps,
    this.rpe = const Value.absent(),
    this.isWarmup = const Value.absent(),
    required DateTime completedAt,
    this.notes = const Value.absent(),
  }) : workoutSessionId = Value(workoutSessionId),
       exerciseId = Value(exerciseId),
       setNumber = Value(setNumber),
       weight = Value(weight),
       reps = Value(reps),
       completedAt = Value(completedAt);
  static Insertable<WorkoutSet> custom({
    Expression<int>? id,
    Expression<int>? workoutSessionId,
    Expression<int>? exerciseId,
    Expression<int>? setNumber,
    Expression<double>? weight,
    Expression<int>? reps,
    Expression<double>? rpe,
    Expression<bool>? isWarmup,
    Expression<DateTime>? completedAt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutSessionId != null) 'workout_session_id': workoutSessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
      if (rpe != null) 'rpe': rpe,
      if (isWarmup != null) 'is_warmup': isWarmup,
      if (completedAt != null) 'completed_at': completedAt,
      if (notes != null) 'notes': notes,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutSessionId,
    Value<int>? exerciseId,
    Value<int>? setNumber,
    Value<double>? weight,
    Value<int>? reps,
    Value<double?>? rpe,
    Value<bool>? isWarmup,
    Value<DateTime>? completedAt,
    Value<String?>? notes,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      isWarmup: isWarmup ?? this.isWarmup,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutSessionId.present) {
      map['workout_session_id'] = Variable<int>(workoutSessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (isWarmup.present) {
      map['is_warmup'] = Variable<bool>(isWarmup.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('workoutSessionId: $workoutSessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('isWarmup: $isWarmup, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SplitDayExercisesTable extends SplitDayExercises
    with TableInfo<$SplitDayExercisesTable, SplitDayExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SplitDayExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _splitDayIdMeta = const VerificationMeta(
    'splitDayId',
  );
  @override
  late final GeneratedColumn<int> splitDayId = GeneratedColumn<int>(
    'split_day_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES split_days (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetRepsLowMeta = const VerificationMeta(
    'targetRepsLow',
  );
  @override
  late final GeneratedColumn<int> targetRepsLow = GeneratedColumn<int>(
    'target_reps_low',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetRepsHighMeta = const VerificationMeta(
    'targetRepsHigh',
  );
  @override
  late final GeneratedColumn<int> targetRepsHigh = GeneratedColumn<int>(
    'target_reps_high',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    splitDayId,
    exerciseId,
    targetSets,
    targetRepsLow,
    targetRepsHigh,
    order,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'split_day_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<SplitDayExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('split_day_id')) {
      context.handle(
        _splitDayIdMeta,
        splitDayId.isAcceptableOrUnknown(
          data['split_day_id']!,
          _splitDayIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_splitDayIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    } else if (isInserting) {
      context.missing(_targetSetsMeta);
    }
    if (data.containsKey('target_reps_low')) {
      context.handle(
        _targetRepsLowMeta,
        targetRepsLow.isAcceptableOrUnknown(
          data['target_reps_low']!,
          _targetRepsLowMeta,
        ),
      );
    }
    if (data.containsKey('target_reps_high')) {
      context.handle(
        _targetRepsHighMeta,
        targetRepsHigh.isAcceptableOrUnknown(
          data['target_reps_high']!,
          _targetRepsHighMeta,
        ),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SplitDayExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SplitDayExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      splitDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}split_day_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      )!,
      targetRepsLow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps_low'],
      ),
      targetRepsHigh: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps_high'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  $SplitDayExercisesTable createAlias(String alias) {
    return $SplitDayExercisesTable(attachedDatabase, alias);
  }
}

class SplitDayExercise extends DataClass
    implements Insertable<SplitDayExercise> {
  final int id;
  final int splitDayId;
  final int exerciseId;
  final int targetSets;
  final int? targetRepsLow;
  final int? targetRepsHigh;
  final int order;
  const SplitDayExercise({
    required this.id,
    required this.splitDayId,
    required this.exerciseId,
    required this.targetSets,
    this.targetRepsLow,
    this.targetRepsHigh,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['split_day_id'] = Variable<int>(splitDayId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['target_sets'] = Variable<int>(targetSets);
    if (!nullToAbsent || targetRepsLow != null) {
      map['target_reps_low'] = Variable<int>(targetRepsLow);
    }
    if (!nullToAbsent || targetRepsHigh != null) {
      map['target_reps_high'] = Variable<int>(targetRepsHigh);
    }
    map['order'] = Variable<int>(order);
    return map;
  }

  SplitDayExercisesCompanion toCompanion(bool nullToAbsent) {
    return SplitDayExercisesCompanion(
      id: Value(id),
      splitDayId: Value(splitDayId),
      exerciseId: Value(exerciseId),
      targetSets: Value(targetSets),
      targetRepsLow: targetRepsLow == null && nullToAbsent
          ? const Value.absent()
          : Value(targetRepsLow),
      targetRepsHigh: targetRepsHigh == null && nullToAbsent
          ? const Value.absent()
          : Value(targetRepsHigh),
      order: Value(order),
    );
  }

  factory SplitDayExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SplitDayExercise(
      id: serializer.fromJson<int>(json['id']),
      splitDayId: serializer.fromJson<int>(json['splitDayId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      targetSets: serializer.fromJson<int>(json['targetSets']),
      targetRepsLow: serializer.fromJson<int?>(json['targetRepsLow']),
      targetRepsHigh: serializer.fromJson<int?>(json['targetRepsHigh']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'splitDayId': serializer.toJson<int>(splitDayId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'targetSets': serializer.toJson<int>(targetSets),
      'targetRepsLow': serializer.toJson<int?>(targetRepsLow),
      'targetRepsHigh': serializer.toJson<int?>(targetRepsHigh),
      'order': serializer.toJson<int>(order),
    };
  }

  SplitDayExercise copyWith({
    int? id,
    int? splitDayId,
    int? exerciseId,
    int? targetSets,
    Value<int?> targetRepsLow = const Value.absent(),
    Value<int?> targetRepsHigh = const Value.absent(),
    int? order,
  }) => SplitDayExercise(
    id: id ?? this.id,
    splitDayId: splitDayId ?? this.splitDayId,
    exerciseId: exerciseId ?? this.exerciseId,
    targetSets: targetSets ?? this.targetSets,
    targetRepsLow: targetRepsLow.present
        ? targetRepsLow.value
        : this.targetRepsLow,
    targetRepsHigh: targetRepsHigh.present
        ? targetRepsHigh.value
        : this.targetRepsHigh,
    order: order ?? this.order,
  );
  SplitDayExercise copyWithCompanion(SplitDayExercisesCompanion data) {
    return SplitDayExercise(
      id: data.id.present ? data.id.value : this.id,
      splitDayId: data.splitDayId.present
          ? data.splitDayId.value
          : this.splitDayId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      targetRepsLow: data.targetRepsLow.present
          ? data.targetRepsLow.value
          : this.targetRepsLow,
      targetRepsHigh: data.targetRepsHigh.present
          ? data.targetRepsHigh.value
          : this.targetRepsHigh,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SplitDayExercise(')
          ..write('id: $id, ')
          ..write('splitDayId: $splitDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetRepsLow: $targetRepsLow, ')
          ..write('targetRepsHigh: $targetRepsHigh, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    splitDayId,
    exerciseId,
    targetSets,
    targetRepsLow,
    targetRepsHigh,
    order,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SplitDayExercise &&
          other.id == this.id &&
          other.splitDayId == this.splitDayId &&
          other.exerciseId == this.exerciseId &&
          other.targetSets == this.targetSets &&
          other.targetRepsLow == this.targetRepsLow &&
          other.targetRepsHigh == this.targetRepsHigh &&
          other.order == this.order);
}

class SplitDayExercisesCompanion extends UpdateCompanion<SplitDayExercise> {
  final Value<int> id;
  final Value<int> splitDayId;
  final Value<int> exerciseId;
  final Value<int> targetSets;
  final Value<int?> targetRepsLow;
  final Value<int?> targetRepsHigh;
  final Value<int> order;
  const SplitDayExercisesCompanion({
    this.id = const Value.absent(),
    this.splitDayId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.targetRepsLow = const Value.absent(),
    this.targetRepsHigh = const Value.absent(),
    this.order = const Value.absent(),
  });
  SplitDayExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int splitDayId,
    required int exerciseId,
    required int targetSets,
    this.targetRepsLow = const Value.absent(),
    this.targetRepsHigh = const Value.absent(),
    required int order,
  }) : splitDayId = Value(splitDayId),
       exerciseId = Value(exerciseId),
       targetSets = Value(targetSets),
       order = Value(order);
  static Insertable<SplitDayExercise> custom({
    Expression<int>? id,
    Expression<int>? splitDayId,
    Expression<int>? exerciseId,
    Expression<int>? targetSets,
    Expression<int>? targetRepsLow,
    Expression<int>? targetRepsHigh,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (splitDayId != null) 'split_day_id': splitDayId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (targetSets != null) 'target_sets': targetSets,
      if (targetRepsLow != null) 'target_reps_low': targetRepsLow,
      if (targetRepsHigh != null) 'target_reps_high': targetRepsHigh,
      if (order != null) 'order': order,
    });
  }

  SplitDayExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? splitDayId,
    Value<int>? exerciseId,
    Value<int>? targetSets,
    Value<int?>? targetRepsLow,
    Value<int?>? targetRepsHigh,
    Value<int>? order,
  }) {
    return SplitDayExercisesCompanion(
      id: id ?? this.id,
      splitDayId: splitDayId ?? this.splitDayId,
      exerciseId: exerciseId ?? this.exerciseId,
      targetSets: targetSets ?? this.targetSets,
      targetRepsLow: targetRepsLow ?? this.targetRepsLow,
      targetRepsHigh: targetRepsHigh ?? this.targetRepsHigh,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (splitDayId.present) {
      map['split_day_id'] = Variable<int>(splitDayId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (targetRepsLow.present) {
      map['target_reps_low'] = Variable<int>(targetRepsLow.value);
    }
    if (targetRepsHigh.present) {
      map['target_reps_high'] = Variable<int>(targetRepsHigh.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SplitDayExercisesCompanion(')
          ..write('id: $id, ')
          ..write('splitDayId: $splitDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetRepsLow: $targetRepsLow, ')
          ..write('targetRepsHigh: $targetRepsHigh, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Gender?, String> gender =
      GeneratedColumn<String>(
        'gender',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Gender?>($UserProfilesTable.$convertergendern);
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExperienceLevel?, String>
  experienceLevel =
      GeneratedColumn<String>(
        'experience_level',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<ExperienceLevel?>(
        $UserProfilesTable.$converterexperienceLeveln,
      );
  @override
  late final GeneratedColumnWithTypeConverter<TrainingGoal?, String>
  primaryGoal = GeneratedColumn<String>(
    'primary_goal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<TrainingGoal?>($UserProfilesTable.$converterprimaryGoaln);
  @override
  late final GeneratedColumnWithTypeConverter<WeightUnit, String>
  preferredWeightUnit = GeneratedColumn<String>(
    'preferred_weight_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('kg'),
  ).withConverter<WeightUnit>($UserProfilesTable.$converterpreferredWeightUnit);
  static const VerificationMeta _weeklyTrainingGoalMeta =
      const VerificationMeta('weeklyTrainingGoal');
  @override
  late final GeneratedColumn<int> weeklyTrainingGoal = GeneratedColumn<int>(
    'weekly_training_goal',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    birthDate,
    gender,
    heightCm,
    experienceLevel,
    primaryGoal,
    preferredWeightUnit,
    weeklyTrainingGoal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('weekly_training_goal')) {
      context.handle(
        _weeklyTrainingGoalMeta,
        weeklyTrainingGoal.isAcceptableOrUnknown(
          data['weekly_training_goal']!,
          _weeklyTrainingGoalMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      gender: $UserProfilesTable.$convertergendern.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}gender'],
        ),
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      experienceLevel: $UserProfilesTable.$converterexperienceLeveln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}experience_level'],
        ),
      ),
      primaryGoal: $UserProfilesTable.$converterprimaryGoaln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}primary_goal'],
        ),
      ),
      preferredWeightUnit: $UserProfilesTable.$converterpreferredWeightUnit
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}preferred_weight_unit'],
            )!,
          ),
      weeklyTrainingGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_training_goal'],
      ),
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Gender, String, String> $convertergender =
      const EnumNameConverter<Gender>(Gender.values);
  static JsonTypeConverter2<Gender?, String?, String?> $convertergendern =
      JsonTypeConverter2.asNullable($convertergender);
  static JsonTypeConverter2<ExperienceLevel, String, String>
  $converterexperienceLevel = const EnumNameConverter<ExperienceLevel>(
    ExperienceLevel.values,
  );
  static JsonTypeConverter2<ExperienceLevel?, String?, String?>
  $converterexperienceLeveln = JsonTypeConverter2.asNullable(
    $converterexperienceLevel,
  );
  static JsonTypeConverter2<TrainingGoal, String, String>
  $converterprimaryGoal = const EnumNameConverter<TrainingGoal>(
    TrainingGoal.values,
  );
  static JsonTypeConverter2<TrainingGoal?, String?, String?>
  $converterprimaryGoaln = JsonTypeConverter2.asNullable($converterprimaryGoal);
  static JsonTypeConverter2<WeightUnit, String, String>
  $converterpreferredWeightUnit = const EnumNameConverter<WeightUnit>(
    WeightUnit.values,
  );
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String? name;
  final DateTime? birthDate;
  final Gender? gender;
  final double? heightCm;
  final ExperienceLevel? experienceLevel;
  final TrainingGoal? primaryGoal;
  final WeightUnit preferredWeightUnit;
  final int? weeklyTrainingGoal;
  const UserProfile({
    required this.id,
    this.name,
    this.birthDate,
    this.gender,
    this.heightCm,
    this.experienceLevel,
    this.primaryGoal,
    required this.preferredWeightUnit,
    this.weeklyTrainingGoal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(
        $UserProfilesTable.$convertergendern.toSql(gender),
      );
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || experienceLevel != null) {
      map['experience_level'] = Variable<String>(
        $UserProfilesTable.$converterexperienceLeveln.toSql(experienceLevel),
      );
    }
    if (!nullToAbsent || primaryGoal != null) {
      map['primary_goal'] = Variable<String>(
        $UserProfilesTable.$converterprimaryGoaln.toSql(primaryGoal),
      );
    }
    {
      map['preferred_weight_unit'] = Variable<String>(
        $UserProfilesTable.$converterpreferredWeightUnit.toSql(
          preferredWeightUnit,
        ),
      );
    }
    if (!nullToAbsent || weeklyTrainingGoal != null) {
      map['weekly_training_goal'] = Variable<int>(weeklyTrainingGoal);
    }
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      experienceLevel: experienceLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(experienceLevel),
      primaryGoal: primaryGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryGoal),
      preferredWeightUnit: Value(preferredWeightUnit),
      weeklyTrainingGoal: weeklyTrainingGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyTrainingGoal),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      gender: $UserProfilesTable.$convertergendern.fromJson(
        serializer.fromJson<String?>(json['gender']),
      ),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      experienceLevel: $UserProfilesTable.$converterexperienceLeveln.fromJson(
        serializer.fromJson<String?>(json['experienceLevel']),
      ),
      primaryGoal: $UserProfilesTable.$converterprimaryGoaln.fromJson(
        serializer.fromJson<String?>(json['primaryGoal']),
      ),
      preferredWeightUnit: $UserProfilesTable.$converterpreferredWeightUnit
          .fromJson(serializer.fromJson<String>(json['preferredWeightUnit'])),
      weeklyTrainingGoal: serializer.fromJson<int?>(json['weeklyTrainingGoal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'gender': serializer.toJson<String?>(
        $UserProfilesTable.$convertergendern.toJson(gender),
      ),
      'heightCm': serializer.toJson<double?>(heightCm),
      'experienceLevel': serializer.toJson<String?>(
        $UserProfilesTable.$converterexperienceLeveln.toJson(experienceLevel),
      ),
      'primaryGoal': serializer.toJson<String?>(
        $UserProfilesTable.$converterprimaryGoaln.toJson(primaryGoal),
      ),
      'preferredWeightUnit': serializer.toJson<String>(
        $UserProfilesTable.$converterpreferredWeightUnit.toJson(
          preferredWeightUnit,
        ),
      ),
      'weeklyTrainingGoal': serializer.toJson<int?>(weeklyTrainingGoal),
    };
  }

  UserProfile copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    Value<DateTime?> birthDate = const Value.absent(),
    Value<Gender?> gender = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<ExperienceLevel?> experienceLevel = const Value.absent(),
    Value<TrainingGoal?> primaryGoal = const Value.absent(),
    WeightUnit? preferredWeightUnit,
    Value<int?> weeklyTrainingGoal = const Value.absent(),
  }) => UserProfile(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    gender: gender.present ? gender.value : this.gender,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    experienceLevel: experienceLevel.present
        ? experienceLevel.value
        : this.experienceLevel,
    primaryGoal: primaryGoal.present ? primaryGoal.value : this.primaryGoal,
    preferredWeightUnit: preferredWeightUnit ?? this.preferredWeightUnit,
    weeklyTrainingGoal: weeklyTrainingGoal.present
        ? weeklyTrainingGoal.value
        : this.weeklyTrainingGoal,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      gender: data.gender.present ? data.gender.value : this.gender,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      experienceLevel: data.experienceLevel.present
          ? data.experienceLevel.value
          : this.experienceLevel,
      primaryGoal: data.primaryGoal.present
          ? data.primaryGoal.value
          : this.primaryGoal,
      preferredWeightUnit: data.preferredWeightUnit.present
          ? data.preferredWeightUnit.value
          : this.preferredWeightUnit,
      weeklyTrainingGoal: data.weeklyTrainingGoal.present
          ? data.weeklyTrainingGoal.value
          : this.weeklyTrainingGoal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('heightCm: $heightCm, ')
          ..write('experienceLevel: $experienceLevel, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('preferredWeightUnit: $preferredWeightUnit, ')
          ..write('weeklyTrainingGoal: $weeklyTrainingGoal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    birthDate,
    gender,
    heightCm,
    experienceLevel,
    primaryGoal,
    preferredWeightUnit,
    weeklyTrainingGoal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.birthDate == this.birthDate &&
          other.gender == this.gender &&
          other.heightCm == this.heightCm &&
          other.experienceLevel == this.experienceLevel &&
          other.primaryGoal == this.primaryGoal &&
          other.preferredWeightUnit == this.preferredWeightUnit &&
          other.weeklyTrainingGoal == this.weeklyTrainingGoal);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String?> name;
  final Value<DateTime?> birthDate;
  final Value<Gender?> gender;
  final Value<double?> heightCm;
  final Value<ExperienceLevel?> experienceLevel;
  final Value<TrainingGoal?> primaryGoal;
  final Value<WeightUnit> preferredWeightUnit;
  final Value<int?> weeklyTrainingGoal;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.experienceLevel = const Value.absent(),
    this.primaryGoal = const Value.absent(),
    this.preferredWeightUnit = const Value.absent(),
    this.weeklyTrainingGoal = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.experienceLevel = const Value.absent(),
    this.primaryGoal = const Value.absent(),
    this.preferredWeightUnit = const Value.absent(),
    this.weeklyTrainingGoal = const Value.absent(),
  });
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? birthDate,
    Expression<String>? gender,
    Expression<double>? heightCm,
    Expression<String>? experienceLevel,
    Expression<String>? primaryGoal,
    Expression<String>? preferredWeightUnit,
    Expression<int>? weeklyTrainingGoal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (birthDate != null) 'birth_date': birthDate,
      if (gender != null) 'gender': gender,
      if (heightCm != null) 'height_cm': heightCm,
      if (experienceLevel != null) 'experience_level': experienceLevel,
      if (primaryGoal != null) 'primary_goal': primaryGoal,
      if (preferredWeightUnit != null)
        'preferred_weight_unit': preferredWeightUnit,
      if (weeklyTrainingGoal != null)
        'weekly_training_goal': weeklyTrainingGoal,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<DateTime?>? birthDate,
    Value<Gender?>? gender,
    Value<double?>? heightCm,
    Value<ExperienceLevel?>? experienceLevel,
    Value<TrainingGoal?>? primaryGoal,
    Value<WeightUnit>? preferredWeightUnit,
    Value<int?>? weeklyTrainingGoal,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      preferredWeightUnit: preferredWeightUnit ?? this.preferredWeightUnit,
      weeklyTrainingGoal: weeklyTrainingGoal ?? this.weeklyTrainingGoal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(
        $UserProfilesTable.$convertergendern.toSql(gender.value),
      );
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (experienceLevel.present) {
      map['experience_level'] = Variable<String>(
        $UserProfilesTable.$converterexperienceLeveln.toSql(
          experienceLevel.value,
        ),
      );
    }
    if (primaryGoal.present) {
      map['primary_goal'] = Variable<String>(
        $UserProfilesTable.$converterprimaryGoaln.toSql(primaryGoal.value),
      );
    }
    if (preferredWeightUnit.present) {
      map['preferred_weight_unit'] = Variable<String>(
        $UserProfilesTable.$converterpreferredWeightUnit.toSql(
          preferredWeightUnit.value,
        ),
      );
    }
    if (weeklyTrainingGoal.present) {
      map['weekly_training_goal'] = Variable<int>(weeklyTrainingGoal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('heightCm: $heightCm, ')
          ..write('experienceLevel: $experienceLevel, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('preferredWeightUnit: $preferredWeightUnit, ')
          ..write('weeklyTrainingGoal: $weeklyTrainingGoal')
          ..write(')'))
        .toString();
  }
}

class $BodyweightLogsTable extends BodyweightLogs
    with TableInfo<$BodyweightLogsTable, BodyweightLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyweightLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, weightKg, loggedAt, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bodyweight_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyweightLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyweightLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyweightLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $BodyweightLogsTable createAlias(String alias) {
    return $BodyweightLogsTable(attachedDatabase, alias);
  }
}

class BodyweightLog extends DataClass implements Insertable<BodyweightLog> {
  final int id;
  final double weightKg;
  final DateTime loggedAt;
  final String? notes;
  const BodyweightLog({
    required this.id,
    required this.weightKg,
    required this.loggedAt,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['weight_kg'] = Variable<double>(weightKg);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  BodyweightLogsCompanion toCompanion(bool nullToAbsent) {
    return BodyweightLogsCompanion(
      id: Value(id),
      weightKg: Value(weightKg),
      loggedAt: Value(loggedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory BodyweightLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyweightLog(
      id: serializer.fromJson<int>(json['id']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weightKg': serializer.toJson<double>(weightKg),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  BodyweightLog copyWith({
    int? id,
    double? weightKg,
    DateTime? loggedAt,
    Value<String?> notes = const Value.absent(),
  }) => BodyweightLog(
    id: id ?? this.id,
    weightKg: weightKg ?? this.weightKg,
    loggedAt: loggedAt ?? this.loggedAt,
    notes: notes.present ? notes.value : this.notes,
  );
  BodyweightLog copyWithCompanion(BodyweightLogsCompanion data) {
    return BodyweightLog(
      id: data.id.present ? data.id.value : this.id,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyweightLog(')
          ..write('id: $id, ')
          ..write('weightKg: $weightKg, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weightKg, loggedAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyweightLog &&
          other.id == this.id &&
          other.weightKg == this.weightKg &&
          other.loggedAt == this.loggedAt &&
          other.notes == this.notes);
}

class BodyweightLogsCompanion extends UpdateCompanion<BodyweightLog> {
  final Value<int> id;
  final Value<double> weightKg;
  final Value<DateTime> loggedAt;
  final Value<String?> notes;
  const BodyweightLogsCompanion({
    this.id = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  BodyweightLogsCompanion.insert({
    this.id = const Value.absent(),
    required double weightKg,
    required DateTime loggedAt,
    this.notes = const Value.absent(),
  }) : weightKg = Value(weightKg),
       loggedAt = Value(loggedAt);
  static Insertable<BodyweightLog> custom({
    Expression<int>? id,
    Expression<double>? weightKg,
    Expression<DateTime>? loggedAt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weightKg != null) 'weight_kg': weightKg,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (notes != null) 'notes': notes,
    });
  }

  BodyweightLogsCompanion copyWith({
    Value<int>? id,
    Value<double>? weightKg,
    Value<DateTime>? loggedAt,
    Value<String?>? notes,
  }) {
    return BodyweightLogsCompanion(
      id: id ?? this.id,
      weightKg: weightKg ?? this.weightKg,
      loggedAt: loggedAt ?? this.loggedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyweightLogsCompanion(')
          ..write('id: $id, ')
          ..write('weightKg: $weightKg, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $SplitsTable splits = $SplitsTable(this);
  late final $SplitDaysTable splitDays = $SplitDaysTable(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $SplitDayExercisesTable splitDayExercises =
      $SplitDayExercisesTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $BodyweightLogsTable bodyweightLogs = $BodyweightLogsTable(this);
  late final Index exerciseNameIdx = Index(
    'exercise_name_idx',
    'CREATE INDEX exercise_name_idx ON exercises (name)',
  );
  late final Index workoutSetSessionIdx = Index(
    'workout_set_session_idx',
    'CREATE INDEX workout_set_session_idx ON workout_sets (workout_session_id)',
  );
  late final Index workoutSetExerciseCompletedIdx = Index(
    'workout_set_exercise_completed_idx',
    'CREATE INDEX workout_set_exercise_completed_idx ON workout_sets (exercise_id, completed_at)',
  );
  late final Index splitDaySplitIdx = Index(
    'split_day_split_idx',
    'CREATE INDEX split_day_split_idx ON split_days (split_id)',
  );
  late final Index splitDayExerciseDayIdx = Index(
    'split_day_exercise_day_idx',
    'CREATE INDEX split_day_exercise_day_idx ON split_day_exercises (split_day_id)',
  );
  late final Index bodyweightLogLoggedAtIdx = Index(
    'bodyweight_log_logged_at_idx',
    'CREATE INDEX bodyweight_log_logged_at_idx ON bodyweight_logs (logged_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    exercises,
    splits,
    splitDays,
    workoutSessions,
    workoutSets,
    splitDayExercises,
    userProfiles,
    bodyweightLogs,
    exerciseNameIdx,
    workoutSetSessionIdx,
    workoutSetExerciseCompletedIdx,
    splitDaySplitIdx,
    splitDayExerciseDayIdx,
    bodyweightLogLoggedAtIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'splits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('split_days', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'split_days',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sessions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'split_days',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('split_day_exercises', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  required String name,
  required MuscleGroup primaryMuscleGroup,
  required Equipment equipment,
  Value<bool> isCustom,
  Value<String?> notes,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<MuscleGroup> primaryMuscleGroup,
  Value<Equipment> equipment,
  Value<bool> isCustom,
  Value<String?> notes,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'exercises__id__workout_sets__exercise_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SplitDayExercisesTable, List<SplitDayExercise>>
  _splitDayExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.splitDayExercises,
        aliasName: 'exercises__id__split_day_exercises__exercise_id',
      );

  $$SplitDayExercisesTableProcessedTableManager get splitDayExercisesRefs {
    final manager = $$SplitDayExercisesTableTableManager(
      $_db,
      $_db.splitDayExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _splitDayExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MuscleGroup, MuscleGroup, String>
  get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Equipment, Equipment, String> get equipment =>
      $composableBuilder(
        column: $table.equipment,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> splitDayExercisesRefs(
    Expression<bool> Function($$SplitDayExercisesTableFilterComposer f) f,
  ) {
    final $$SplitDayExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.splitDayExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitDayExercisesTableFilterComposer(
            $db: $db,
            $table: $db.splitDayExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MuscleGroup, String>
  get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Equipment, String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> splitDayExercisesRefs<T extends Object>(
    Expression<T> Function($$SplitDayExercisesTableAnnotationComposer a) f,
  ) {
    final $$SplitDayExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.splitDayExercises,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SplitDayExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.splitDayExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({
            bool workoutSetsRefs,
            bool splitDayExercisesRefs,
          })
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<MuscleGroup> primaryMuscleGroup = const Value.absent(),
                Value<Equipment> equipment = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                primaryMuscleGroup: primaryMuscleGroup,
                equipment: equipment,
                isCustom: isCustom,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required MuscleGroup primaryMuscleGroup,
                required Equipment equipment,
                Value<bool> isCustom = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                primaryMuscleGroup: primaryMuscleGroup,
                equipment: equipment,
                isCustom: isCustom,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExercisesTable, Exercise>(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({workoutSetsRefs = false, splitDayExercisesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
                    if (splitDayExercisesRefs) db.splitDayExercises,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          WorkoutSet
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (splitDayExercisesRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          SplitDayExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._splitDayExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).splitDayExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
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

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({bool workoutSetsRefs, bool splitDayExercisesRefs})
    >;
typedef $$SplitsTableCreateCompanionBuilder = SplitsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
});
typedef $$SplitsTableUpdateCompanionBuilder = SplitsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
});

final class $$SplitsTableReferences
    extends BaseReferences<_$AppDatabase, $SplitsTable, Split> {
  $$SplitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SplitDaysTable, List<SplitDay>>
  _splitDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.splitDays,
    aliasName: 'splits__id__split_days__split_id',
  );

  $$SplitDaysTableProcessedTableManager get splitDaysRefs {
    final manager = $$SplitDaysTableTableManager(
      $_db,
      $_db.splitDays,
    ).filter((f) => f.splitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_splitDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SplitsTableFilterComposer
    extends Composer<_$AppDatabase, $SplitsTable> {
  $$SplitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> splitDaysRefs(
    Expression<bool> Function($$SplitDaysTableFilterComposer f) f,
  ) {
    final $$SplitDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.splitDays,
      getReferencedColumn: (t) => t.splitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitDaysTableFilterComposer(
            $db: $db,
            $table: $db.splitDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SplitsTableOrderingComposer
    extends Composer<_$AppDatabase, $SplitsTable> {
  $$SplitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SplitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SplitsTable> {
  $$SplitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> splitDaysRefs<T extends Object>(
    Expression<T> Function($$SplitDaysTableAnnotationComposer a) f,
  ) {
    final $$SplitDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.splitDays,
      getReferencedColumn: (t) => t.splitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.splitDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SplitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SplitsTable,
          Split,
          $$SplitsTableFilterComposer,
          $$SplitsTableOrderingComposer,
          $$SplitsTableAnnotationComposer,
          $$SplitsTableCreateCompanionBuilder,
          $$SplitsTableUpdateCompanionBuilder,
          (Split, $$SplitsTableReferences),
          Split,
          PrefetchHooks Function({bool splitDaysRefs})
        > {
  $$SplitsTableTableManager(_$AppDatabase db, $SplitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SplitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SplitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SplitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
          }) => SplitsCompanion(id: id, name: name, description: description),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
              }) => SplitsCompanion.insert(
                id: id,
                name: name,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SplitsTable, Split>(table),
                  $$SplitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({splitDaysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (splitDaysRefs) db.splitDays],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (splitDaysRefs)
                    await $_getPrefetchedData<Split, $SplitsTable, SplitDay>(
                      currentTable: table,
                      referencedTable: $$SplitsTableReferences
                          ._splitDaysRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SplitsTableReferences(db, table, p0).splitDaysRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.splitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SplitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SplitsTable,
      Split,
      $$SplitsTableFilterComposer,
      $$SplitsTableOrderingComposer,
      $$SplitsTableAnnotationComposer,
      $$SplitsTableCreateCompanionBuilder,
      $$SplitsTableUpdateCompanionBuilder,
      (Split, $$SplitsTableReferences),
      Split,
      PrefetchHooks Function({bool splitDaysRefs})
    >;
typedef $$SplitDaysTableCreateCompanionBuilder = SplitDaysCompanion Function({
  Value<int> id,
  required int splitId,
  required String name,
  required int dayOrder,
});
typedef $$SplitDaysTableUpdateCompanionBuilder = SplitDaysCompanion Function({
  Value<int> id,
  Value<int> splitId,
  Value<String> name,
  Value<int> dayOrder,
});

final class $$SplitDaysTableReferences
    extends BaseReferences<_$AppDatabase, $SplitDaysTable, SplitDay> {
  $$SplitDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SplitsTable _splitIdTable(_$AppDatabase db) =>
      db.splits.createAlias('split_days__split_id__splits__id');

  $$SplitsTableProcessedTableManager get splitId {
    final $_column = $_itemColumn<int>('split_id')!;

    final manager = $$SplitsTableTableManager(
      $_db,
      $_db.splits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_splitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSessionsTable, List<WorkoutSession>>
  _workoutSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSessions,
    aliasName: 'split_days__id__workout_sessions__split_day_id',
  );

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionsRefs {
    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.splitDayId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SplitDayExercisesTable, List<SplitDayExercise>>
  _splitDayExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.splitDayExercises,
        aliasName: 'split_days__id__split_day_exercises__split_day_id',
      );

  $$SplitDayExercisesTableProcessedTableManager get splitDayExercisesRefs {
    final manager = $$SplitDayExercisesTableTableManager(
      $_db,
      $_db.splitDayExercises,
    ).filter((f) => f.splitDayId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _splitDayExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SplitDaysTableFilterComposer
    extends Composer<_$AppDatabase, $SplitDaysTable> {
  $$SplitDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOrder => $composableBuilder(
    column: $table.dayOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$SplitsTableFilterComposer get splitId {
    final $$SplitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.splitId,
      referencedTable: $db.splits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitsTableFilterComposer(
            $db: $db,
            $table: $db.splits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSessionsRefs(
    Expression<bool> Function($$WorkoutSessionsTableFilterComposer f) f,
  ) {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.splitDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> splitDayExercisesRefs(
    Expression<bool> Function($$SplitDayExercisesTableFilterComposer f) f,
  ) {
    final $$SplitDayExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.splitDayExercises,
      getReferencedColumn: (t) => t.splitDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitDayExercisesTableFilterComposer(
            $db: $db,
            $table: $db.splitDayExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SplitDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $SplitDaysTable> {
  $$SplitDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOrder => $composableBuilder(
    column: $table.dayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$SplitsTableOrderingComposer get splitId {
    final $$SplitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.splitId,
      referencedTable: $db.splits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitsTableOrderingComposer(
            $db: $db,
            $table: $db.splits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SplitDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $SplitDaysTable> {
  $$SplitDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get dayOrder =>
      $composableBuilder(column: $table.dayOrder, builder: (column) => column);

  $$SplitsTableAnnotationComposer get splitId {
    final $$SplitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.splitId,
      referencedTable: $db.splits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitsTableAnnotationComposer(
            $db: $db,
            $table: $db.splits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSessionsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSessionsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.splitDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> splitDayExercisesRefs<T extends Object>(
    Expression<T> Function($$SplitDayExercisesTableAnnotationComposer a) f,
  ) {
    final $$SplitDayExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.splitDayExercises,
          getReferencedColumn: (t) => t.splitDayId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SplitDayExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.splitDayExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SplitDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SplitDaysTable,
          SplitDay,
          $$SplitDaysTableFilterComposer,
          $$SplitDaysTableOrderingComposer,
          $$SplitDaysTableAnnotationComposer,
          $$SplitDaysTableCreateCompanionBuilder,
          $$SplitDaysTableUpdateCompanionBuilder,
          (SplitDay, $$SplitDaysTableReferences),
          SplitDay,
          PrefetchHooks Function({
            bool splitId,
            bool workoutSessionsRefs,
            bool splitDayExercisesRefs,
          })
        > {
  $$SplitDaysTableTableManager(_$AppDatabase db, $SplitDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SplitDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SplitDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SplitDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> splitId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> dayOrder = const Value.absent(),
              }) => SplitDaysCompanion(
                id: id,
                splitId: splitId,
                name: name,
                dayOrder: dayOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int splitId,
                required String name,
                required int dayOrder,
              }) => SplitDaysCompanion.insert(
                id: id,
                splitId: splitId,
                name: name,
                dayOrder: dayOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SplitDaysTable, SplitDay>(table),
                  $$SplitDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                splitId = false,
                workoutSessionsRefs = false,
                splitDayExercisesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSessionsRefs) db.workoutSessions,
                    if (splitDayExercisesRefs) db.splitDayExercises,
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
                        if (splitId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.splitId,
                            referencedTable: $$SplitDaysTableReferences
                                ._splitIdTable(db),
                            referencedColumn: $$SplitDaysTableReferences
                                ._splitIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSessionsRefs)
                        await $_getPrefetchedData<
                          SplitDay,
                          $SplitDaysTable,
                          WorkoutSession
                        >(
                          currentTable: table,
                          referencedTable: $$SplitDaysTableReferences
                              ._workoutSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SplitDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.splitDayId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (splitDayExercisesRefs)
                        await $_getPrefetchedData<
                          SplitDay,
                          $SplitDaysTable,
                          SplitDayExercise
                        >(
                          currentTable: table,
                          referencedTable: $$SplitDaysTableReferences
                              ._splitDayExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SplitDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).splitDayExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.splitDayId == item.id,
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

typedef $$SplitDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SplitDaysTable,
      SplitDay,
      $$SplitDaysTableFilterComposer,
      $$SplitDaysTableOrderingComposer,
      $$SplitDaysTableAnnotationComposer,
      $$SplitDaysTableCreateCompanionBuilder,
      $$SplitDaysTableUpdateCompanionBuilder,
      (SplitDay, $$SplitDaysTableReferences),
      SplitDay,
      PrefetchHooks Function({
        bool splitId,
        bool workoutSessionsRefs,
        bool splitDayExercisesRefs,
      })
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int?> splitDayId,
      Value<String?> notes,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int?> splitDayId,
      Value<String?> notes,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SplitDaysTable _splitDayIdTable(_$AppDatabase db) => db.splitDays
      .createAlias('workout_sessions__split_day_id__split_days__id');

  $$SplitDaysTableProcessedTableManager? get splitDayId {
    final $_column = $_itemColumn<int>('split_day_id');
    if ($_column == null) return null;
    final manager = $$SplitDaysTableTableManager(
      $_db,
      $_db.splitDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_splitDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'workout_sessions__id__workout_sets__workout_session_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.workoutSessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
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

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$SplitDaysTableFilterComposer get splitDayId {
    final $$SplitDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.splitDayId,
      referencedTable: $db.splitDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitDaysTableFilterComposer(
            $db: $db,
            $table: $db.splitDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.workoutSessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
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

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$SplitDaysTableOrderingComposer get splitDayId {
    final $$SplitDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.splitDayId,
      referencedTable: $db.splitDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitDaysTableOrderingComposer(
            $db: $db,
            $table: $db.splitDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$SplitDaysTableAnnotationComposer get splitDayId {
    final $$SplitDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.splitDayId,
      referencedTable: $db.splitDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.splitDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.workoutSessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({bool splitDayId, bool workoutSetsRefs})
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> splitDayId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                splitDayId: splitDayId,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> splitDayId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                splitDayId: splitDayId,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, WorkoutSession>(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({splitDayId = false, workoutSetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
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
                        if (splitDayId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.splitDayId,
                            referencedTable: $$WorkoutSessionsTableReferences
                                ._splitDayIdTable(db),
                            referencedColumn: $$WorkoutSessionsTableReferences
                                ._splitDayIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsRefs)
                        await $_getPrefetchedData<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          WorkoutSet
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutSessionId == item.id,
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

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({bool splitDayId, bool workoutSetsRefs})
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      required int workoutSessionId,
      required int exerciseId,
      required int setNumber,
      required double weight,
      required int reps,
      Value<double?> rpe,
      Value<bool> isWarmup,
      required DateTime completedAt,
      Value<String?> notes,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      Value<int> workoutSessionId,
      Value<int> exerciseId,
      Value<int> setNumber,
      Value<double> weight,
      Value<int> reps,
      Value<double?> rpe,
      Value<bool> isWarmup,
      Value<DateTime> completedAt,
      Value<String?> notes,
    });

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSet> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _workoutSessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('workout_sets__workout_session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionId {
    final $_column = $_itemColumn<int>('workout_session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutSessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('workout_sets__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isWarmup => $composableBuilder(
    column: $table.isWarmup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get workoutSessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutSessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWarmup => $composableBuilder(
    column: $table.isWarmup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get workoutSessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutSessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<bool> get isWarmup =>
      $composableBuilder(column: $table.isWarmup, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get workoutSessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutSessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTable,
          WorkoutSet,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (WorkoutSet, $$WorkoutSetsTableReferences),
          WorkoutSet,
          PrefetchHooks Function({bool workoutSessionId, bool exerciseId})
        > {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workoutSessionId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<bool> isWarmup = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                workoutSessionId: workoutSessionId,
                exerciseId: exerciseId,
                setNumber: setNumber,
                weight: weight,
                reps: reps,
                rpe: rpe,
                isWarmup: isWarmup,
                completedAt: completedAt,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workoutSessionId,
                required int exerciseId,
                required int setNumber,
                required double weight,
                required int reps,
                Value<double?> rpe = const Value.absent(),
                Value<bool> isWarmup = const Value.absent(),
                required DateTime completedAt,
                Value<String?> notes = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                workoutSessionId: workoutSessionId,
                exerciseId: exerciseId,
                setNumber: setNumber,
                weight: weight,
                reps: reps,
                rpe: rpe,
                isWarmup: isWarmup,
                completedAt: completedAt,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSetsTable, WorkoutSet>(table),
                  $$WorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({workoutSessionId = false, exerciseId = false}) {
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
                        if (workoutSessionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.workoutSessionId,
                            referencedTable: $$WorkoutSetsTableReferences
                                ._workoutSessionIdTable(db),
                            referencedColumn: $$WorkoutSetsTableReferences
                                ._workoutSessionIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$WorkoutSetsTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn: $$WorkoutSetsTableReferences
                                ._exerciseIdTable(db)
                                .id,
                          ) as T;
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

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTable,
      WorkoutSet,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (WorkoutSet, $$WorkoutSetsTableReferences),
      WorkoutSet,
      PrefetchHooks Function({bool workoutSessionId, bool exerciseId})
    >;
typedef $$SplitDayExercisesTableCreateCompanionBuilder =
    SplitDayExercisesCompanion Function({
      Value<int> id,
      required int splitDayId,
      required int exerciseId,
      required int targetSets,
      Value<int?> targetRepsLow,
      Value<int?> targetRepsHigh,
      required int order,
    });
typedef $$SplitDayExercisesTableUpdateCompanionBuilder =
    SplitDayExercisesCompanion Function({
      Value<int> id,
      Value<int> splitDayId,
      Value<int> exerciseId,
      Value<int> targetSets,
      Value<int?> targetRepsLow,
      Value<int?> targetRepsHigh,
      Value<int> order,
    });

final class $$SplitDayExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SplitDayExercisesTable,
          SplitDayExercise
        > {
  $$SplitDayExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SplitDaysTable _splitDayIdTable(_$AppDatabase db) => db.splitDays
      .createAlias('split_day_exercises__split_day_id__split_days__id');

  $$SplitDaysTableProcessedTableManager get splitDayId {
    final $_column = $_itemColumn<int>('split_day_id')!;

    final manager = $$SplitDaysTableTableManager(
      $_db,
      $_db.splitDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_splitDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) => db.exercises
      .createAlias('split_day_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SplitDayExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $SplitDayExercisesTable> {
  $$SplitDayExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetRepsLow => $composableBuilder(
    column: $table.targetRepsLow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetRepsHigh => $composableBuilder(
    column: $table.targetRepsHigh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  $$SplitDaysTableFilterComposer get splitDayId {
    final $$SplitDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.splitDayId,
      referencedTable: $db.splitDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitDaysTableFilterComposer(
            $db: $db,
            $table: $db.splitDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SplitDayExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $SplitDayExercisesTable> {
  $$SplitDayExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetRepsLow => $composableBuilder(
    column: $table.targetRepsLow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetRepsHigh => $composableBuilder(
    column: $table.targetRepsHigh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  $$SplitDaysTableOrderingComposer get splitDayId {
    final $$SplitDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.splitDayId,
      referencedTable: $db.splitDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitDaysTableOrderingComposer(
            $db: $db,
            $table: $db.splitDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SplitDayExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SplitDayExercisesTable> {
  $$SplitDayExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetRepsLow => $composableBuilder(
    column: $table.targetRepsLow,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetRepsHigh => $composableBuilder(
    column: $table.targetRepsHigh,
    builder: (column) => column,
  );

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  $$SplitDaysTableAnnotationComposer get splitDayId {
    final $$SplitDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.splitDayId,
      referencedTable: $db.splitDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.splitDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SplitDayExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SplitDayExercisesTable,
          SplitDayExercise,
          $$SplitDayExercisesTableFilterComposer,
          $$SplitDayExercisesTableOrderingComposer,
          $$SplitDayExercisesTableAnnotationComposer,
          $$SplitDayExercisesTableCreateCompanionBuilder,
          $$SplitDayExercisesTableUpdateCompanionBuilder,
          (SplitDayExercise, $$SplitDayExercisesTableReferences),
          SplitDayExercise,
          PrefetchHooks Function({bool splitDayId, bool exerciseId})
        > {
  $$SplitDayExercisesTableTableManager(
    _$AppDatabase db,
    $SplitDayExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SplitDayExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SplitDayExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SplitDayExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> splitDayId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> targetSets = const Value.absent(),
                Value<int?> targetRepsLow = const Value.absent(),
                Value<int?> targetRepsHigh = const Value.absent(),
                Value<int> order = const Value.absent(),
              }) => SplitDayExercisesCompanion(
                id: id,
                splitDayId: splitDayId,
                exerciseId: exerciseId,
                targetSets: targetSets,
                targetRepsLow: targetRepsLow,
                targetRepsHigh: targetRepsHigh,
                order: order,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int splitDayId,
                required int exerciseId,
                required int targetSets,
                Value<int?> targetRepsLow = const Value.absent(),
                Value<int?> targetRepsHigh = const Value.absent(),
                required int order,
              }) => SplitDayExercisesCompanion.insert(
                id: id,
                splitDayId: splitDayId,
                exerciseId: exerciseId,
                targetSets: targetSets,
                targetRepsLow: targetRepsLow,
                targetRepsHigh: targetRepsHigh,
                order: order,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SplitDayExercisesTable, SplitDayExercise>(table),
                  $$SplitDayExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({splitDayId = false, exerciseId = false}) {
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
                    if (splitDayId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.splitDayId,
                        referencedTable: $$SplitDayExercisesTableReferences
                            ._splitDayIdTable(db),
                        referencedColumn: $$SplitDayExercisesTableReferences
                            ._splitDayIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (exerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exerciseId,
                        referencedTable: $$SplitDayExercisesTableReferences
                            ._exerciseIdTable(db),
                        referencedColumn: $$SplitDayExercisesTableReferences
                            ._exerciseIdTable(db)
                            .id,
                      ) as T;
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

typedef $$SplitDayExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SplitDayExercisesTable,
      SplitDayExercise,
      $$SplitDayExercisesTableFilterComposer,
      $$SplitDayExercisesTableOrderingComposer,
      $$SplitDayExercisesTableAnnotationComposer,
      $$SplitDayExercisesTableCreateCompanionBuilder,
      $$SplitDayExercisesTableUpdateCompanionBuilder,
      (SplitDayExercise, $$SplitDayExercisesTableReferences),
      SplitDayExercise,
      PrefetchHooks Function({bool splitDayId, bool exerciseId})
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<DateTime?> birthDate,
      Value<Gender?> gender,
      Value<double?> heightCm,
      Value<ExperienceLevel?> experienceLevel,
      Value<TrainingGoal?> primaryGoal,
      Value<WeightUnit> preferredWeightUnit,
      Value<int?> weeklyTrainingGoal,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<DateTime?> birthDate,
      Value<Gender?> gender,
      Value<double?> heightCm,
      Value<ExperienceLevel?> experienceLevel,
      Value<TrainingGoal?> primaryGoal,
      Value<WeightUnit> preferredWeightUnit,
      Value<int?> weeklyTrainingGoal,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Gender?, Gender, String> get gender =>
      $composableBuilder(
        column: $table.gender,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExperienceLevel?, ExperienceLevel, String>
  get experienceLevel => $composableBuilder(
    column: $table.experienceLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TrainingGoal?, TrainingGoal, String>
  get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<WeightUnit, WeightUnit, String>
  get preferredWeightUnit => $composableBuilder(
    column: $table.preferredWeightUnit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get weeklyTrainingGoal => $composableBuilder(
    column: $table.weeklyTrainingGoal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get experienceLevel => $composableBuilder(
    column: $table.experienceLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredWeightUnit => $composableBuilder(
    column: $table.preferredWeightUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyTrainingGoal => $composableBuilder(
    column: $table.weeklyTrainingGoal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Gender?, String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExperienceLevel?, String>
  get experienceLevel => $composableBuilder(
    column: $table.experienceLevel,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TrainingGoal?, String> get primaryGoal =>
      $composableBuilder(
        column: $table.primaryGoal,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<WeightUnit, String>
  get preferredWeightUnit => $composableBuilder(
    column: $table.preferredWeightUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyTrainingGoal => $composableBuilder(
    column: $table.weeklyTrainingGoal,
    builder: (column) => column,
  );
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<Gender?> gender = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<ExperienceLevel?> experienceLevel = const Value.absent(),
                Value<TrainingGoal?> primaryGoal = const Value.absent(),
                Value<WeightUnit> preferredWeightUnit = const Value.absent(),
                Value<int?> weeklyTrainingGoal = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                name: name,
                birthDate: birthDate,
                gender: gender,
                heightCm: heightCm,
                experienceLevel: experienceLevel,
                primaryGoal: primaryGoal,
                preferredWeightUnit: preferredWeightUnit,
                weeklyTrainingGoal: weeklyTrainingGoal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<Gender?> gender = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<ExperienceLevel?> experienceLevel = const Value.absent(),
                Value<TrainingGoal?> primaryGoal = const Value.absent(),
                Value<WeightUnit> preferredWeightUnit = const Value.absent(),
                Value<int?> weeklyTrainingGoal = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                name: name,
                birthDate: birthDate,
                gender: gender,
                heightCm: heightCm,
                experienceLevel: experienceLevel,
                primaryGoal: primaryGoal,
                preferredWeightUnit: preferredWeightUnit,
                weeklyTrainingGoal: weeklyTrainingGoal,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, UserProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfilesTable,
                    UserProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$BodyweightLogsTableCreateCompanionBuilder =
    BodyweightLogsCompanion Function({
      Value<int> id,
      required double weightKg,
      required DateTime loggedAt,
      Value<String?> notes,
    });
typedef $$BodyweightLogsTableUpdateCompanionBuilder =
    BodyweightLogsCompanion Function({
      Value<int> id,
      Value<double> weightKg,
      Value<DateTime> loggedAt,
      Value<String?> notes,
    });

class $$BodyweightLogsTableFilterComposer
    extends Composer<_$AppDatabase, $BodyweightLogsTable> {
  $$BodyweightLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyweightLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyweightLogsTable> {
  $$BodyweightLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyweightLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyweightLogsTable> {
  $$BodyweightLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$BodyweightLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyweightLogsTable,
          BodyweightLog,
          $$BodyweightLogsTableFilterComposer,
          $$BodyweightLogsTableOrderingComposer,
          $$BodyweightLogsTableAnnotationComposer,
          $$BodyweightLogsTableCreateCompanionBuilder,
          $$BodyweightLogsTableUpdateCompanionBuilder,
          (
            BodyweightLog,
            BaseReferences<_$AppDatabase, $BodyweightLogsTable, BodyweightLog>,
          ),
          BodyweightLog,
          PrefetchHooks Function()
        > {
  $$BodyweightLogsTableTableManager(
    _$AppDatabase db,
    $BodyweightLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyweightLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyweightLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyweightLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => BodyweightLogsCompanion(
                id: id,
                weightKg: weightKg,
                loggedAt: loggedAt,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double weightKg,
                required DateTime loggedAt,
                Value<String?> notes = const Value.absent(),
              }) => BodyweightLogsCompanion.insert(
                id: id,
                weightKg: weightKg,
                loggedAt: loggedAt,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyweightLogsTable, BodyweightLog>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BodyweightLogsTable,
                    BodyweightLog
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyweightLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyweightLogsTable,
      BodyweightLog,
      $$BodyweightLogsTableFilterComposer,
      $$BodyweightLogsTableOrderingComposer,
      $$BodyweightLogsTableAnnotationComposer,
      $$BodyweightLogsTableCreateCompanionBuilder,
      $$BodyweightLogsTableUpdateCompanionBuilder,
      (
        BodyweightLog,
        BaseReferences<_$AppDatabase, $BodyweightLogsTable, BodyweightLog>,
      ),
      BodyweightLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$SplitsTableTableManager get splits =>
      $$SplitsTableTableManager(_db, _db.splits);
  $$SplitDaysTableTableManager get splitDays =>
      $$SplitDaysTableTableManager(_db, _db.splitDays);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$SplitDayExercisesTableTableManager get splitDayExercises =>
      $$SplitDayExercisesTableTableManager(_db, _db.splitDayExercises);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$BodyweightLogsTableTableManager get bodyweightLogs =>
      $$BodyweightLogsTableTableManager(_db, _db.bodyweightLogs);
}
