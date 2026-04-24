// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_offline_database.dart';

// ignore_for_file: type=lint
class $LocalProductsTable extends LocalProducts
    with TableInfo<$LocalProductsTable, LocalProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costPriceMeta = const VerificationMeta(
    'costPrice',
  );
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
    'cost_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _isWeightedMeta = const VerificationMeta(
    'isWeighted',
  );
  @override
  late final GeneratedColumn<bool> isWeighted = GeneratedColumn<bool>(
    'is_weighted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_weighted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isAgeRestrictedMeta = const VerificationMeta(
    'isAgeRestricted',
  );
  @override
  late final GeneratedColumn<bool> isAgeRestricted = GeneratedColumn<bool>(
    'is_age_restricted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_age_restricted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _minimumAgeMeta = const VerificationMeta(
    'minimumAge',
  );
  @override
  late final GeneratedColumn<int> minimumAge = GeneratedColumn<int>(
    'minimum_age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    sku,
    barcode,
    name,
    nameAr,
    price,
    costPrice,
    taxRate,
    unit,
    isWeighted,
    isAgeRestricted,
    minimumAge,
    categoryId,
    imageUrl,
    isActive,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('cost_price')) {
      context.handle(
        _costPriceMeta,
        costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('is_weighted')) {
      context.handle(
        _isWeightedMeta,
        isWeighted.isAcceptableOrUnknown(data['is_weighted']!, _isWeightedMeta),
      );
    }
    if (data.containsKey('is_age_restricted')) {
      context.handle(
        _isAgeRestrictedMeta,
        isAgeRestricted.isAcceptableOrUnknown(
          data['is_age_restricted']!,
          _isAgeRestrictedMeta,
        ),
      );
    }
    if (data.containsKey('minimum_age')) {
      context.handle(
        _minimumAgeMeta,
        minimumAge.isAcceptableOrUnknown(data['minimum_age']!, _minimumAgeMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
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
  LocalProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProduct(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      costPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_price'],
      ),
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      isWeighted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_weighted'],
      )!,
      isAgeRestricted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_age_restricted'],
      )!,
      minimumAge: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_age'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalProductsTable createAlias(String alias) {
    return $LocalProductsTable(attachedDatabase, alias);
  }
}

class LocalProduct extends DataClass implements Insertable<LocalProduct> {
  final String id;
  final String? sku;
  final String? barcode;
  final String name;
  final String? nameAr;
  final double price;
  final double? costPrice;
  final double taxRate;
  final String? unit;
  final bool isWeighted;
  final bool isAgeRestricted;
  final int? minimumAge;
  final String? categoryId;
  final String? imageUrl;
  final bool isActive;
  final DateTime updatedAt;
  const LocalProduct({
    required this.id,
    this.sku,
    this.barcode,
    required this.name,
    this.nameAr,
    required this.price,
    this.costPrice,
    required this.taxRate,
    this.unit,
    required this.isWeighted,
    required this.isAgeRestricted,
    this.minimumAge,
    this.categoryId,
    this.imageUrl,
    required this.isActive,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || costPrice != null) {
      map['cost_price'] = Variable<double>(costPrice);
    }
    map['tax_rate'] = Variable<double>(taxRate);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['is_weighted'] = Variable<bool>(isWeighted);
    map['is_age_restricted'] = Variable<bool>(isAgeRestricted);
    if (!nullToAbsent || minimumAge != null) {
      map['minimum_age'] = Variable<int>(minimumAge);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalProductsCompanion toCompanion(bool nullToAbsent) {
    return LocalProductsCompanion(
      id: Value(id),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      name: Value(name),
      nameAr: nameAr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameAr),
      price: Value(price),
      costPrice: costPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(costPrice),
      taxRate: Value(taxRate),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      isWeighted: Value(isWeighted),
      isAgeRestricted: Value(isAgeRestricted),
      minimumAge: minimumAge == null && nullToAbsent
          ? const Value.absent()
          : Value(minimumAge),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProduct(
      id: serializer.fromJson<String>(json['id']),
      sku: serializer.fromJson<String?>(json['sku']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      price: serializer.fromJson<double>(json['price']),
      costPrice: serializer.fromJson<double?>(json['costPrice']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      unit: serializer.fromJson<String?>(json['unit']),
      isWeighted: serializer.fromJson<bool>(json['isWeighted']),
      isAgeRestricted: serializer.fromJson<bool>(json['isAgeRestricted']),
      minimumAge: serializer.fromJson<int?>(json['minimumAge']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sku': serializer.toJson<String?>(sku),
      'barcode': serializer.toJson<String?>(barcode),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'price': serializer.toJson<double>(price),
      'costPrice': serializer.toJson<double?>(costPrice),
      'taxRate': serializer.toJson<double>(taxRate),
      'unit': serializer.toJson<String?>(unit),
      'isWeighted': serializer.toJson<bool>(isWeighted),
      'isAgeRestricted': serializer.toJson<bool>(isAgeRestricted),
      'minimumAge': serializer.toJson<int?>(minimumAge),
      'categoryId': serializer.toJson<String?>(categoryId),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'isActive': serializer.toJson<bool>(isActive),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalProduct copyWith({
    String? id,
    Value<String?> sku = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    String? name,
    Value<String?> nameAr = const Value.absent(),
    double? price,
    Value<double?> costPrice = const Value.absent(),
    double? taxRate,
    Value<String?> unit = const Value.absent(),
    bool? isWeighted,
    bool? isAgeRestricted,
    Value<int?> minimumAge = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    bool? isActive,
    DateTime? updatedAt,
  }) => LocalProduct(
    id: id ?? this.id,
    sku: sku.present ? sku.value : this.sku,
    barcode: barcode.present ? barcode.value : this.barcode,
    name: name ?? this.name,
    nameAr: nameAr.present ? nameAr.value : this.nameAr,
    price: price ?? this.price,
    costPrice: costPrice.present ? costPrice.value : this.costPrice,
    taxRate: taxRate ?? this.taxRate,
    unit: unit.present ? unit.value : this.unit,
    isWeighted: isWeighted ?? this.isWeighted,
    isAgeRestricted: isAgeRestricted ?? this.isAgeRestricted,
    minimumAge: minimumAge.present ? minimumAge.value : this.minimumAge,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalProduct copyWithCompanion(LocalProductsCompanion data) {
    return LocalProduct(
      id: data.id.present ? data.id.value : this.id,
      sku: data.sku.present ? data.sku.value : this.sku,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      price: data.price.present ? data.price.value : this.price,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      unit: data.unit.present ? data.unit.value : this.unit,
      isWeighted: data.isWeighted.present
          ? data.isWeighted.value
          : this.isWeighted,
      isAgeRestricted: data.isAgeRestricted.present
          ? data.isAgeRestricted.value
          : this.isAgeRestricted,
      minimumAge: data.minimumAge.present
          ? data.minimumAge.value
          : this.minimumAge,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProduct(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('price: $price, ')
          ..write('costPrice: $costPrice, ')
          ..write('taxRate: $taxRate, ')
          ..write('unit: $unit, ')
          ..write('isWeighted: $isWeighted, ')
          ..write('isAgeRestricted: $isAgeRestricted, ')
          ..write('minimumAge: $minimumAge, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sku,
    barcode,
    name,
    nameAr,
    price,
    costPrice,
    taxRate,
    unit,
    isWeighted,
    isAgeRestricted,
    minimumAge,
    categoryId,
    imageUrl,
    isActive,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProduct &&
          other.id == this.id &&
          other.sku == this.sku &&
          other.barcode == this.barcode &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.price == this.price &&
          other.costPrice == this.costPrice &&
          other.taxRate == this.taxRate &&
          other.unit == this.unit &&
          other.isWeighted == this.isWeighted &&
          other.isAgeRestricted == this.isAgeRestricted &&
          other.minimumAge == this.minimumAge &&
          other.categoryId == this.categoryId &&
          other.imageUrl == this.imageUrl &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt);
}

class LocalProductsCompanion extends UpdateCompanion<LocalProduct> {
  final Value<String> id;
  final Value<String?> sku;
  final Value<String?> barcode;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<double> price;
  final Value<double?> costPrice;
  final Value<double> taxRate;
  final Value<String?> unit;
  final Value<bool> isWeighted;
  final Value<bool> isAgeRestricted;
  final Value<int?> minimumAge;
  final Value<String?> categoryId;
  final Value<String?> imageUrl;
  final Value<bool> isActive;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalProductsCompanion({
    this.id = const Value.absent(),
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.price = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.unit = const Value.absent(),
    this.isWeighted = const Value.absent(),
    this.isAgeRestricted = const Value.absent(),
    this.minimumAge = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProductsCompanion.insert({
    required String id,
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    required String name,
    this.nameAr = const Value.absent(),
    required double price,
    this.costPrice = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.unit = const Value.absent(),
    this.isWeighted = const Value.absent(),
    this.isAgeRestricted = const Value.absent(),
    this.minimumAge = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       price = Value(price),
       updatedAt = Value(updatedAt);
  static Insertable<LocalProduct> custom({
    Expression<String>? id,
    Expression<String>? sku,
    Expression<String>? barcode,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<double>? price,
    Expression<double>? costPrice,
    Expression<double>? taxRate,
    Expression<String>? unit,
    Expression<bool>? isWeighted,
    Expression<bool>? isAgeRestricted,
    Expression<int>? minimumAge,
    Expression<String>? categoryId,
    Expression<String>? imageUrl,
    Expression<bool>? isActive,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sku != null) 'sku': sku,
      if (barcode != null) 'barcode': barcode,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (price != null) 'price': price,
      if (costPrice != null) 'cost_price': costPrice,
      if (taxRate != null) 'tax_rate': taxRate,
      if (unit != null) 'unit': unit,
      if (isWeighted != null) 'is_weighted': isWeighted,
      if (isAgeRestricted != null) 'is_age_restricted': isAgeRestricted,
      if (minimumAge != null) 'minimum_age': minimumAge,
      if (categoryId != null) 'category_id': categoryId,
      if (imageUrl != null) 'image_url': imageUrl,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProductsCompanion copyWith({
    Value<String>? id,
    Value<String?>? sku,
    Value<String?>? barcode,
    Value<String>? name,
    Value<String?>? nameAr,
    Value<double>? price,
    Value<double?>? costPrice,
    Value<double>? taxRate,
    Value<String?>? unit,
    Value<bool>? isWeighted,
    Value<bool>? isAgeRestricted,
    Value<int?>? minimumAge,
    Value<String?>? categoryId,
    Value<String?>? imageUrl,
    Value<bool>? isActive,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalProductsCompanion(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      taxRate: taxRate ?? this.taxRate,
      unit: unit ?? this.unit,
      isWeighted: isWeighted ?? this.isWeighted,
      isAgeRestricted: isAgeRestricted ?? this.isAgeRestricted,
      minimumAge: minimumAge ?? this.minimumAge,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
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
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (isWeighted.present) {
      map['is_weighted'] = Variable<bool>(isWeighted.value);
    }
    if (isAgeRestricted.present) {
      map['is_age_restricted'] = Variable<bool>(isAgeRestricted.value);
    }
    if (minimumAge.present) {
      map['minimum_age'] = Variable<int>(minimumAge.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
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
    return (StringBuffer('LocalProductsCompanion(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('price: $price, ')
          ..write('costPrice: $costPrice, ')
          ..write('taxRate: $taxRate, ')
          ..write('unit: $unit, ')
          ..write('isWeighted: $isWeighted, ')
          ..write('isAgeRestricted: $isAgeRestricted, ')
          ..write('minimumAge: $minimumAge, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalInventoryTable extends LocalInventory
    with TableInfo<$LocalInventoryTable, LocalInventoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalInventoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reservedMeta = const VerificationMeta(
    'reserved',
  );
  @override
  late final GeneratedColumn<double> reserved = GeneratedColumn<double>(
    'reserved',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    productId,
    storeId,
    quantity,
    reserved,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_inventory';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalInventoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('reserved')) {
      context.handle(
        _reservedMeta,
        reserved.isAcceptableOrUnknown(data['reserved']!, _reservedMeta),
      );
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
  Set<GeneratedColumn> get $primaryKey => {productId, storeId};
  @override
  LocalInventoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalInventoryData(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      reserved: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reserved'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalInventoryTable createAlias(String alias) {
    return $LocalInventoryTable(attachedDatabase, alias);
  }
}

class LocalInventoryData extends DataClass
    implements Insertable<LocalInventoryData> {
  final String productId;
  final String storeId;
  final double quantity;
  final double reserved;
  final DateTime updatedAt;
  const LocalInventoryData({
    required this.productId,
    required this.storeId,
    required this.quantity,
    required this.reserved,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<String>(productId);
    map['store_id'] = Variable<String>(storeId);
    map['quantity'] = Variable<double>(quantity);
    map['reserved'] = Variable<double>(reserved);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalInventoryCompanion toCompanion(bool nullToAbsent) {
    return LocalInventoryCompanion(
      productId: Value(productId),
      storeId: Value(storeId),
      quantity: Value(quantity),
      reserved: Value(reserved),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalInventoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalInventoryData(
      productId: serializer.fromJson<String>(json['productId']),
      storeId: serializer.fromJson<String>(json['storeId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      reserved: serializer.fromJson<double>(json['reserved']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<String>(productId),
      'storeId': serializer.toJson<String>(storeId),
      'quantity': serializer.toJson<double>(quantity),
      'reserved': serializer.toJson<double>(reserved),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalInventoryData copyWith({
    String? productId,
    String? storeId,
    double? quantity,
    double? reserved,
    DateTime? updatedAt,
  }) => LocalInventoryData(
    productId: productId ?? this.productId,
    storeId: storeId ?? this.storeId,
    quantity: quantity ?? this.quantity,
    reserved: reserved ?? this.reserved,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalInventoryData copyWithCompanion(LocalInventoryCompanion data) {
    return LocalInventoryData(
      productId: data.productId.present ? data.productId.value : this.productId,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      reserved: data.reserved.present ? data.reserved.value : this.reserved,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalInventoryData(')
          ..write('productId: $productId, ')
          ..write('storeId: $storeId, ')
          ..write('quantity: $quantity, ')
          ..write('reserved: $reserved, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(productId, storeId, quantity, reserved, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalInventoryData &&
          other.productId == this.productId &&
          other.storeId == this.storeId &&
          other.quantity == this.quantity &&
          other.reserved == this.reserved &&
          other.updatedAt == this.updatedAt);
}

class LocalInventoryCompanion extends UpdateCompanion<LocalInventoryData> {
  final Value<String> productId;
  final Value<String> storeId;
  final Value<double> quantity;
  final Value<double> reserved;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalInventoryCompanion({
    this.productId = const Value.absent(),
    this.storeId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.reserved = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalInventoryCompanion.insert({
    required String productId,
    required String storeId,
    this.quantity = const Value.absent(),
    this.reserved = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : productId = Value(productId),
       storeId = Value(storeId),
       updatedAt = Value(updatedAt);
  static Insertable<LocalInventoryData> custom({
    Expression<String>? productId,
    Expression<String>? storeId,
    Expression<double>? quantity,
    Expression<double>? reserved,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (storeId != null) 'store_id': storeId,
      if (quantity != null) 'quantity': quantity,
      if (reserved != null) 'reserved': reserved,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalInventoryCompanion copyWith({
    Value<String>? productId,
    Value<String>? storeId,
    Value<double>? quantity,
    Value<double>? reserved,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalInventoryCompanion(
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
      quantity: quantity ?? this.quantity,
      reserved: reserved ?? this.reserved,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (reserved.present) {
      map['reserved'] = Variable<double>(reserved.value);
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
    return (StringBuffer('LocalInventoryCompanion(')
          ..write('productId: $productId, ')
          ..write('storeId: $storeId, ')
          ..write('quantity: $quantity, ')
          ..write('reserved: $reserved, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalHeldCartsTable extends LocalHeldCarts
    with TableInfo<$LocalHeldCartsTable, LocalHeldCart> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalHeldCartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientUuidMeta = const VerificationMeta(
    'clientUuid',
  );
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
    'client_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registerIdMeta = const VerificationMeta(
    'registerId',
  );
  @override
  late final GeneratedColumn<String> registerId = GeneratedColumn<String>(
    'register_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cashierIdMeta = const VerificationMeta(
    'cashierId',
  );
  @override
  late final GeneratedColumn<String> cashierId = GeneratedColumn<String>(
    'cashier_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
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
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    clientUuid,
    storeId,
    registerId,
    cashierId,
    customerId,
    name,
    itemsJson,
    total,
    createdAt,
    expiresAt,
    serverId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_held_carts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalHeldCart> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_uuid')) {
      context.handle(
        _clientUuidMeta,
        clientUuid.isAcceptableOrUnknown(data['client_uuid']!, _clientUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('register_id')) {
      context.handle(
        _registerIdMeta,
        registerId.isAcceptableOrUnknown(data['register_id']!, _registerIdMeta),
      );
    }
    if (data.containsKey('cashier_id')) {
      context.handle(
        _cashierIdMeta,
        cashierId.isAcceptableOrUnknown(data['cashier_id']!, _cashierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cashierIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientUuid};
  @override
  LocalHeldCart map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalHeldCart(
      clientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_uuid'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      registerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}register_id'],
      ),
      cashierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier_id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
    );
  }

  @override
  $LocalHeldCartsTable createAlias(String alias) {
    return $LocalHeldCartsTable(attachedDatabase, alias);
  }
}

class LocalHeldCart extends DataClass implements Insertable<LocalHeldCart> {
  final String clientUuid;
  final String storeId;
  final String? registerId;
  final String cashierId;
  final String? customerId;
  final String? name;
  final String itemsJson;
  final double total;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String? serverId;
  const LocalHeldCart({
    required this.clientUuid,
    required this.storeId,
    this.registerId,
    required this.cashierId,
    this.customerId,
    this.name,
    required this.itemsJson,
    required this.total,
    required this.createdAt,
    this.expiresAt,
    this.serverId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_uuid'] = Variable<String>(clientUuid);
    map['store_id'] = Variable<String>(storeId);
    if (!nullToAbsent || registerId != null) {
      map['register_id'] = Variable<String>(registerId);
    }
    map['cashier_id'] = Variable<String>(cashierId);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['items_json'] = Variable<String>(itemsJson);
    map['total'] = Variable<double>(total);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    return map;
  }

  LocalHeldCartsCompanion toCompanion(bool nullToAbsent) {
    return LocalHeldCartsCompanion(
      clientUuid: Value(clientUuid),
      storeId: Value(storeId),
      registerId: registerId == null && nullToAbsent
          ? const Value.absent()
          : Value(registerId),
      cashierId: Value(cashierId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      itemsJson: Value(itemsJson),
      total: Value(total),
      createdAt: Value(createdAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory LocalHeldCart.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalHeldCart(
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      storeId: serializer.fromJson<String>(json['storeId']),
      registerId: serializer.fromJson<String?>(json['registerId']),
      cashierId: serializer.fromJson<String>(json['cashierId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      name: serializer.fromJson<String?>(json['name']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      total: serializer.fromJson<double>(json['total']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      serverId: serializer.fromJson<String?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientUuid': serializer.toJson<String>(clientUuid),
      'storeId': serializer.toJson<String>(storeId),
      'registerId': serializer.toJson<String?>(registerId),
      'cashierId': serializer.toJson<String>(cashierId),
      'customerId': serializer.toJson<String?>(customerId),
      'name': serializer.toJson<String?>(name),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'total': serializer.toJson<double>(total),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'serverId': serializer.toJson<String?>(serverId),
    };
  }

  LocalHeldCart copyWith({
    String? clientUuid,
    String? storeId,
    Value<String?> registerId = const Value.absent(),
    String? cashierId,
    Value<String?> customerId = const Value.absent(),
    Value<String?> name = const Value.absent(),
    String? itemsJson,
    double? total,
    DateTime? createdAt,
    Value<DateTime?> expiresAt = const Value.absent(),
    Value<String?> serverId = const Value.absent(),
  }) => LocalHeldCart(
    clientUuid: clientUuid ?? this.clientUuid,
    storeId: storeId ?? this.storeId,
    registerId: registerId.present ? registerId.value : this.registerId,
    cashierId: cashierId ?? this.cashierId,
    customerId: customerId.present ? customerId.value : this.customerId,
    name: name.present ? name.value : this.name,
    itemsJson: itemsJson ?? this.itemsJson,
    total: total ?? this.total,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    serverId: serverId.present ? serverId.value : this.serverId,
  );
  LocalHeldCart copyWithCompanion(LocalHeldCartsCompanion data) {
    return LocalHeldCart(
      clientUuid: data.clientUuid.present
          ? data.clientUuid.value
          : this.clientUuid,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      registerId: data.registerId.present
          ? data.registerId.value
          : this.registerId,
      cashierId: data.cashierId.present ? data.cashierId.value : this.cashierId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      name: data.name.present ? data.name.value : this.name,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      total: data.total.present ? data.total.value : this.total,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalHeldCart(')
          ..write('clientUuid: $clientUuid, ')
          ..write('storeId: $storeId, ')
          ..write('registerId: $registerId, ')
          ..write('cashierId: $cashierId, ')
          ..write('customerId: $customerId, ')
          ..write('name: $name, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('total: $total, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientUuid,
    storeId,
    registerId,
    cashierId,
    customerId,
    name,
    itemsJson,
    total,
    createdAt,
    expiresAt,
    serverId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalHeldCart &&
          other.clientUuid == this.clientUuid &&
          other.storeId == this.storeId &&
          other.registerId == this.registerId &&
          other.cashierId == this.cashierId &&
          other.customerId == this.customerId &&
          other.name == this.name &&
          other.itemsJson == this.itemsJson &&
          other.total == this.total &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt &&
          other.serverId == this.serverId);
}

class LocalHeldCartsCompanion extends UpdateCompanion<LocalHeldCart> {
  final Value<String> clientUuid;
  final Value<String> storeId;
  final Value<String?> registerId;
  final Value<String> cashierId;
  final Value<String?> customerId;
  final Value<String?> name;
  final Value<String> itemsJson;
  final Value<double> total;
  final Value<DateTime> createdAt;
  final Value<DateTime?> expiresAt;
  final Value<String?> serverId;
  final Value<int> rowid;
  const LocalHeldCartsCompanion({
    this.clientUuid = const Value.absent(),
    this.storeId = const Value.absent(),
    this.registerId = const Value.absent(),
    this.cashierId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.name = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.total = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.serverId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalHeldCartsCompanion.insert({
    required String clientUuid,
    required String storeId,
    this.registerId = const Value.absent(),
    required String cashierId,
    this.customerId = const Value.absent(),
    this.name = const Value.absent(),
    required String itemsJson,
    required double total,
    required DateTime createdAt,
    this.expiresAt = const Value.absent(),
    this.serverId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientUuid = Value(clientUuid),
       storeId = Value(storeId),
       cashierId = Value(cashierId),
       itemsJson = Value(itemsJson),
       total = Value(total),
       createdAt = Value(createdAt);
  static Insertable<LocalHeldCart> custom({
    Expression<String>? clientUuid,
    Expression<String>? storeId,
    Expression<String>? registerId,
    Expression<String>? cashierId,
    Expression<String>? customerId,
    Expression<String>? name,
    Expression<String>? itemsJson,
    Expression<double>? total,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
    Expression<String>? serverId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (storeId != null) 'store_id': storeId,
      if (registerId != null) 'register_id': registerId,
      if (cashierId != null) 'cashier_id': cashierId,
      if (customerId != null) 'customer_id': customerId,
      if (name != null) 'name': name,
      if (itemsJson != null) 'items_json': itemsJson,
      if (total != null) 'total': total,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (serverId != null) 'server_id': serverId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalHeldCartsCompanion copyWith({
    Value<String>? clientUuid,
    Value<String>? storeId,
    Value<String?>? registerId,
    Value<String>? cashierId,
    Value<String?>? customerId,
    Value<String?>? name,
    Value<String>? itemsJson,
    Value<double>? total,
    Value<DateTime>? createdAt,
    Value<DateTime?>? expiresAt,
    Value<String?>? serverId,
    Value<int>? rowid,
  }) {
    return LocalHeldCartsCompanion(
      clientUuid: clientUuid ?? this.clientUuid,
      storeId: storeId ?? this.storeId,
      registerId: registerId ?? this.registerId,
      cashierId: cashierId ?? this.cashierId,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      itemsJson: itemsJson ?? this.itemsJson,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      serverId: serverId ?? this.serverId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (registerId.present) {
      map['register_id'] = Variable<String>(registerId.value);
    }
    if (cashierId.present) {
      map['cashier_id'] = Variable<String>(cashierId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalHeldCartsCompanion(')
          ..write('clientUuid: $clientUuid, ')
          ..write('storeId: $storeId, ')
          ..write('registerId: $registerId, ')
          ..write('cashierId: $cashierId, ')
          ..write('customerId: $customerId, ')
          ..write('name: $name, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('total: $total, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('serverId: $serverId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalTransactionsTable extends LocalTransactions
    with TableInfo<$LocalTransactionsTable, LocalTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientUuidMeta = const VerificationMeta(
    'clientUuid',
  );
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
    'client_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionNumberMeta = const VerificationMeta(
    'transactionNumber',
  );
  @override
  late final GeneratedColumn<String> transactionNumber =
      GeneratedColumn<String>(
        'transaction_number',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registerIdMeta = const VerificationMeta(
    'registerId',
  );
  @override
  late final GeneratedColumn<String> registerId = GeneratedColumn<String>(
    'register_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cashierIdMeta = const VerificationMeta(
    'cashierId',
  );
  @override
  late final GeneratedColumn<String> cashierId = GeneratedColumn<String>(
    'cashier_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxAmountMeta = const VerificationMeta(
    'taxAmount',
  );
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
    'tax_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
    'discount_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentsJsonMeta = const VerificationMeta(
    'paymentsJson',
  );
  @override
  late final GeneratedColumn<String> paymentsJson = GeneratedColumn<String>(
    'payments_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxExemptionJsonMeta = const VerificationMeta(
    'taxExemptionJson',
  );
  @override
  late final GeneratedColumn<String> taxExemptionJson = GeneratedColumn<String>(
    'tax_exemption_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _returnTransactionIdMeta =
      const VerificationMeta('returnTransactionId');
  @override
  late final GeneratedColumn<String> returnTransactionId =
      GeneratedColumn<String>(
        'return_transaction_id',
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
  @override
  List<GeneratedColumn> get $columns => [
    clientUuid,
    serverId,
    transactionNumber,
    type,
    status,
    storeId,
    registerId,
    cashierId,
    customerId,
    sessionId,
    subtotal,
    taxAmount,
    discountAmount,
    totalAmount,
    itemsJson,
    paymentsJson,
    taxExemptionJson,
    notes,
    returnTransactionId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_uuid')) {
      context.handle(
        _clientUuidMeta,
        clientUuid.isAcceptableOrUnknown(data['client_uuid']!, _clientUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('transaction_number')) {
      context.handle(
        _transactionNumberMeta,
        transactionNumber.isAcceptableOrUnknown(
          data['transaction_number']!,
          _transactionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionNumberMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('register_id')) {
      context.handle(
        _registerIdMeta,
        registerId.isAcceptableOrUnknown(data['register_id']!, _registerIdMeta),
      );
    }
    if (data.containsKey('cashier_id')) {
      context.handle(
        _cashierIdMeta,
        cashierId.isAcceptableOrUnknown(data['cashier_id']!, _cashierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cashierIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('tax_amount')) {
      context.handle(
        _taxAmountMeta,
        taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta),
      );
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('payments_json')) {
      context.handle(
        _paymentsJsonMeta,
        paymentsJson.isAcceptableOrUnknown(
          data['payments_json']!,
          _paymentsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentsJsonMeta);
    }
    if (data.containsKey('tax_exemption_json')) {
      context.handle(
        _taxExemptionJsonMeta,
        taxExemptionJson.isAcceptableOrUnknown(
          data['tax_exemption_json']!,
          _taxExemptionJsonMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('return_transaction_id')) {
      context.handle(
        _returnTransactionIdMeta,
        returnTransactionId.isAcceptableOrUnknown(
          data['return_transaction_id']!,
          _returnTransactionIdMeta,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientUuid};
  @override
  LocalTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTransaction(
      clientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_uuid'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      transactionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_number'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      registerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}register_id'],
      ),
      cashierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier_id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      taxAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_amount'],
      )!,
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_amount'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
      paymentsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payments_json'],
      )!,
      taxExemptionJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_exemption_json'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      returnTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}return_transaction_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalTransactionsTable createAlias(String alias) {
    return $LocalTransactionsTable(attachedDatabase, alias);
  }
}

class LocalTransaction extends DataClass
    implements Insertable<LocalTransaction> {
  final String clientUuid;
  final String? serverId;
  final String transactionNumber;
  final String type;
  final String status;
  final String storeId;
  final String? registerId;
  final String cashierId;
  final String? customerId;
  final String? sessionId;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final String itemsJson;
  final String paymentsJson;
  final String? taxExemptionJson;
  final String? notes;
  final String? returnTransactionId;
  final DateTime createdAt;
  const LocalTransaction({
    required this.clientUuid,
    this.serverId,
    required this.transactionNumber,
    required this.type,
    required this.status,
    required this.storeId,
    this.registerId,
    required this.cashierId,
    this.customerId,
    this.sessionId,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.itemsJson,
    required this.paymentsJson,
    this.taxExemptionJson,
    this.notes,
    this.returnTransactionId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_uuid'] = Variable<String>(clientUuid);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['transaction_number'] = Variable<String>(transactionNumber);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    map['store_id'] = Variable<String>(storeId);
    if (!nullToAbsent || registerId != null) {
      map['register_id'] = Variable<String>(registerId);
    }
    map['cashier_id'] = Variable<String>(cashierId);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['subtotal'] = Variable<double>(subtotal);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['discount_amount'] = Variable<double>(discountAmount);
    map['total_amount'] = Variable<double>(totalAmount);
    map['items_json'] = Variable<String>(itemsJson);
    map['payments_json'] = Variable<String>(paymentsJson);
    if (!nullToAbsent || taxExemptionJson != null) {
      map['tax_exemption_json'] = Variable<String>(taxExemptionJson);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || returnTransactionId != null) {
      map['return_transaction_id'] = Variable<String>(returnTransactionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalTransactionsCompanion toCompanion(bool nullToAbsent) {
    return LocalTransactionsCompanion(
      clientUuid: Value(clientUuid),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      transactionNumber: Value(transactionNumber),
      type: Value(type),
      status: Value(status),
      storeId: Value(storeId),
      registerId: registerId == null && nullToAbsent
          ? const Value.absent()
          : Value(registerId),
      cashierId: Value(cashierId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      subtotal: Value(subtotal),
      taxAmount: Value(taxAmount),
      discountAmount: Value(discountAmount),
      totalAmount: Value(totalAmount),
      itemsJson: Value(itemsJson),
      paymentsJson: Value(paymentsJson),
      taxExemptionJson: taxExemptionJson == null && nullToAbsent
          ? const Value.absent()
          : Value(taxExemptionJson),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      returnTransactionId: returnTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(returnTransactionId),
      createdAt: Value(createdAt),
    );
  }

  factory LocalTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTransaction(
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      transactionNumber: serializer.fromJson<String>(json['transactionNumber']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      storeId: serializer.fromJson<String>(json['storeId']),
      registerId: serializer.fromJson<String?>(json['registerId']),
      cashierId: serializer.fromJson<String>(json['cashierId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      paymentsJson: serializer.fromJson<String>(json['paymentsJson']),
      taxExemptionJson: serializer.fromJson<String?>(json['taxExemptionJson']),
      notes: serializer.fromJson<String?>(json['notes']),
      returnTransactionId: serializer.fromJson<String?>(
        json['returnTransactionId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientUuid': serializer.toJson<String>(clientUuid),
      'serverId': serializer.toJson<String?>(serverId),
      'transactionNumber': serializer.toJson<String>(transactionNumber),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'storeId': serializer.toJson<String>(storeId),
      'registerId': serializer.toJson<String?>(registerId),
      'cashierId': serializer.toJson<String>(cashierId),
      'customerId': serializer.toJson<String?>(customerId),
      'sessionId': serializer.toJson<String?>(sessionId),
      'subtotal': serializer.toJson<double>(subtotal),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'paymentsJson': serializer.toJson<String>(paymentsJson),
      'taxExemptionJson': serializer.toJson<String?>(taxExemptionJson),
      'notes': serializer.toJson<String?>(notes),
      'returnTransactionId': serializer.toJson<String?>(returnTransactionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalTransaction copyWith({
    String? clientUuid,
    Value<String?> serverId = const Value.absent(),
    String? transactionNumber,
    String? type,
    String? status,
    String? storeId,
    Value<String?> registerId = const Value.absent(),
    String? cashierId,
    Value<String?> customerId = const Value.absent(),
    Value<String?> sessionId = const Value.absent(),
    double? subtotal,
    double? taxAmount,
    double? discountAmount,
    double? totalAmount,
    String? itemsJson,
    String? paymentsJson,
    Value<String?> taxExemptionJson = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> returnTransactionId = const Value.absent(),
    DateTime? createdAt,
  }) => LocalTransaction(
    clientUuid: clientUuid ?? this.clientUuid,
    serverId: serverId.present ? serverId.value : this.serverId,
    transactionNumber: transactionNumber ?? this.transactionNumber,
    type: type ?? this.type,
    status: status ?? this.status,
    storeId: storeId ?? this.storeId,
    registerId: registerId.present ? registerId.value : this.registerId,
    cashierId: cashierId ?? this.cashierId,
    customerId: customerId.present ? customerId.value : this.customerId,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    subtotal: subtotal ?? this.subtotal,
    taxAmount: taxAmount ?? this.taxAmount,
    discountAmount: discountAmount ?? this.discountAmount,
    totalAmount: totalAmount ?? this.totalAmount,
    itemsJson: itemsJson ?? this.itemsJson,
    paymentsJson: paymentsJson ?? this.paymentsJson,
    taxExemptionJson: taxExemptionJson.present
        ? taxExemptionJson.value
        : this.taxExemptionJson,
    notes: notes.present ? notes.value : this.notes,
    returnTransactionId: returnTransactionId.present
        ? returnTransactionId.value
        : this.returnTransactionId,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalTransaction copyWithCompanion(LocalTransactionsCompanion data) {
    return LocalTransaction(
      clientUuid: data.clientUuid.present
          ? data.clientUuid.value
          : this.clientUuid,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      transactionNumber: data.transactionNumber.present
          ? data.transactionNumber.value
          : this.transactionNumber,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      registerId: data.registerId.present
          ? data.registerId.value
          : this.registerId,
      cashierId: data.cashierId.present ? data.cashierId.value : this.cashierId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      paymentsJson: data.paymentsJson.present
          ? data.paymentsJson.value
          : this.paymentsJson,
      taxExemptionJson: data.taxExemptionJson.present
          ? data.taxExemptionJson.value
          : this.taxExemptionJson,
      notes: data.notes.present ? data.notes.value : this.notes,
      returnTransactionId: data.returnTransactionId.present
          ? data.returnTransactionId.value
          : this.returnTransactionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransaction(')
          ..write('clientUuid: $clientUuid, ')
          ..write('serverId: $serverId, ')
          ..write('transactionNumber: $transactionNumber, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('storeId: $storeId, ')
          ..write('registerId: $registerId, ')
          ..write('cashierId: $cashierId, ')
          ..write('customerId: $customerId, ')
          ..write('sessionId: $sessionId, ')
          ..write('subtotal: $subtotal, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('paymentsJson: $paymentsJson, ')
          ..write('taxExemptionJson: $taxExemptionJson, ')
          ..write('notes: $notes, ')
          ..write('returnTransactionId: $returnTransactionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientUuid,
    serverId,
    transactionNumber,
    type,
    status,
    storeId,
    registerId,
    cashierId,
    customerId,
    sessionId,
    subtotal,
    taxAmount,
    discountAmount,
    totalAmount,
    itemsJson,
    paymentsJson,
    taxExemptionJson,
    notes,
    returnTransactionId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTransaction &&
          other.clientUuid == this.clientUuid &&
          other.serverId == this.serverId &&
          other.transactionNumber == this.transactionNumber &&
          other.type == this.type &&
          other.status == this.status &&
          other.storeId == this.storeId &&
          other.registerId == this.registerId &&
          other.cashierId == this.cashierId &&
          other.customerId == this.customerId &&
          other.sessionId == this.sessionId &&
          other.subtotal == this.subtotal &&
          other.taxAmount == this.taxAmount &&
          other.discountAmount == this.discountAmount &&
          other.totalAmount == this.totalAmount &&
          other.itemsJson == this.itemsJson &&
          other.paymentsJson == this.paymentsJson &&
          other.taxExemptionJson == this.taxExemptionJson &&
          other.notes == this.notes &&
          other.returnTransactionId == this.returnTransactionId &&
          other.createdAt == this.createdAt);
}

class LocalTransactionsCompanion extends UpdateCompanion<LocalTransaction> {
  final Value<String> clientUuid;
  final Value<String?> serverId;
  final Value<String> transactionNumber;
  final Value<String> type;
  final Value<String> status;
  final Value<String> storeId;
  final Value<String?> registerId;
  final Value<String> cashierId;
  final Value<String?> customerId;
  final Value<String?> sessionId;
  final Value<double> subtotal;
  final Value<double> taxAmount;
  final Value<double> discountAmount;
  final Value<double> totalAmount;
  final Value<String> itemsJson;
  final Value<String> paymentsJson;
  final Value<String?> taxExemptionJson;
  final Value<String?> notes;
  final Value<String?> returnTransactionId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalTransactionsCompanion({
    this.clientUuid = const Value.absent(),
    this.serverId = const Value.absent(),
    this.transactionNumber = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.storeId = const Value.absent(),
    this.registerId = const Value.absent(),
    this.cashierId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.paymentsJson = const Value.absent(),
    this.taxExemptionJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.returnTransactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalTransactionsCompanion.insert({
    required String clientUuid,
    this.serverId = const Value.absent(),
    required String transactionNumber,
    required String type,
    required String status,
    required String storeId,
    this.registerId = const Value.absent(),
    required String cashierId,
    this.customerId = const Value.absent(),
    this.sessionId = const Value.absent(),
    required double subtotal,
    this.taxAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    required double totalAmount,
    required String itemsJson,
    required String paymentsJson,
    this.taxExemptionJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.returnTransactionId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : clientUuid = Value(clientUuid),
       transactionNumber = Value(transactionNumber),
       type = Value(type),
       status = Value(status),
       storeId = Value(storeId),
       cashierId = Value(cashierId),
       subtotal = Value(subtotal),
       totalAmount = Value(totalAmount),
       itemsJson = Value(itemsJson),
       paymentsJson = Value(paymentsJson),
       createdAt = Value(createdAt);
  static Insertable<LocalTransaction> custom({
    Expression<String>? clientUuid,
    Expression<String>? serverId,
    Expression<String>? transactionNumber,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? storeId,
    Expression<String>? registerId,
    Expression<String>? cashierId,
    Expression<String>? customerId,
    Expression<String>? sessionId,
    Expression<double>? subtotal,
    Expression<double>? taxAmount,
    Expression<double>? discountAmount,
    Expression<double>? totalAmount,
    Expression<String>? itemsJson,
    Expression<String>? paymentsJson,
    Expression<String>? taxExemptionJson,
    Expression<String>? notes,
    Expression<String>? returnTransactionId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (serverId != null) 'server_id': serverId,
      if (transactionNumber != null) 'transaction_number': transactionNumber,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (storeId != null) 'store_id': storeId,
      if (registerId != null) 'register_id': registerId,
      if (cashierId != null) 'cashier_id': cashierId,
      if (customerId != null) 'customer_id': customerId,
      if (sessionId != null) 'session_id': sessionId,
      if (subtotal != null) 'subtotal': subtotal,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (itemsJson != null) 'items_json': itemsJson,
      if (paymentsJson != null) 'payments_json': paymentsJson,
      if (taxExemptionJson != null) 'tax_exemption_json': taxExemptionJson,
      if (notes != null) 'notes': notes,
      if (returnTransactionId != null)
        'return_transaction_id': returnTransactionId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalTransactionsCompanion copyWith({
    Value<String>? clientUuid,
    Value<String?>? serverId,
    Value<String>? transactionNumber,
    Value<String>? type,
    Value<String>? status,
    Value<String>? storeId,
    Value<String?>? registerId,
    Value<String>? cashierId,
    Value<String?>? customerId,
    Value<String?>? sessionId,
    Value<double>? subtotal,
    Value<double>? taxAmount,
    Value<double>? discountAmount,
    Value<double>? totalAmount,
    Value<String>? itemsJson,
    Value<String>? paymentsJson,
    Value<String?>? taxExemptionJson,
    Value<String?>? notes,
    Value<String?>? returnTransactionId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalTransactionsCompanion(
      clientUuid: clientUuid ?? this.clientUuid,
      serverId: serverId ?? this.serverId,
      transactionNumber: transactionNumber ?? this.transactionNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      storeId: storeId ?? this.storeId,
      registerId: registerId ?? this.registerId,
      cashierId: cashierId ?? this.cashierId,
      customerId: customerId ?? this.customerId,
      sessionId: sessionId ?? this.sessionId,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      itemsJson: itemsJson ?? this.itemsJson,
      paymentsJson: paymentsJson ?? this.paymentsJson,
      taxExemptionJson: taxExemptionJson ?? this.taxExemptionJson,
      notes: notes ?? this.notes,
      returnTransactionId: returnTransactionId ?? this.returnTransactionId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (transactionNumber.present) {
      map['transaction_number'] = Variable<String>(transactionNumber.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (registerId.present) {
      map['register_id'] = Variable<String>(registerId.value);
    }
    if (cashierId.present) {
      map['cashier_id'] = Variable<String>(cashierId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (paymentsJson.present) {
      map['payments_json'] = Variable<String>(paymentsJson.value);
    }
    if (taxExemptionJson.present) {
      map['tax_exemption_json'] = Variable<String>(taxExemptionJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (returnTransactionId.present) {
      map['return_transaction_id'] = Variable<String>(
        returnTransactionId.value,
      );
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
    return (StringBuffer('LocalTransactionsCompanion(')
          ..write('clientUuid: $clientUuid, ')
          ..write('serverId: $serverId, ')
          ..write('transactionNumber: $transactionNumber, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('storeId: $storeId, ')
          ..write('registerId: $registerId, ')
          ..write('cashierId: $cashierId, ')
          ..write('customerId: $customerId, ')
          ..write('sessionId: $sessionId, ')
          ..write('subtotal: $subtotal, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('paymentsJson: $paymentsJson, ')
          ..write('taxExemptionJson: $taxExemptionJson, ')
          ..write('notes: $notes, ')
          ..write('returnTransactionId: $returnTransactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSyncQueueTable extends LocalSyncQueue
    with TableInfo<$LocalSyncQueueTable, LocalSyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSyncQueueTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _clientUuidMeta = const VerificationMeta(
    'clientUuid',
  );
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
    'client_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
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
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientUuid,
    kind,
    payloadJson,
    attempts,
    lastError,
    createdAt,
    nextAttemptAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_uuid')) {
      context.handle(
        _clientUuidMeta,
        clientUuid.isAcceptableOrUnknown(data['client_uuid']!, _clientUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
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
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextAttemptAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_uuid'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $LocalSyncQueueTable createAlias(String alias) {
    return $LocalSyncQueueTable(attachedDatabase, alias);
  }
}

class LocalSyncQueueData extends DataClass
    implements Insertable<LocalSyncQueueData> {
  final int id;
  final String clientUuid;
  final String kind;
  final String payloadJson;
  final int attempts;
  final String? lastError;
  final DateTime createdAt;
  final DateTime nextAttemptAt;
  final String status;
  const LocalSyncQueueData({
    required this.id,
    required this.clientUuid,
    required this.kind,
    required this.payloadJson,
    required this.attempts,
    this.lastError,
    required this.createdAt,
    required this.nextAttemptAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_uuid'] = Variable<String>(clientUuid);
    map['kind'] = Variable<String>(kind);
    map['payload_json'] = Variable<String>(payloadJson);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    map['status'] = Variable<String>(status);
    return map;
  }

  LocalSyncQueueCompanion toCompanion(bool nullToAbsent) {
    return LocalSyncQueueCompanion(
      id: Value(id),
      clientUuid: Value(clientUuid),
      kind: Value(kind),
      payloadJson: Value(payloadJson),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      nextAttemptAt: Value(nextAttemptAt),
      status: Value(status),
    );
  }

  factory LocalSyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      kind: serializer.fromJson<String>(json['kind']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      nextAttemptAt: serializer.fromJson<DateTime>(json['nextAttemptAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientUuid': serializer.toJson<String>(clientUuid),
      'kind': serializer.toJson<String>(kind),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'nextAttemptAt': serializer.toJson<DateTime>(nextAttemptAt),
      'status': serializer.toJson<String>(status),
    };
  }

  LocalSyncQueueData copyWith({
    int? id,
    String? clientUuid,
    String? kind,
    String? payloadJson,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
    DateTime? nextAttemptAt,
    String? status,
  }) => LocalSyncQueueData(
    id: id ?? this.id,
    clientUuid: clientUuid ?? this.clientUuid,
    kind: kind ?? this.kind,
    payloadJson: payloadJson ?? this.payloadJson,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
    status: status ?? this.status,
  );
  LocalSyncQueueData copyWithCompanion(LocalSyncQueueCompanion data) {
    return LocalSyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      clientUuid: data.clientUuid.present
          ? data.clientUuid.value
          : this.clientUuid,
      kind: data.kind.present ? data.kind.value : this.kind,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSyncQueueData(')
          ..write('id: $id, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('kind: $kind, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientUuid,
    kind,
    payloadJson,
    attempts,
    lastError,
    createdAt,
    nextAttemptAt,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSyncQueueData &&
          other.id == this.id &&
          other.clientUuid == this.clientUuid &&
          other.kind == this.kind &&
          other.payloadJson == this.payloadJson &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.status == this.status);
}

class LocalSyncQueueCompanion extends UpdateCompanion<LocalSyncQueueData> {
  final Value<int> id;
  final Value<String> clientUuid;
  final Value<String> kind;
  final Value<String> payloadJson;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime> nextAttemptAt;
  final Value<String> status;
  const LocalSyncQueueCompanion({
    this.id = const Value.absent(),
    this.clientUuid = const Value.absent(),
    this.kind = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.status = const Value.absent(),
  });
  LocalSyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String clientUuid,
    required String kind,
    required String payloadJson,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    required DateTime nextAttemptAt,
    this.status = const Value.absent(),
  }) : clientUuid = Value(clientUuid),
       kind = Value(kind),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt),
       nextAttemptAt = Value(nextAttemptAt);
  static Insertable<LocalSyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? clientUuid,
    Expression<String>? kind,
    Expression<String>? payloadJson,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (kind != null) 'kind': kind,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (status != null) 'status': status,
    });
  }

  LocalSyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? clientUuid,
    Value<String>? kind,
    Value<String>? payloadJson,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<DateTime>? nextAttemptAt,
    Value<String>? status,
  }) {
    return LocalSyncQueueCompanion(
      id: id ?? this.id,
      clientUuid: clientUuid ?? this.clientUuid,
      kind: kind ?? this.kind,
      payloadJson: payloadJson ?? this.payloadJson,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('kind: $kind, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $LocalCategoriesTable extends LocalCategories
    with TableInfo<$LocalCategoriesTable, LocalCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    parentId,
    name,
    nameAr,
    colorHex,
    iconName,
    sortOrder,
    isActive,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
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
  LocalCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      ),
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      ),
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalCategoriesTable createAlias(String alias) {
    return $LocalCategoriesTable(attachedDatabase, alias);
  }
}

class LocalCategory extends DataClass implements Insertable<LocalCategory> {
  final String id;
  final String? parentId;
  final String name;
  final String? nameAr;
  final String? colorHex;
  final String? iconName;
  final int sortOrder;
  final bool isActive;
  final DateTime updatedAt;
  const LocalCategory({
    required this.id,
    this.parentId,
    required this.name,
    this.nameAr,
    this.colorHex,
    this.iconName,
    required this.sortOrder,
    required this.isActive,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalCategoriesCompanion toCompanion(bool nullToAbsent) {
    return LocalCategoriesCompanion(
      id: Value(id),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      nameAr: nameAr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameAr),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCategory(
      id: serializer.fromJson<String>(json['id']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'parentId': serializer.toJson<String?>(parentId),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'colorHex': serializer.toJson<String?>(colorHex),
      'iconName': serializer.toJson<String?>(iconName),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalCategory copyWith({
    String? id,
    Value<String?> parentId = const Value.absent(),
    String? name,
    Value<String?> nameAr = const Value.absent(),
    Value<String?> colorHex = const Value.absent(),
    Value<String?> iconName = const Value.absent(),
    int? sortOrder,
    bool? isActive,
    DateTime? updatedAt,
  }) => LocalCategory(
    id: id ?? this.id,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    nameAr: nameAr.present ? nameAr.value : this.nameAr,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    iconName: iconName.present ? iconName.value : this.iconName,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalCategory copyWithCompanion(LocalCategoriesCompanion data) {
    return LocalCategory(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCategory(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('colorHex: $colorHex, ')
          ..write('iconName: $iconName, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    parentId,
    name,
    nameAr,
    colorHex,
    iconName,
    sortOrder,
    isActive,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCategory &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.colorHex == this.colorHex &&
          other.iconName == this.iconName &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt);
}

class LocalCategoriesCompanion extends UpdateCompanion<LocalCategory> {
  final Value<String> id;
  final Value<String?> parentId;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<String?> colorHex;
  final Value<String?> iconName;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalCategoriesCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.iconName = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCategoriesCompanion.insert({
    required String id,
    this.parentId = const Value.absent(),
    required String name,
    this.nameAr = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.iconName = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       updatedAt = Value(updatedAt);
  static Insertable<LocalCategory> custom({
    Expression<String>? id,
    Expression<String>? parentId,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<String>? colorHex,
    Expression<String>? iconName,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (colorHex != null) 'color_hex': colorHex,
      if (iconName != null) 'icon_name': iconName,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? parentId,
    Value<String>? name,
    Value<String?>? nameAr,
    Value<String?>? colorHex,
    Value<String?>? iconName,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalCategoriesCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      colorHex: colorHex ?? this.colorHex,
      iconName: iconName ?? this.iconName,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
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
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
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
    return (StringBuffer('LocalCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('colorHex: $colorHex, ')
          ..write('iconName: $iconName, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSuppliersTable extends LocalSuppliers
    with TableInfo<$LocalSuppliersTable, LocalSupplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSuppliersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _contactPersonMeta = const VerificationMeta(
    'contactPerson',
  );
  @override
  late final GeneratedColumn<String> contactPerson = GeneratedColumn<String>(
    'contact_person',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    contactPerson,
    phone,
    email,
    isActive,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSupplier> instance, {
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
    if (data.containsKey('contact_person')) {
      context.handle(
        _contactPersonMeta,
        contactPerson.isAcceptableOrUnknown(
          data['contact_person']!,
          _contactPersonMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
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
  LocalSupplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSupplier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      contactPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalSuppliersTable createAlias(String alias) {
    return $LocalSuppliersTable(attachedDatabase, alias);
  }
}

class LocalSupplier extends DataClass implements Insertable<LocalSupplier> {
  final String id;
  final String name;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final bool isActive;
  final DateTime updatedAt;
  const LocalSupplier({
    required this.id,
    required this.name,
    this.contactPerson,
    this.phone,
    this.email,
    required this.isActive,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || contactPerson != null) {
      map['contact_person'] = Variable<String>(contactPerson);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalSuppliersCompanion toCompanion(bool nullToAbsent) {
    return LocalSuppliersCompanion(
      id: Value(id),
      name: Value(name),
      contactPerson: contactPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPerson),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalSupplier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSupplier(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      contactPerson: serializer.fromJson<String?>(json['contactPerson']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'contactPerson': serializer.toJson<String?>(contactPerson),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'isActive': serializer.toJson<bool>(isActive),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalSupplier copyWith({
    String? id,
    String? name,
    Value<String?> contactPerson = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    bool? isActive,
    DateTime? updatedAt,
  }) => LocalSupplier(
    id: id ?? this.id,
    name: name ?? this.name,
    contactPerson: contactPerson.present
        ? contactPerson.value
        : this.contactPerson,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalSupplier copyWithCompanion(LocalSuppliersCompanion data) {
    return LocalSupplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      contactPerson: data.contactPerson.present
          ? data.contactPerson.value
          : this.contactPerson,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSupplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, contactPerson, phone, email, isActive, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSupplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.contactPerson == this.contactPerson &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt);
}

class LocalSuppliersCompanion extends UpdateCompanion<LocalSupplier> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> contactPerson;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<bool> isActive;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalSuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSuppliersCompanion.insert({
    required String id,
    required String name,
    this.contactPerson = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       updatedAt = Value(updatedAt);
  static Insertable<LocalSupplier> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? contactPerson,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<bool>? isActive,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (contactPerson != null) 'contact_person': contactPerson,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSuppliersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? contactPerson,
    Value<String?>? phone,
    Value<String?>? email,
    Value<bool>? isActive,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalSuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
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
    if (contactPerson.present) {
      map['contact_person'] = Variable<String>(contactPerson.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
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
    return (StringBuffer('LocalSuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalProductSuppliersTable extends LocalProductSuppliers
    with TableInfo<$LocalProductSuppliersTable, LocalProductSupplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProductSuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costPriceMeta = const VerificationMeta(
    'costPrice',
  );
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
    'cost_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierSkuMeta = const VerificationMeta(
    'supplierSku',
  );
  @override
  late final GeneratedColumn<String> supplierSku = GeneratedColumn<String>(
    'supplier_sku',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leadTimeDaysMeta = const VerificationMeta(
    'leadTimeDays',
  );
  @override
  late final GeneratedColumn<int> leadTimeDays = GeneratedColumn<int>(
    'lead_time_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPreferredMeta = const VerificationMeta(
    'isPreferred',
  );
  @override
  late final GeneratedColumn<bool> isPreferred = GeneratedColumn<bool>(
    'is_preferred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_preferred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    productId,
    supplierId,
    costPrice,
    supplierSku,
    leadTimeDays,
    isPreferred,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_product_suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProductSupplier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('cost_price')) {
      context.handle(
        _costPriceMeta,
        costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta),
      );
    }
    if (data.containsKey('supplier_sku')) {
      context.handle(
        _supplierSkuMeta,
        supplierSku.isAcceptableOrUnknown(
          data['supplier_sku']!,
          _supplierSkuMeta,
        ),
      );
    }
    if (data.containsKey('lead_time_days')) {
      context.handle(
        _leadTimeDaysMeta,
        leadTimeDays.isAcceptableOrUnknown(
          data['lead_time_days']!,
          _leadTimeDaysMeta,
        ),
      );
    }
    if (data.containsKey('is_preferred')) {
      context.handle(
        _isPreferredMeta,
        isPreferred.isAcceptableOrUnknown(
          data['is_preferred']!,
          _isPreferredMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId, supplierId};
  @override
  LocalProductSupplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProductSupplier(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      )!,
      costPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_price'],
      ),
      supplierSku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_sku'],
      ),
      leadTimeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lead_time_days'],
      ),
      isPreferred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_preferred'],
      )!,
    );
  }

  @override
  $LocalProductSuppliersTable createAlias(String alias) {
    return $LocalProductSuppliersTable(attachedDatabase, alias);
  }
}

class LocalProductSupplier extends DataClass
    implements Insertable<LocalProductSupplier> {
  final String productId;
  final String supplierId;
  final double? costPrice;
  final String? supplierSku;
  final int? leadTimeDays;
  final bool isPreferred;
  const LocalProductSupplier({
    required this.productId,
    required this.supplierId,
    this.costPrice,
    this.supplierSku,
    this.leadTimeDays,
    required this.isPreferred,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<String>(productId);
    map['supplier_id'] = Variable<String>(supplierId);
    if (!nullToAbsent || costPrice != null) {
      map['cost_price'] = Variable<double>(costPrice);
    }
    if (!nullToAbsent || supplierSku != null) {
      map['supplier_sku'] = Variable<String>(supplierSku);
    }
    if (!nullToAbsent || leadTimeDays != null) {
      map['lead_time_days'] = Variable<int>(leadTimeDays);
    }
    map['is_preferred'] = Variable<bool>(isPreferred);
    return map;
  }

  LocalProductSuppliersCompanion toCompanion(bool nullToAbsent) {
    return LocalProductSuppliersCompanion(
      productId: Value(productId),
      supplierId: Value(supplierId),
      costPrice: costPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(costPrice),
      supplierSku: supplierSku == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierSku),
      leadTimeDays: leadTimeDays == null && nullToAbsent
          ? const Value.absent()
          : Value(leadTimeDays),
      isPreferred: Value(isPreferred),
    );
  }

  factory LocalProductSupplier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProductSupplier(
      productId: serializer.fromJson<String>(json['productId']),
      supplierId: serializer.fromJson<String>(json['supplierId']),
      costPrice: serializer.fromJson<double?>(json['costPrice']),
      supplierSku: serializer.fromJson<String?>(json['supplierSku']),
      leadTimeDays: serializer.fromJson<int?>(json['leadTimeDays']),
      isPreferred: serializer.fromJson<bool>(json['isPreferred']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<String>(productId),
      'supplierId': serializer.toJson<String>(supplierId),
      'costPrice': serializer.toJson<double?>(costPrice),
      'supplierSku': serializer.toJson<String?>(supplierSku),
      'leadTimeDays': serializer.toJson<int?>(leadTimeDays),
      'isPreferred': serializer.toJson<bool>(isPreferred),
    };
  }

  LocalProductSupplier copyWith({
    String? productId,
    String? supplierId,
    Value<double?> costPrice = const Value.absent(),
    Value<String?> supplierSku = const Value.absent(),
    Value<int?> leadTimeDays = const Value.absent(),
    bool? isPreferred,
  }) => LocalProductSupplier(
    productId: productId ?? this.productId,
    supplierId: supplierId ?? this.supplierId,
    costPrice: costPrice.present ? costPrice.value : this.costPrice,
    supplierSku: supplierSku.present ? supplierSku.value : this.supplierSku,
    leadTimeDays: leadTimeDays.present ? leadTimeDays.value : this.leadTimeDays,
    isPreferred: isPreferred ?? this.isPreferred,
  );
  LocalProductSupplier copyWithCompanion(LocalProductSuppliersCompanion data) {
    return LocalProductSupplier(
      productId: data.productId.present ? data.productId.value : this.productId,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      supplierSku: data.supplierSku.present
          ? data.supplierSku.value
          : this.supplierSku,
      leadTimeDays: data.leadTimeDays.present
          ? data.leadTimeDays.value
          : this.leadTimeDays,
      isPreferred: data.isPreferred.present
          ? data.isPreferred.value
          : this.isPreferred,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductSupplier(')
          ..write('productId: $productId, ')
          ..write('supplierId: $supplierId, ')
          ..write('costPrice: $costPrice, ')
          ..write('supplierSku: $supplierSku, ')
          ..write('leadTimeDays: $leadTimeDays, ')
          ..write('isPreferred: $isPreferred')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productId,
    supplierId,
    costPrice,
    supplierSku,
    leadTimeDays,
    isPreferred,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProductSupplier &&
          other.productId == this.productId &&
          other.supplierId == this.supplierId &&
          other.costPrice == this.costPrice &&
          other.supplierSku == this.supplierSku &&
          other.leadTimeDays == this.leadTimeDays &&
          other.isPreferred == this.isPreferred);
}

class LocalProductSuppliersCompanion
    extends UpdateCompanion<LocalProductSupplier> {
  final Value<String> productId;
  final Value<String> supplierId;
  final Value<double?> costPrice;
  final Value<String?> supplierSku;
  final Value<int?> leadTimeDays;
  final Value<bool> isPreferred;
  final Value<int> rowid;
  const LocalProductSuppliersCompanion({
    this.productId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.supplierSku = const Value.absent(),
    this.leadTimeDays = const Value.absent(),
    this.isPreferred = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProductSuppliersCompanion.insert({
    required String productId,
    required String supplierId,
    this.costPrice = const Value.absent(),
    this.supplierSku = const Value.absent(),
    this.leadTimeDays = const Value.absent(),
    this.isPreferred = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : productId = Value(productId),
       supplierId = Value(supplierId);
  static Insertable<LocalProductSupplier> custom({
    Expression<String>? productId,
    Expression<String>? supplierId,
    Expression<double>? costPrice,
    Expression<String>? supplierSku,
    Expression<int>? leadTimeDays,
    Expression<bool>? isPreferred,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (costPrice != null) 'cost_price': costPrice,
      if (supplierSku != null) 'supplier_sku': supplierSku,
      if (leadTimeDays != null) 'lead_time_days': leadTimeDays,
      if (isPreferred != null) 'is_preferred': isPreferred,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProductSuppliersCompanion copyWith({
    Value<String>? productId,
    Value<String>? supplierId,
    Value<double?>? costPrice,
    Value<String?>? supplierSku,
    Value<int?>? leadTimeDays,
    Value<bool>? isPreferred,
    Value<int>? rowid,
  }) {
    return LocalProductSuppliersCompanion(
      productId: productId ?? this.productId,
      supplierId: supplierId ?? this.supplierId,
      costPrice: costPrice ?? this.costPrice,
      supplierSku: supplierSku ?? this.supplierSku,
      leadTimeDays: leadTimeDays ?? this.leadTimeDays,
      isPreferred: isPreferred ?? this.isPreferred,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (supplierSku.present) {
      map['supplier_sku'] = Variable<String>(supplierSku.value);
    }
    if (leadTimeDays.present) {
      map['lead_time_days'] = Variable<int>(leadTimeDays.value);
    }
    if (isPreferred.present) {
      map['is_preferred'] = Variable<bool>(isPreferred.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductSuppliersCompanion(')
          ..write('productId: $productId, ')
          ..write('supplierId: $supplierId, ')
          ..write('costPrice: $costPrice, ')
          ..write('supplierSku: $supplierSku, ')
          ..write('leadTimeDays: $leadTimeDays, ')
          ..write('isPreferred: $isPreferred, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalProductVariantsTable extends LocalProductVariants
    with TableInfo<$LocalProductVariantsTable, LocalProductVariant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProductVariantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _attributesJsonMeta = const VerificationMeta(
    'attributesJson',
  );
  @override
  late final GeneratedColumn<String> attributesJson = GeneratedColumn<String>(
    'attributes_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _priceDeltaMeta = const VerificationMeta(
    'priceDelta',
  );
  @override
  late final GeneratedColumn<double> priceDelta = GeneratedColumn<double>(
    'price_delta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _costPriceMeta = const VerificationMeta(
    'costPrice',
  );
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
    'cost_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    sku,
    barcode,
    name,
    attributesJson,
    priceDelta,
    costPrice,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_product_variants';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProductVariant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('attributes_json')) {
      context.handle(
        _attributesJsonMeta,
        attributesJson.isAcceptableOrUnknown(
          data['attributes_json']!,
          _attributesJsonMeta,
        ),
      );
    }
    if (data.containsKey('price_delta')) {
      context.handle(
        _priceDeltaMeta,
        priceDelta.isAcceptableOrUnknown(data['price_delta']!, _priceDeltaMeta),
      );
    }
    if (data.containsKey('cost_price')) {
      context.handle(
        _costPriceMeta,
        costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProductVariant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProductVariant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      attributesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attributes_json'],
      )!,
      priceDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_delta'],
      )!,
      costPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_price'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $LocalProductVariantsTable createAlias(String alias) {
    return $LocalProductVariantsTable(attachedDatabase, alias);
  }
}

class LocalProductVariant extends DataClass
    implements Insertable<LocalProductVariant> {
  final String id;
  final String productId;
  final String? sku;
  final String? barcode;
  final String name;
  final String attributesJson;
  final double priceDelta;
  final double? costPrice;
  final bool isActive;
  const LocalProductVariant({
    required this.id,
    required this.productId,
    this.sku,
    this.barcode,
    required this.name,
    required this.attributesJson,
    required this.priceDelta,
    this.costPrice,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['name'] = Variable<String>(name);
    map['attributes_json'] = Variable<String>(attributesJson);
    map['price_delta'] = Variable<double>(priceDelta);
    if (!nullToAbsent || costPrice != null) {
      map['cost_price'] = Variable<double>(costPrice);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  LocalProductVariantsCompanion toCompanion(bool nullToAbsent) {
    return LocalProductVariantsCompanion(
      id: Value(id),
      productId: Value(productId),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      name: Value(name),
      attributesJson: Value(attributesJson),
      priceDelta: Value(priceDelta),
      costPrice: costPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(costPrice),
      isActive: Value(isActive),
    );
  }

  factory LocalProductVariant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProductVariant(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      sku: serializer.fromJson<String?>(json['sku']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      name: serializer.fromJson<String>(json['name']),
      attributesJson: serializer.fromJson<String>(json['attributesJson']),
      priceDelta: serializer.fromJson<double>(json['priceDelta']),
      costPrice: serializer.fromJson<double?>(json['costPrice']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'sku': serializer.toJson<String?>(sku),
      'barcode': serializer.toJson<String?>(barcode),
      'name': serializer.toJson<String>(name),
      'attributesJson': serializer.toJson<String>(attributesJson),
      'priceDelta': serializer.toJson<double>(priceDelta),
      'costPrice': serializer.toJson<double?>(costPrice),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  LocalProductVariant copyWith({
    String? id,
    String? productId,
    Value<String?> sku = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    String? name,
    String? attributesJson,
    double? priceDelta,
    Value<double?> costPrice = const Value.absent(),
    bool? isActive,
  }) => LocalProductVariant(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    sku: sku.present ? sku.value : this.sku,
    barcode: barcode.present ? barcode.value : this.barcode,
    name: name ?? this.name,
    attributesJson: attributesJson ?? this.attributesJson,
    priceDelta: priceDelta ?? this.priceDelta,
    costPrice: costPrice.present ? costPrice.value : this.costPrice,
    isActive: isActive ?? this.isActive,
  );
  LocalProductVariant copyWithCompanion(LocalProductVariantsCompanion data) {
    return LocalProductVariant(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      sku: data.sku.present ? data.sku.value : this.sku,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      name: data.name.present ? data.name.value : this.name,
      attributesJson: data.attributesJson.present
          ? data.attributesJson.value
          : this.attributesJson,
      priceDelta: data.priceDelta.present
          ? data.priceDelta.value
          : this.priceDelta,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductVariant(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('attributesJson: $attributesJson, ')
          ..write('priceDelta: $priceDelta, ')
          ..write('costPrice: $costPrice, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    sku,
    barcode,
    name,
    attributesJson,
    priceDelta,
    costPrice,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProductVariant &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.sku == this.sku &&
          other.barcode == this.barcode &&
          other.name == this.name &&
          other.attributesJson == this.attributesJson &&
          other.priceDelta == this.priceDelta &&
          other.costPrice == this.costPrice &&
          other.isActive == this.isActive);
}

class LocalProductVariantsCompanion
    extends UpdateCompanion<LocalProductVariant> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String?> sku;
  final Value<String?> barcode;
  final Value<String> name;
  final Value<String> attributesJson;
  final Value<double> priceDelta;
  final Value<double?> costPrice;
  final Value<bool> isActive;
  final Value<int> rowid;
  const LocalProductVariantsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.name = const Value.absent(),
    this.attributesJson = const Value.absent(),
    this.priceDelta = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProductVariantsCompanion.insert({
    required String id,
    required String productId,
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    required String name,
    this.attributesJson = const Value.absent(),
    this.priceDelta = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       name = Value(name);
  static Insertable<LocalProductVariant> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? sku,
    Expression<String>? barcode,
    Expression<String>? name,
    Expression<String>? attributesJson,
    Expression<double>? priceDelta,
    Expression<double>? costPrice,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (sku != null) 'sku': sku,
      if (barcode != null) 'barcode': barcode,
      if (name != null) 'name': name,
      if (attributesJson != null) 'attributes_json': attributesJson,
      if (priceDelta != null) 'price_delta': priceDelta,
      if (costPrice != null) 'cost_price': costPrice,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProductVariantsCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String?>? sku,
    Value<String?>? barcode,
    Value<String>? name,
    Value<String>? attributesJson,
    Value<double>? priceDelta,
    Value<double?>? costPrice,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return LocalProductVariantsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      attributesJson: attributesJson ?? this.attributesJson,
      priceDelta: priceDelta ?? this.priceDelta,
      costPrice: costPrice ?? this.costPrice,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (attributesJson.present) {
      map['attributes_json'] = Variable<String>(attributesJson.value);
    }
    if (priceDelta.present) {
      map['price_delta'] = Variable<double>(priceDelta.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductVariantsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('attributesJson: $attributesJson, ')
          ..write('priceDelta: $priceDelta, ')
          ..write('costPrice: $costPrice, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalModifierGroupsTable extends LocalModifierGroups
    with TableInfo<$LocalModifierGroupsTable, LocalModifierGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalModifierGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
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
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minSelectMeta = const VerificationMeta(
    'minSelect',
  );
  @override
  late final GeneratedColumn<int> minSelect = GeneratedColumn<int>(
    'min_select',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _maxSelectMeta = const VerificationMeta(
    'maxSelect',
  );
  @override
  late final GeneratedColumn<int> maxSelect = GeneratedColumn<int>(
    'max_select',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRequiredMeta = const VerificationMeta(
    'isRequired',
  );
  @override
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>(
    'is_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_required" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    name,
    nameAr,
    minSelect,
    maxSelect,
    isRequired,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_modifier_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalModifierGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    }
    if (data.containsKey('min_select')) {
      context.handle(
        _minSelectMeta,
        minSelect.isAcceptableOrUnknown(data['min_select']!, _minSelectMeta),
      );
    }
    if (data.containsKey('max_select')) {
      context.handle(
        _maxSelectMeta,
        maxSelect.isAcceptableOrUnknown(data['max_select']!, _maxSelectMeta),
      );
    }
    if (data.containsKey('is_required')) {
      context.handle(
        _isRequiredMeta,
        isRequired.isAcceptableOrUnknown(data['is_required']!, _isRequiredMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalModifierGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalModifierGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      ),
      minSelect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_select'],
      )!,
      maxSelect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_select'],
      ),
      isRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_required'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $LocalModifierGroupsTable createAlias(String alias) {
    return $LocalModifierGroupsTable(attachedDatabase, alias);
  }
}

class LocalModifierGroup extends DataClass
    implements Insertable<LocalModifierGroup> {
  final String id;
  final String productId;
  final String name;
  final String? nameAr;
  final int minSelect;
  final int? maxSelect;
  final bool isRequired;
  final int sortOrder;
  const LocalModifierGroup({
    required this.id,
    required this.productId,
    required this.name,
    this.nameAr,
    required this.minSelect,
    this.maxSelect,
    required this.isRequired,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    map['min_select'] = Variable<int>(minSelect);
    if (!nullToAbsent || maxSelect != null) {
      map['max_select'] = Variable<int>(maxSelect);
    }
    map['is_required'] = Variable<bool>(isRequired);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  LocalModifierGroupsCompanion toCompanion(bool nullToAbsent) {
    return LocalModifierGroupsCompanion(
      id: Value(id),
      productId: Value(productId),
      name: Value(name),
      nameAr: nameAr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameAr),
      minSelect: Value(minSelect),
      maxSelect: maxSelect == null && nullToAbsent
          ? const Value.absent()
          : Value(maxSelect),
      isRequired: Value(isRequired),
      sortOrder: Value(sortOrder),
    );
  }

  factory LocalModifierGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalModifierGroup(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      minSelect: serializer.fromJson<int>(json['minSelect']),
      maxSelect: serializer.fromJson<int?>(json['maxSelect']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'minSelect': serializer.toJson<int>(minSelect),
      'maxSelect': serializer.toJson<int?>(maxSelect),
      'isRequired': serializer.toJson<bool>(isRequired),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  LocalModifierGroup copyWith({
    String? id,
    String? productId,
    String? name,
    Value<String?> nameAr = const Value.absent(),
    int? minSelect,
    Value<int?> maxSelect = const Value.absent(),
    bool? isRequired,
    int? sortOrder,
  }) => LocalModifierGroup(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    name: name ?? this.name,
    nameAr: nameAr.present ? nameAr.value : this.nameAr,
    minSelect: minSelect ?? this.minSelect,
    maxSelect: maxSelect.present ? maxSelect.value : this.maxSelect,
    isRequired: isRequired ?? this.isRequired,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  LocalModifierGroup copyWithCompanion(LocalModifierGroupsCompanion data) {
    return LocalModifierGroup(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      minSelect: data.minSelect.present ? data.minSelect.value : this.minSelect,
      maxSelect: data.maxSelect.present ? data.maxSelect.value : this.maxSelect,
      isRequired: data.isRequired.present
          ? data.isRequired.value
          : this.isRequired,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalModifierGroup(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('minSelect: $minSelect, ')
          ..write('maxSelect: $maxSelect, ')
          ..write('isRequired: $isRequired, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    name,
    nameAr,
    minSelect,
    maxSelect,
    isRequired,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalModifierGroup &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.minSelect == this.minSelect &&
          other.maxSelect == this.maxSelect &&
          other.isRequired == this.isRequired &&
          other.sortOrder == this.sortOrder);
}

class LocalModifierGroupsCompanion extends UpdateCompanion<LocalModifierGroup> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<int> minSelect;
  final Value<int?> maxSelect;
  final Value<bool> isRequired;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const LocalModifierGroupsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.minSelect = const Value.absent(),
    this.maxSelect = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalModifierGroupsCompanion.insert({
    required String id,
    required String productId,
    required String name,
    this.nameAr = const Value.absent(),
    this.minSelect = const Value.absent(),
    this.maxSelect = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       name = Value(name);
  static Insertable<LocalModifierGroup> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<int>? minSelect,
    Expression<int>? maxSelect,
    Expression<bool>? isRequired,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (minSelect != null) 'min_select': minSelect,
      if (maxSelect != null) 'max_select': maxSelect,
      if (isRequired != null) 'is_required': isRequired,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalModifierGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? name,
    Value<String?>? nameAr,
    Value<int>? minSelect,
    Value<int?>? maxSelect,
    Value<bool>? isRequired,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return LocalModifierGroupsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      minSelect: minSelect ?? this.minSelect,
      maxSelect: maxSelect ?? this.maxSelect,
      isRequired: isRequired ?? this.isRequired,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (minSelect.present) {
      map['min_select'] = Variable<int>(minSelect.value);
    }
    if (maxSelect.present) {
      map['max_select'] = Variable<int>(maxSelect.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalModifierGroupsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('minSelect: $minSelect, ')
          ..write('maxSelect: $maxSelect, ')
          ..write('isRequired: $isRequired, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalModifierOptionsTable extends LocalModifierOptions
    with TableInfo<$LocalModifierOptionsTable, LocalModifierOption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalModifierOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
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
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceDeltaMeta = const VerificationMeta(
    'priceDelta',
  );
  @override
  late final GeneratedColumn<double> priceDelta = GeneratedColumn<double>(
    'price_delta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    name,
    nameAr,
    priceDelta,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_modifier_options';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalModifierOption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    }
    if (data.containsKey('price_delta')) {
      context.handle(
        _priceDeltaMeta,
        priceDelta.isAcceptableOrUnknown(data['price_delta']!, _priceDeltaMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalModifierOption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalModifierOption(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      ),
      priceDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_delta'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $LocalModifierOptionsTable createAlias(String alias) {
    return $LocalModifierOptionsTable(attachedDatabase, alias);
  }
}

class LocalModifierOption extends DataClass
    implements Insertable<LocalModifierOption> {
  final String id;
  final String groupId;
  final String name;
  final String? nameAr;
  final double priceDelta;
  final int sortOrder;
  final bool isActive;
  const LocalModifierOption({
    required this.id,
    required this.groupId,
    required this.name,
    this.nameAr,
    required this.priceDelta,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    map['price_delta'] = Variable<double>(priceDelta);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  LocalModifierOptionsCompanion toCompanion(bool nullToAbsent) {
    return LocalModifierOptionsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      name: Value(name),
      nameAr: nameAr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameAr),
      priceDelta: Value(priceDelta),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory LocalModifierOption.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalModifierOption(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      priceDelta: serializer.fromJson<double>(json['priceDelta']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'priceDelta': serializer.toJson<double>(priceDelta),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  LocalModifierOption copyWith({
    String? id,
    String? groupId,
    String? name,
    Value<String?> nameAr = const Value.absent(),
    double? priceDelta,
    int? sortOrder,
    bool? isActive,
  }) => LocalModifierOption(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    name: name ?? this.name,
    nameAr: nameAr.present ? nameAr.value : this.nameAr,
    priceDelta: priceDelta ?? this.priceDelta,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  LocalModifierOption copyWithCompanion(LocalModifierOptionsCompanion data) {
    return LocalModifierOption(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      priceDelta: data.priceDelta.present
          ? data.priceDelta.value
          : this.priceDelta,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalModifierOption(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('priceDelta: $priceDelta, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, groupId, name, nameAr, priceDelta, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalModifierOption &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.priceDelta == this.priceDelta &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class LocalModifierOptionsCompanion
    extends UpdateCompanion<LocalModifierOption> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<double> priceDelta;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const LocalModifierOptionsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.priceDelta = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalModifierOptionsCompanion.insert({
    required String id,
    required String groupId,
    required String name,
    this.nameAr = const Value.absent(),
    this.priceDelta = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       name = Value(name);
  static Insertable<LocalModifierOption> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<double>? priceDelta,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (priceDelta != null) 'price_delta': priceDelta,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalModifierOptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? name,
    Value<String?>? nameAr,
    Value<double>? priceDelta,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return LocalModifierOptionsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      priceDelta: priceDelta ?? this.priceDelta,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (priceDelta.present) {
      map['price_delta'] = Variable<double>(priceDelta.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalModifierOptionsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('priceDelta: $priceDelta, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPromotionsTable extends LocalPromotions
    with TableInfo<$LocalPromotionsTable, LocalPromotion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPromotionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountValueMeta = const VerificationMeta(
    'discountValue',
  );
  @override
  late final GeneratedColumn<double> discountValue = GeneratedColumn<double>(
    'discount_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _buyQuantityMeta = const VerificationMeta(
    'buyQuantity',
  );
  @override
  late final GeneratedColumn<int> buyQuantity = GeneratedColumn<int>(
    'buy_quantity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _getQuantityMeta = const VerificationMeta(
    'getQuantity',
  );
  @override
  late final GeneratedColumn<int> getQuantity = GeneratedColumn<int>(
    'get_quantity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _getDiscountPercentMeta =
      const VerificationMeta('getDiscountPercent');
  @override
  late final GeneratedColumn<double> getDiscountPercent =
      GeneratedColumn<double>(
        'get_discount_percent',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _bundlePriceMeta = const VerificationMeta(
    'bundlePrice',
  );
  @override
  late final GeneratedColumn<double> bundlePrice = GeneratedColumn<double>(
    'bundle_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minOrderTotalMeta = const VerificationMeta(
    'minOrderTotal',
  );
  @override
  late final GeneratedColumn<double> minOrderTotal = GeneratedColumn<double>(
    'min_order_total',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minItemQuantityMeta = const VerificationMeta(
    'minItemQuantity',
  );
  @override
  late final GeneratedColumn<int> minItemQuantity = GeneratedColumn<int>(
    'min_item_quantity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
    'valid_from',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validToMeta = const VerificationMeta(
    'validTo',
  );
  @override
  late final GeneratedColumn<DateTime> validTo = GeneratedColumn<DateTime>(
    'valid_to',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeDaysJsonMeta = const VerificationMeta(
    'activeDaysJson',
  );
  @override
  late final GeneratedColumn<String> activeDaysJson = GeneratedColumn<String>(
    'active_days_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _activeTimeFromMeta = const VerificationMeta(
    'activeTimeFrom',
  );
  @override
  late final GeneratedColumn<String> activeTimeFrom = GeneratedColumn<String>(
    'active_time_from',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeTimeToMeta = const VerificationMeta(
    'activeTimeTo',
  );
  @override
  late final GeneratedColumn<String> activeTimeTo = GeneratedColumn<String>(
    'active_time_to',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxUsesMeta = const VerificationMeta(
    'maxUses',
  );
  @override
  late final GeneratedColumn<int> maxUses = GeneratedColumn<int>(
    'max_uses',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxUsesPerCustomerMeta =
      const VerificationMeta('maxUsesPerCustomer');
  @override
  late final GeneratedColumn<int> maxUsesPerCustomer = GeneratedColumn<int>(
    'max_uses_per_customer',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usageCountMeta = const VerificationMeta(
    'usageCount',
  );
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
    'usage_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isStackableMeta = const VerificationMeta(
    'isStackable',
  );
  @override
  late final GeneratedColumn<bool> isStackable = GeneratedColumn<bool>(
    'is_stackable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_stackable" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isCouponMeta = const VerificationMeta(
    'isCoupon',
  );
  @override
  late final GeneratedColumn<bool> isCoupon = GeneratedColumn<bool>(
    'is_coupon',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_coupon" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _productIdsJsonMeta = const VerificationMeta(
    'productIdsJson',
  );
  @override
  late final GeneratedColumn<String> productIdsJson = GeneratedColumn<String>(
    'product_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _categoryIdsJsonMeta = const VerificationMeta(
    'categoryIdsJson',
  );
  @override
  late final GeneratedColumn<String> categoryIdsJson = GeneratedColumn<String>(
    'category_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _customerGroupIdsJsonMeta =
      const VerificationMeta('customerGroupIdsJson');
  @override
  late final GeneratedColumn<String> customerGroupIdsJson =
      GeneratedColumn<String>(
        'customer_group_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _bundleProductsJsonMeta =
      const VerificationMeta('bundleProductsJson');
  @override
  late final GeneratedColumn<String> bundleProductsJson =
      GeneratedColumn<String>(
        'bundle_products_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
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
    type,
    discountValue,
    buyQuantity,
    getQuantity,
    getDiscountPercent,
    bundlePrice,
    minOrderTotal,
    minItemQuantity,
    validFrom,
    validTo,
    activeDaysJson,
    activeTimeFrom,
    activeTimeTo,
    maxUses,
    maxUsesPerCustomer,
    usageCount,
    isStackable,
    isActive,
    isCoupon,
    productIdsJson,
    categoryIdsJson,
    customerGroupIdsJson,
    bundleProductsJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_promotions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPromotion> instance, {
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
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('discount_value')) {
      context.handle(
        _discountValueMeta,
        discountValue.isAcceptableOrUnknown(
          data['discount_value']!,
          _discountValueMeta,
        ),
      );
    }
    if (data.containsKey('buy_quantity')) {
      context.handle(
        _buyQuantityMeta,
        buyQuantity.isAcceptableOrUnknown(
          data['buy_quantity']!,
          _buyQuantityMeta,
        ),
      );
    }
    if (data.containsKey('get_quantity')) {
      context.handle(
        _getQuantityMeta,
        getQuantity.isAcceptableOrUnknown(
          data['get_quantity']!,
          _getQuantityMeta,
        ),
      );
    }
    if (data.containsKey('get_discount_percent')) {
      context.handle(
        _getDiscountPercentMeta,
        getDiscountPercent.isAcceptableOrUnknown(
          data['get_discount_percent']!,
          _getDiscountPercentMeta,
        ),
      );
    }
    if (data.containsKey('bundle_price')) {
      context.handle(
        _bundlePriceMeta,
        bundlePrice.isAcceptableOrUnknown(
          data['bundle_price']!,
          _bundlePriceMeta,
        ),
      );
    }
    if (data.containsKey('min_order_total')) {
      context.handle(
        _minOrderTotalMeta,
        minOrderTotal.isAcceptableOrUnknown(
          data['min_order_total']!,
          _minOrderTotalMeta,
        ),
      );
    }
    if (data.containsKey('min_item_quantity')) {
      context.handle(
        _minItemQuantityMeta,
        minItemQuantity.isAcceptableOrUnknown(
          data['min_item_quantity']!,
          _minItemQuantityMeta,
        ),
      );
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    }
    if (data.containsKey('valid_to')) {
      context.handle(
        _validToMeta,
        validTo.isAcceptableOrUnknown(data['valid_to']!, _validToMeta),
      );
    }
    if (data.containsKey('active_days_json')) {
      context.handle(
        _activeDaysJsonMeta,
        activeDaysJson.isAcceptableOrUnknown(
          data['active_days_json']!,
          _activeDaysJsonMeta,
        ),
      );
    }
    if (data.containsKey('active_time_from')) {
      context.handle(
        _activeTimeFromMeta,
        activeTimeFrom.isAcceptableOrUnknown(
          data['active_time_from']!,
          _activeTimeFromMeta,
        ),
      );
    }
    if (data.containsKey('active_time_to')) {
      context.handle(
        _activeTimeToMeta,
        activeTimeTo.isAcceptableOrUnknown(
          data['active_time_to']!,
          _activeTimeToMeta,
        ),
      );
    }
    if (data.containsKey('max_uses')) {
      context.handle(
        _maxUsesMeta,
        maxUses.isAcceptableOrUnknown(data['max_uses']!, _maxUsesMeta),
      );
    }
    if (data.containsKey('max_uses_per_customer')) {
      context.handle(
        _maxUsesPerCustomerMeta,
        maxUsesPerCustomer.isAcceptableOrUnknown(
          data['max_uses_per_customer']!,
          _maxUsesPerCustomerMeta,
        ),
      );
    }
    if (data.containsKey('usage_count')) {
      context.handle(
        _usageCountMeta,
        usageCount.isAcceptableOrUnknown(data['usage_count']!, _usageCountMeta),
      );
    }
    if (data.containsKey('is_stackable')) {
      context.handle(
        _isStackableMeta,
        isStackable.isAcceptableOrUnknown(
          data['is_stackable']!,
          _isStackableMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_coupon')) {
      context.handle(
        _isCouponMeta,
        isCoupon.isAcceptableOrUnknown(data['is_coupon']!, _isCouponMeta),
      );
    }
    if (data.containsKey('product_ids_json')) {
      context.handle(
        _productIdsJsonMeta,
        productIdsJson.isAcceptableOrUnknown(
          data['product_ids_json']!,
          _productIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('category_ids_json')) {
      context.handle(
        _categoryIdsJsonMeta,
        categoryIdsJson.isAcceptableOrUnknown(
          data['category_ids_json']!,
          _categoryIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('customer_group_ids_json')) {
      context.handle(
        _customerGroupIdsJsonMeta,
        customerGroupIdsJson.isAcceptableOrUnknown(
          data['customer_group_ids_json']!,
          _customerGroupIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('bundle_products_json')) {
      context.handle(
        _bundleProductsJsonMeta,
        bundleProductsJson.isAcceptableOrUnknown(
          data['bundle_products_json']!,
          _bundleProductsJsonMeta,
        ),
      );
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
  LocalPromotion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPromotion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      discountValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_value'],
      ),
      buyQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}buy_quantity'],
      ),
      getQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}get_quantity'],
      ),
      getDiscountPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}get_discount_percent'],
      ),
      bundlePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bundle_price'],
      ),
      minOrderTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_order_total'],
      ),
      minItemQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_item_quantity'],
      ),
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_from'],
      ),
      validTo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_to'],
      ),
      activeDaysJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_days_json'],
      )!,
      activeTimeFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_time_from'],
      ),
      activeTimeTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_time_to'],
      ),
      maxUses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_uses'],
      ),
      maxUsesPerCustomer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_uses_per_customer'],
      ),
      usageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usage_count'],
      )!,
      isStackable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_stackable'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isCoupon: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_coupon'],
      )!,
      productIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_ids_json'],
      )!,
      categoryIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_ids_json'],
      )!,
      customerGroupIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_group_ids_json'],
      )!,
      bundleProductsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bundle_products_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalPromotionsTable createAlias(String alias) {
    return $LocalPromotionsTable(attachedDatabase, alias);
  }
}

class LocalPromotion extends DataClass implements Insertable<LocalPromotion> {
  final String id;
  final String name;
  final String type;
  final double? discountValue;
  final int? buyQuantity;
  final int? getQuantity;
  final double? getDiscountPercent;
  final double? bundlePrice;
  final double? minOrderTotal;
  final int? minItemQuantity;
  final DateTime? validFrom;
  final DateTime? validTo;
  final String activeDaysJson;
  final String? activeTimeFrom;
  final String? activeTimeTo;
  final int? maxUses;
  final int? maxUsesPerCustomer;
  final int usageCount;
  final bool isStackable;
  final bool isActive;
  final bool isCoupon;
  final String productIdsJson;
  final String categoryIdsJson;
  final String customerGroupIdsJson;
  final String bundleProductsJson;
  final DateTime updatedAt;
  const LocalPromotion({
    required this.id,
    required this.name,
    required this.type,
    this.discountValue,
    this.buyQuantity,
    this.getQuantity,
    this.getDiscountPercent,
    this.bundlePrice,
    this.minOrderTotal,
    this.minItemQuantity,
    this.validFrom,
    this.validTo,
    required this.activeDaysJson,
    this.activeTimeFrom,
    this.activeTimeTo,
    this.maxUses,
    this.maxUsesPerCustomer,
    required this.usageCount,
    required this.isStackable,
    required this.isActive,
    required this.isCoupon,
    required this.productIdsJson,
    required this.categoryIdsJson,
    required this.customerGroupIdsJson,
    required this.bundleProductsJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || discountValue != null) {
      map['discount_value'] = Variable<double>(discountValue);
    }
    if (!nullToAbsent || buyQuantity != null) {
      map['buy_quantity'] = Variable<int>(buyQuantity);
    }
    if (!nullToAbsent || getQuantity != null) {
      map['get_quantity'] = Variable<int>(getQuantity);
    }
    if (!nullToAbsent || getDiscountPercent != null) {
      map['get_discount_percent'] = Variable<double>(getDiscountPercent);
    }
    if (!nullToAbsent || bundlePrice != null) {
      map['bundle_price'] = Variable<double>(bundlePrice);
    }
    if (!nullToAbsent || minOrderTotal != null) {
      map['min_order_total'] = Variable<double>(minOrderTotal);
    }
    if (!nullToAbsent || minItemQuantity != null) {
      map['min_item_quantity'] = Variable<int>(minItemQuantity);
    }
    if (!nullToAbsent || validFrom != null) {
      map['valid_from'] = Variable<DateTime>(validFrom);
    }
    if (!nullToAbsent || validTo != null) {
      map['valid_to'] = Variable<DateTime>(validTo);
    }
    map['active_days_json'] = Variable<String>(activeDaysJson);
    if (!nullToAbsent || activeTimeFrom != null) {
      map['active_time_from'] = Variable<String>(activeTimeFrom);
    }
    if (!nullToAbsent || activeTimeTo != null) {
      map['active_time_to'] = Variable<String>(activeTimeTo);
    }
    if (!nullToAbsent || maxUses != null) {
      map['max_uses'] = Variable<int>(maxUses);
    }
    if (!nullToAbsent || maxUsesPerCustomer != null) {
      map['max_uses_per_customer'] = Variable<int>(maxUsesPerCustomer);
    }
    map['usage_count'] = Variable<int>(usageCount);
    map['is_stackable'] = Variable<bool>(isStackable);
    map['is_active'] = Variable<bool>(isActive);
    map['is_coupon'] = Variable<bool>(isCoupon);
    map['product_ids_json'] = Variable<String>(productIdsJson);
    map['category_ids_json'] = Variable<String>(categoryIdsJson);
    map['customer_group_ids_json'] = Variable<String>(customerGroupIdsJson);
    map['bundle_products_json'] = Variable<String>(bundleProductsJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalPromotionsCompanion toCompanion(bool nullToAbsent) {
    return LocalPromotionsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      discountValue: discountValue == null && nullToAbsent
          ? const Value.absent()
          : Value(discountValue),
      buyQuantity: buyQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(buyQuantity),
      getQuantity: getQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(getQuantity),
      getDiscountPercent: getDiscountPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(getDiscountPercent),
      bundlePrice: bundlePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(bundlePrice),
      minOrderTotal: minOrderTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(minOrderTotal),
      minItemQuantity: minItemQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(minItemQuantity),
      validFrom: validFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(validFrom),
      validTo: validTo == null && nullToAbsent
          ? const Value.absent()
          : Value(validTo),
      activeDaysJson: Value(activeDaysJson),
      activeTimeFrom: activeTimeFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(activeTimeFrom),
      activeTimeTo: activeTimeTo == null && nullToAbsent
          ? const Value.absent()
          : Value(activeTimeTo),
      maxUses: maxUses == null && nullToAbsent
          ? const Value.absent()
          : Value(maxUses),
      maxUsesPerCustomer: maxUsesPerCustomer == null && nullToAbsent
          ? const Value.absent()
          : Value(maxUsesPerCustomer),
      usageCount: Value(usageCount),
      isStackable: Value(isStackable),
      isActive: Value(isActive),
      isCoupon: Value(isCoupon),
      productIdsJson: Value(productIdsJson),
      categoryIdsJson: Value(categoryIdsJson),
      customerGroupIdsJson: Value(customerGroupIdsJson),
      bundleProductsJson: Value(bundleProductsJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalPromotion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPromotion(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      discountValue: serializer.fromJson<double?>(json['discountValue']),
      buyQuantity: serializer.fromJson<int?>(json['buyQuantity']),
      getQuantity: serializer.fromJson<int?>(json['getQuantity']),
      getDiscountPercent: serializer.fromJson<double?>(
        json['getDiscountPercent'],
      ),
      bundlePrice: serializer.fromJson<double?>(json['bundlePrice']),
      minOrderTotal: serializer.fromJson<double?>(json['minOrderTotal']),
      minItemQuantity: serializer.fromJson<int?>(json['minItemQuantity']),
      validFrom: serializer.fromJson<DateTime?>(json['validFrom']),
      validTo: serializer.fromJson<DateTime?>(json['validTo']),
      activeDaysJson: serializer.fromJson<String>(json['activeDaysJson']),
      activeTimeFrom: serializer.fromJson<String?>(json['activeTimeFrom']),
      activeTimeTo: serializer.fromJson<String?>(json['activeTimeTo']),
      maxUses: serializer.fromJson<int?>(json['maxUses']),
      maxUsesPerCustomer: serializer.fromJson<int?>(json['maxUsesPerCustomer']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      isStackable: serializer.fromJson<bool>(json['isStackable']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isCoupon: serializer.fromJson<bool>(json['isCoupon']),
      productIdsJson: serializer.fromJson<String>(json['productIdsJson']),
      categoryIdsJson: serializer.fromJson<String>(json['categoryIdsJson']),
      customerGroupIdsJson: serializer.fromJson<String>(
        json['customerGroupIdsJson'],
      ),
      bundleProductsJson: serializer.fromJson<String>(
        json['bundleProductsJson'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'discountValue': serializer.toJson<double?>(discountValue),
      'buyQuantity': serializer.toJson<int?>(buyQuantity),
      'getQuantity': serializer.toJson<int?>(getQuantity),
      'getDiscountPercent': serializer.toJson<double?>(getDiscountPercent),
      'bundlePrice': serializer.toJson<double?>(bundlePrice),
      'minOrderTotal': serializer.toJson<double?>(minOrderTotal),
      'minItemQuantity': serializer.toJson<int?>(minItemQuantity),
      'validFrom': serializer.toJson<DateTime?>(validFrom),
      'validTo': serializer.toJson<DateTime?>(validTo),
      'activeDaysJson': serializer.toJson<String>(activeDaysJson),
      'activeTimeFrom': serializer.toJson<String?>(activeTimeFrom),
      'activeTimeTo': serializer.toJson<String?>(activeTimeTo),
      'maxUses': serializer.toJson<int?>(maxUses),
      'maxUsesPerCustomer': serializer.toJson<int?>(maxUsesPerCustomer),
      'usageCount': serializer.toJson<int>(usageCount),
      'isStackable': serializer.toJson<bool>(isStackable),
      'isActive': serializer.toJson<bool>(isActive),
      'isCoupon': serializer.toJson<bool>(isCoupon),
      'productIdsJson': serializer.toJson<String>(productIdsJson),
      'categoryIdsJson': serializer.toJson<String>(categoryIdsJson),
      'customerGroupIdsJson': serializer.toJson<String>(customerGroupIdsJson),
      'bundleProductsJson': serializer.toJson<String>(bundleProductsJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalPromotion copyWith({
    String? id,
    String? name,
    String? type,
    Value<double?> discountValue = const Value.absent(),
    Value<int?> buyQuantity = const Value.absent(),
    Value<int?> getQuantity = const Value.absent(),
    Value<double?> getDiscountPercent = const Value.absent(),
    Value<double?> bundlePrice = const Value.absent(),
    Value<double?> minOrderTotal = const Value.absent(),
    Value<int?> minItemQuantity = const Value.absent(),
    Value<DateTime?> validFrom = const Value.absent(),
    Value<DateTime?> validTo = const Value.absent(),
    String? activeDaysJson,
    Value<String?> activeTimeFrom = const Value.absent(),
    Value<String?> activeTimeTo = const Value.absent(),
    Value<int?> maxUses = const Value.absent(),
    Value<int?> maxUsesPerCustomer = const Value.absent(),
    int? usageCount,
    bool? isStackable,
    bool? isActive,
    bool? isCoupon,
    String? productIdsJson,
    String? categoryIdsJson,
    String? customerGroupIdsJson,
    String? bundleProductsJson,
    DateTime? updatedAt,
  }) => LocalPromotion(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    discountValue: discountValue.present
        ? discountValue.value
        : this.discountValue,
    buyQuantity: buyQuantity.present ? buyQuantity.value : this.buyQuantity,
    getQuantity: getQuantity.present ? getQuantity.value : this.getQuantity,
    getDiscountPercent: getDiscountPercent.present
        ? getDiscountPercent.value
        : this.getDiscountPercent,
    bundlePrice: bundlePrice.present ? bundlePrice.value : this.bundlePrice,
    minOrderTotal: minOrderTotal.present
        ? minOrderTotal.value
        : this.minOrderTotal,
    minItemQuantity: minItemQuantity.present
        ? minItemQuantity.value
        : this.minItemQuantity,
    validFrom: validFrom.present ? validFrom.value : this.validFrom,
    validTo: validTo.present ? validTo.value : this.validTo,
    activeDaysJson: activeDaysJson ?? this.activeDaysJson,
    activeTimeFrom: activeTimeFrom.present
        ? activeTimeFrom.value
        : this.activeTimeFrom,
    activeTimeTo: activeTimeTo.present ? activeTimeTo.value : this.activeTimeTo,
    maxUses: maxUses.present ? maxUses.value : this.maxUses,
    maxUsesPerCustomer: maxUsesPerCustomer.present
        ? maxUsesPerCustomer.value
        : this.maxUsesPerCustomer,
    usageCount: usageCount ?? this.usageCount,
    isStackable: isStackable ?? this.isStackable,
    isActive: isActive ?? this.isActive,
    isCoupon: isCoupon ?? this.isCoupon,
    productIdsJson: productIdsJson ?? this.productIdsJson,
    categoryIdsJson: categoryIdsJson ?? this.categoryIdsJson,
    customerGroupIdsJson: customerGroupIdsJson ?? this.customerGroupIdsJson,
    bundleProductsJson: bundleProductsJson ?? this.bundleProductsJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalPromotion copyWithCompanion(LocalPromotionsCompanion data) {
    return LocalPromotion(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      discountValue: data.discountValue.present
          ? data.discountValue.value
          : this.discountValue,
      buyQuantity: data.buyQuantity.present
          ? data.buyQuantity.value
          : this.buyQuantity,
      getQuantity: data.getQuantity.present
          ? data.getQuantity.value
          : this.getQuantity,
      getDiscountPercent: data.getDiscountPercent.present
          ? data.getDiscountPercent.value
          : this.getDiscountPercent,
      bundlePrice: data.bundlePrice.present
          ? data.bundlePrice.value
          : this.bundlePrice,
      minOrderTotal: data.minOrderTotal.present
          ? data.minOrderTotal.value
          : this.minOrderTotal,
      minItemQuantity: data.minItemQuantity.present
          ? data.minItemQuantity.value
          : this.minItemQuantity,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validTo: data.validTo.present ? data.validTo.value : this.validTo,
      activeDaysJson: data.activeDaysJson.present
          ? data.activeDaysJson.value
          : this.activeDaysJson,
      activeTimeFrom: data.activeTimeFrom.present
          ? data.activeTimeFrom.value
          : this.activeTimeFrom,
      activeTimeTo: data.activeTimeTo.present
          ? data.activeTimeTo.value
          : this.activeTimeTo,
      maxUses: data.maxUses.present ? data.maxUses.value : this.maxUses,
      maxUsesPerCustomer: data.maxUsesPerCustomer.present
          ? data.maxUsesPerCustomer.value
          : this.maxUsesPerCustomer,
      usageCount: data.usageCount.present
          ? data.usageCount.value
          : this.usageCount,
      isStackable: data.isStackable.present
          ? data.isStackable.value
          : this.isStackable,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isCoupon: data.isCoupon.present ? data.isCoupon.value : this.isCoupon,
      productIdsJson: data.productIdsJson.present
          ? data.productIdsJson.value
          : this.productIdsJson,
      categoryIdsJson: data.categoryIdsJson.present
          ? data.categoryIdsJson.value
          : this.categoryIdsJson,
      customerGroupIdsJson: data.customerGroupIdsJson.present
          ? data.customerGroupIdsJson.value
          : this.customerGroupIdsJson,
      bundleProductsJson: data.bundleProductsJson.present
          ? data.bundleProductsJson.value
          : this.bundleProductsJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPromotion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('discountValue: $discountValue, ')
          ..write('buyQuantity: $buyQuantity, ')
          ..write('getQuantity: $getQuantity, ')
          ..write('getDiscountPercent: $getDiscountPercent, ')
          ..write('bundlePrice: $bundlePrice, ')
          ..write('minOrderTotal: $minOrderTotal, ')
          ..write('minItemQuantity: $minItemQuantity, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('activeDaysJson: $activeDaysJson, ')
          ..write('activeTimeFrom: $activeTimeFrom, ')
          ..write('activeTimeTo: $activeTimeTo, ')
          ..write('maxUses: $maxUses, ')
          ..write('maxUsesPerCustomer: $maxUsesPerCustomer, ')
          ..write('usageCount: $usageCount, ')
          ..write('isStackable: $isStackable, ')
          ..write('isActive: $isActive, ')
          ..write('isCoupon: $isCoupon, ')
          ..write('productIdsJson: $productIdsJson, ')
          ..write('categoryIdsJson: $categoryIdsJson, ')
          ..write('customerGroupIdsJson: $customerGroupIdsJson, ')
          ..write('bundleProductsJson: $bundleProductsJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    type,
    discountValue,
    buyQuantity,
    getQuantity,
    getDiscountPercent,
    bundlePrice,
    minOrderTotal,
    minItemQuantity,
    validFrom,
    validTo,
    activeDaysJson,
    activeTimeFrom,
    activeTimeTo,
    maxUses,
    maxUsesPerCustomer,
    usageCount,
    isStackable,
    isActive,
    isCoupon,
    productIdsJson,
    categoryIdsJson,
    customerGroupIdsJson,
    bundleProductsJson,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPromotion &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.discountValue == this.discountValue &&
          other.buyQuantity == this.buyQuantity &&
          other.getQuantity == this.getQuantity &&
          other.getDiscountPercent == this.getDiscountPercent &&
          other.bundlePrice == this.bundlePrice &&
          other.minOrderTotal == this.minOrderTotal &&
          other.minItemQuantity == this.minItemQuantity &&
          other.validFrom == this.validFrom &&
          other.validTo == this.validTo &&
          other.activeDaysJson == this.activeDaysJson &&
          other.activeTimeFrom == this.activeTimeFrom &&
          other.activeTimeTo == this.activeTimeTo &&
          other.maxUses == this.maxUses &&
          other.maxUsesPerCustomer == this.maxUsesPerCustomer &&
          other.usageCount == this.usageCount &&
          other.isStackable == this.isStackable &&
          other.isActive == this.isActive &&
          other.isCoupon == this.isCoupon &&
          other.productIdsJson == this.productIdsJson &&
          other.categoryIdsJson == this.categoryIdsJson &&
          other.customerGroupIdsJson == this.customerGroupIdsJson &&
          other.bundleProductsJson == this.bundleProductsJson &&
          other.updatedAt == this.updatedAt);
}

class LocalPromotionsCompanion extends UpdateCompanion<LocalPromotion> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<double?> discountValue;
  final Value<int?> buyQuantity;
  final Value<int?> getQuantity;
  final Value<double?> getDiscountPercent;
  final Value<double?> bundlePrice;
  final Value<double?> minOrderTotal;
  final Value<int?> minItemQuantity;
  final Value<DateTime?> validFrom;
  final Value<DateTime?> validTo;
  final Value<String> activeDaysJson;
  final Value<String?> activeTimeFrom;
  final Value<String?> activeTimeTo;
  final Value<int?> maxUses;
  final Value<int?> maxUsesPerCustomer;
  final Value<int> usageCount;
  final Value<bool> isStackable;
  final Value<bool> isActive;
  final Value<bool> isCoupon;
  final Value<String> productIdsJson;
  final Value<String> categoryIdsJson;
  final Value<String> customerGroupIdsJson;
  final Value<String> bundleProductsJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalPromotionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.buyQuantity = const Value.absent(),
    this.getQuantity = const Value.absent(),
    this.getDiscountPercent = const Value.absent(),
    this.bundlePrice = const Value.absent(),
    this.minOrderTotal = const Value.absent(),
    this.minItemQuantity = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validTo = const Value.absent(),
    this.activeDaysJson = const Value.absent(),
    this.activeTimeFrom = const Value.absent(),
    this.activeTimeTo = const Value.absent(),
    this.maxUses = const Value.absent(),
    this.maxUsesPerCustomer = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.isStackable = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isCoupon = const Value.absent(),
    this.productIdsJson = const Value.absent(),
    this.categoryIdsJson = const Value.absent(),
    this.customerGroupIdsJson = const Value.absent(),
    this.bundleProductsJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPromotionsCompanion.insert({
    required String id,
    required String name,
    required String type,
    this.discountValue = const Value.absent(),
    this.buyQuantity = const Value.absent(),
    this.getQuantity = const Value.absent(),
    this.getDiscountPercent = const Value.absent(),
    this.bundlePrice = const Value.absent(),
    this.minOrderTotal = const Value.absent(),
    this.minItemQuantity = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validTo = const Value.absent(),
    this.activeDaysJson = const Value.absent(),
    this.activeTimeFrom = const Value.absent(),
    this.activeTimeTo = const Value.absent(),
    this.maxUses = const Value.absent(),
    this.maxUsesPerCustomer = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.isStackable = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isCoupon = const Value.absent(),
    this.productIdsJson = const Value.absent(),
    this.categoryIdsJson = const Value.absent(),
    this.customerGroupIdsJson = const Value.absent(),
    this.bundleProductsJson = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       updatedAt = Value(updatedAt);
  static Insertable<LocalPromotion> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? discountValue,
    Expression<int>? buyQuantity,
    Expression<int>? getQuantity,
    Expression<double>? getDiscountPercent,
    Expression<double>? bundlePrice,
    Expression<double>? minOrderTotal,
    Expression<int>? minItemQuantity,
    Expression<DateTime>? validFrom,
    Expression<DateTime>? validTo,
    Expression<String>? activeDaysJson,
    Expression<String>? activeTimeFrom,
    Expression<String>? activeTimeTo,
    Expression<int>? maxUses,
    Expression<int>? maxUsesPerCustomer,
    Expression<int>? usageCount,
    Expression<bool>? isStackable,
    Expression<bool>? isActive,
    Expression<bool>? isCoupon,
    Expression<String>? productIdsJson,
    Expression<String>? categoryIdsJson,
    Expression<String>? customerGroupIdsJson,
    Expression<String>? bundleProductsJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (discountValue != null) 'discount_value': discountValue,
      if (buyQuantity != null) 'buy_quantity': buyQuantity,
      if (getQuantity != null) 'get_quantity': getQuantity,
      if (getDiscountPercent != null)
        'get_discount_percent': getDiscountPercent,
      if (bundlePrice != null) 'bundle_price': bundlePrice,
      if (minOrderTotal != null) 'min_order_total': minOrderTotal,
      if (minItemQuantity != null) 'min_item_quantity': minItemQuantity,
      if (validFrom != null) 'valid_from': validFrom,
      if (validTo != null) 'valid_to': validTo,
      if (activeDaysJson != null) 'active_days_json': activeDaysJson,
      if (activeTimeFrom != null) 'active_time_from': activeTimeFrom,
      if (activeTimeTo != null) 'active_time_to': activeTimeTo,
      if (maxUses != null) 'max_uses': maxUses,
      if (maxUsesPerCustomer != null)
        'max_uses_per_customer': maxUsesPerCustomer,
      if (usageCount != null) 'usage_count': usageCount,
      if (isStackable != null) 'is_stackable': isStackable,
      if (isActive != null) 'is_active': isActive,
      if (isCoupon != null) 'is_coupon': isCoupon,
      if (productIdsJson != null) 'product_ids_json': productIdsJson,
      if (categoryIdsJson != null) 'category_ids_json': categoryIdsJson,
      if (customerGroupIdsJson != null)
        'customer_group_ids_json': customerGroupIdsJson,
      if (bundleProductsJson != null)
        'bundle_products_json': bundleProductsJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPromotionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<double?>? discountValue,
    Value<int?>? buyQuantity,
    Value<int?>? getQuantity,
    Value<double?>? getDiscountPercent,
    Value<double?>? bundlePrice,
    Value<double?>? minOrderTotal,
    Value<int?>? minItemQuantity,
    Value<DateTime?>? validFrom,
    Value<DateTime?>? validTo,
    Value<String>? activeDaysJson,
    Value<String?>? activeTimeFrom,
    Value<String?>? activeTimeTo,
    Value<int?>? maxUses,
    Value<int?>? maxUsesPerCustomer,
    Value<int>? usageCount,
    Value<bool>? isStackable,
    Value<bool>? isActive,
    Value<bool>? isCoupon,
    Value<String>? productIdsJson,
    Value<String>? categoryIdsJson,
    Value<String>? customerGroupIdsJson,
    Value<String>? bundleProductsJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalPromotionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      discountValue: discountValue ?? this.discountValue,
      buyQuantity: buyQuantity ?? this.buyQuantity,
      getQuantity: getQuantity ?? this.getQuantity,
      getDiscountPercent: getDiscountPercent ?? this.getDiscountPercent,
      bundlePrice: bundlePrice ?? this.bundlePrice,
      minOrderTotal: minOrderTotal ?? this.minOrderTotal,
      minItemQuantity: minItemQuantity ?? this.minItemQuantity,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      activeDaysJson: activeDaysJson ?? this.activeDaysJson,
      activeTimeFrom: activeTimeFrom ?? this.activeTimeFrom,
      activeTimeTo: activeTimeTo ?? this.activeTimeTo,
      maxUses: maxUses ?? this.maxUses,
      maxUsesPerCustomer: maxUsesPerCustomer ?? this.maxUsesPerCustomer,
      usageCount: usageCount ?? this.usageCount,
      isStackable: isStackable ?? this.isStackable,
      isActive: isActive ?? this.isActive,
      isCoupon: isCoupon ?? this.isCoupon,
      productIdsJson: productIdsJson ?? this.productIdsJson,
      categoryIdsJson: categoryIdsJson ?? this.categoryIdsJson,
      customerGroupIdsJson: customerGroupIdsJson ?? this.customerGroupIdsJson,
      bundleProductsJson: bundleProductsJson ?? this.bundleProductsJson,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (discountValue.present) {
      map['discount_value'] = Variable<double>(discountValue.value);
    }
    if (buyQuantity.present) {
      map['buy_quantity'] = Variable<int>(buyQuantity.value);
    }
    if (getQuantity.present) {
      map['get_quantity'] = Variable<int>(getQuantity.value);
    }
    if (getDiscountPercent.present) {
      map['get_discount_percent'] = Variable<double>(getDiscountPercent.value);
    }
    if (bundlePrice.present) {
      map['bundle_price'] = Variable<double>(bundlePrice.value);
    }
    if (minOrderTotal.present) {
      map['min_order_total'] = Variable<double>(minOrderTotal.value);
    }
    if (minItemQuantity.present) {
      map['min_item_quantity'] = Variable<int>(minItemQuantity.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<DateTime>(validFrom.value);
    }
    if (validTo.present) {
      map['valid_to'] = Variable<DateTime>(validTo.value);
    }
    if (activeDaysJson.present) {
      map['active_days_json'] = Variable<String>(activeDaysJson.value);
    }
    if (activeTimeFrom.present) {
      map['active_time_from'] = Variable<String>(activeTimeFrom.value);
    }
    if (activeTimeTo.present) {
      map['active_time_to'] = Variable<String>(activeTimeTo.value);
    }
    if (maxUses.present) {
      map['max_uses'] = Variable<int>(maxUses.value);
    }
    if (maxUsesPerCustomer.present) {
      map['max_uses_per_customer'] = Variable<int>(maxUsesPerCustomer.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (isStackable.present) {
      map['is_stackable'] = Variable<bool>(isStackable.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isCoupon.present) {
      map['is_coupon'] = Variable<bool>(isCoupon.value);
    }
    if (productIdsJson.present) {
      map['product_ids_json'] = Variable<String>(productIdsJson.value);
    }
    if (categoryIdsJson.present) {
      map['category_ids_json'] = Variable<String>(categoryIdsJson.value);
    }
    if (customerGroupIdsJson.present) {
      map['customer_group_ids_json'] = Variable<String>(
        customerGroupIdsJson.value,
      );
    }
    if (bundleProductsJson.present) {
      map['bundle_products_json'] = Variable<String>(bundleProductsJson.value);
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
    return (StringBuffer('LocalPromotionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('discountValue: $discountValue, ')
          ..write('buyQuantity: $buyQuantity, ')
          ..write('getQuantity: $getQuantity, ')
          ..write('getDiscountPercent: $getDiscountPercent, ')
          ..write('bundlePrice: $bundlePrice, ')
          ..write('minOrderTotal: $minOrderTotal, ')
          ..write('minItemQuantity: $minItemQuantity, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('activeDaysJson: $activeDaysJson, ')
          ..write('activeTimeFrom: $activeTimeFrom, ')
          ..write('activeTimeTo: $activeTimeTo, ')
          ..write('maxUses: $maxUses, ')
          ..write('maxUsesPerCustomer: $maxUsesPerCustomer, ')
          ..write('usageCount: $usageCount, ')
          ..write('isStackable: $isStackable, ')
          ..write('isActive: $isActive, ')
          ..write('isCoupon: $isCoupon, ')
          ..write('productIdsJson: $productIdsJson, ')
          ..write('categoryIdsJson: $categoryIdsJson, ')
          ..write('customerGroupIdsJson: $customerGroupIdsJson, ')
          ..write('bundleProductsJson: $bundleProductsJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCouponCodesTable extends LocalCouponCodes
    with TableInfo<$LocalCouponCodesTable, LocalCouponCode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCouponCodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promotionIdMeta = const VerificationMeta(
    'promotionId',
  );
  @override
  late final GeneratedColumn<String> promotionId = GeneratedColumn<String>(
    'promotion_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxUsesMeta = const VerificationMeta(
    'maxUses',
  );
  @override
  late final GeneratedColumn<int> maxUses = GeneratedColumn<int>(
    'max_uses',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usageCountMeta = const VerificationMeta(
    'usageCount',
  );
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
    'usage_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    promotionId,
    code,
    maxUses,
    usageCount,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_coupon_codes';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCouponCode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('promotion_id')) {
      context.handle(
        _promotionIdMeta,
        promotionId.isAcceptableOrUnknown(
          data['promotion_id']!,
          _promotionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_promotionIdMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('max_uses')) {
      context.handle(
        _maxUsesMeta,
        maxUses.isAcceptableOrUnknown(data['max_uses']!, _maxUsesMeta),
      );
    }
    if (data.containsKey('usage_count')) {
      context.handle(
        _usageCountMeta,
        usageCount.isAcceptableOrUnknown(data['usage_count']!, _usageCountMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCouponCode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCouponCode(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      promotionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}promotion_id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      maxUses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_uses'],
      ),
      usageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usage_count'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $LocalCouponCodesTable createAlias(String alias) {
    return $LocalCouponCodesTable(attachedDatabase, alias);
  }
}

class LocalCouponCode extends DataClass implements Insertable<LocalCouponCode> {
  final String id;
  final String promotionId;
  final String code;
  final int? maxUses;
  final int usageCount;
  final bool isActive;
  const LocalCouponCode({
    required this.id,
    required this.promotionId,
    required this.code,
    this.maxUses,
    required this.usageCount,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['promotion_id'] = Variable<String>(promotionId);
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || maxUses != null) {
      map['max_uses'] = Variable<int>(maxUses);
    }
    map['usage_count'] = Variable<int>(usageCount);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  LocalCouponCodesCompanion toCompanion(bool nullToAbsent) {
    return LocalCouponCodesCompanion(
      id: Value(id),
      promotionId: Value(promotionId),
      code: Value(code),
      maxUses: maxUses == null && nullToAbsent
          ? const Value.absent()
          : Value(maxUses),
      usageCount: Value(usageCount),
      isActive: Value(isActive),
    );
  }

  factory LocalCouponCode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCouponCode(
      id: serializer.fromJson<String>(json['id']),
      promotionId: serializer.fromJson<String>(json['promotionId']),
      code: serializer.fromJson<String>(json['code']),
      maxUses: serializer.fromJson<int?>(json['maxUses']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'promotionId': serializer.toJson<String>(promotionId),
      'code': serializer.toJson<String>(code),
      'maxUses': serializer.toJson<int?>(maxUses),
      'usageCount': serializer.toJson<int>(usageCount),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  LocalCouponCode copyWith({
    String? id,
    String? promotionId,
    String? code,
    Value<int?> maxUses = const Value.absent(),
    int? usageCount,
    bool? isActive,
  }) => LocalCouponCode(
    id: id ?? this.id,
    promotionId: promotionId ?? this.promotionId,
    code: code ?? this.code,
    maxUses: maxUses.present ? maxUses.value : this.maxUses,
    usageCount: usageCount ?? this.usageCount,
    isActive: isActive ?? this.isActive,
  );
  LocalCouponCode copyWithCompanion(LocalCouponCodesCompanion data) {
    return LocalCouponCode(
      id: data.id.present ? data.id.value : this.id,
      promotionId: data.promotionId.present
          ? data.promotionId.value
          : this.promotionId,
      code: data.code.present ? data.code.value : this.code,
      maxUses: data.maxUses.present ? data.maxUses.value : this.maxUses,
      usageCount: data.usageCount.present
          ? data.usageCount.value
          : this.usageCount,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCouponCode(')
          ..write('id: $id, ')
          ..write('promotionId: $promotionId, ')
          ..write('code: $code, ')
          ..write('maxUses: $maxUses, ')
          ..write('usageCount: $usageCount, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, promotionId, code, maxUses, usageCount, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCouponCode &&
          other.id == this.id &&
          other.promotionId == this.promotionId &&
          other.code == this.code &&
          other.maxUses == this.maxUses &&
          other.usageCount == this.usageCount &&
          other.isActive == this.isActive);
}

class LocalCouponCodesCompanion extends UpdateCompanion<LocalCouponCode> {
  final Value<String> id;
  final Value<String> promotionId;
  final Value<String> code;
  final Value<int?> maxUses;
  final Value<int> usageCount;
  final Value<bool> isActive;
  final Value<int> rowid;
  const LocalCouponCodesCompanion({
    this.id = const Value.absent(),
    this.promotionId = const Value.absent(),
    this.code = const Value.absent(),
    this.maxUses = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCouponCodesCompanion.insert({
    required String id,
    required String promotionId,
    required String code,
    this.maxUses = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       promotionId = Value(promotionId),
       code = Value(code);
  static Insertable<LocalCouponCode> custom({
    Expression<String>? id,
    Expression<String>? promotionId,
    Expression<String>? code,
    Expression<int>? maxUses,
    Expression<int>? usageCount,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (promotionId != null) 'promotion_id': promotionId,
      if (code != null) 'code': code,
      if (maxUses != null) 'max_uses': maxUses,
      if (usageCount != null) 'usage_count': usageCount,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCouponCodesCompanion copyWith({
    Value<String>? id,
    Value<String>? promotionId,
    Value<String>? code,
    Value<int?>? maxUses,
    Value<int>? usageCount,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return LocalCouponCodesCompanion(
      id: id ?? this.id,
      promotionId: promotionId ?? this.promotionId,
      code: code ?? this.code,
      maxUses: maxUses ?? this.maxUses,
      usageCount: usageCount ?? this.usageCount,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (promotionId.present) {
      map['promotion_id'] = Variable<String>(promotionId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (maxUses.present) {
      map['max_uses'] = Variable<int>(maxUses.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCouponCodesCompanion(')
          ..write('id: $id, ')
          ..write('promotionId: $promotionId, ')
          ..write('code: $code, ')
          ..write('maxUses: $maxUses, ')
          ..write('usageCount: $usageCount, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalLabelTemplatesTable extends LocalLabelTemplates
    with TableInfo<$LocalLabelTemplatesTable, LocalLabelTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLabelTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
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
  static const VerificationMeta _labelWidthMmMeta = const VerificationMeta(
    'labelWidthMm',
  );
  @override
  late final GeneratedColumn<double> labelWidthMm = GeneratedColumn<double>(
    'label_width_mm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelHeightMmMeta = const VerificationMeta(
    'labelHeightMm',
  );
  @override
  late final GeneratedColumn<double> labelHeightMm = GeneratedColumn<double>(
    'label_height_mm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _layoutJsonMeta = const VerificationMeta(
    'layoutJson',
  );
  @override
  late final GeneratedColumn<String> layoutJson = GeneratedColumn<String>(
    'layout_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPresetMeta = const VerificationMeta(
    'isPreset',
  );
  @override
  late final GeneratedColumn<bool> isPreset = GeneratedColumn<bool>(
    'is_preset',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_preset" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizationId,
    name,
    labelWidthMm,
    labelHeightMm,
    layoutJson,
    isPreset,
    isDefault,
    syncVersion,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_label_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLabelTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('label_width_mm')) {
      context.handle(
        _labelWidthMmMeta,
        labelWidthMm.isAcceptableOrUnknown(
          data['label_width_mm']!,
          _labelWidthMmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_labelWidthMmMeta);
    }
    if (data.containsKey('label_height_mm')) {
      context.handle(
        _labelHeightMmMeta,
        labelHeightMm.isAcceptableOrUnknown(
          data['label_height_mm']!,
          _labelHeightMmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_labelHeightMmMeta);
    }
    if (data.containsKey('layout_json')) {
      context.handle(
        _layoutJsonMeta,
        layoutJson.isAcceptableOrUnknown(data['layout_json']!, _layoutJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_layoutJsonMeta);
    }
    if (data.containsKey('is_preset')) {
      context.handle(
        _isPresetMeta,
        isPreset.isAcceptableOrUnknown(data['is_preset']!, _isPresetMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalLabelTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLabelTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      labelWidthMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}label_width_mm'],
      )!,
      labelHeightMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}label_height_mm'],
      )!,
      layoutJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layout_json'],
      )!,
      isPreset: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_preset'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalLabelTemplatesTable createAlias(String alias) {
    return $LocalLabelTemplatesTable(attachedDatabase, alias);
  }
}

class LocalLabelTemplate extends DataClass
    implements Insertable<LocalLabelTemplate> {
  final String id;
  final String organizationId;
  final String name;
  final double labelWidthMm;
  final double labelHeightMm;
  final String layoutJson;
  final bool isPreset;
  final bool isDefault;
  final int syncVersion;
  final DateTime updatedAt;
  const LocalLabelTemplate({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.labelWidthMm,
    required this.labelHeightMm,
    required this.layoutJson,
    required this.isPreset,
    required this.isDefault,
    required this.syncVersion,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['organization_id'] = Variable<String>(organizationId);
    map['name'] = Variable<String>(name);
    map['label_width_mm'] = Variable<double>(labelWidthMm);
    map['label_height_mm'] = Variable<double>(labelHeightMm);
    map['layout_json'] = Variable<String>(layoutJson);
    map['is_preset'] = Variable<bool>(isPreset);
    map['is_default'] = Variable<bool>(isDefault);
    map['sync_version'] = Variable<int>(syncVersion);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalLabelTemplatesCompanion toCompanion(bool nullToAbsent) {
    return LocalLabelTemplatesCompanion(
      id: Value(id),
      organizationId: Value(organizationId),
      name: Value(name),
      labelWidthMm: Value(labelWidthMm),
      labelHeightMm: Value(labelHeightMm),
      layoutJson: Value(layoutJson),
      isPreset: Value(isPreset),
      isDefault: Value(isDefault),
      syncVersion: Value(syncVersion),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalLabelTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLabelTemplate(
      id: serializer.fromJson<String>(json['id']),
      organizationId: serializer.fromJson<String>(json['organizationId']),
      name: serializer.fromJson<String>(json['name']),
      labelWidthMm: serializer.fromJson<double>(json['labelWidthMm']),
      labelHeightMm: serializer.fromJson<double>(json['labelHeightMm']),
      layoutJson: serializer.fromJson<String>(json['layoutJson']),
      isPreset: serializer.fromJson<bool>(json['isPreset']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'organizationId': serializer.toJson<String>(organizationId),
      'name': serializer.toJson<String>(name),
      'labelWidthMm': serializer.toJson<double>(labelWidthMm),
      'labelHeightMm': serializer.toJson<double>(labelHeightMm),
      'layoutJson': serializer.toJson<String>(layoutJson),
      'isPreset': serializer.toJson<bool>(isPreset),
      'isDefault': serializer.toJson<bool>(isDefault),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalLabelTemplate copyWith({
    String? id,
    String? organizationId,
    String? name,
    double? labelWidthMm,
    double? labelHeightMm,
    String? layoutJson,
    bool? isPreset,
    bool? isDefault,
    int? syncVersion,
    DateTime? updatedAt,
  }) => LocalLabelTemplate(
    id: id ?? this.id,
    organizationId: organizationId ?? this.organizationId,
    name: name ?? this.name,
    labelWidthMm: labelWidthMm ?? this.labelWidthMm,
    labelHeightMm: labelHeightMm ?? this.labelHeightMm,
    layoutJson: layoutJson ?? this.layoutJson,
    isPreset: isPreset ?? this.isPreset,
    isDefault: isDefault ?? this.isDefault,
    syncVersion: syncVersion ?? this.syncVersion,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalLabelTemplate copyWithCompanion(LocalLabelTemplatesCompanion data) {
    return LocalLabelTemplate(
      id: data.id.present ? data.id.value : this.id,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      name: data.name.present ? data.name.value : this.name,
      labelWidthMm: data.labelWidthMm.present
          ? data.labelWidthMm.value
          : this.labelWidthMm,
      labelHeightMm: data.labelHeightMm.present
          ? data.labelHeightMm.value
          : this.labelHeightMm,
      layoutJson: data.layoutJson.present
          ? data.layoutJson.value
          : this.layoutJson,
      isPreset: data.isPreset.present ? data.isPreset.value : this.isPreset,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLabelTemplate(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('name: $name, ')
          ..write('labelWidthMm: $labelWidthMm, ')
          ..write('labelHeightMm: $labelHeightMm, ')
          ..write('layoutJson: $layoutJson, ')
          ..write('isPreset: $isPreset, ')
          ..write('isDefault: $isDefault, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizationId,
    name,
    labelWidthMm,
    labelHeightMm,
    layoutJson,
    isPreset,
    isDefault,
    syncVersion,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLabelTemplate &&
          other.id == this.id &&
          other.organizationId == this.organizationId &&
          other.name == this.name &&
          other.labelWidthMm == this.labelWidthMm &&
          other.labelHeightMm == this.labelHeightMm &&
          other.layoutJson == this.layoutJson &&
          other.isPreset == this.isPreset &&
          other.isDefault == this.isDefault &&
          other.syncVersion == this.syncVersion &&
          other.updatedAt == this.updatedAt);
}

class LocalLabelTemplatesCompanion extends UpdateCompanion<LocalLabelTemplate> {
  final Value<String> id;
  final Value<String> organizationId;
  final Value<String> name;
  final Value<double> labelWidthMm;
  final Value<double> labelHeightMm;
  final Value<String> layoutJson;
  final Value<bool> isPreset;
  final Value<bool> isDefault;
  final Value<int> syncVersion;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalLabelTemplatesCompanion({
    this.id = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.name = const Value.absent(),
    this.labelWidthMm = const Value.absent(),
    this.labelHeightMm = const Value.absent(),
    this.layoutJson = const Value.absent(),
    this.isPreset = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLabelTemplatesCompanion.insert({
    required String id,
    required String organizationId,
    required String name,
    required double labelWidthMm,
    required double labelHeightMm,
    required String layoutJson,
    this.isPreset = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       organizationId = Value(organizationId),
       name = Value(name),
       labelWidthMm = Value(labelWidthMm),
       labelHeightMm = Value(labelHeightMm),
       layoutJson = Value(layoutJson);
  static Insertable<LocalLabelTemplate> custom({
    Expression<String>? id,
    Expression<String>? organizationId,
    Expression<String>? name,
    Expression<double>? labelWidthMm,
    Expression<double>? labelHeightMm,
    Expression<String>? layoutJson,
    Expression<bool>? isPreset,
    Expression<bool>? isDefault,
    Expression<int>? syncVersion,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizationId != null) 'organization_id': organizationId,
      if (name != null) 'name': name,
      if (labelWidthMm != null) 'label_width_mm': labelWidthMm,
      if (labelHeightMm != null) 'label_height_mm': labelHeightMm,
      if (layoutJson != null) 'layout_json': layoutJson,
      if (isPreset != null) 'is_preset': isPreset,
      if (isDefault != null) 'is_default': isDefault,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLabelTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? organizationId,
    Value<String>? name,
    Value<double>? labelWidthMm,
    Value<double>? labelHeightMm,
    Value<String>? layoutJson,
    Value<bool>? isPreset,
    Value<bool>? isDefault,
    Value<int>? syncVersion,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalLabelTemplatesCompanion(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      labelWidthMm: labelWidthMm ?? this.labelWidthMm,
      labelHeightMm: labelHeightMm ?? this.labelHeightMm,
      layoutJson: layoutJson ?? this.layoutJson,
      isPreset: isPreset ?? this.isPreset,
      isDefault: isDefault ?? this.isDefault,
      syncVersion: syncVersion ?? this.syncVersion,
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
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (labelWidthMm.present) {
      map['label_width_mm'] = Variable<double>(labelWidthMm.value);
    }
    if (labelHeightMm.present) {
      map['label_height_mm'] = Variable<double>(labelHeightMm.value);
    }
    if (layoutJson.present) {
      map['layout_json'] = Variable<String>(layoutJson.value);
    }
    if (isPreset.present) {
      map['is_preset'] = Variable<bool>(isPreset.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
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
    return (StringBuffer('LocalLabelTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('name: $name, ')
          ..write('labelWidthMm: $labelWidthMm, ')
          ..write('labelHeightMm: $labelHeightMm, ')
          ..write('layoutJson: $layoutJson, ')
          ..write('isPreset: $isPreset, ')
          ..write('isDefault: $isDefault, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalLabelPrintHistoryTable extends LocalLabelPrintHistory
    with TableInfo<$LocalLabelPrintHistoryTable, LocalLabelPrintHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLabelPrintHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _printerNameMeta = const VerificationMeta(
    'printerName',
  );
  @override
  late final GeneratedColumn<String> printerName = GeneratedColumn<String>(
    'printer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productCountMeta = const VerificationMeta(
    'productCount',
  );
  @override
  late final GeneratedColumn<int> productCount = GeneratedColumn<int>(
    'product_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalLabelsMeta = const VerificationMeta(
    'totalLabels',
  );
  @override
  late final GeneratedColumn<int> totalLabels = GeneratedColumn<int>(
    'total_labels',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _printedAtMeta = const VerificationMeta(
    'printedAt',
  );
  @override
  late final GeneratedColumn<DateTime> printedAt = GeneratedColumn<DateTime>(
    'printed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncedToServerMeta = const VerificationMeta(
    'syncedToServer',
  );
  @override
  late final GeneratedColumn<bool> syncedToServer = GeneratedColumn<bool>(
    'synced_to_server',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced_to_server" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateId,
    printerName,
    productCount,
    totalLabels,
    printedAt,
    syncedToServer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_label_print_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLabelPrintHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('printer_name')) {
      context.handle(
        _printerNameMeta,
        printerName.isAcceptableOrUnknown(
          data['printer_name']!,
          _printerNameMeta,
        ),
      );
    }
    if (data.containsKey('product_count')) {
      context.handle(
        _productCountMeta,
        productCount.isAcceptableOrUnknown(
          data['product_count']!,
          _productCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productCountMeta);
    }
    if (data.containsKey('total_labels')) {
      context.handle(
        _totalLabelsMeta,
        totalLabels.isAcceptableOrUnknown(
          data['total_labels']!,
          _totalLabelsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalLabelsMeta);
    }
    if (data.containsKey('printed_at')) {
      context.handle(
        _printedAtMeta,
        printedAt.isAcceptableOrUnknown(data['printed_at']!, _printedAtMeta),
      );
    }
    if (data.containsKey('synced_to_server')) {
      context.handle(
        _syncedToServerMeta,
        syncedToServer.isAcceptableOrUnknown(
          data['synced_to_server']!,
          _syncedToServerMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalLabelPrintHistoryData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLabelPrintHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      ),
      printerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}printer_name'],
      ),
      productCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_count'],
      )!,
      totalLabels: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_labels'],
      )!,
      printedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}printed_at'],
      )!,
      syncedToServer: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced_to_server'],
      )!,
    );
  }

  @override
  $LocalLabelPrintHistoryTable createAlias(String alias) {
    return $LocalLabelPrintHistoryTable(attachedDatabase, alias);
  }
}

class LocalLabelPrintHistoryData extends DataClass
    implements Insertable<LocalLabelPrintHistoryData> {
  final String id;
  final String? templateId;
  final String? printerName;
  final int productCount;
  final int totalLabels;
  final DateTime printedAt;
  final bool syncedToServer;
  const LocalLabelPrintHistoryData({
    required this.id,
    this.templateId,
    this.printerName,
    required this.productCount,
    required this.totalLabels,
    required this.printedAt,
    required this.syncedToServer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    if (!nullToAbsent || printerName != null) {
      map['printer_name'] = Variable<String>(printerName);
    }
    map['product_count'] = Variable<int>(productCount);
    map['total_labels'] = Variable<int>(totalLabels);
    map['printed_at'] = Variable<DateTime>(printedAt);
    map['synced_to_server'] = Variable<bool>(syncedToServer);
    return map;
  }

  LocalLabelPrintHistoryCompanion toCompanion(bool nullToAbsent) {
    return LocalLabelPrintHistoryCompanion(
      id: Value(id),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      printerName: printerName == null && nullToAbsent
          ? const Value.absent()
          : Value(printerName),
      productCount: Value(productCount),
      totalLabels: Value(totalLabels),
      printedAt: Value(printedAt),
      syncedToServer: Value(syncedToServer),
    );
  }

  factory LocalLabelPrintHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLabelPrintHistoryData(
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<String?>(json['templateId']),
      printerName: serializer.fromJson<String?>(json['printerName']),
      productCount: serializer.fromJson<int>(json['productCount']),
      totalLabels: serializer.fromJson<int>(json['totalLabels']),
      printedAt: serializer.fromJson<DateTime>(json['printedAt']),
      syncedToServer: serializer.fromJson<bool>(json['syncedToServer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<String?>(templateId),
      'printerName': serializer.toJson<String?>(printerName),
      'productCount': serializer.toJson<int>(productCount),
      'totalLabels': serializer.toJson<int>(totalLabels),
      'printedAt': serializer.toJson<DateTime>(printedAt),
      'syncedToServer': serializer.toJson<bool>(syncedToServer),
    };
  }

  LocalLabelPrintHistoryData copyWith({
    String? id,
    Value<String?> templateId = const Value.absent(),
    Value<String?> printerName = const Value.absent(),
    int? productCount,
    int? totalLabels,
    DateTime? printedAt,
    bool? syncedToServer,
  }) => LocalLabelPrintHistoryData(
    id: id ?? this.id,
    templateId: templateId.present ? templateId.value : this.templateId,
    printerName: printerName.present ? printerName.value : this.printerName,
    productCount: productCount ?? this.productCount,
    totalLabels: totalLabels ?? this.totalLabels,
    printedAt: printedAt ?? this.printedAt,
    syncedToServer: syncedToServer ?? this.syncedToServer,
  );
  LocalLabelPrintHistoryData copyWithCompanion(
    LocalLabelPrintHistoryCompanion data,
  ) {
    return LocalLabelPrintHistoryData(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      printerName: data.printerName.present
          ? data.printerName.value
          : this.printerName,
      productCount: data.productCount.present
          ? data.productCount.value
          : this.productCount,
      totalLabels: data.totalLabels.present
          ? data.totalLabels.value
          : this.totalLabels,
      printedAt: data.printedAt.present ? data.printedAt.value : this.printedAt,
      syncedToServer: data.syncedToServer.present
          ? data.syncedToServer.value
          : this.syncedToServer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLabelPrintHistoryData(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('printerName: $printerName, ')
          ..write('productCount: $productCount, ')
          ..write('totalLabels: $totalLabels, ')
          ..write('printedAt: $printedAt, ')
          ..write('syncedToServer: $syncedToServer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    templateId,
    printerName,
    productCount,
    totalLabels,
    printedAt,
    syncedToServer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLabelPrintHistoryData &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.printerName == this.printerName &&
          other.productCount == this.productCount &&
          other.totalLabels == this.totalLabels &&
          other.printedAt == this.printedAt &&
          other.syncedToServer == this.syncedToServer);
}

class LocalLabelPrintHistoryCompanion
    extends UpdateCompanion<LocalLabelPrintHistoryData> {
  final Value<String> id;
  final Value<String?> templateId;
  final Value<String?> printerName;
  final Value<int> productCount;
  final Value<int> totalLabels;
  final Value<DateTime> printedAt;
  final Value<bool> syncedToServer;
  final Value<int> rowid;
  const LocalLabelPrintHistoryCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.printerName = const Value.absent(),
    this.productCount = const Value.absent(),
    this.totalLabels = const Value.absent(),
    this.printedAt = const Value.absent(),
    this.syncedToServer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLabelPrintHistoryCompanion.insert({
    required String id,
    this.templateId = const Value.absent(),
    this.printerName = const Value.absent(),
    required int productCount,
    required int totalLabels,
    this.printedAt = const Value.absent(),
    this.syncedToServer = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productCount = Value(productCount),
       totalLabels = Value(totalLabels);
  static Insertable<LocalLabelPrintHistoryData> custom({
    Expression<String>? id,
    Expression<String>? templateId,
    Expression<String>? printerName,
    Expression<int>? productCount,
    Expression<int>? totalLabels,
    Expression<DateTime>? printedAt,
    Expression<bool>? syncedToServer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (printerName != null) 'printer_name': printerName,
      if (productCount != null) 'product_count': productCount,
      if (totalLabels != null) 'total_labels': totalLabels,
      if (printedAt != null) 'printed_at': printedAt,
      if (syncedToServer != null) 'synced_to_server': syncedToServer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLabelPrintHistoryCompanion copyWith({
    Value<String>? id,
    Value<String?>? templateId,
    Value<String?>? printerName,
    Value<int>? productCount,
    Value<int>? totalLabels,
    Value<DateTime>? printedAt,
    Value<bool>? syncedToServer,
    Value<int>? rowid,
  }) {
    return LocalLabelPrintHistoryCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      printerName: printerName ?? this.printerName,
      productCount: productCount ?? this.productCount,
      totalLabels: totalLabels ?? this.totalLabels,
      printedAt: printedAt ?? this.printedAt,
      syncedToServer: syncedToServer ?? this.syncedToServer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (printerName.present) {
      map['printer_name'] = Variable<String>(printerName.value);
    }
    if (productCount.present) {
      map['product_count'] = Variable<int>(productCount.value);
    }
    if (totalLabels.present) {
      map['total_labels'] = Variable<int>(totalLabels.value);
    }
    if (printedAt.present) {
      map['printed_at'] = Variable<DateTime>(printedAt.value);
    }
    if (syncedToServer.present) {
      map['synced_to_server'] = Variable<bool>(syncedToServer.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalLabelPrintHistoryCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('printerName: $printerName, ')
          ..write('productCount: $productCount, ')
          ..write('totalLabels: $totalLabels, ')
          ..write('printedAt: $printedAt, ')
          ..write('syncedToServer: $syncedToServer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCustomersTable extends LocalCustomers
    with TableInfo<$LocalCustomersTable, LocalCustomer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
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
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loyaltyCodeMeta = const VerificationMeta(
    'loyaltyCode',
  );
  @override
  late final GeneratedColumn<String> loyaltyCode = GeneratedColumn<String>(
    'loyalty_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loyaltyPointsMeta = const VerificationMeta(
    'loyaltyPoints',
  );
  @override
  late final GeneratedColumn<int> loyaltyPoints = GeneratedColumn<int>(
    'loyalty_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _storeCreditBalanceMeta =
      const VerificationMeta('storeCreditBalance');
  @override
  late final GeneratedColumn<double> storeCreditBalance =
      GeneratedColumn<double>(
        'store_credit_balance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxRegistrationNumberMeta =
      const VerificationMeta('taxRegistrationNumber');
  @override
  late final GeneratedColumn<String> taxRegistrationNumber =
      GeneratedColumn<String>(
        'tax_registration_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
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
  static const VerificationMeta _totalSpendMeta = const VerificationMeta(
    'totalSpend',
  );
  @override
  late final GeneratedColumn<double> totalSpend = GeneratedColumn<double>(
    'total_spend',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _visitCountMeta = const VerificationMeta(
    'visitCount',
  );
  @override
  late final GeneratedColumn<int> visitCount = GeneratedColumn<int>(
    'visit_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastVisitAtMeta = const VerificationMeta(
    'lastVisitAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastVisitAt = GeneratedColumn<DateTime>(
    'last_visit_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncVersionMeta = const VerificationMeta(
    'syncVersion',
  );
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
    'sync_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizationId,
    name,
    phone,
    email,
    address,
    dateOfBirth,
    loyaltyCode,
    loyaltyPoints,
    storeCreditBalance,
    groupId,
    taxRegistrationNumber,
    notes,
    totalSpend,
    visitCount,
    lastVisitAt,
    syncVersion,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCustomer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('loyalty_code')) {
      context.handle(
        _loyaltyCodeMeta,
        loyaltyCode.isAcceptableOrUnknown(
          data['loyalty_code']!,
          _loyaltyCodeMeta,
        ),
      );
    }
    if (data.containsKey('loyalty_points')) {
      context.handle(
        _loyaltyPointsMeta,
        loyaltyPoints.isAcceptableOrUnknown(
          data['loyalty_points']!,
          _loyaltyPointsMeta,
        ),
      );
    }
    if (data.containsKey('store_credit_balance')) {
      context.handle(
        _storeCreditBalanceMeta,
        storeCreditBalance.isAcceptableOrUnknown(
          data['store_credit_balance']!,
          _storeCreditBalanceMeta,
        ),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('tax_registration_number')) {
      context.handle(
        _taxRegistrationNumberMeta,
        taxRegistrationNumber.isAcceptableOrUnknown(
          data['tax_registration_number']!,
          _taxRegistrationNumberMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('total_spend')) {
      context.handle(
        _totalSpendMeta,
        totalSpend.isAcceptableOrUnknown(data['total_spend']!, _totalSpendMeta),
      );
    }
    if (data.containsKey('visit_count')) {
      context.handle(
        _visitCountMeta,
        visitCount.isAcceptableOrUnknown(data['visit_count']!, _visitCountMeta),
      );
    }
    if (data.containsKey('last_visit_at')) {
      context.handle(
        _lastVisitAtMeta,
        lastVisitAt.isAcceptableOrUnknown(
          data['last_visit_at']!,
          _lastVisitAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_version')) {
      context.handle(
        _syncVersionMeta,
        syncVersion.isAcceptableOrUnknown(
          data['sync_version']!,
          _syncVersionMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCustomer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCustomer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_of_birth'],
      ),
      loyaltyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loyalty_code'],
      ),
      loyaltyPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loyalty_points'],
      )!,
      storeCreditBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}store_credit_balance'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      ),
      taxRegistrationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_registration_number'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      totalSpend: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_spend'],
      )!,
      visitCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_count'],
      )!,
      lastVisitAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_visit_at'],
      ),
      syncVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LocalCustomersTable createAlias(String alias) {
    return $LocalCustomersTable(attachedDatabase, alias);
  }
}

class LocalCustomer extends DataClass implements Insertable<LocalCustomer> {
  final String id;
  final String organizationId;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final DateTime? dateOfBirth;
  final String? loyaltyCode;
  final int loyaltyPoints;
  final double storeCreditBalance;
  final String? groupId;
  final String? taxRegistrationNumber;
  final String? notes;
  final double totalSpend;
  final int visitCount;
  final DateTime? lastVisitAt;
  final int syncVersion;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const LocalCustomer({
    required this.id,
    required this.organizationId,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.dateOfBirth,
    this.loyaltyCode,
    required this.loyaltyPoints,
    required this.storeCreditBalance,
    this.groupId,
    this.taxRegistrationNumber,
    this.notes,
    required this.totalSpend,
    required this.visitCount,
    this.lastVisitAt,
    required this.syncVersion,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['organization_id'] = Variable<String>(organizationId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    }
    if (!nullToAbsent || loyaltyCode != null) {
      map['loyalty_code'] = Variable<String>(loyaltyCode);
    }
    map['loyalty_points'] = Variable<int>(loyaltyPoints);
    map['store_credit_balance'] = Variable<double>(storeCreditBalance);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    if (!nullToAbsent || taxRegistrationNumber != null) {
      map['tax_registration_number'] = Variable<String>(taxRegistrationNumber);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['total_spend'] = Variable<double>(totalSpend);
    map['visit_count'] = Variable<int>(visitCount);
    if (!nullToAbsent || lastVisitAt != null) {
      map['last_visit_at'] = Variable<DateTime>(lastVisitAt);
    }
    map['sync_version'] = Variable<int>(syncVersion);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  LocalCustomersCompanion toCompanion(bool nullToAbsent) {
    return LocalCustomersCompanion(
      id: Value(id),
      organizationId: Value(organizationId),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      loyaltyCode: loyaltyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(loyaltyCode),
      loyaltyPoints: Value(loyaltyPoints),
      storeCreditBalance: Value(storeCreditBalance),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      taxRegistrationNumber: taxRegistrationNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(taxRegistrationNumber),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      totalSpend: Value(totalSpend),
      visitCount: Value(visitCount),
      lastVisitAt: lastVisitAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVisitAt),
      syncVersion: Value(syncVersion),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory LocalCustomer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCustomer(
      id: serializer.fromJson<String>(json['id']),
      organizationId: serializer.fromJson<String>(json['organizationId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      dateOfBirth: serializer.fromJson<DateTime?>(json['dateOfBirth']),
      loyaltyCode: serializer.fromJson<String?>(json['loyaltyCode']),
      loyaltyPoints: serializer.fromJson<int>(json['loyaltyPoints']),
      storeCreditBalance: serializer.fromJson<double>(
        json['storeCreditBalance'],
      ),
      groupId: serializer.fromJson<String?>(json['groupId']),
      taxRegistrationNumber: serializer.fromJson<String?>(
        json['taxRegistrationNumber'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      totalSpend: serializer.fromJson<double>(json['totalSpend']),
      visitCount: serializer.fromJson<int>(json['visitCount']),
      lastVisitAt: serializer.fromJson<DateTime?>(json['lastVisitAt']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'organizationId': serializer.toJson<String>(organizationId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'dateOfBirth': serializer.toJson<DateTime?>(dateOfBirth),
      'loyaltyCode': serializer.toJson<String?>(loyaltyCode),
      'loyaltyPoints': serializer.toJson<int>(loyaltyPoints),
      'storeCreditBalance': serializer.toJson<double>(storeCreditBalance),
      'groupId': serializer.toJson<String?>(groupId),
      'taxRegistrationNumber': serializer.toJson<String?>(
        taxRegistrationNumber,
      ),
      'notes': serializer.toJson<String?>(notes),
      'totalSpend': serializer.toJson<double>(totalSpend),
      'visitCount': serializer.toJson<int>(visitCount),
      'lastVisitAt': serializer.toJson<DateTime?>(lastVisitAt),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  LocalCustomer copyWith({
    String? id,
    String? organizationId,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<DateTime?> dateOfBirth = const Value.absent(),
    Value<String?> loyaltyCode = const Value.absent(),
    int? loyaltyPoints,
    double? storeCreditBalance,
    Value<String?> groupId = const Value.absent(),
    Value<String?> taxRegistrationNumber = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    double? totalSpend,
    int? visitCount,
    Value<DateTime?> lastVisitAt = const Value.absent(),
    int? syncVersion,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => LocalCustomer(
    id: id ?? this.id,
    organizationId: organizationId ?? this.organizationId,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    address: address.present ? address.value : this.address,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    loyaltyCode: loyaltyCode.present ? loyaltyCode.value : this.loyaltyCode,
    loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
    storeCreditBalance: storeCreditBalance ?? this.storeCreditBalance,
    groupId: groupId.present ? groupId.value : this.groupId,
    taxRegistrationNumber: taxRegistrationNumber.present
        ? taxRegistrationNumber.value
        : this.taxRegistrationNumber,
    notes: notes.present ? notes.value : this.notes,
    totalSpend: totalSpend ?? this.totalSpend,
    visitCount: visitCount ?? this.visitCount,
    lastVisitAt: lastVisitAt.present ? lastVisitAt.value : this.lastVisitAt,
    syncVersion: syncVersion ?? this.syncVersion,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  LocalCustomer copyWithCompanion(LocalCustomersCompanion data) {
    return LocalCustomer(
      id: data.id.present ? data.id.value : this.id,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      loyaltyCode: data.loyaltyCode.present
          ? data.loyaltyCode.value
          : this.loyaltyCode,
      loyaltyPoints: data.loyaltyPoints.present
          ? data.loyaltyPoints.value
          : this.loyaltyPoints,
      storeCreditBalance: data.storeCreditBalance.present
          ? data.storeCreditBalance.value
          : this.storeCreditBalance,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      taxRegistrationNumber: data.taxRegistrationNumber.present
          ? data.taxRegistrationNumber.value
          : this.taxRegistrationNumber,
      notes: data.notes.present ? data.notes.value : this.notes,
      totalSpend: data.totalSpend.present
          ? data.totalSpend.value
          : this.totalSpend,
      visitCount: data.visitCount.present
          ? data.visitCount.value
          : this.visitCount,
      lastVisitAt: data.lastVisitAt.present
          ? data.lastVisitAt.value
          : this.lastVisitAt,
      syncVersion: data.syncVersion.present
          ? data.syncVersion.value
          : this.syncVersion,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCustomer(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('loyaltyCode: $loyaltyCode, ')
          ..write('loyaltyPoints: $loyaltyPoints, ')
          ..write('storeCreditBalance: $storeCreditBalance, ')
          ..write('groupId: $groupId, ')
          ..write('taxRegistrationNumber: $taxRegistrationNumber, ')
          ..write('notes: $notes, ')
          ..write('totalSpend: $totalSpend, ')
          ..write('visitCount: $visitCount, ')
          ..write('lastVisitAt: $lastVisitAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizationId,
    name,
    phone,
    email,
    address,
    dateOfBirth,
    loyaltyCode,
    loyaltyPoints,
    storeCreditBalance,
    groupId,
    taxRegistrationNumber,
    notes,
    totalSpend,
    visitCount,
    lastVisitAt,
    syncVersion,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCustomer &&
          other.id == this.id &&
          other.organizationId == this.organizationId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.dateOfBirth == this.dateOfBirth &&
          other.loyaltyCode == this.loyaltyCode &&
          other.loyaltyPoints == this.loyaltyPoints &&
          other.storeCreditBalance == this.storeCreditBalance &&
          other.groupId == this.groupId &&
          other.taxRegistrationNumber == this.taxRegistrationNumber &&
          other.notes == this.notes &&
          other.totalSpend == this.totalSpend &&
          other.visitCount == this.visitCount &&
          other.lastVisitAt == this.lastVisitAt &&
          other.syncVersion == this.syncVersion &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class LocalCustomersCompanion extends UpdateCompanion<LocalCustomer> {
  final Value<String> id;
  final Value<String> organizationId;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<DateTime?> dateOfBirth;
  final Value<String?> loyaltyCode;
  final Value<int> loyaltyPoints;
  final Value<double> storeCreditBalance;
  final Value<String?> groupId;
  final Value<String?> taxRegistrationNumber;
  final Value<String?> notes;
  final Value<double> totalSpend;
  final Value<int> visitCount;
  final Value<DateTime?> lastVisitAt;
  final Value<int> syncVersion;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const LocalCustomersCompanion({
    this.id = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.loyaltyCode = const Value.absent(),
    this.loyaltyPoints = const Value.absent(),
    this.storeCreditBalance = const Value.absent(),
    this.groupId = const Value.absent(),
    this.taxRegistrationNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.totalSpend = const Value.absent(),
    this.visitCount = const Value.absent(),
    this.lastVisitAt = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCustomersCompanion.insert({
    required String id,
    required String organizationId,
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.loyaltyCode = const Value.absent(),
    this.loyaltyPoints = const Value.absent(),
    this.storeCreditBalance = const Value.absent(),
    this.groupId = const Value.absent(),
    this.taxRegistrationNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.totalSpend = const Value.absent(),
    this.visitCount = const Value.absent(),
    this.lastVisitAt = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       organizationId = Value(organizationId),
       name = Value(name);
  static Insertable<LocalCustomer> custom({
    Expression<String>? id,
    Expression<String>? organizationId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? loyaltyCode,
    Expression<int>? loyaltyPoints,
    Expression<double>? storeCreditBalance,
    Expression<String>? groupId,
    Expression<String>? taxRegistrationNumber,
    Expression<String>? notes,
    Expression<double>? totalSpend,
    Expression<int>? visitCount,
    Expression<DateTime>? lastVisitAt,
    Expression<int>? syncVersion,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizationId != null) 'organization_id': organizationId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (loyaltyCode != null) 'loyalty_code': loyaltyCode,
      if (loyaltyPoints != null) 'loyalty_points': loyaltyPoints,
      if (storeCreditBalance != null)
        'store_credit_balance': storeCreditBalance,
      if (groupId != null) 'group_id': groupId,
      if (taxRegistrationNumber != null)
        'tax_registration_number': taxRegistrationNumber,
      if (notes != null) 'notes': notes,
      if (totalSpend != null) 'total_spend': totalSpend,
      if (visitCount != null) 'visit_count': visitCount,
      if (lastVisitAt != null) 'last_visit_at': lastVisitAt,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? organizationId,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? address,
    Value<DateTime?>? dateOfBirth,
    Value<String?>? loyaltyCode,
    Value<int>? loyaltyPoints,
    Value<double>? storeCreditBalance,
    Value<String?>? groupId,
    Value<String?>? taxRegistrationNumber,
    Value<String?>? notes,
    Value<double>? totalSpend,
    Value<int>? visitCount,
    Value<DateTime?>? lastVisitAt,
    Value<int>? syncVersion,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return LocalCustomersCompanion(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      loyaltyCode: loyaltyCode ?? this.loyaltyCode,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      storeCreditBalance: storeCreditBalance ?? this.storeCreditBalance,
      groupId: groupId ?? this.groupId,
      taxRegistrationNumber:
          taxRegistrationNumber ?? this.taxRegistrationNumber,
      notes: notes ?? this.notes,
      totalSpend: totalSpend ?? this.totalSpend,
      visitCount: visitCount ?? this.visitCount,
      lastVisitAt: lastVisitAt ?? this.lastVisitAt,
      syncVersion: syncVersion ?? this.syncVersion,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (loyaltyCode.present) {
      map['loyalty_code'] = Variable<String>(loyaltyCode.value);
    }
    if (loyaltyPoints.present) {
      map['loyalty_points'] = Variable<int>(loyaltyPoints.value);
    }
    if (storeCreditBalance.present) {
      map['store_credit_balance'] = Variable<double>(storeCreditBalance.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (taxRegistrationNumber.present) {
      map['tax_registration_number'] = Variable<String>(
        taxRegistrationNumber.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (totalSpend.present) {
      map['total_spend'] = Variable<double>(totalSpend.value);
    }
    if (visitCount.present) {
      map['visit_count'] = Variable<int>(visitCount.value);
    }
    if (lastVisitAt.present) {
      map['last_visit_at'] = Variable<DateTime>(lastVisitAt.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCustomersCompanion(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('loyaltyCode: $loyaltyCode, ')
          ..write('loyaltyPoints: $loyaltyPoints, ')
          ..write('storeCreditBalance: $storeCreditBalance, ')
          ..write('groupId: $groupId, ')
          ..write('taxRegistrationNumber: $taxRegistrationNumber, ')
          ..write('notes: $notes, ')
          ..write('totalSpend: $totalSpend, ')
          ..write('visitCount: $visitCount, ')
          ..write('lastVisitAt: $lastVisitAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCustomerGroupsTable extends LocalCustomerGroups
    with TableInfo<$LocalCustomerGroupsTable, LocalCustomerGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCustomerGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
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
  static const VerificationMeta _discountPercentMeta = const VerificationMeta(
    'discountPercent',
  );
  @override
  late final GeneratedColumn<double> discountPercent = GeneratedColumn<double>(
    'discount_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizationId,
    name,
    discountPercent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_customer_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCustomerGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
        _discountPercentMeta,
        discountPercent.isAcceptableOrUnknown(
          data['discount_percent']!,
          _discountPercentMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCustomerGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCustomerGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      discountPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_percent'],
      )!,
    );
  }

  @override
  $LocalCustomerGroupsTable createAlias(String alias) {
    return $LocalCustomerGroupsTable(attachedDatabase, alias);
  }
}

class LocalCustomerGroup extends DataClass
    implements Insertable<LocalCustomerGroup> {
  final String id;
  final String organizationId;
  final String name;
  final double discountPercent;
  const LocalCustomerGroup({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.discountPercent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['organization_id'] = Variable<String>(organizationId);
    map['name'] = Variable<String>(name);
    map['discount_percent'] = Variable<double>(discountPercent);
    return map;
  }

  LocalCustomerGroupsCompanion toCompanion(bool nullToAbsent) {
    return LocalCustomerGroupsCompanion(
      id: Value(id),
      organizationId: Value(organizationId),
      name: Value(name),
      discountPercent: Value(discountPercent),
    );
  }

  factory LocalCustomerGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCustomerGroup(
      id: serializer.fromJson<String>(json['id']),
      organizationId: serializer.fromJson<String>(json['organizationId']),
      name: serializer.fromJson<String>(json['name']),
      discountPercent: serializer.fromJson<double>(json['discountPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'organizationId': serializer.toJson<String>(organizationId),
      'name': serializer.toJson<String>(name),
      'discountPercent': serializer.toJson<double>(discountPercent),
    };
  }

  LocalCustomerGroup copyWith({
    String? id,
    String? organizationId,
    String? name,
    double? discountPercent,
  }) => LocalCustomerGroup(
    id: id ?? this.id,
    organizationId: organizationId ?? this.organizationId,
    name: name ?? this.name,
    discountPercent: discountPercent ?? this.discountPercent,
  );
  LocalCustomerGroup copyWithCompanion(LocalCustomerGroupsCompanion data) {
    return LocalCustomerGroup(
      id: data.id.present ? data.id.value : this.id,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      name: data.name.present ? data.name.value : this.name,
      discountPercent: data.discountPercent.present
          ? data.discountPercent.value
          : this.discountPercent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCustomerGroup(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('name: $name, ')
          ..write('discountPercent: $discountPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, organizationId, name, discountPercent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCustomerGroup &&
          other.id == this.id &&
          other.organizationId == this.organizationId &&
          other.name == this.name &&
          other.discountPercent == this.discountPercent);
}

class LocalCustomerGroupsCompanion extends UpdateCompanion<LocalCustomerGroup> {
  final Value<String> id;
  final Value<String> organizationId;
  final Value<String> name;
  final Value<double> discountPercent;
  final Value<int> rowid;
  const LocalCustomerGroupsCompanion({
    this.id = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.name = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCustomerGroupsCompanion.insert({
    required String id,
    required String organizationId,
    required String name,
    this.discountPercent = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       organizationId = Value(organizationId),
       name = Value(name);
  static Insertable<LocalCustomerGroup> custom({
    Expression<String>? id,
    Expression<String>? organizationId,
    Expression<String>? name,
    Expression<double>? discountPercent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizationId != null) 'organization_id': organizationId,
      if (name != null) 'name': name,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCustomerGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? organizationId,
    Value<String>? name,
    Value<double>? discountPercent,
    Value<int>? rowid,
  }) {
    return LocalCustomerGroupsCompanion(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      discountPercent: discountPercent ?? this.discountPercent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<double>(discountPercent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCustomerGroupsCompanion(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('name: $name, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$PosOfflineDatabase extends GeneratedDatabase {
  _$PosOfflineDatabase(QueryExecutor e) : super(e);
  $PosOfflineDatabaseManager get managers => $PosOfflineDatabaseManager(this);
  late final $LocalProductsTable localProducts = $LocalProductsTable(this);
  late final $LocalInventoryTable localInventory = $LocalInventoryTable(this);
  late final $LocalHeldCartsTable localHeldCarts = $LocalHeldCartsTable(this);
  late final $LocalTransactionsTable localTransactions =
      $LocalTransactionsTable(this);
  late final $LocalSyncQueueTable localSyncQueue = $LocalSyncQueueTable(this);
  late final $LocalCategoriesTable localCategories = $LocalCategoriesTable(
    this,
  );
  late final $LocalSuppliersTable localSuppliers = $LocalSuppliersTable(this);
  late final $LocalProductSuppliersTable localProductSuppliers =
      $LocalProductSuppliersTable(this);
  late final $LocalProductVariantsTable localProductVariants =
      $LocalProductVariantsTable(this);
  late final $LocalModifierGroupsTable localModifierGroups =
      $LocalModifierGroupsTable(this);
  late final $LocalModifierOptionsTable localModifierOptions =
      $LocalModifierOptionsTable(this);
  late final $LocalPromotionsTable localPromotions = $LocalPromotionsTable(
    this,
  );
  late final $LocalCouponCodesTable localCouponCodes = $LocalCouponCodesTable(
    this,
  );
  late final $LocalLabelTemplatesTable localLabelTemplates =
      $LocalLabelTemplatesTable(this);
  late final $LocalLabelPrintHistoryTable localLabelPrintHistory =
      $LocalLabelPrintHistoryTable(this);
  late final $LocalCustomersTable localCustomers = $LocalCustomersTable(this);
  late final $LocalCustomerGroupsTable localCustomerGroups =
      $LocalCustomerGroupsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localProducts,
    localInventory,
    localHeldCarts,
    localTransactions,
    localSyncQueue,
    localCategories,
    localSuppliers,
    localProductSuppliers,
    localProductVariants,
    localModifierGroups,
    localModifierOptions,
    localPromotions,
    localCouponCodes,
    localLabelTemplates,
    localLabelPrintHistory,
    localCustomers,
    localCustomerGroups,
  ];
}

typedef $$LocalProductsTableCreateCompanionBuilder =
    LocalProductsCompanion Function({
      required String id,
      Value<String?> sku,
      Value<String?> barcode,
      required String name,
      Value<String?> nameAr,
      required double price,
      Value<double?> costPrice,
      Value<double> taxRate,
      Value<String?> unit,
      Value<bool> isWeighted,
      Value<bool> isAgeRestricted,
      Value<int?> minimumAge,
      Value<String?> categoryId,
      Value<String?> imageUrl,
      Value<bool> isActive,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalProductsTableUpdateCompanionBuilder =
    LocalProductsCompanion Function({
      Value<String> id,
      Value<String?> sku,
      Value<String?> barcode,
      Value<String> name,
      Value<String?> nameAr,
      Value<double> price,
      Value<double?> costPrice,
      Value<double> taxRate,
      Value<String?> unit,
      Value<bool> isWeighted,
      Value<bool> isAgeRestricted,
      Value<int?> minimumAge,
      Value<String?> categoryId,
      Value<String?> imageUrl,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalProductsTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalProductsTable> {
  $$LocalProductsTableFilterComposer({
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

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isWeighted => $composableBuilder(
    column: $table.isWeighted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAgeRestricted => $composableBuilder(
    column: $table.isAgeRestricted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumAge => $composableBuilder(
    column: $table.minimumAge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalProductsTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalProductsTable> {
  $$LocalProductsTableOrderingComposer({
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

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWeighted => $composableBuilder(
    column: $table.isWeighted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAgeRestricted => $composableBuilder(
    column: $table.isAgeRestricted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumAge => $composableBuilder(
    column: $table.minimumAge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalProductsTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalProductsTable> {
  $$LocalProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isWeighted => $composableBuilder(
    column: $table.isWeighted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAgeRestricted => $composableBuilder(
    column: $table.isAgeRestricted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minimumAge => $composableBuilder(
    column: $table.minimumAge,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalProductsTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalProductsTable,
          LocalProduct,
          $$LocalProductsTableFilterComposer,
          $$LocalProductsTableOrderingComposer,
          $$LocalProductsTableAnnotationComposer,
          $$LocalProductsTableCreateCompanionBuilder,
          $$LocalProductsTableUpdateCompanionBuilder,
          (
            LocalProduct,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalProductsTable,
              LocalProduct
            >,
          ),
          LocalProduct,
          PrefetchHooks Function()
        > {
  $$LocalProductsTableTableManager(
    _$PosOfflineDatabase db,
    $LocalProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> sku = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double?> costPrice = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<bool> isWeighted = const Value.absent(),
                Value<bool> isAgeRestricted = const Value.absent(),
                Value<int?> minimumAge = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProductsCompanion(
                id: id,
                sku: sku,
                barcode: barcode,
                name: name,
                nameAr: nameAr,
                price: price,
                costPrice: costPrice,
                taxRate: taxRate,
                unit: unit,
                isWeighted: isWeighted,
                isAgeRestricted: isAgeRestricted,
                minimumAge: minimumAge,
                categoryId: categoryId,
                imageUrl: imageUrl,
                isActive: isActive,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> sku = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                required String name,
                Value<String?> nameAr = const Value.absent(),
                required double price,
                Value<double?> costPrice = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<bool> isWeighted = const Value.absent(),
                Value<bool> isAgeRestricted = const Value.absent(),
                Value<int?> minimumAge = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalProductsCompanion.insert(
                id: id,
                sku: sku,
                barcode: barcode,
                name: name,
                nameAr: nameAr,
                price: price,
                costPrice: costPrice,
                taxRate: taxRate,
                unit: unit,
                isWeighted: isWeighted,
                isAgeRestricted: isAgeRestricted,
                minimumAge: minimumAge,
                categoryId: categoryId,
                imageUrl: imageUrl,
                isActive: isActive,
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

typedef $$LocalProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalProductsTable,
      LocalProduct,
      $$LocalProductsTableFilterComposer,
      $$LocalProductsTableOrderingComposer,
      $$LocalProductsTableAnnotationComposer,
      $$LocalProductsTableCreateCompanionBuilder,
      $$LocalProductsTableUpdateCompanionBuilder,
      (
        LocalProduct,
        BaseReferences<_$PosOfflineDatabase, $LocalProductsTable, LocalProduct>,
      ),
      LocalProduct,
      PrefetchHooks Function()
    >;
typedef $$LocalInventoryTableCreateCompanionBuilder =
    LocalInventoryCompanion Function({
      required String productId,
      required String storeId,
      Value<double> quantity,
      Value<double> reserved,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalInventoryTableUpdateCompanionBuilder =
    LocalInventoryCompanion Function({
      Value<String> productId,
      Value<String> storeId,
      Value<double> quantity,
      Value<double> reserved,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalInventoryTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalInventoryTable> {
  $$LocalInventoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get reserved => $composableBuilder(
    column: $table.reserved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalInventoryTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalInventoryTable> {
  $$LocalInventoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get reserved => $composableBuilder(
    column: $table.reserved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalInventoryTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalInventoryTable> {
  $$LocalInventoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get reserved =>
      $composableBuilder(column: $table.reserved, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalInventoryTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalInventoryTable,
          LocalInventoryData,
          $$LocalInventoryTableFilterComposer,
          $$LocalInventoryTableOrderingComposer,
          $$LocalInventoryTableAnnotationComposer,
          $$LocalInventoryTableCreateCompanionBuilder,
          $$LocalInventoryTableUpdateCompanionBuilder,
          (
            LocalInventoryData,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalInventoryTable,
              LocalInventoryData
            >,
          ),
          LocalInventoryData,
          PrefetchHooks Function()
        > {
  $$LocalInventoryTableTableManager(
    _$PosOfflineDatabase db,
    $LocalInventoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalInventoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalInventoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalInventoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> productId = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> reserved = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalInventoryCompanion(
                productId: productId,
                storeId: storeId,
                quantity: quantity,
                reserved: reserved,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String productId,
                required String storeId,
                Value<double> quantity = const Value.absent(),
                Value<double> reserved = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalInventoryCompanion.insert(
                productId: productId,
                storeId: storeId,
                quantity: quantity,
                reserved: reserved,
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

typedef $$LocalInventoryTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalInventoryTable,
      LocalInventoryData,
      $$LocalInventoryTableFilterComposer,
      $$LocalInventoryTableOrderingComposer,
      $$LocalInventoryTableAnnotationComposer,
      $$LocalInventoryTableCreateCompanionBuilder,
      $$LocalInventoryTableUpdateCompanionBuilder,
      (
        LocalInventoryData,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalInventoryTable,
          LocalInventoryData
        >,
      ),
      LocalInventoryData,
      PrefetchHooks Function()
    >;
typedef $$LocalHeldCartsTableCreateCompanionBuilder =
    LocalHeldCartsCompanion Function({
      required String clientUuid,
      required String storeId,
      Value<String?> registerId,
      required String cashierId,
      Value<String?> customerId,
      Value<String?> name,
      required String itemsJson,
      required double total,
      required DateTime createdAt,
      Value<DateTime?> expiresAt,
      Value<String?> serverId,
      Value<int> rowid,
    });
typedef $$LocalHeldCartsTableUpdateCompanionBuilder =
    LocalHeldCartsCompanion Function({
      Value<String> clientUuid,
      Value<String> storeId,
      Value<String?> registerId,
      Value<String> cashierId,
      Value<String?> customerId,
      Value<String?> name,
      Value<String> itemsJson,
      Value<double> total,
      Value<DateTime> createdAt,
      Value<DateTime?> expiresAt,
      Value<String?> serverId,
      Value<int> rowid,
    });

class $$LocalHeldCartsTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalHeldCartsTable> {
  $$LocalHeldCartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registerId => $composableBuilder(
    column: $table.registerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashierId => $composableBuilder(
    column: $table.cashierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalHeldCartsTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalHeldCartsTable> {
  $$LocalHeldCartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registerId => $composableBuilder(
    column: $table.registerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashierId => $composableBuilder(
    column: $table.cashierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalHeldCartsTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalHeldCartsTable> {
  $$LocalHeldCartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get registerId => $composableBuilder(
    column: $table.registerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cashierId =>
      $composableBuilder(column: $table.cashierId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);
}

class $$LocalHeldCartsTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalHeldCartsTable,
          LocalHeldCart,
          $$LocalHeldCartsTableFilterComposer,
          $$LocalHeldCartsTableOrderingComposer,
          $$LocalHeldCartsTableAnnotationComposer,
          $$LocalHeldCartsTableCreateCompanionBuilder,
          $$LocalHeldCartsTableUpdateCompanionBuilder,
          (
            LocalHeldCart,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalHeldCartsTable,
              LocalHeldCart
            >,
          ),
          LocalHeldCart,
          PrefetchHooks Function()
        > {
  $$LocalHeldCartsTableTableManager(
    _$PosOfflineDatabase db,
    $LocalHeldCartsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalHeldCartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalHeldCartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalHeldCartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientUuid = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String?> registerId = const Value.absent(),
                Value<String> cashierId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalHeldCartsCompanion(
                clientUuid: clientUuid,
                storeId: storeId,
                registerId: registerId,
                cashierId: cashierId,
                customerId: customerId,
                name: name,
                itemsJson: itemsJson,
                total: total,
                createdAt: createdAt,
                expiresAt: expiresAt,
                serverId: serverId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientUuid,
                required String storeId,
                Value<String?> registerId = const Value.absent(),
                required String cashierId,
                Value<String?> customerId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                required String itemsJson,
                required double total,
                required DateTime createdAt,
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalHeldCartsCompanion.insert(
                clientUuid: clientUuid,
                storeId: storeId,
                registerId: registerId,
                cashierId: cashierId,
                customerId: customerId,
                name: name,
                itemsJson: itemsJson,
                total: total,
                createdAt: createdAt,
                expiresAt: expiresAt,
                serverId: serverId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalHeldCartsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalHeldCartsTable,
      LocalHeldCart,
      $$LocalHeldCartsTableFilterComposer,
      $$LocalHeldCartsTableOrderingComposer,
      $$LocalHeldCartsTableAnnotationComposer,
      $$LocalHeldCartsTableCreateCompanionBuilder,
      $$LocalHeldCartsTableUpdateCompanionBuilder,
      (
        LocalHeldCart,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalHeldCartsTable,
          LocalHeldCart
        >,
      ),
      LocalHeldCart,
      PrefetchHooks Function()
    >;
typedef $$LocalTransactionsTableCreateCompanionBuilder =
    LocalTransactionsCompanion Function({
      required String clientUuid,
      Value<String?> serverId,
      required String transactionNumber,
      required String type,
      required String status,
      required String storeId,
      Value<String?> registerId,
      required String cashierId,
      Value<String?> customerId,
      Value<String?> sessionId,
      required double subtotal,
      Value<double> taxAmount,
      Value<double> discountAmount,
      required double totalAmount,
      required String itemsJson,
      required String paymentsJson,
      Value<String?> taxExemptionJson,
      Value<String?> notes,
      Value<String?> returnTransactionId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$LocalTransactionsTableUpdateCompanionBuilder =
    LocalTransactionsCompanion Function({
      Value<String> clientUuid,
      Value<String?> serverId,
      Value<String> transactionNumber,
      Value<String> type,
      Value<String> status,
      Value<String> storeId,
      Value<String?> registerId,
      Value<String> cashierId,
      Value<String?> customerId,
      Value<String?> sessionId,
      Value<double> subtotal,
      Value<double> taxAmount,
      Value<double> discountAmount,
      Value<double> totalAmount,
      Value<String> itemsJson,
      Value<String> paymentsJson,
      Value<String?> taxExemptionJson,
      Value<String?> notes,
      Value<String?> returnTransactionId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalTransactionsTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalTransactionsTable> {
  $$LocalTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionNumber => $composableBuilder(
    column: $table.transactionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registerId => $composableBuilder(
    column: $table.registerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashierId => $composableBuilder(
    column: $table.cashierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentsJson => $composableBuilder(
    column: $table.paymentsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxExemptionJson => $composableBuilder(
    column: $table.taxExemptionJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get returnTransactionId => $composableBuilder(
    column: $table.returnTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTransactionsTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalTransactionsTable> {
  $$LocalTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionNumber => $composableBuilder(
    column: $table.transactionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registerId => $composableBuilder(
    column: $table.registerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashierId => $composableBuilder(
    column: $table.cashierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentsJson => $composableBuilder(
    column: $table.paymentsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxExemptionJson => $composableBuilder(
    column: $table.taxExemptionJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get returnTransactionId => $composableBuilder(
    column: $table.returnTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTransactionsTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalTransactionsTable> {
  $$LocalTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get transactionNumber => $composableBuilder(
    column: $table.transactionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get registerId => $composableBuilder(
    column: $table.registerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cashierId =>
      $composableBuilder(column: $table.cashierId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<String> get paymentsJson => $composableBuilder(
    column: $table.paymentsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taxExemptionJson => $composableBuilder(
    column: $table.taxExemptionJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get returnTransactionId => $composableBuilder(
    column: $table.returnTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalTransactionsTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalTransactionsTable,
          LocalTransaction,
          $$LocalTransactionsTableFilterComposer,
          $$LocalTransactionsTableOrderingComposer,
          $$LocalTransactionsTableAnnotationComposer,
          $$LocalTransactionsTableCreateCompanionBuilder,
          $$LocalTransactionsTableUpdateCompanionBuilder,
          (
            LocalTransaction,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalTransactionsTable,
              LocalTransaction
            >,
          ),
          LocalTransaction,
          PrefetchHooks Function()
        > {
  $$LocalTransactionsTableTableManager(
    _$PosOfflineDatabase db,
    $LocalTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> clientUuid = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> transactionNumber = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String?> registerId = const Value.absent(),
                Value<String> cashierId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> taxAmount = const Value.absent(),
                Value<double> discountAmount = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<String> paymentsJson = const Value.absent(),
                Value<String?> taxExemptionJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> returnTransactionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTransactionsCompanion(
                clientUuid: clientUuid,
                serverId: serverId,
                transactionNumber: transactionNumber,
                type: type,
                status: status,
                storeId: storeId,
                registerId: registerId,
                cashierId: cashierId,
                customerId: customerId,
                sessionId: sessionId,
                subtotal: subtotal,
                taxAmount: taxAmount,
                discountAmount: discountAmount,
                totalAmount: totalAmount,
                itemsJson: itemsJson,
                paymentsJson: paymentsJson,
                taxExemptionJson: taxExemptionJson,
                notes: notes,
                returnTransactionId: returnTransactionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientUuid,
                Value<String?> serverId = const Value.absent(),
                required String transactionNumber,
                required String type,
                required String status,
                required String storeId,
                Value<String?> registerId = const Value.absent(),
                required String cashierId,
                Value<String?> customerId = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                required double subtotal,
                Value<double> taxAmount = const Value.absent(),
                Value<double> discountAmount = const Value.absent(),
                required double totalAmount,
                required String itemsJson,
                required String paymentsJson,
                Value<String?> taxExemptionJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> returnTransactionId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalTransactionsCompanion.insert(
                clientUuid: clientUuid,
                serverId: serverId,
                transactionNumber: transactionNumber,
                type: type,
                status: status,
                storeId: storeId,
                registerId: registerId,
                cashierId: cashierId,
                customerId: customerId,
                sessionId: sessionId,
                subtotal: subtotal,
                taxAmount: taxAmount,
                discountAmount: discountAmount,
                totalAmount: totalAmount,
                itemsJson: itemsJson,
                paymentsJson: paymentsJson,
                taxExemptionJson: taxExemptionJson,
                notes: notes,
                returnTransactionId: returnTransactionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalTransactionsTable,
      LocalTransaction,
      $$LocalTransactionsTableFilterComposer,
      $$LocalTransactionsTableOrderingComposer,
      $$LocalTransactionsTableAnnotationComposer,
      $$LocalTransactionsTableCreateCompanionBuilder,
      $$LocalTransactionsTableUpdateCompanionBuilder,
      (
        LocalTransaction,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalTransactionsTable,
          LocalTransaction
        >,
      ),
      LocalTransaction,
      PrefetchHooks Function()
    >;
typedef $$LocalSyncQueueTableCreateCompanionBuilder =
    LocalSyncQueueCompanion Function({
      Value<int> id,
      required String clientUuid,
      required String kind,
      required String payloadJson,
      Value<int> attempts,
      Value<String?> lastError,
      required DateTime createdAt,
      required DateTime nextAttemptAt,
      Value<String> status,
    });
typedef $$LocalSyncQueueTableUpdateCompanionBuilder =
    LocalSyncQueueCompanion Function({
      Value<int> id,
      Value<String> clientUuid,
      Value<String> kind,
      Value<String> payloadJson,
      Value<int> attempts,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime> nextAttemptAt,
      Value<String> status,
    });

class $$LocalSyncQueueTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalSyncQueueTable> {
  $$LocalSyncQueueTableFilterComposer({
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

  ColumnFilters<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSyncQueueTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalSyncQueueTable> {
  $$LocalSyncQueueTableOrderingComposer({
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

  ColumnOrderings<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSyncQueueTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalSyncQueueTable> {
  $$LocalSyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$LocalSyncQueueTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalSyncQueueTable,
          LocalSyncQueueData,
          $$LocalSyncQueueTableFilterComposer,
          $$LocalSyncQueueTableOrderingComposer,
          $$LocalSyncQueueTableAnnotationComposer,
          $$LocalSyncQueueTableCreateCompanionBuilder,
          $$LocalSyncQueueTableUpdateCompanionBuilder,
          (
            LocalSyncQueueData,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalSyncQueueTable,
              LocalSyncQueueData
            >,
          ),
          LocalSyncQueueData,
          PrefetchHooks Function()
        > {
  $$LocalSyncQueueTableTableManager(
    _$PosOfflineDatabase db,
    $LocalSyncQueueTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> clientUuid = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> nextAttemptAt = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => LocalSyncQueueCompanion(
                id: id,
                clientUuid: clientUuid,
                kind: kind,
                payloadJson: payloadJson,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
                nextAttemptAt: nextAttemptAt,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String clientUuid,
                required String kind,
                required String payloadJson,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required DateTime createdAt,
                required DateTime nextAttemptAt,
                Value<String> status = const Value.absent(),
              }) => LocalSyncQueueCompanion.insert(
                id: id,
                clientUuid: clientUuid,
                kind: kind,
                payloadJson: payloadJson,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
                nextAttemptAt: nextAttemptAt,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalSyncQueueTable,
      LocalSyncQueueData,
      $$LocalSyncQueueTableFilterComposer,
      $$LocalSyncQueueTableOrderingComposer,
      $$LocalSyncQueueTableAnnotationComposer,
      $$LocalSyncQueueTableCreateCompanionBuilder,
      $$LocalSyncQueueTableUpdateCompanionBuilder,
      (
        LocalSyncQueueData,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalSyncQueueTable,
          LocalSyncQueueData
        >,
      ),
      LocalSyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$LocalCategoriesTableCreateCompanionBuilder =
    LocalCategoriesCompanion Function({
      required String id,
      Value<String?> parentId,
      required String name,
      Value<String?> nameAr,
      Value<String?> colorHex,
      Value<String?> iconName,
      Value<int> sortOrder,
      Value<bool> isActive,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalCategoriesTableUpdateCompanionBuilder =
    LocalCategoriesCompanion Function({
      Value<String> id,
      Value<String?> parentId,
      Value<String> name,
      Value<String?> nameAr,
      Value<String?> colorHex,
      Value<String?> iconName,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalCategoriesTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalCategoriesTable> {
  $$LocalCategoriesTableFilterComposer({
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

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCategoriesTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalCategoriesTable> {
  $$LocalCategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCategoriesTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalCategoriesTable> {
  $$LocalCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalCategoriesTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalCategoriesTable,
          LocalCategory,
          $$LocalCategoriesTableFilterComposer,
          $$LocalCategoriesTableOrderingComposer,
          $$LocalCategoriesTableAnnotationComposer,
          $$LocalCategoriesTableCreateCompanionBuilder,
          $$LocalCategoriesTableUpdateCompanionBuilder,
          (
            LocalCategory,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalCategoriesTable,
              LocalCategory
            >,
          ),
          LocalCategory,
          PrefetchHooks Function()
        > {
  $$LocalCategoriesTableTableManager(
    _$PosOfflineDatabase db,
    $LocalCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCategoriesCompanion(
                id: id,
                parentId: parentId,
                name: name,
                nameAr: nameAr,
                colorHex: colorHex,
                iconName: iconName,
                sortOrder: sortOrder,
                isActive: isActive,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> parentId = const Value.absent(),
                required String name,
                Value<String?> nameAr = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalCategoriesCompanion.insert(
                id: id,
                parentId: parentId,
                name: name,
                nameAr: nameAr,
                colorHex: colorHex,
                iconName: iconName,
                sortOrder: sortOrder,
                isActive: isActive,
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

typedef $$LocalCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalCategoriesTable,
      LocalCategory,
      $$LocalCategoriesTableFilterComposer,
      $$LocalCategoriesTableOrderingComposer,
      $$LocalCategoriesTableAnnotationComposer,
      $$LocalCategoriesTableCreateCompanionBuilder,
      $$LocalCategoriesTableUpdateCompanionBuilder,
      (
        LocalCategory,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalCategoriesTable,
          LocalCategory
        >,
      ),
      LocalCategory,
      PrefetchHooks Function()
    >;
typedef $$LocalSuppliersTableCreateCompanionBuilder =
    LocalSuppliersCompanion Function({
      required String id,
      required String name,
      Value<String?> contactPerson,
      Value<String?> phone,
      Value<String?> email,
      Value<bool> isActive,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalSuppliersTableUpdateCompanionBuilder =
    LocalSuppliersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> contactPerson,
      Value<String?> phone,
      Value<String?> email,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalSuppliersTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalSuppliersTable> {
  $$LocalSuppliersTableFilterComposer({
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

  ColumnFilters<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSuppliersTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalSuppliersTable> {
  $$LocalSuppliersTableOrderingComposer({
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

  ColumnOrderings<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSuppliersTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalSuppliersTable> {
  $$LocalSuppliersTableAnnotationComposer({
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

  GeneratedColumn<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalSuppliersTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalSuppliersTable,
          LocalSupplier,
          $$LocalSuppliersTableFilterComposer,
          $$LocalSuppliersTableOrderingComposer,
          $$LocalSuppliersTableAnnotationComposer,
          $$LocalSuppliersTableCreateCompanionBuilder,
          $$LocalSuppliersTableUpdateCompanionBuilder,
          (
            LocalSupplier,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalSuppliersTable,
              LocalSupplier
            >,
          ),
          LocalSupplier,
          PrefetchHooks Function()
        > {
  $$LocalSuppliersTableTableManager(
    _$PosOfflineDatabase db,
    $LocalSuppliersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> contactPerson = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSuppliersCompanion(
                id: id,
                name: name,
                contactPerson: contactPerson,
                phone: phone,
                email: email,
                isActive: isActive,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> contactPerson = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalSuppliersCompanion.insert(
                id: id,
                name: name,
                contactPerson: contactPerson,
                phone: phone,
                email: email,
                isActive: isActive,
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

typedef $$LocalSuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalSuppliersTable,
      LocalSupplier,
      $$LocalSuppliersTableFilterComposer,
      $$LocalSuppliersTableOrderingComposer,
      $$LocalSuppliersTableAnnotationComposer,
      $$LocalSuppliersTableCreateCompanionBuilder,
      $$LocalSuppliersTableUpdateCompanionBuilder,
      (
        LocalSupplier,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalSuppliersTable,
          LocalSupplier
        >,
      ),
      LocalSupplier,
      PrefetchHooks Function()
    >;
typedef $$LocalProductSuppliersTableCreateCompanionBuilder =
    LocalProductSuppliersCompanion Function({
      required String productId,
      required String supplierId,
      Value<double?> costPrice,
      Value<String?> supplierSku,
      Value<int?> leadTimeDays,
      Value<bool> isPreferred,
      Value<int> rowid,
    });
typedef $$LocalProductSuppliersTableUpdateCompanionBuilder =
    LocalProductSuppliersCompanion Function({
      Value<String> productId,
      Value<String> supplierId,
      Value<double?> costPrice,
      Value<String?> supplierSku,
      Value<int?> leadTimeDays,
      Value<bool> isPreferred,
      Value<int> rowid,
    });

class $$LocalProductSuppliersTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalProductSuppliersTable> {
  $$LocalProductSuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierSku => $composableBuilder(
    column: $table.supplierSku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leadTimeDays => $composableBuilder(
    column: $table.leadTimeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPreferred => $composableBuilder(
    column: $table.isPreferred,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalProductSuppliersTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalProductSuppliersTable> {
  $$LocalProductSuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierSku => $composableBuilder(
    column: $table.supplierSku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leadTimeDays => $composableBuilder(
    column: $table.leadTimeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPreferred => $composableBuilder(
    column: $table.isPreferred,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalProductSuppliersTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalProductSuppliersTable> {
  $$LocalProductSuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<String> get supplierSku => $composableBuilder(
    column: $table.supplierSku,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leadTimeDays => $composableBuilder(
    column: $table.leadTimeDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPreferred => $composableBuilder(
    column: $table.isPreferred,
    builder: (column) => column,
  );
}

class $$LocalProductSuppliersTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalProductSuppliersTable,
          LocalProductSupplier,
          $$LocalProductSuppliersTableFilterComposer,
          $$LocalProductSuppliersTableOrderingComposer,
          $$LocalProductSuppliersTableAnnotationComposer,
          $$LocalProductSuppliersTableCreateCompanionBuilder,
          $$LocalProductSuppliersTableUpdateCompanionBuilder,
          (
            LocalProductSupplier,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalProductSuppliersTable,
              LocalProductSupplier
            >,
          ),
          LocalProductSupplier,
          PrefetchHooks Function()
        > {
  $$LocalProductSuppliersTableTableManager(
    _$PosOfflineDatabase db,
    $LocalProductSuppliersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProductSuppliersTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalProductSuppliersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalProductSuppliersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> productId = const Value.absent(),
                Value<String> supplierId = const Value.absent(),
                Value<double?> costPrice = const Value.absent(),
                Value<String?> supplierSku = const Value.absent(),
                Value<int?> leadTimeDays = const Value.absent(),
                Value<bool> isPreferred = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProductSuppliersCompanion(
                productId: productId,
                supplierId: supplierId,
                costPrice: costPrice,
                supplierSku: supplierSku,
                leadTimeDays: leadTimeDays,
                isPreferred: isPreferred,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String productId,
                required String supplierId,
                Value<double?> costPrice = const Value.absent(),
                Value<String?> supplierSku = const Value.absent(),
                Value<int?> leadTimeDays = const Value.absent(),
                Value<bool> isPreferred = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProductSuppliersCompanion.insert(
                productId: productId,
                supplierId: supplierId,
                costPrice: costPrice,
                supplierSku: supplierSku,
                leadTimeDays: leadTimeDays,
                isPreferred: isPreferred,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalProductSuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalProductSuppliersTable,
      LocalProductSupplier,
      $$LocalProductSuppliersTableFilterComposer,
      $$LocalProductSuppliersTableOrderingComposer,
      $$LocalProductSuppliersTableAnnotationComposer,
      $$LocalProductSuppliersTableCreateCompanionBuilder,
      $$LocalProductSuppliersTableUpdateCompanionBuilder,
      (
        LocalProductSupplier,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalProductSuppliersTable,
          LocalProductSupplier
        >,
      ),
      LocalProductSupplier,
      PrefetchHooks Function()
    >;
typedef $$LocalProductVariantsTableCreateCompanionBuilder =
    LocalProductVariantsCompanion Function({
      required String id,
      required String productId,
      Value<String?> sku,
      Value<String?> barcode,
      required String name,
      Value<String> attributesJson,
      Value<double> priceDelta,
      Value<double?> costPrice,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$LocalProductVariantsTableUpdateCompanionBuilder =
    LocalProductVariantsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String?> sku,
      Value<String?> barcode,
      Value<String> name,
      Value<String> attributesJson,
      Value<double> priceDelta,
      Value<double?> costPrice,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$LocalProductVariantsTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalProductVariantsTable> {
  $$LocalProductVariantsTableFilterComposer({
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

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attributesJson => $composableBuilder(
    column: $table.attributesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceDelta => $composableBuilder(
    column: $table.priceDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalProductVariantsTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalProductVariantsTable> {
  $$LocalProductVariantsTableOrderingComposer({
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

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attributesJson => $composableBuilder(
    column: $table.attributesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceDelta => $composableBuilder(
    column: $table.priceDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalProductVariantsTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalProductVariantsTable> {
  $$LocalProductVariantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get attributesJson => $composableBuilder(
    column: $table.attributesJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get priceDelta => $composableBuilder(
    column: $table.priceDelta,
    builder: (column) => column,
  );

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$LocalProductVariantsTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalProductVariantsTable,
          LocalProductVariant,
          $$LocalProductVariantsTableFilterComposer,
          $$LocalProductVariantsTableOrderingComposer,
          $$LocalProductVariantsTableAnnotationComposer,
          $$LocalProductVariantsTableCreateCompanionBuilder,
          $$LocalProductVariantsTableUpdateCompanionBuilder,
          (
            LocalProductVariant,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalProductVariantsTable,
              LocalProductVariant
            >,
          ),
          LocalProductVariant,
          PrefetchHooks Function()
        > {
  $$LocalProductVariantsTableTableManager(
    _$PosOfflineDatabase db,
    $LocalProductVariantsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProductVariantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProductVariantsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalProductVariantsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String?> sku = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> attributesJson = const Value.absent(),
                Value<double> priceDelta = const Value.absent(),
                Value<double?> costPrice = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProductVariantsCompanion(
                id: id,
                productId: productId,
                sku: sku,
                barcode: barcode,
                name: name,
                attributesJson: attributesJson,
                priceDelta: priceDelta,
                costPrice: costPrice,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                Value<String?> sku = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                required String name,
                Value<String> attributesJson = const Value.absent(),
                Value<double> priceDelta = const Value.absent(),
                Value<double?> costPrice = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProductVariantsCompanion.insert(
                id: id,
                productId: productId,
                sku: sku,
                barcode: barcode,
                name: name,
                attributesJson: attributesJson,
                priceDelta: priceDelta,
                costPrice: costPrice,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalProductVariantsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalProductVariantsTable,
      LocalProductVariant,
      $$LocalProductVariantsTableFilterComposer,
      $$LocalProductVariantsTableOrderingComposer,
      $$LocalProductVariantsTableAnnotationComposer,
      $$LocalProductVariantsTableCreateCompanionBuilder,
      $$LocalProductVariantsTableUpdateCompanionBuilder,
      (
        LocalProductVariant,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalProductVariantsTable,
          LocalProductVariant
        >,
      ),
      LocalProductVariant,
      PrefetchHooks Function()
    >;
typedef $$LocalModifierGroupsTableCreateCompanionBuilder =
    LocalModifierGroupsCompanion Function({
      required String id,
      required String productId,
      required String name,
      Value<String?> nameAr,
      Value<int> minSelect,
      Value<int?> maxSelect,
      Value<bool> isRequired,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$LocalModifierGroupsTableUpdateCompanionBuilder =
    LocalModifierGroupsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> name,
      Value<String?> nameAr,
      Value<int> minSelect,
      Value<int?> maxSelect,
      Value<bool> isRequired,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$LocalModifierGroupsTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalModifierGroupsTable> {
  $$LocalModifierGroupsTableFilterComposer({
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

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minSelect => $composableBuilder(
    column: $table.minSelect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxSelect => $composableBuilder(
    column: $table.maxSelect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalModifierGroupsTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalModifierGroupsTable> {
  $$LocalModifierGroupsTableOrderingComposer({
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

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minSelect => $composableBuilder(
    column: $table.minSelect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxSelect => $composableBuilder(
    column: $table.maxSelect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalModifierGroupsTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalModifierGroupsTable> {
  $$LocalModifierGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<int> get minSelect =>
      $composableBuilder(column: $table.minSelect, builder: (column) => column);

  GeneratedColumn<int> get maxSelect =>
      $composableBuilder(column: $table.maxSelect, builder: (column) => column);

  GeneratedColumn<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$LocalModifierGroupsTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalModifierGroupsTable,
          LocalModifierGroup,
          $$LocalModifierGroupsTableFilterComposer,
          $$LocalModifierGroupsTableOrderingComposer,
          $$LocalModifierGroupsTableAnnotationComposer,
          $$LocalModifierGroupsTableCreateCompanionBuilder,
          $$LocalModifierGroupsTableUpdateCompanionBuilder,
          (
            LocalModifierGroup,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalModifierGroupsTable,
              LocalModifierGroup
            >,
          ),
          LocalModifierGroup,
          PrefetchHooks Function()
        > {
  $$LocalModifierGroupsTableTableManager(
    _$PosOfflineDatabase db,
    $LocalModifierGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalModifierGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalModifierGroupsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalModifierGroupsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                Value<int> minSelect = const Value.absent(),
                Value<int?> maxSelect = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalModifierGroupsCompanion(
                id: id,
                productId: productId,
                name: name,
                nameAr: nameAr,
                minSelect: minSelect,
                maxSelect: maxSelect,
                isRequired: isRequired,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String name,
                Value<String?> nameAr = const Value.absent(),
                Value<int> minSelect = const Value.absent(),
                Value<int?> maxSelect = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalModifierGroupsCompanion.insert(
                id: id,
                productId: productId,
                name: name,
                nameAr: nameAr,
                minSelect: minSelect,
                maxSelect: maxSelect,
                isRequired: isRequired,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalModifierGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalModifierGroupsTable,
      LocalModifierGroup,
      $$LocalModifierGroupsTableFilterComposer,
      $$LocalModifierGroupsTableOrderingComposer,
      $$LocalModifierGroupsTableAnnotationComposer,
      $$LocalModifierGroupsTableCreateCompanionBuilder,
      $$LocalModifierGroupsTableUpdateCompanionBuilder,
      (
        LocalModifierGroup,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalModifierGroupsTable,
          LocalModifierGroup
        >,
      ),
      LocalModifierGroup,
      PrefetchHooks Function()
    >;
typedef $$LocalModifierOptionsTableCreateCompanionBuilder =
    LocalModifierOptionsCompanion Function({
      required String id,
      required String groupId,
      required String name,
      Value<String?> nameAr,
      Value<double> priceDelta,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$LocalModifierOptionsTableUpdateCompanionBuilder =
    LocalModifierOptionsCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> name,
      Value<String?> nameAr,
      Value<double> priceDelta,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$LocalModifierOptionsTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalModifierOptionsTable> {
  $$LocalModifierOptionsTableFilterComposer({
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

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceDelta => $composableBuilder(
    column: $table.priceDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalModifierOptionsTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalModifierOptionsTable> {
  $$LocalModifierOptionsTableOrderingComposer({
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

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceDelta => $composableBuilder(
    column: $table.priceDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalModifierOptionsTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalModifierOptionsTable> {
  $$LocalModifierOptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<double> get priceDelta => $composableBuilder(
    column: $table.priceDelta,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$LocalModifierOptionsTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalModifierOptionsTable,
          LocalModifierOption,
          $$LocalModifierOptionsTableFilterComposer,
          $$LocalModifierOptionsTableOrderingComposer,
          $$LocalModifierOptionsTableAnnotationComposer,
          $$LocalModifierOptionsTableCreateCompanionBuilder,
          $$LocalModifierOptionsTableUpdateCompanionBuilder,
          (
            LocalModifierOption,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalModifierOptionsTable,
              LocalModifierOption
            >,
          ),
          LocalModifierOption,
          PrefetchHooks Function()
        > {
  $$LocalModifierOptionsTableTableManager(
    _$PosOfflineDatabase db,
    $LocalModifierOptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalModifierOptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalModifierOptionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalModifierOptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                Value<double> priceDelta = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalModifierOptionsCompanion(
                id: id,
                groupId: groupId,
                name: name,
                nameAr: nameAr,
                priceDelta: priceDelta,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String name,
                Value<String?> nameAr = const Value.absent(),
                Value<double> priceDelta = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalModifierOptionsCompanion.insert(
                id: id,
                groupId: groupId,
                name: name,
                nameAr: nameAr,
                priceDelta: priceDelta,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalModifierOptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalModifierOptionsTable,
      LocalModifierOption,
      $$LocalModifierOptionsTableFilterComposer,
      $$LocalModifierOptionsTableOrderingComposer,
      $$LocalModifierOptionsTableAnnotationComposer,
      $$LocalModifierOptionsTableCreateCompanionBuilder,
      $$LocalModifierOptionsTableUpdateCompanionBuilder,
      (
        LocalModifierOption,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalModifierOptionsTable,
          LocalModifierOption
        >,
      ),
      LocalModifierOption,
      PrefetchHooks Function()
    >;
typedef $$LocalPromotionsTableCreateCompanionBuilder =
    LocalPromotionsCompanion Function({
      required String id,
      required String name,
      required String type,
      Value<double?> discountValue,
      Value<int?> buyQuantity,
      Value<int?> getQuantity,
      Value<double?> getDiscountPercent,
      Value<double?> bundlePrice,
      Value<double?> minOrderTotal,
      Value<int?> minItemQuantity,
      Value<DateTime?> validFrom,
      Value<DateTime?> validTo,
      Value<String> activeDaysJson,
      Value<String?> activeTimeFrom,
      Value<String?> activeTimeTo,
      Value<int?> maxUses,
      Value<int?> maxUsesPerCustomer,
      Value<int> usageCount,
      Value<bool> isStackable,
      Value<bool> isActive,
      Value<bool> isCoupon,
      Value<String> productIdsJson,
      Value<String> categoryIdsJson,
      Value<String> customerGroupIdsJson,
      Value<String> bundleProductsJson,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalPromotionsTableUpdateCompanionBuilder =
    LocalPromotionsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<double?> discountValue,
      Value<int?> buyQuantity,
      Value<int?> getQuantity,
      Value<double?> getDiscountPercent,
      Value<double?> bundlePrice,
      Value<double?> minOrderTotal,
      Value<int?> minItemQuantity,
      Value<DateTime?> validFrom,
      Value<DateTime?> validTo,
      Value<String> activeDaysJson,
      Value<String?> activeTimeFrom,
      Value<String?> activeTimeTo,
      Value<int?> maxUses,
      Value<int?> maxUsesPerCustomer,
      Value<int> usageCount,
      Value<bool> isStackable,
      Value<bool> isActive,
      Value<bool> isCoupon,
      Value<String> productIdsJson,
      Value<String> categoryIdsJson,
      Value<String> customerGroupIdsJson,
      Value<String> bundleProductsJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalPromotionsTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalPromotionsTable> {
  $$LocalPromotionsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get buyQuantity => $composableBuilder(
    column: $table.buyQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get getQuantity => $composableBuilder(
    column: $table.getQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get getDiscountPercent => $composableBuilder(
    column: $table.getDiscountPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bundlePrice => $composableBuilder(
    column: $table.bundlePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minOrderTotal => $composableBuilder(
    column: $table.minOrderTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minItemQuantity => $composableBuilder(
    column: $table.minItemQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validTo => $composableBuilder(
    column: $table.validTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeDaysJson => $composableBuilder(
    column: $table.activeDaysJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeTimeFrom => $composableBuilder(
    column: $table.activeTimeFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeTimeTo => $composableBuilder(
    column: $table.activeTimeTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxUses => $composableBuilder(
    column: $table.maxUses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxUsesPerCustomer => $composableBuilder(
    column: $table.maxUsesPerCustomer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStackable => $composableBuilder(
    column: $table.isStackable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCoupon => $composableBuilder(
    column: $table.isCoupon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productIdsJson => $composableBuilder(
    column: $table.productIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryIdsJson => $composableBuilder(
    column: $table.categoryIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerGroupIdsJson => $composableBuilder(
    column: $table.customerGroupIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bundleProductsJson => $composableBuilder(
    column: $table.bundleProductsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPromotionsTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalPromotionsTable> {
  $$LocalPromotionsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get buyQuantity => $composableBuilder(
    column: $table.buyQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get getQuantity => $composableBuilder(
    column: $table.getQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get getDiscountPercent => $composableBuilder(
    column: $table.getDiscountPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bundlePrice => $composableBuilder(
    column: $table.bundlePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minOrderTotal => $composableBuilder(
    column: $table.minOrderTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minItemQuantity => $composableBuilder(
    column: $table.minItemQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validTo => $composableBuilder(
    column: $table.validTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeDaysJson => $composableBuilder(
    column: $table.activeDaysJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeTimeFrom => $composableBuilder(
    column: $table.activeTimeFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeTimeTo => $composableBuilder(
    column: $table.activeTimeTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxUses => $composableBuilder(
    column: $table.maxUses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxUsesPerCustomer => $composableBuilder(
    column: $table.maxUsesPerCustomer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStackable => $composableBuilder(
    column: $table.isStackable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCoupon => $composableBuilder(
    column: $table.isCoupon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productIdsJson => $composableBuilder(
    column: $table.productIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryIdsJson => $composableBuilder(
    column: $table.categoryIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerGroupIdsJson => $composableBuilder(
    column: $table.customerGroupIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bundleProductsJson => $composableBuilder(
    column: $table.bundleProductsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPromotionsTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalPromotionsTable> {
  $$LocalPromotionsTableAnnotationComposer({
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get buyQuantity => $composableBuilder(
    column: $table.buyQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get getQuantity => $composableBuilder(
    column: $table.getQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get getDiscountPercent => $composableBuilder(
    column: $table.getDiscountPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bundlePrice => $composableBuilder(
    column: $table.bundlePrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minOrderTotal => $composableBuilder(
    column: $table.minOrderTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minItemQuantity => $composableBuilder(
    column: $table.minItemQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get validTo =>
      $composableBuilder(column: $table.validTo, builder: (column) => column);

  GeneratedColumn<String> get activeDaysJson => $composableBuilder(
    column: $table.activeDaysJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeTimeFrom => $composableBuilder(
    column: $table.activeTimeFrom,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeTimeTo => $composableBuilder(
    column: $table.activeTimeTo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxUses =>
      $composableBuilder(column: $table.maxUses, builder: (column) => column);

  GeneratedColumn<int> get maxUsesPerCustomer => $composableBuilder(
    column: $table.maxUsesPerCustomer,
    builder: (column) => column,
  );

  GeneratedColumn<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isStackable => $composableBuilder(
    column: $table.isStackable,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isCoupon =>
      $composableBuilder(column: $table.isCoupon, builder: (column) => column);

  GeneratedColumn<String> get productIdsJson => $composableBuilder(
    column: $table.productIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryIdsJson => $composableBuilder(
    column: $table.categoryIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerGroupIdsJson => $composableBuilder(
    column: $table.customerGroupIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bundleProductsJson => $composableBuilder(
    column: $table.bundleProductsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalPromotionsTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalPromotionsTable,
          LocalPromotion,
          $$LocalPromotionsTableFilterComposer,
          $$LocalPromotionsTableOrderingComposer,
          $$LocalPromotionsTableAnnotationComposer,
          $$LocalPromotionsTableCreateCompanionBuilder,
          $$LocalPromotionsTableUpdateCompanionBuilder,
          (
            LocalPromotion,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalPromotionsTable,
              LocalPromotion
            >,
          ),
          LocalPromotion,
          PrefetchHooks Function()
        > {
  $$LocalPromotionsTableTableManager(
    _$PosOfflineDatabase db,
    $LocalPromotionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPromotionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPromotionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalPromotionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double?> discountValue = const Value.absent(),
                Value<int?> buyQuantity = const Value.absent(),
                Value<int?> getQuantity = const Value.absent(),
                Value<double?> getDiscountPercent = const Value.absent(),
                Value<double?> bundlePrice = const Value.absent(),
                Value<double?> minOrderTotal = const Value.absent(),
                Value<int?> minItemQuantity = const Value.absent(),
                Value<DateTime?> validFrom = const Value.absent(),
                Value<DateTime?> validTo = const Value.absent(),
                Value<String> activeDaysJson = const Value.absent(),
                Value<String?> activeTimeFrom = const Value.absent(),
                Value<String?> activeTimeTo = const Value.absent(),
                Value<int?> maxUses = const Value.absent(),
                Value<int?> maxUsesPerCustomer = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<bool> isStackable = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isCoupon = const Value.absent(),
                Value<String> productIdsJson = const Value.absent(),
                Value<String> categoryIdsJson = const Value.absent(),
                Value<String> customerGroupIdsJson = const Value.absent(),
                Value<String> bundleProductsJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPromotionsCompanion(
                id: id,
                name: name,
                type: type,
                discountValue: discountValue,
                buyQuantity: buyQuantity,
                getQuantity: getQuantity,
                getDiscountPercent: getDiscountPercent,
                bundlePrice: bundlePrice,
                minOrderTotal: minOrderTotal,
                minItemQuantity: minItemQuantity,
                validFrom: validFrom,
                validTo: validTo,
                activeDaysJson: activeDaysJson,
                activeTimeFrom: activeTimeFrom,
                activeTimeTo: activeTimeTo,
                maxUses: maxUses,
                maxUsesPerCustomer: maxUsesPerCustomer,
                usageCount: usageCount,
                isStackable: isStackable,
                isActive: isActive,
                isCoupon: isCoupon,
                productIdsJson: productIdsJson,
                categoryIdsJson: categoryIdsJson,
                customerGroupIdsJson: customerGroupIdsJson,
                bundleProductsJson: bundleProductsJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                Value<double?> discountValue = const Value.absent(),
                Value<int?> buyQuantity = const Value.absent(),
                Value<int?> getQuantity = const Value.absent(),
                Value<double?> getDiscountPercent = const Value.absent(),
                Value<double?> bundlePrice = const Value.absent(),
                Value<double?> minOrderTotal = const Value.absent(),
                Value<int?> minItemQuantity = const Value.absent(),
                Value<DateTime?> validFrom = const Value.absent(),
                Value<DateTime?> validTo = const Value.absent(),
                Value<String> activeDaysJson = const Value.absent(),
                Value<String?> activeTimeFrom = const Value.absent(),
                Value<String?> activeTimeTo = const Value.absent(),
                Value<int?> maxUses = const Value.absent(),
                Value<int?> maxUsesPerCustomer = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<bool> isStackable = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isCoupon = const Value.absent(),
                Value<String> productIdsJson = const Value.absent(),
                Value<String> categoryIdsJson = const Value.absent(),
                Value<String> customerGroupIdsJson = const Value.absent(),
                Value<String> bundleProductsJson = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalPromotionsCompanion.insert(
                id: id,
                name: name,
                type: type,
                discountValue: discountValue,
                buyQuantity: buyQuantity,
                getQuantity: getQuantity,
                getDiscountPercent: getDiscountPercent,
                bundlePrice: bundlePrice,
                minOrderTotal: minOrderTotal,
                minItemQuantity: minItemQuantity,
                validFrom: validFrom,
                validTo: validTo,
                activeDaysJson: activeDaysJson,
                activeTimeFrom: activeTimeFrom,
                activeTimeTo: activeTimeTo,
                maxUses: maxUses,
                maxUsesPerCustomer: maxUsesPerCustomer,
                usageCount: usageCount,
                isStackable: isStackable,
                isActive: isActive,
                isCoupon: isCoupon,
                productIdsJson: productIdsJson,
                categoryIdsJson: categoryIdsJson,
                customerGroupIdsJson: customerGroupIdsJson,
                bundleProductsJson: bundleProductsJson,
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

typedef $$LocalPromotionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalPromotionsTable,
      LocalPromotion,
      $$LocalPromotionsTableFilterComposer,
      $$LocalPromotionsTableOrderingComposer,
      $$LocalPromotionsTableAnnotationComposer,
      $$LocalPromotionsTableCreateCompanionBuilder,
      $$LocalPromotionsTableUpdateCompanionBuilder,
      (
        LocalPromotion,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalPromotionsTable,
          LocalPromotion
        >,
      ),
      LocalPromotion,
      PrefetchHooks Function()
    >;
typedef $$LocalCouponCodesTableCreateCompanionBuilder =
    LocalCouponCodesCompanion Function({
      required String id,
      required String promotionId,
      required String code,
      Value<int?> maxUses,
      Value<int> usageCount,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$LocalCouponCodesTableUpdateCompanionBuilder =
    LocalCouponCodesCompanion Function({
      Value<String> id,
      Value<String> promotionId,
      Value<String> code,
      Value<int?> maxUses,
      Value<int> usageCount,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$LocalCouponCodesTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalCouponCodesTable> {
  $$LocalCouponCodesTableFilterComposer({
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

  ColumnFilters<String> get promotionId => $composableBuilder(
    column: $table.promotionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxUses => $composableBuilder(
    column: $table.maxUses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCouponCodesTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalCouponCodesTable> {
  $$LocalCouponCodesTableOrderingComposer({
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

  ColumnOrderings<String> get promotionId => $composableBuilder(
    column: $table.promotionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxUses => $composableBuilder(
    column: $table.maxUses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCouponCodesTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalCouponCodesTable> {
  $$LocalCouponCodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get promotionId => $composableBuilder(
    column: $table.promotionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get maxUses =>
      $composableBuilder(column: $table.maxUses, builder: (column) => column);

  GeneratedColumn<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$LocalCouponCodesTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalCouponCodesTable,
          LocalCouponCode,
          $$LocalCouponCodesTableFilterComposer,
          $$LocalCouponCodesTableOrderingComposer,
          $$LocalCouponCodesTableAnnotationComposer,
          $$LocalCouponCodesTableCreateCompanionBuilder,
          $$LocalCouponCodesTableUpdateCompanionBuilder,
          (
            LocalCouponCode,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalCouponCodesTable,
              LocalCouponCode
            >,
          ),
          LocalCouponCode,
          PrefetchHooks Function()
        > {
  $$LocalCouponCodesTableTableManager(
    _$PosOfflineDatabase db,
    $LocalCouponCodesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCouponCodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCouponCodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCouponCodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> promotionId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int?> maxUses = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCouponCodesCompanion(
                id: id,
                promotionId: promotionId,
                code: code,
                maxUses: maxUses,
                usageCount: usageCount,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String promotionId,
                required String code,
                Value<int?> maxUses = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCouponCodesCompanion.insert(
                id: id,
                promotionId: promotionId,
                code: code,
                maxUses: maxUses,
                usageCount: usageCount,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCouponCodesTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalCouponCodesTable,
      LocalCouponCode,
      $$LocalCouponCodesTableFilterComposer,
      $$LocalCouponCodesTableOrderingComposer,
      $$LocalCouponCodesTableAnnotationComposer,
      $$LocalCouponCodesTableCreateCompanionBuilder,
      $$LocalCouponCodesTableUpdateCompanionBuilder,
      (
        LocalCouponCode,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalCouponCodesTable,
          LocalCouponCode
        >,
      ),
      LocalCouponCode,
      PrefetchHooks Function()
    >;
typedef $$LocalLabelTemplatesTableCreateCompanionBuilder =
    LocalLabelTemplatesCompanion Function({
      required String id,
      required String organizationId,
      required String name,
      required double labelWidthMm,
      required double labelHeightMm,
      required String layoutJson,
      Value<bool> isPreset,
      Value<bool> isDefault,
      Value<int> syncVersion,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalLabelTemplatesTableUpdateCompanionBuilder =
    LocalLabelTemplatesCompanion Function({
      Value<String> id,
      Value<String> organizationId,
      Value<String> name,
      Value<double> labelWidthMm,
      Value<double> labelHeightMm,
      Value<String> layoutJson,
      Value<bool> isPreset,
      Value<bool> isDefault,
      Value<int> syncVersion,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalLabelTemplatesTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalLabelTemplatesTable> {
  $$LocalLabelTemplatesTableFilterComposer({
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

  ColumnFilters<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get labelWidthMm => $composableBuilder(
    column: $table.labelWidthMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get labelHeightMm => $composableBuilder(
    column: $table.labelHeightMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get layoutJson => $composableBuilder(
    column: $table.layoutJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPreset => $composableBuilder(
    column: $table.isPreset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalLabelTemplatesTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalLabelTemplatesTable> {
  $$LocalLabelTemplatesTableOrderingComposer({
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

  ColumnOrderings<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get labelWidthMm => $composableBuilder(
    column: $table.labelWidthMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get labelHeightMm => $composableBuilder(
    column: $table.labelHeightMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get layoutJson => $composableBuilder(
    column: $table.layoutJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPreset => $composableBuilder(
    column: $table.isPreset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalLabelTemplatesTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalLabelTemplatesTable> {
  $$LocalLabelTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get labelWidthMm => $composableBuilder(
    column: $table.labelWidthMm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get labelHeightMm => $composableBuilder(
    column: $table.labelHeightMm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get layoutJson => $composableBuilder(
    column: $table.layoutJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPreset =>
      $composableBuilder(column: $table.isPreset, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalLabelTemplatesTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalLabelTemplatesTable,
          LocalLabelTemplate,
          $$LocalLabelTemplatesTableFilterComposer,
          $$LocalLabelTemplatesTableOrderingComposer,
          $$LocalLabelTemplatesTableAnnotationComposer,
          $$LocalLabelTemplatesTableCreateCompanionBuilder,
          $$LocalLabelTemplatesTableUpdateCompanionBuilder,
          (
            LocalLabelTemplate,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalLabelTemplatesTable,
              LocalLabelTemplate
            >,
          ),
          LocalLabelTemplate,
          PrefetchHooks Function()
        > {
  $$LocalLabelTemplatesTableTableManager(
    _$PosOfflineDatabase db,
    $LocalLabelTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLabelTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalLabelTemplatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalLabelTemplatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> organizationId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> labelWidthMm = const Value.absent(),
                Value<double> labelHeightMm = const Value.absent(),
                Value<String> layoutJson = const Value.absent(),
                Value<bool> isPreset = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLabelTemplatesCompanion(
                id: id,
                organizationId: organizationId,
                name: name,
                labelWidthMm: labelWidthMm,
                labelHeightMm: labelHeightMm,
                layoutJson: layoutJson,
                isPreset: isPreset,
                isDefault: isDefault,
                syncVersion: syncVersion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String organizationId,
                required String name,
                required double labelWidthMm,
                required double labelHeightMm,
                required String layoutJson,
                Value<bool> isPreset = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLabelTemplatesCompanion.insert(
                id: id,
                organizationId: organizationId,
                name: name,
                labelWidthMm: labelWidthMm,
                labelHeightMm: labelHeightMm,
                layoutJson: layoutJson,
                isPreset: isPreset,
                isDefault: isDefault,
                syncVersion: syncVersion,
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

typedef $$LocalLabelTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalLabelTemplatesTable,
      LocalLabelTemplate,
      $$LocalLabelTemplatesTableFilterComposer,
      $$LocalLabelTemplatesTableOrderingComposer,
      $$LocalLabelTemplatesTableAnnotationComposer,
      $$LocalLabelTemplatesTableCreateCompanionBuilder,
      $$LocalLabelTemplatesTableUpdateCompanionBuilder,
      (
        LocalLabelTemplate,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalLabelTemplatesTable,
          LocalLabelTemplate
        >,
      ),
      LocalLabelTemplate,
      PrefetchHooks Function()
    >;
typedef $$LocalLabelPrintHistoryTableCreateCompanionBuilder =
    LocalLabelPrintHistoryCompanion Function({
      required String id,
      Value<String?> templateId,
      Value<String?> printerName,
      required int productCount,
      required int totalLabels,
      Value<DateTime> printedAt,
      Value<bool> syncedToServer,
      Value<int> rowid,
    });
typedef $$LocalLabelPrintHistoryTableUpdateCompanionBuilder =
    LocalLabelPrintHistoryCompanion Function({
      Value<String> id,
      Value<String?> templateId,
      Value<String?> printerName,
      Value<int> productCount,
      Value<int> totalLabels,
      Value<DateTime> printedAt,
      Value<bool> syncedToServer,
      Value<int> rowid,
    });

class $$LocalLabelPrintHistoryTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalLabelPrintHistoryTable> {
  $$LocalLabelPrintHistoryTableFilterComposer({
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

  ColumnFilters<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get printerName => $composableBuilder(
    column: $table.printerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productCount => $composableBuilder(
    column: $table.productCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalLabels => $composableBuilder(
    column: $table.totalLabels,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get printedAt => $composableBuilder(
    column: $table.printedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncedToServer => $composableBuilder(
    column: $table.syncedToServer,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalLabelPrintHistoryTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalLabelPrintHistoryTable> {
  $$LocalLabelPrintHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get printerName => $composableBuilder(
    column: $table.printerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productCount => $composableBuilder(
    column: $table.productCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalLabels => $composableBuilder(
    column: $table.totalLabels,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get printedAt => $composableBuilder(
    column: $table.printedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncedToServer => $composableBuilder(
    column: $table.syncedToServer,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalLabelPrintHistoryTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalLabelPrintHistoryTable> {
  $$LocalLabelPrintHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get printerName => $composableBuilder(
    column: $table.printerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get productCount => $composableBuilder(
    column: $table.productCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalLabels => $composableBuilder(
    column: $table.totalLabels,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get printedAt =>
      $composableBuilder(column: $table.printedAt, builder: (column) => column);

  GeneratedColumn<bool> get syncedToServer => $composableBuilder(
    column: $table.syncedToServer,
    builder: (column) => column,
  );
}

class $$LocalLabelPrintHistoryTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalLabelPrintHistoryTable,
          LocalLabelPrintHistoryData,
          $$LocalLabelPrintHistoryTableFilterComposer,
          $$LocalLabelPrintHistoryTableOrderingComposer,
          $$LocalLabelPrintHistoryTableAnnotationComposer,
          $$LocalLabelPrintHistoryTableCreateCompanionBuilder,
          $$LocalLabelPrintHistoryTableUpdateCompanionBuilder,
          (
            LocalLabelPrintHistoryData,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalLabelPrintHistoryTable,
              LocalLabelPrintHistoryData
            >,
          ),
          LocalLabelPrintHistoryData,
          PrefetchHooks Function()
        > {
  $$LocalLabelPrintHistoryTableTableManager(
    _$PosOfflineDatabase db,
    $LocalLabelPrintHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLabelPrintHistoryTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalLabelPrintHistoryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalLabelPrintHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> templateId = const Value.absent(),
                Value<String?> printerName = const Value.absent(),
                Value<int> productCount = const Value.absent(),
                Value<int> totalLabels = const Value.absent(),
                Value<DateTime> printedAt = const Value.absent(),
                Value<bool> syncedToServer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLabelPrintHistoryCompanion(
                id: id,
                templateId: templateId,
                printerName: printerName,
                productCount: productCount,
                totalLabels: totalLabels,
                printedAt: printedAt,
                syncedToServer: syncedToServer,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> templateId = const Value.absent(),
                Value<String?> printerName = const Value.absent(),
                required int productCount,
                required int totalLabels,
                Value<DateTime> printedAt = const Value.absent(),
                Value<bool> syncedToServer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLabelPrintHistoryCompanion.insert(
                id: id,
                templateId: templateId,
                printerName: printerName,
                productCount: productCount,
                totalLabels: totalLabels,
                printedAt: printedAt,
                syncedToServer: syncedToServer,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalLabelPrintHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalLabelPrintHistoryTable,
      LocalLabelPrintHistoryData,
      $$LocalLabelPrintHistoryTableFilterComposer,
      $$LocalLabelPrintHistoryTableOrderingComposer,
      $$LocalLabelPrintHistoryTableAnnotationComposer,
      $$LocalLabelPrintHistoryTableCreateCompanionBuilder,
      $$LocalLabelPrintHistoryTableUpdateCompanionBuilder,
      (
        LocalLabelPrintHistoryData,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalLabelPrintHistoryTable,
          LocalLabelPrintHistoryData
        >,
      ),
      LocalLabelPrintHistoryData,
      PrefetchHooks Function()
    >;
typedef $$LocalCustomersTableCreateCompanionBuilder =
    LocalCustomersCompanion Function({
      required String id,
      required String organizationId,
      required String name,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<DateTime?> dateOfBirth,
      Value<String?> loyaltyCode,
      Value<int> loyaltyPoints,
      Value<double> storeCreditBalance,
      Value<String?> groupId,
      Value<String?> taxRegistrationNumber,
      Value<String?> notes,
      Value<double> totalSpend,
      Value<int> visitCount,
      Value<DateTime?> lastVisitAt,
      Value<int> syncVersion,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$LocalCustomersTableUpdateCompanionBuilder =
    LocalCustomersCompanion Function({
      Value<String> id,
      Value<String> organizationId,
      Value<String> name,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<DateTime?> dateOfBirth,
      Value<String?> loyaltyCode,
      Value<int> loyaltyPoints,
      Value<double> storeCreditBalance,
      Value<String?> groupId,
      Value<String?> taxRegistrationNumber,
      Value<String?> notes,
      Value<double> totalSpend,
      Value<int> visitCount,
      Value<DateTime?> lastVisitAt,
      Value<int> syncVersion,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$LocalCustomersTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalCustomersTable> {
  $$LocalCustomersTableFilterComposer({
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

  ColumnFilters<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loyaltyCode => $composableBuilder(
    column: $table.loyaltyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loyaltyPoints => $composableBuilder(
    column: $table.loyaltyPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get storeCreditBalance => $composableBuilder(
    column: $table.storeCreditBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxRegistrationNumber => $composableBuilder(
    column: $table.taxRegistrationNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalSpend => $composableBuilder(
    column: $table.totalSpend,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get visitCount => $composableBuilder(
    column: $table.visitCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastVisitAt => $composableBuilder(
    column: $table.lastVisitAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCustomersTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalCustomersTable> {
  $$LocalCustomersTableOrderingComposer({
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

  ColumnOrderings<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loyaltyCode => $composableBuilder(
    column: $table.loyaltyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loyaltyPoints => $composableBuilder(
    column: $table.loyaltyPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get storeCreditBalance => $composableBuilder(
    column: $table.storeCreditBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxRegistrationNumber => $composableBuilder(
    column: $table.taxRegistrationNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalSpend => $composableBuilder(
    column: $table.totalSpend,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get visitCount => $composableBuilder(
    column: $table.visitCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastVisitAt => $composableBuilder(
    column: $table.lastVisitAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCustomersTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalCustomersTable> {
  $$LocalCustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get loyaltyCode => $composableBuilder(
    column: $table.loyaltyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get loyaltyPoints => $composableBuilder(
    column: $table.loyaltyPoints,
    builder: (column) => column,
  );

  GeneratedColumn<double> get storeCreditBalance => $composableBuilder(
    column: $table.storeCreditBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get taxRegistrationNumber => $composableBuilder(
    column: $table.taxRegistrationNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get totalSpend => $composableBuilder(
    column: $table.totalSpend,
    builder: (column) => column,
  );

  GeneratedColumn<int> get visitCount => $composableBuilder(
    column: $table.visitCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastVisitAt => $composableBuilder(
    column: $table.lastVisitAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncVersion => $composableBuilder(
    column: $table.syncVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$LocalCustomersTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalCustomersTable,
          LocalCustomer,
          $$LocalCustomersTableFilterComposer,
          $$LocalCustomersTableOrderingComposer,
          $$LocalCustomersTableAnnotationComposer,
          $$LocalCustomersTableCreateCompanionBuilder,
          $$LocalCustomersTableUpdateCompanionBuilder,
          (
            LocalCustomer,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalCustomersTable,
              LocalCustomer
            >,
          ),
          LocalCustomer,
          PrefetchHooks Function()
        > {
  $$LocalCustomersTableTableManager(
    _$PosOfflineDatabase db,
    $LocalCustomersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> organizationId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<String?> loyaltyCode = const Value.absent(),
                Value<int> loyaltyPoints = const Value.absent(),
                Value<double> storeCreditBalance = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<String?> taxRegistrationNumber = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double> totalSpend = const Value.absent(),
                Value<int> visitCount = const Value.absent(),
                Value<DateTime?> lastVisitAt = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCustomersCompanion(
                id: id,
                organizationId: organizationId,
                name: name,
                phone: phone,
                email: email,
                address: address,
                dateOfBirth: dateOfBirth,
                loyaltyCode: loyaltyCode,
                loyaltyPoints: loyaltyPoints,
                storeCreditBalance: storeCreditBalance,
                groupId: groupId,
                taxRegistrationNumber: taxRegistrationNumber,
                notes: notes,
                totalSpend: totalSpend,
                visitCount: visitCount,
                lastVisitAt: lastVisitAt,
                syncVersion: syncVersion,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String organizationId,
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<String?> loyaltyCode = const Value.absent(),
                Value<int> loyaltyPoints = const Value.absent(),
                Value<double> storeCreditBalance = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<String?> taxRegistrationNumber = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double> totalSpend = const Value.absent(),
                Value<int> visitCount = const Value.absent(),
                Value<DateTime?> lastVisitAt = const Value.absent(),
                Value<int> syncVersion = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCustomersCompanion.insert(
                id: id,
                organizationId: organizationId,
                name: name,
                phone: phone,
                email: email,
                address: address,
                dateOfBirth: dateOfBirth,
                loyaltyCode: loyaltyCode,
                loyaltyPoints: loyaltyPoints,
                storeCreditBalance: storeCreditBalance,
                groupId: groupId,
                taxRegistrationNumber: taxRegistrationNumber,
                notes: notes,
                totalSpend: totalSpend,
                visitCount: visitCount,
                lastVisitAt: lastVisitAt,
                syncVersion: syncVersion,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalCustomersTable,
      LocalCustomer,
      $$LocalCustomersTableFilterComposer,
      $$LocalCustomersTableOrderingComposer,
      $$LocalCustomersTableAnnotationComposer,
      $$LocalCustomersTableCreateCompanionBuilder,
      $$LocalCustomersTableUpdateCompanionBuilder,
      (
        LocalCustomer,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalCustomersTable,
          LocalCustomer
        >,
      ),
      LocalCustomer,
      PrefetchHooks Function()
    >;
typedef $$LocalCustomerGroupsTableCreateCompanionBuilder =
    LocalCustomerGroupsCompanion Function({
      required String id,
      required String organizationId,
      required String name,
      Value<double> discountPercent,
      Value<int> rowid,
    });
typedef $$LocalCustomerGroupsTableUpdateCompanionBuilder =
    LocalCustomerGroupsCompanion Function({
      Value<String> id,
      Value<String> organizationId,
      Value<String> name,
      Value<double> discountPercent,
      Value<int> rowid,
    });

class $$LocalCustomerGroupsTableFilterComposer
    extends Composer<_$PosOfflineDatabase, $LocalCustomerGroupsTable> {
  $$LocalCustomerGroupsTableFilterComposer({
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

  ColumnFilters<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCustomerGroupsTableOrderingComposer
    extends Composer<_$PosOfflineDatabase, $LocalCustomerGroupsTable> {
  $$LocalCustomerGroupsTableOrderingComposer({
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

  ColumnOrderings<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCustomerGroupsTableAnnotationComposer
    extends Composer<_$PosOfflineDatabase, $LocalCustomerGroupsTable> {
  $$LocalCustomerGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => column,
  );
}

class $$LocalCustomerGroupsTableTableManager
    extends
        RootTableManager<
          _$PosOfflineDatabase,
          $LocalCustomerGroupsTable,
          LocalCustomerGroup,
          $$LocalCustomerGroupsTableFilterComposer,
          $$LocalCustomerGroupsTableOrderingComposer,
          $$LocalCustomerGroupsTableAnnotationComposer,
          $$LocalCustomerGroupsTableCreateCompanionBuilder,
          $$LocalCustomerGroupsTableUpdateCompanionBuilder,
          (
            LocalCustomerGroup,
            BaseReferences<
              _$PosOfflineDatabase,
              $LocalCustomerGroupsTable,
              LocalCustomerGroup
            >,
          ),
          LocalCustomerGroup,
          PrefetchHooks Function()
        > {
  $$LocalCustomerGroupsTableTableManager(
    _$PosOfflineDatabase db,
    $LocalCustomerGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCustomerGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCustomerGroupsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalCustomerGroupsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> organizationId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> discountPercent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCustomerGroupsCompanion(
                id: id,
                organizationId: organizationId,
                name: name,
                discountPercent: discountPercent,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String organizationId,
                required String name,
                Value<double> discountPercent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCustomerGroupsCompanion.insert(
                id: id,
                organizationId: organizationId,
                name: name,
                discountPercent: discountPercent,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCustomerGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosOfflineDatabase,
      $LocalCustomerGroupsTable,
      LocalCustomerGroup,
      $$LocalCustomerGroupsTableFilterComposer,
      $$LocalCustomerGroupsTableOrderingComposer,
      $$LocalCustomerGroupsTableAnnotationComposer,
      $$LocalCustomerGroupsTableCreateCompanionBuilder,
      $$LocalCustomerGroupsTableUpdateCompanionBuilder,
      (
        LocalCustomerGroup,
        BaseReferences<
          _$PosOfflineDatabase,
          $LocalCustomerGroupsTable,
          LocalCustomerGroup
        >,
      ),
      LocalCustomerGroup,
      PrefetchHooks Function()
    >;

class $PosOfflineDatabaseManager {
  final _$PosOfflineDatabase _db;
  $PosOfflineDatabaseManager(this._db);
  $$LocalProductsTableTableManager get localProducts =>
      $$LocalProductsTableTableManager(_db, _db.localProducts);
  $$LocalInventoryTableTableManager get localInventory =>
      $$LocalInventoryTableTableManager(_db, _db.localInventory);
  $$LocalHeldCartsTableTableManager get localHeldCarts =>
      $$LocalHeldCartsTableTableManager(_db, _db.localHeldCarts);
  $$LocalTransactionsTableTableManager get localTransactions =>
      $$LocalTransactionsTableTableManager(_db, _db.localTransactions);
  $$LocalSyncQueueTableTableManager get localSyncQueue =>
      $$LocalSyncQueueTableTableManager(_db, _db.localSyncQueue);
  $$LocalCategoriesTableTableManager get localCategories =>
      $$LocalCategoriesTableTableManager(_db, _db.localCategories);
  $$LocalSuppliersTableTableManager get localSuppliers =>
      $$LocalSuppliersTableTableManager(_db, _db.localSuppliers);
  $$LocalProductSuppliersTableTableManager get localProductSuppliers =>
      $$LocalProductSuppliersTableTableManager(_db, _db.localProductSuppliers);
  $$LocalProductVariantsTableTableManager get localProductVariants =>
      $$LocalProductVariantsTableTableManager(_db, _db.localProductVariants);
  $$LocalModifierGroupsTableTableManager get localModifierGroups =>
      $$LocalModifierGroupsTableTableManager(_db, _db.localModifierGroups);
  $$LocalModifierOptionsTableTableManager get localModifierOptions =>
      $$LocalModifierOptionsTableTableManager(_db, _db.localModifierOptions);
  $$LocalPromotionsTableTableManager get localPromotions =>
      $$LocalPromotionsTableTableManager(_db, _db.localPromotions);
  $$LocalCouponCodesTableTableManager get localCouponCodes =>
      $$LocalCouponCodesTableTableManager(_db, _db.localCouponCodes);
  $$LocalLabelTemplatesTableTableManager get localLabelTemplates =>
      $$LocalLabelTemplatesTableTableManager(_db, _db.localLabelTemplates);
  $$LocalLabelPrintHistoryTableTableManager get localLabelPrintHistory =>
      $$LocalLabelPrintHistoryTableTableManager(
        _db,
        _db.localLabelPrintHistory,
      );
  $$LocalCustomersTableTableManager get localCustomers =>
      $$LocalCustomersTableTableManager(_db, _db.localCustomers);
  $$LocalCustomerGroupsTableTableManager get localCustomerGroups =>
      $$LocalCustomerGroupsTableTableManager(_db, _db.localCustomerGroups);
}
