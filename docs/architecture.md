# 架構

## 技術選擇

| 用途 | 套件 |
|---|---|
| 狀態管理 | flutter_riverpod、riverpod_annotation、riverpod_generator（Riverpod 3，codegen） |
| 路由 | go_router |
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
repositories（商業規則、交易、檔案處理）
      ↓
daos（drift）＋ file_store（照片、簽名檔案）
```

- 畫面不直接碰 DAO 或檔案。
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
| `inspections` | propertyId、type（moveIn／moveOut）、status（draft／signed）、inspectedOn、landlordName、tenantName、layoutJson（空間配置快照，JSON 字串）、baseInspectionId（退租對照的入住紀錄；沒有對照為 null）、signedAt |
| `item_results` | inspectionId、roomKey（空間配置裡的空間 key）、itemKey、condition（good／damaged／missing／notApplicable，未填為 null）、note；(inspectionId, roomKey, itemKey) 不可重複 |
| `photos` | inspectionId、roomKey、itemKey、relativePath |
| `signatures` | inspectionId、role（landlord／tenant）、relativePath、signedAt；(inspectionId, role) 不可重複 |

- enum 一律存成文字（drift 的 `textEnum`），不要存 index，避免 enum 調整順序時資料錯亂。
- 時間一律存 UTC，顯示時才轉成當地時間。
- `inspectedOn` 只存日期（`YYYY-MM-DD` 文字），不做時區轉換。

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

空間配置（存在 `inspections.layoutJson`）是這筆點交實際有的空間：

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

- 路由集中在 `lib/app/router.dart`，路徑用常數定義，不在畫面裡手寫字串。
- 主要轉跳用 `context.go`，依巢狀路徑建立返回堆疊；照片檢視這類疊在上面的頁面用 `context.push`。
- 頁面參數只傳 ID，資料由 provider 依 ID 讀取。

## PDF

- 用 `pdf` 套件產生，用 `printing` 預覽、分享、列印。
- 一定要內嵌中文字型（例如 Noto Sans TC，OFL 授權），放在 `assets/fonts/`，否則中文會顯示不出來。
- 產生 PDF、處理照片這類耗時工作不能卡住畫面，必要時放到背景 isolate。

## 資料庫升版

- 每次改資料表：`schemaVersion` 加 1，在 `onUpgrade` 寫對應的 migration。
- 依 drift 官方的 make-migrations 流程，把 schema 快照匯出到 `drift_schemas/` 並產生 migration 測試，確認舊版資料升級後正確。
- 還沒有真實使用者資料之前，schema 可以直接改；有了之後一律走 migration。

## 測試

| 對象 | 方式 |
|---|---|
| DAO、repository | 用 `NativeDatabase.memory()` 的記憶體資料庫 |
| 規則（狀態轉換、簽名前檢查、刪除規則） | 純單元測試 |
| 退租對照（找入住紀錄、判斷變差） | 純單元測試 |
| 重要畫面（點交頁的唯讀切換、簽名前檢查的提示） | widget test |
| 資料庫升版 | drift 的 migration 測試 |

## 為第二階段（Supabase 同步）預先遵守的規則

- 主鍵用 UUID。
- 每張表都有 `updatedAt`、`deletedAt`。
- 檔案只存相對路徑。
