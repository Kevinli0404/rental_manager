import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../providers/property_list_provider.dart';

/// 新增物件。名稱必填，地址、備註可以不填（architecture.md「資料表」）。
///
/// 推論：填到一半按返回直接離開，不跳確認視窗。規格只在點交填寫寫了
/// 「離開頁面也不詢問」（product.md「轉跳規則」第 4 點）；物件只有三個欄位，
/// 重填的成本低，比照辦理。
class NewPropertyPage extends ConsumerStatefulWidget {
  const NewPropertyPage({super.key});

  @override
  ConsumerState<NewPropertyPage> createState() => _NewPropertyPageState();
}

class _NewPropertyPageState extends ConsumerState<NewPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _note = TextEditingController();
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
      await ref
          .read(propertyListProvider.notifier)
          .create(name: _name.text, address: _address.text, note: _note.text);
    } catch (error) {
      // 頁面已經關掉就沒有地方顯示，往上丟。
      if (!mounted) rethrow;
      // 推論：存檔失敗時留在這頁，已填的內容不清掉，讓使用者可以再試一次。
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('儲存失敗：$error')));
      return;
    }

    if (mounted) context.go(AppRoutes.propertyList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增物件'),
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
