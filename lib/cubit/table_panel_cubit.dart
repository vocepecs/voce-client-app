import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/table_format.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/table_sector.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'table_panel_state.dart';

class TablePanelCubit extends Cubit<TablePanelState> {
  final VoceAPIRepository voceApiRepository;
  final CAAContentOperation tableOperation;
  final User user;
  CaaTable? caaTable;
  Patient? patient;

  TablePanelCubit({
    required this.user,
    required this.voceApiRepository,
    required this.tableOperation,
    this.patient,
    this.caaTable,
  }) : super(TablePanelInitial()) {
    if (caaTable == null) {
      caaTable = CaaTable.createEmptyTable(user.id!);
    }
    emit(TablePanelLoaded(caaTable!));
  }

  void emitTablePanelLoaded() => emit(TablePanelLoaded(caaTable!));

  // Future<void> getTableData(int tableId) async {
  //   Response response = await voceApiRepository.getCaaTable(tableId);
  //   if (response.statusCode == 200) {
  //     dynamic tableData = json.decode(response.body);
  //     _caaTable = CaaTable.fromJson(tableData);
  //     emit(TablePanelLoaded(_caaTable));
  //   } else {
  //     print(response.body);
  //   }
  // }

  bool isUserTableOwner() => caaTable!.userId == user.id;
  bool isPatientTable() => patient != null;
  void updateTableName(String value) => caaTable!.name = value;
  void updateTableDescription(String value) => caaTable!.description = value;

  void updateTableImageStringConding(String value) {
    emit(TablePanelLoading());
    caaTable!.imageStringCoding = value;
    emit(TablePanelLoaded(caaTable!));
  }

  void updateIsAutismCentrePrivate(bool value) {
    emit(TablePanelInitial());
    if (value == true) {
      caaTable!.isPrivate = false;
      caaTable!.autismCentreId = user.autismCentre!.id;
    } else {
      caaTable!.autismCentreId = null;
    }
    emit(TablePanelLoaded(caaTable!));
  }

  void updateIsUserPrivate(bool value) {
    emit(TablePanelInitial());
    if (value == true) {
      caaTable!.autismCentreId = null;
    }
    caaTable!.isPrivate = value;
    emit(TablePanelLoaded(caaTable!));
  }

  void updateSectorColor(int index, int color) {
    emit(TablePanelInitial());
    caaTable!.sectorList[index].sectorColor = color;
    emit(TablePanelLoaded(caaTable!));
  }

  void updateSectorImages(CaaImage image, int sectorIndex) {
    emit(TablePanelInitial());
    caaTable!.addImageToSector(sectorIndex, image);
    emit(TablePanelLoaded(caaTable!));
  }

  void removeSectorImage(int sectorIndex, imageIndex) {
    emit(TablePanelInitial());
    caaTable!.removeImageFromSector(sectorIndex, imageIndex);
    emit(TablePanelLoaded(caaTable!));
  }

  void updateSectorImagePosition(
    int sectorIndex,
    int oldPosition,
    int newPosition,
  ) {
    emit(TablePanelInitial());
    CaaImage image = caaTable!.sectorList[sectorIndex].imageList[oldPosition];
    caaTable!.sectorList[sectorIndex].imageList.removeAt(oldPosition);
    caaTable!.sectorList[sectorIndex].imageList.insert(newPosition, image);
    emit(TablePanelLoaded(caaTable!));
  }

  void updateTableFormat(TableFormat format) {
    emit(TablePanelInitial());
    switch (format) {
      case TableFormat.SINGLE_SECTOR:
        caaTable!.sectorList =
            List.generate(1, (index) => TableSector.createEmptySector(index));
        break;
      case TableFormat.TWO_SECTORS_VERTICAL:
        caaTable!.sectorList =
            List.generate(2, (index) => TableSector.createEmptySector(index));
        break;
      case TableFormat.TWO_SECTORS_HORIZONTAL:
        caaTable!.sectorList =
            List.generate(2, (index) => TableSector.createEmptySector(index));
        break;
      case TableFormat.THREE_SECTORS_RIGHT:
        caaTable!.sectorList =
            List.generate(3, (index) => TableSector.createEmptySector(index));
        break;
      case TableFormat.THREE_SECTORS_LEFT:
        caaTable!.sectorList =
            List.generate(3, (index) => TableSector.createEmptySector(index));
        break;
      case TableFormat.FOUR_SECTORS:
        caaTable!.sectorList =
            List.generate(4, (index) => TableSector.createEmptySector(index));
        break;
    }
    caaTable!.tableFormat = format;
    emit(TablePanelLoaded(caaTable!));
  }

  void saveTable({bool confirmPersonalImages = false}) async {
    emit(TablePanelLoading());

    if (caaTable!.getAllImages().any((element) => element.isPersonal) &&
        !confirmPersonalImages &&
        patient == null) {
      emit(TablePanelPersonalImagesWarning());
    } else if (caaTable!.getTotalNumberOfSymbols() > 0) {
      if (confirmPersonalImages) {
        caaTable!.isPrivate = true;
      }
      switch (tableOperation) {
        case CAAContentOperation.CREATE_GENERAL:
          try {
            await voceApiRepository.createCaaTable(
              caaTable!.toJson(),
              userId: user.id,
            );
            emit(TableCreated());
          } on VoceApiException catch (_) {
            emit(TableCreationError());
          }
          break;

        case CAAContentOperation.CREATE_PATIENT_ASSOCIATION:
          caaTable!.isPrivate = true;
          try {
            await voceApiRepository.createCaaTable(
              caaTable!.toJson(),
              patientId: patient!.id,
              userId: user.id,
            );
            emit(TableCreated());
          } on VoceApiException catch (_) {
            emit(TableCreationError());
          }

          break;
        case CAAContentOperation.UPDATE:
          try {
            await voceApiRepository.updateCaaTable(
              caaTable!.toJson(),
              caaTable!.id!,
            );
            emit(TableUpdated());
          } on VoceApiException catch (_) {
            emit(TableUpdateError());
          }
          break;
      }
    } else {
      emit(TablePanelError());
    }
  }

  void deleteTable() async {
    emit(TablePanelLoading());
    if (caaTable!.id != null) {
      try {
        await voceApiRepository.deleteCaaTable(caaTable!.id!);
        emit(TableDeleted());
      } on VoceApiException catch (_) {
        emit(TableDeletionError());
      }
    }
  }

  void duplicateTable() async {
    emit(TablePanelLoading());
    CaaTable table = caaTable!;

    table.name = "${table.name} <Copia>";

    try {
      await voceApiRepository.createCaaTable(
        table.toJson(),
        userId: user.id,
        patientId: patient?.id,
      );
      emit(TableCreated());
    } on VoceApiException catch (_) {
      emit(TableCreationError());
    }
  }
}
