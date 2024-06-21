import 'package:flutter/material.dart';
import 'package:voce/models/enums/table_scope.dart';
import 'package:voce/models/caa_table.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:voce/widgets/tables/communication_tables/commt_1.dart';
import 'package:voce/widgets/tables/content_tables/cont_1.dart';
import 'package:voce/widgets/tables/format_tables/formt_1.dart';
import 'package:voce/widgets/tables/vocecaa_table.dart';

class Tb1 implements VocecaaTable {
  @override
  Widget build({
    required BuildContext context,
    required CaaTable caaTable,
    required TableScope scope,
  }) {
    switch (scope) {
      case TableScope.FORMAT:
        return FormT1(caaTable: caaTable);
      case TableScope.CONTENT:
        return ConT1(
          caaTable: caaTable,
        );
      case TableScope.COMMUNICATION:
        return CommT1(caaTable: caaTable);
    }
  }
}
