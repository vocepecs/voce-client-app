import 'package:flutter/material.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/table_format.dart';
import 'package:voce/models/enums/table_scope.dart';
import 'package:voce/widgets/tables/table_builders/tb_1.dart';
import 'package:voce/widgets/tables/table_builders/tb_2_horizontal.dart';
import 'package:voce/widgets/tables/table_builders/tb_2_vertical.dart';
import 'package:voce/widgets/tables/table_builders/tb_3_left.dart';
import 'package:voce/widgets/tables/table_builders/tb_3_right.dart';
import 'package:voce/widgets/tables/table_builders/tb_4.dart';

abstract class VocecaaTable {
  factory VocecaaTable(TableFormat format) {
    switch (format) {
      case TableFormat.SINGLE_SECTOR:
        return Tb1();
      case TableFormat.TWO_SECTORS_VERTICAL:
        return Tb2Vertical();
      case TableFormat.TWO_SECTORS_HORIZONTAL:
        return Tb2Horizontal();
      case TableFormat.THREE_SECTORS_LEFT:
        return Tb3Left();
      case TableFormat.THREE_SECTORS_RIGHT:
        return Tb3Right();
      case TableFormat.FOUR_SECTORS:
        return Tb4();
    }
  }
  Widget build({
    required BuildContext context,
    required CaaTable caaTable,
    required TableScope scope,
  });
}
