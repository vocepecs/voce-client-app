import 'package:json_annotation/json_annotation.dart';
import 'package:voce/models/enums/table_sector_number.dart';
import 'package:voce/models/image.dart';

part 'table_sector.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class TableSector {
  TableSector();

  factory TableSector.createEmptySector(int index) {
    TableSector ts = TableSector();
    ts.id = index;
    ts.sectorColor = 0xFF7FC8F8;
    ts.tableSectorNumber = TableSectorNumber.ONE;
    ts.imageList = List<CaaImage>.empty(growable: true);
    return ts;
  }

  late int _id;
  late TableSectorNumber _tableSectorNumber;
  late int _sectorColor;
  late List<CaaImage> _imageList;

  int get id => this._id;
  set id(value) => this._id = value;
  TableSectorNumber get tableSectorNumber => this._tableSectorNumber;
  set tableSectorNumber(value) => this._tableSectorNumber = value;
  int get sectorColor => this._sectorColor;
  set sectorColor(value) => this._sectorColor = value;
  List<CaaImage> get imageList => this._imageList;
  set imageList(value) => this._imageList = value;

  factory TableSector.fromJson(Map<String, dynamic> json) =>
      _$TableSectorFromJson(json);
  Map<String, dynamic> toJson() => _$TableSectorToJson(this);

  void addImage(CaaImage caaImage) {
    this.imageList.add(caaImage);
  }

  void removeImage(int index) {
    this.imageList.removeAt(index);
  }
}
