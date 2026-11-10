import 'package:flutter/material.dart';

import '../../../core/database/database.dart';

/// 表單填的內容，還沒去掉前後空白。
typedef PropertyFormValues = ({String name, String address, String note});

/// 新增、編輯物件共用的整頁表單：右上角「儲存」，名稱必填，地址、備註可以不填
/// （architecture.md「資料表」）。
///
/// 推論：填到一半按返回直接離開，不跳確認視窗。規格只在點交填寫寫了
/// 「離開頁面也不詢問」（product.md「轉跳規則」第 4 點）；物件只有三個欄位，
/// 重填的成本低，比照辦理。
class PropertyForm extends StatefulWidget {
  const PropertyForm({
    super.key,
    required this.title,
    required this.onSave,
    required this.onSaved,
    this.initial,
  });

  final String title;

  /// 編輯時帶入的原本內容；新增時是 null。
  final Property? initial;

  /// 寫入資料庫。丟出例外時留在這頁顯示錯誤。
  final Future<void> Function(PropertyFormValues values) onSave;

  /// 寫入成功後呼叫，用來轉跳離開這頁。
  final VoidCallback onSaved;

  @override
  State<PropertyForm> createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _address = TextEditingController(text: widget.initial?.address);
  late final _note = TextEditingController(text: widget.initial?.note);
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // 推論：存檔中不接受第二次點擊，避免連點時新增兩筆一樣的物件。
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      await widget.onSave((
        name: _name.text,
        address: _address.text,
        note: _note.text,
      ));
    } catch (error) {
      // 頁面已經關掉就沒有地方顯示，往上丟。
      if (!mounted) rethrow;
      // 推論：存檔失敗時留在這頁，已填的內容不清掉，讓使用者可以再試一次。
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('儲存失敗：$error')));
      return;
    }

    // 存檔按鈕維持停用，離開這頁之前不能再按。
    if (mounted) widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: const Text('儲存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: '名稱'),
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? '請輸入名稱' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _address,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: '地址（選填）'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _note,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: null,
              decoration: const InputDecoration(labelText: '備註（選填）'),
            ),
          ],
        ),
      ),
    );
  }
}
