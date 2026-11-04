import 'dart:convert';

import 'package:flutter/services.dart';

import 'template.dart';

/// 第一版唯一的內建範本。
const defaultTemplateAsset = 'assets/templates/default_residence.json';

/// 從 App 內建的 assets 載入範本。
Future<Template> loadDefaultTemplate() async {
  final source = await rootBundle.loadString(defaultTemplateAsset);
  return Template.fromJson(jsonDecode(source) as Map<String, Object?>);
}
