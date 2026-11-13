import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:rental_manager/core/files/file_store.dart';

void main() {
  late Directory temp;
  late Directory documents;
  late FileStore store;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('file_store_test');
    documents = await Directory(p.join(temp.path, 'documents')).create();
    store = FileStore(documents);
  });

  tearDown(() async {
    await temp.delete(recursive: true);
  });

  /// 在 Documents 外面建一個來源檔（模擬 image_picker 給的暫存檔）。
  Future<String> sourceFile(String name, List<int> bytes) async {
    final file = File(p.join(temp.path, 'picker', name));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes);
    return file.path;
  }

  group('savePhoto', () {
    test('複製到 photos/{inspectionId}/{photoId}，回傳用 / 分隔的相對路徑；來源檔不動', () async {
      final source = await sourceFile('image_picker_A1B2.jpg', [1, 2, 3]);

      final relativePath = await store.savePhoto(
        inspectionId: 'inspection-1',
        photoId: 'photo-1',
        sourcePath: source,
      );

      expect(relativePath, 'photos/inspection-1/photo-1.jpg');
      final saved = File(
        p.join(documents.path, 'photos', 'inspection-1', 'photo-1.jpg'),
      );
      expect(await saved.readAsBytes(), [1, 2, 3]);
      expect(await File(source).readAsBytes(), [1, 2, 3]);
    });

    test('副檔名照來源檔、轉成小寫；PNG、GIF 保留原本的格式', () async {
      Future<String> save(String name) async => store.savePhoto(
        inspectionId: 'inspection-1',
        photoId: name,
        sourcePath: await sourceFile('$name.${name.toUpperCase()}', [0]),
      );

      expect(await save('jpg'), 'photos/inspection-1/jpg.jpg');
      expect(await save('png'), 'photos/inspection-1/png.png');
      expect(await save('gif'), 'photos/inspection-1/gif.gif');
    });

    test('來源檔不存在時丟出錯誤', () async {
      await expectLater(
        store.savePhoto(
          inspectionId: 'inspection-1',
          photoId: 'photo-1',
          sourcePath: p.join(temp.path, 'missing.jpg'),
        ),
        throwsA(isA<FileSystemException>()),
      );
    });
  });

  test('Documents 目錄換了位置（例如 App 更新後），用同一個相對路徑還找得到檔案', () async {
    final relativePath = await store.savePhoto(
      inspectionId: 'inspection-1',
      photoId: 'photo-1',
      sourcePath: await sourceFile('a.jpg', [7, 8, 9]),
    );

    final moved = await documents.rename(p.join(temp.path, 'new-container'));
    final file = FileStore(moved).resolve(relativePath);

    expect(
      file.path,
      p.join(moved.path, 'photos', 'inspection-1', 'photo-1.jpg'),
    );
    expect(await file.readAsBytes(), [7, 8, 9]);
  });

  group('delete', () {
    test('刪除檔案；檔案本來就不存在也不會出錯', () async {
      final relativePath = await store.savePhoto(
        inspectionId: 'inspection-1',
        photoId: 'photo-1',
        sourcePath: await sourceFile('a.jpg', [1]),
      );

      await store.delete(relativePath);
      expect(await store.resolve(relativePath).exists(), isFalse);

      await store.delete(relativePath);
      expect(await store.resolve(relativePath).exists(), isFalse);
    });

    test('只刪指定的檔案，同一個資料夾的其他照片還在', () async {
      Future<String> save(String photoId) async => store.savePhoto(
        inspectionId: 'inspection-1',
        photoId: photoId,
        sourcePath: await sourceFile('$photoId.jpg', [1]),
      );
      final deleted = await save('photo-1');
      final kept = await save('photo-2');

      await store.delete(deleted);

      expect(await store.resolve(kept).exists(), isTrue);
    });
  });
}
