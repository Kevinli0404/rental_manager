# 架構

## 技術選擇

| 用途 | 套件 |
|---|---|
| 狀態管理 | flutter_riverpod（Riverpod 3，手寫 provider，不用 codegen，D-017） |
| 路由 | go_router |
| 語系 | flutter_localizations（只用繁體中文 zh_TW，D-019） |
| 本機資料庫 | drift、drift_flutter |
| 不可變資料類別、JSON | freezed、json_serializable（只用在範本、空間配置這類需要的地方） |
| ID | uuid |
| 檔案路徑 | path_provider、path |
| 拍照、選照片 | image_picker |
| 簽名 | signature |
| PDF | pdf、printing |
| 分享 | share_plus |

以上是預計使用的套件；實際加入時，照 `CLAUDE.md` 的規則先確認。

## 版面

- 以手機直式為主；平板能正常操作就好，不另外做版面。

## 分層

```
pages / widgets（畫面）
      ↓ 只透過 provider 取資料、呼叫動作
providers（Riverpod）
      ↓
repositories（需要時才加：檔案處理、跨 DAO 的商業規則）
      ↓
daos（drift）＋ file_store（照片、簽名檔案）
```

- 畫面不直接碰 DAO 或檔案。
- repository 只在需要時才加：要處理檔案，或商業規則要組合好幾個 DAO 時。單純的讀寫、單一 DAO 裡就能完成的交易（例如刪除物件時連帶刪除點交紀錄），provider 直接呼叫 DAO（D-016）。
- 商業規則（狀態轉換、簽名前檢查、刪除規則、退租對照）放在 `features/inspections/rules/` 這類獨立的規則類別或純函式，要能單獨寫單元測試。
- 讀取用 drift 的 watch 查詢配 StreamProvider，資料一改畫面就自動更新。
- 寫入動作放在 Notifier 的方法裡，例如 `InspectionController.setCondition(...)`。
- 不要為了分層而分層：drift 產生的資料類別可以直接給畫面用，需要時才另外定義 model。

## 資料夾

```
lib/
  main.dart
  app/                 App 進入點、路由、主題
  core/
    database/          drift：database.dart、tables/、daos/
    files/             照片、簽名檔案的存取（只回傳相對路徑）
    pdf/               PDF 版面與產生
    widgets/           跨功能共用的小元件
  features/
    properties/        物件：pages/、widgets/、providers/、data/
    inspections/       點交：pages/、widgets/、providers/、data/、rules/
    templates/         範本、空間配置的 model 與載入
    settings/
assets/
  templates/           內建範本 JSON
  fonts/               PDF 用的中文字型
test/                  結構對應 lib/
drift_schemas/         drift schema 快照（migration 測試用）
```

- 上面列到的資料夾先建好，還沒有檔案的放 `.gitkeep` 佔位；放進第一個檔案時把 `.gitkeep` 刪掉。
- 功能底下的子資料夾（`pages/`、`providers/` 等）第一次用到時才建立。

## 資料表

每張表都有的欄位：

| 欄位 | 說明 |
|---|---|
| `id` | UUID 字串，主鍵（不用自動遞增） |
| `createdAt` | 建立時間（UTC） |
| `updatedAt` | 最後修改時間（UTC），每次寫入都要更新 |
| `deletedAt` | 軟刪除時間（UTC），沒刪除為 null；所有查詢預設排除已刪除的資料 |

各表的主要欄位：

| 表 | 欄位 |
|---|---|
| `properties` | name、address、note |
| `inspections` | propertyId、type（moveIn／moveOut）、status（draft／signed）、inspectedOn、landlordName、tenantName、layout（空間配置快照；SQL 欄位 `layout_json` 存 JSON 字串，程式裡由 TypeConverter 轉成 `Layout`）、baseInspectionId（退租對照的入住紀錄；沒有對照為 null）、signedAt |
| `item_results` | inspectionId、roomKey（空間配置裡的空間 key）、itemKey、condition（good／damaged／missing／notApplicable，未填為 null）、note；(inspectionId, roomKey, itemKey) 不可重複 |
| `photos` | inspectionId、roomKey、itemKey、relativePath |
| `signatures` | inspectionId、role（landlord／tenant）、relativePath、signedAt；(inspectionId, role) 不可重複 |

- enum 一律存成文字（drift 的 `textEnum`），不要存 index，避免 enum 調整順序時資料錯亂。
- 時間一律存 UTC，顯示時才轉成當地時間；資料庫裡存成 ISO-8601 文字（D-014）。
- `inspectedOn` 只存日期（`YYYY-MM-DD` 文字），不做時區轉換。
- 可以不填的文字欄位（地址、備註、姓名）存空字串，不存 null。
- 開啟 SQLite 的外鍵檢查（`PRAGMA foreign_keys = ON`），`propertyId`、`inspectionId`、`baseInspectionId` 都參照對應的表。
- 資料表定義在 `lib/core/database/tables/`，共同欄位用 `SyncColumns` mixin。
- 資料庫連線由 `databaseProvider`（`lib/core/database/database_provider.dart`）提供：App 用 drift_flutter 開 Documents 目錄裡的檔案，ProviderScope 結束時關閉；測試用 `overrideWithValue` 換成記憶體資料庫。
- DAO 在 `lib/core/database/daos/`：
  - 新增資料時，id 用 `AppDatabase.newId()`（UUID v4），時間用 `AppDatabase.nowUtc()`；測試可以傳入固定的 `clock`。
  - 讀取一律用 watch 查詢，並排除 `deletedAt` 不是 null 的資料。
  - 修改、刪除時找不到資料（不存在或已刪除）就丟出 `StateError`，不默默略過。
  - 軟刪除同時更新 `updatedAt`。刪除物件時，在同一個交易裡把底下還沒刪除的點交紀錄一起軟刪除。
  - 項目結果依 (inspectionId, roomKey, itemKey) 新增或更新（upsert）；狀況、備註分開寫入，只更新該欄位和 `updatedAt`。

## 範本與空間配置

範本（`assets/templates/*.json`）定義空間類型，以及每類空間的項目：

```json
{
  "id": "default-residence",
  "name": "一般住宅",
  "version": 1,
  "rooms": [
    {
      "key": "bedroom",
      "name": "臥室",
      "items": [
        { "key": "wall", "name": "牆面" },
        { "key": "floor", "name": "地板" }
      ]
    }
  ]
}
```

空間配置（存在 `inspections.layout_json`）是這筆點交實際有的空間：

```json
{
  "templateId": "default-residence",
  "templateVersion": 1,
  "rooms": [
    {
      "key": "bedroom",
      "typeKey": "bedroom",
      "name": "臥室",
      "items": [{ "key": "wall", "name": "牆面" }]
    },
    {
      "key": "0b7e4c2a-5d1f-4e8b-9a63-2f1c8d7e6b54",
      "typeKey": "bedroom",
      "name": "臥室 2",
      "items": [{ "key": "wall", "name": "牆面" }]
    }
  ]
}
```

- 空間 `key` 在同一筆點交裡不能重複，建立後就不改。由範本產生的空間沿用範本的 key；之後新增、複製的空間用新的 UUID，用過的 key 不再使用。
- 項目 `key` 沿用範本的 key。
- 退租沿用入住的空間配置時，key 完全不變，所以能用 (roomKey, itemKey) 一對一對照。
- 畫面和 PDF 都依空間配置顯示，不再回頭讀範本。
- 範本、空間配置的 model 在 `lib/features/templates/data/`，用 freezed＋json_serializable 產生；`Layout.fromTemplate` 依範本產生空間配置。

## 檔案（照片、簽名）

- 存在 App 的 Documents 目錄：`photos/{inspectionId}/{photoId}.jpg`、`signatures/{inspectionId}/{role}.png`。
- 資料庫只存相對路徑；iOS 更新 App 之後，沙盒的絕對路徑可能會變。
- 照片存檔前先縮小（長邊 1600px 以內、JPEG 品質約 80），控制容量和 PDF 大小。
- 刪除照片時，先在資料庫標記刪除，成功後再刪檔案。

## 路由

- 路由集中在 `lib/app/router.dart`，路徑用 `AppRoutes` 的常數和方法產生（例如 `AppRoutes.propertyDetail(id)`），不在畫面裡手寫字串。
- 主要轉跳用 `context.go`，依巢狀路徑建立返回堆疊；照片檢視這類疊在上面的頁面用 `context.push`。
- 頁面參數只傳 ID，資料由 provider 依 ID 讀取。
- 刪除目前這頁顯示的資料時，先轉跳離開，等這頁的退場動畫結束（`ModalRoute.of(context)!.completed`）才寫入資料庫（D-018）。

## PDF

- 用 `pdf` 套件產生，用 `printing` 預覽、分享、列印。
- 一定要內嵌中文字型（例如 Noto Sans TC，OFL 授權），放在 `assets/fonts/`，否則中文會顯示不出來。
- 產生 PDF、處理照片這類耗時工作不能卡住畫面，必要時放到背景 isolate。

## 資料庫升版

- 每次改資料表：`schemaVersion` 加 1，在 `onUpgrade` 寫對應的 migration。
- 依 drift 官方的 make-migrations 流程，把 schema 快照匯出到 `drift_schemas/` 並產生 migration 測試，確認舊版資料升級後正確。
  - 指令：`fvm dart run drift_dev make-migrations`（設定在 `build.yaml`），測試放在 `test/drift/`。
  - drift 要有兩個以上版本才會產生 migration 測試；`test/drift/rental_manager/schema_test.dart` 另外檢查「新安裝時建出的結構」和最新快照一致。升版後要把它改成比對新的版本。
- 還沒有真實使用者資料之前，schema 可以直接改；有了之後一律走 migration。

## 測試

| 對象 | 方式 |
|---|---|
| DAO、repository | 用 `NativeDatabase.memory()` 的記憶體資料庫 |
| 規則（狀態轉換、簽名前檢查、刪除規則） | 純單元測試 |
| 退租對照（找入住紀錄、判斷變差） | 純單元測試 |
| 重要畫面（點交頁的唯讀切換、簽名前檢查的提示） | widget test：用 `test/helpers/pump_app.dart` 啟動整個 App（含路由），資料庫換成記憶體資料庫 |
| 資料庫升版 | drift 的 migration 測試 |

## 為第二階段（Supabase 同步）預先遵守的規則

- 主鍵用 UUID。
- 每張表都有 `updatedAt`、`deletedAt`。
- 檔案只存相對路徑。
