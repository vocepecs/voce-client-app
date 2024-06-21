import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:voce/models/enums/table_format.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/table_sector.dart';
import 'package:voce/widgets/table_placeholder_1.dart';
import 'package:voce/widgets/table_placeholder_2.dart';
import 'package:voce/widgets/table_placeholder_2_horizontal.dart';
import 'package:voce/widgets/table_placeholder_3.dart';
import 'package:voce/widgets/table_placeholder_3_reverse.dart';
import 'package:voce/widgets/table_placeholder_4.dart';

part 'caa_table.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class CaaTable {
  CaaTable(int userId) {
    _userId = userId;
  }

  int? _id;
  late String _name;
  late TableFormat _tableFormat;
  late DateTime _creationDate;
  late DateTime? _lastModifyDate;
  late List<TableSector> _sectorList;
  late bool _isActive;
  late String? _description;
  late int _userId;
  int? _autismCentreId;
  late bool _isPrivate;
  String? _imageStringCoding;

  int? get id => this._id;
  set id(value) => this._id = value;
  String get name => this._name;
  set name(value) => this._name = value;
  TableFormat get tableFormat => this._tableFormat;
  set tableFormat(value) => this._tableFormat = value;
  DateTime get creationDate => this._creationDate;
  set creationDate(value) => this._creationDate = value;
  DateTime? get lastModifyDate => this._lastModifyDate;
  set lastModifyDate(value) => this._lastModifyDate = value;
  List<TableSector> get sectorList => this._sectorList;
  set sectorList(value) => this._sectorList = value;
  bool get isActive => this._isActive;
  set isActive(value) => this._isActive = value;
  String? get description => this._description;
  set description(value) => this._description = value;
  bool get isPrivate => this._isPrivate;
  set isPrivate(value) => this._isPrivate = value;
  int get userId => this._userId;
  String? get imageStringCoding => this._imageStringCoding;
  set imageStringCoding(value) => this._imageStringCoding = value;

  int? get autismCentreId => this._autismCentreId;
  set autismCentreId(value) => this._autismCentreId = value;

  factory CaaTable.fromJson(Map<String, dynamic> json) =>
      _$CaaTableFromJson(json);
  Map<String, dynamic> toJson() => _$CaaTableToJson(this);

  factory CaaTable.createEmptyTable(int userId) {
    CaaTable caaTable = CaaTable(userId);
    caaTable.name = '';
    caaTable.tableFormat = TableFormat.THREE_SECTORS_RIGHT;
    caaTable.creationDate = DateTime.now();
    caaTable.lastModifyDate = DateTime.now();
    caaTable.sectorList =
        List.generate(3, (index) => TableSector.createEmptySector(index + 1));
    caaTable.isActive = false;
    caaTable.description = '';
    caaTable._isPrivate = false;
    return caaTable;
  }

  void initAsEmptyTable() {}

  void changeTableSector(int index, TableSector tableSector) {
    this.sectorList.removeAt(index);
    this.sectorList.insert(index, tableSector);
  }

  void addImageToSector(int index, CaaImage caaImage) {
    if (!this
        .sectorList[index]
        .imageList
        .any((element) => element.id == caaImage.id)) {
      this.sectorList[index].addImage(caaImage);
    }
  }

  void removeImageFromSector(int sectorIndex, int imageIndex) {
    this.sectorList[sectorIndex].removeImage(imageIndex);
  }

  int getTotalNumberOfSymbols() {
    int count = 0;
    this.sectorList.forEach((element) => count += element.imageList.length);
    return count;
  }

  List<CaaImage> getAllImages() {
    List<CaaImage> imageList = [];
    this.sectorList.forEach((element) => imageList.addAll(element.imageList));
    return imageList;
  }

  List<Widget> getTableTabBar() {
    print(this._tableFormat.toString());
    switch (this._tableFormat) {
      case TableFormat.SINGLE_SECTOR:
        return List.generate(
            1, (index) => TablePlaceholder1Icon(isHighlighted: true));
      case TableFormat.TWO_SECTORS_VERTICAL:
        return List.generate(
          2,
          (i) => TablePlaceholder2Icon(
            highlightSectionList:
                List.generate(2, (ii) => i == ii ? true : false),
          ),
        );
      case TableFormat.TWO_SECTORS_HORIZONTAL:
        return List.generate(
          2,
          (i) => TablePlaceholder2HorizontalIcon(
            highlightSectionList:
                List.generate(2, (ii) => i == ii ? true : false),
          ),
        );
      case TableFormat.THREE_SECTORS_LEFT:
        return List.generate(
          3,
          (i) => TablePlaceholder3ReverseIcon(
            highlightSectionList:
                List.generate(3, (ii) => i == ii ? true : false),
          ),
        );
      case TableFormat.THREE_SECTORS_RIGHT:
        return List.generate(
          3,
          (i) => TablePlaceholder3Icon(
            highlightSectionList:
                List.generate(3, (ii) => i == ii ? true : false),
          ),
        );
      case TableFormat.FOUR_SECTORS:
        return List.generate(
          4,
          (i) => TablePlaceholder4Icon(
            highlightSectionList:
                List.generate(4, (ii) => i == ii ? true : false),
          ),
        );
    }
  }
}
