# 租賃管理平台（Rental Manager）

租賃管理平台的 App。第一版先做離線優先的點交功能：入住、退租時逐項檢查房屋狀況、拍照、雙方簽名，退租時對照入住紀錄，現場產生 PDF 點交單。
這是個人 side project，也是作品集；程式碼品質和開發過程都會被檢視。

## 開始工作前

1. 先讀 `docs/product.md`（要做什麼）和 `docs/architecture.md`（怎麼做）。
2. 確認這次要做的是 `docs/roadmap.md` 的哪個 task；不在清單上的事先問我。
3. 規格沒寫清楚，或有兩種以上合理做法時，先問，並附上你的建議。不要自己推測。

## 溝通

- 一律用繁體中文回覆。
- 做完要回報：改了什麼、怎麼驗證的、還有什麼沒做或有風險。
- 測試失敗、指令沒跑、有步驟跳過，都要照實說。

## 指令

Flutter 一律用 fvm，版本以 `.fvmrc` 為準。

```bash
fvm flutter pub get
fvm dart run build_runner build   # 改了 drift、riverpod、freezed 相關程式碼之後
fvm flutter analyze               # 必須 0 issue
fvm flutter test
fvm flutter run
```

## 開發規則

1. 一次只做一個 task，改動不超出 task 範圍。不要順手重構，也不要改無關的檔案。
2. 改動要小到我看得完。一次的 diff 太大，就先拆成幾步，每步停下來讓我看。
3. 動手前先列出這次的驗收條件；完成時要有對應的測試，而且測試要驗證行為，不是照著實作抄一遍。
4. 新增套件前先問我，說明為什麼需要、有沒有不用套件的做法。先確認套件在 pub.dev 真的存在、有人維護、授權可用。
5. 不要過度設計：不寫用不到的抽象層，不預留「以後可能用到」的參數。專案裡已經有的 helper 先拿來用，不要重寫一份。
6. 錯誤不能吞掉：catch 之後要處理或往上丟，不寫空的 catch。
7. 規格沒寫、你自己推論出來的邏輯，要在註解標「推論：」並寫出依據，回報時列出來，方便我確認或還原。
8. 改了資料表，就要升 `schemaVersion`、寫 migration、更新 schema 快照和 migration 測試（見 `docs/architecture.md`）。
9. 行為、架構或決策有變動時，在同一次改動裡一起更新 `docs/`；新的架構決策追加到 `docs/decisions.md`。

## 完成的定義

- [ ] `fvm flutter analyze` 0 issue
- [ ] `fvm flutter test` 全部通過，新功能有新測試
- [ ] 有改到產生檔來源時，已重跑 build_runner
- [ ] 相關的 `docs/` 已更新
- [ ] 回報裡寫了驗證方式

## Git

- 不要 commit 或 push，除非我明確要求。
- commit 訊息格式：`類型:描述`（冒號後不空格）。類型用 `feat`、`fix`、`refactor`、`test`、`docs`、`chore`。例如：`feat:點交頁加入照片上傳`
- 一個 commit 只做一件事。
- AI 參與的 commit 保留 `Co-Authored-By` 那一行。

## 禁止事項

- 金鑰、token、個資不寫進程式碼，也不 commit。
- 不使用任何公司或客戶專案的程式碼、資料或文件。
- 不關掉、不繞過 lint 或測試來讓檢查通過。
