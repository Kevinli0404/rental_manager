# Rental Manager（租賃管理平台）

房東和房客在入住、退租時，用手機逐項檢查房屋狀況、拍照、雙方簽名；退租時對照入住紀錄，現場產生 PDF 點交單。

第一版只做點交，而且全部離線、資料只存在裝置上。目前還在開發中，進度見 [docs/roadmap.md](docs/roadmap.md)。

## 開發環境

- [fvm](https://fvm.app/)：Flutter 版本以 [`.fvmrc`](.fvmrc) 為準
- iOS：Xcode
- Android：Android Studio（Android SDK）

## 開始

```bash
git clone <repo-url>
cd rental_manager
fvm install
fvm flutter pub get
fvm flutter run
```

## 常用指令

```bash
fvm flutter analyze               # 必須 0 issue
fvm flutter test
fvm dart run build_runner build   # 改了 drift、riverpod、freezed 相關程式碼之後
```

每次 push 都會由 GitHub Actions 跑 analyze 和 test（[`.github/workflows/ci.yml`](.github/workflows/ci.yml)）。

## 文件

| 文件 | 內容 |
|---|---|
| [docs/product.md](docs/product.md) | 產品規格：要做什麼、頁面、規則 |
| [docs/architecture.md](docs/architecture.md) | 架構：技術選擇、分層、資料表 |
| [docs/roadmap.md](docs/roadmap.md) | 開發計畫與進度 |
| [docs/decisions.md](docs/decisions.md) | 架構決策紀錄 |

## 我怎麼使用 AI

這個專案搭配 [Claude Code](https://claude.com/claude-code) 開發。做法如下：

- **先寫文件，再寫程式。** 規格、架構、開發計畫和決策紀錄都放在 `docs/`。AI 每次開始工作前先讀這些文件，確認這次要做的是 roadmap 上的哪個 task。
- **規則寫在 [`CLAUDE.md`](CLAUDE.md)。** 例如：一次只做一個 task；改動小到看得完；動手前先列驗收條件；測試要驗證行為；新增套件前先問；規格沒寫、自己推論出來的邏輯要標「推論：」。
- **分工。** 做什麼、選哪個方案、要不要 commit，由我決定；AI 提出做法和建議、實作，跑 analyze 和測試，並回報怎麼驗證、還有什麼沒做。每一步的 diff 我都會看過。
- **留下紀錄。** 有 AI 參與的 commit 都保留 `Co-Authored-By`，從 git log 就看得出哪些改動有 AI 參與。重要的決定寫進 `docs/decisions.md`，包含沒採用的做法。
