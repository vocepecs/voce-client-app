import 'package:flutter/material.dart';
import 'package:voce/models/enums/table_scope.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/widgets/tables/communication_tables/commt_3_left.dart';
import 'package:voce/widgets/tables/content_tables/cont_3_left.dart';
import 'package:voce/widgets/tables/format_tables/formt_3_left.dart';
import 'package:voce/widgets/tables/vocecaa_table.dart';

class Tb3Left implements VocecaaTable {
  @override
  Widget build({
    required BuildContext context,
    required CaaTable caaTable,
    required TableScope scope,
  }) {
    switch (scope) {
      case TableScope.FORMAT:
        return FormT3Left(caaTable: caaTable);
      case TableScope.CONTENT:
        return ConT3Left(caaTable: caaTable);
      case TableScope.COMMUNICATION:
        return CommT3Left(caaTable: caaTable);
    }
  }
}
