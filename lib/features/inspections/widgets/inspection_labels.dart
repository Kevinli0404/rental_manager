import '../../../core/database/database.dart';

/// 點交類型在畫面上的名稱。
extension InspectionTypeLabel on InspectionType {
  String get label => switch (this) {
    InspectionType.moveIn => '入住',
    InspectionType.moveOut => '退租',
  };
}

/// 點交狀態在畫面上的名稱（product.md「點交紀錄狀態」）。
extension InspectionStatusLabel on InspectionStatus {
  String get label => switch (this) {
    InspectionStatus.draft => '草稿',
    InspectionStatus.signed => '已簽名',
  };
}

/// 項目狀況在畫面上的名稱（product.md「項目狀況」）。
extension ItemConditionLabel on ItemCondition {
  String get label => switch (this) {
    ItemCondition.good => '良好',
    ItemCondition.damaged => '損壞',
    ItemCondition.missing => '缺少',
    ItemCondition.notApplicable => '不適用',
  };
}
