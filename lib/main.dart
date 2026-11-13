import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'core/files/file_store.dart';
import 'core/files/file_store_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final documents = await getApplicationDocumentsDirectory();
  runApp(
    ProviderScope(
      overrides: [fileStoreProvider.overrideWithValue(FileStore(documents))],
      child: const RentalManagerApp(),
    ),
  );
}
