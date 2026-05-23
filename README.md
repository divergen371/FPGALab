# Tang Nano 9K FPGA/HDL/CPU 学習ラボ (tang-nano-9k-lab)

Apple Silicon Mac環境で、オープンソースのツールチェーンを活用しながら、SystemVerilogによる論理回路設計から独自ISAを持つ最小CPUの実装、そしてTang Nano 9K実機での動作確認までを段階的に学ぶためのラボプロジェクトです。

---

## 🚀 プロジェクト概要

本プロジェクトは、FPGA・HDL・論理回路・CPU設計を基礎から段階的に学ぶための実験環境です。
最終目標は、**独自ISA（命令セットアーキテクチャ）を持つ最小の8ビットCPUをSystemVerilogで設計し、Tang Nano 9Kの実機で動作させること**です。

---

## 🛠 前提環境 & ツールチェーン

Apple Silicon Mac (MacBook Air等) で以下のオープンソースEDAツールチェーンを使用します。

- **シミュレーション・検証**:
  - [Icarus Verilog (`iverilog`)](https://github.com/steveicarus/iverilog): シミュレータ (SystemVerilog-2012 対応)
  - [GTKWave](https://gtkwave.sourceforge.net/): 波形ビューア
  - `slang`: Linter / 静的解析ツール
- **合成・配置配線 (Gowin FPGA向け)**:
  - [Yosys](https://github.com/YosysHQ/yosys): 論理合成ツール (`synth_gowin` ターゲット)
  - [nextpnr-himbaechel](https://github.com/YosysHQ/nextpnr): 配置配線ツール (Gowinサポート用)
  - `gowin_pack`: ビットストリーム（`.fs` ファイル）生成ツール
- **実機書き込み**:
  - [openFPGALoader](https://github.com/trabucayre/openFPGALoader): Tang Nano 9Kへの書き込みツール
- **フォーマッタ**:
  - `verible-verilog-format`: コードフォーマッタ

---

## 📂 プロジェクト構成

```text
tang-nano-9k-lab/
├── rtl/               # SystemVerilog ソースコード (.sv)
│   ├── alu4.sv        # 4ビットALU
│   ├── blinky.sv      # 単純なLED点滅回路 (L-chika)
│   └── counter_led.sv # 6ビットLEDカウンタ回路
├── tb/                # テストベンチ (.sv)
│   └── tb_alu4.sv     # 4ビットALU用テストベンチ
├── constraints/       # ピン配置制約ファイル (.cst)
│   └── tangnano9k.cst # Tang Nano 9K用物理ピン配置制約
├── sim/               # シミュレーション生成物 (VCD, VVP) (Git管理除外)
├── build/             # 実機合成用ビルド成果物 (JSON, FS) (Git管理除外)
├── docs/              # 設計ドキュメント・学習指導書
├── Makefile           # ビルドライフサイクル管理
├── .verible-format    # Verible フォーマット設定ファイル
└── README.md          # 本ドキュメント
```

---

## 🗺 学習ロードマップ

**詳細はdocs/fpga_hdl_cpu_coaching_directive_core.md参照**
### Phase 1: HDL / SystemVerilog基礎 (LED & スイッチ)
- `module`, `logic`, `assign`, `always_comb`, `always_ff`, 同期リセットの基礎。
- **実績**: LED点滅 (`blinky`), 複数LEDカウンタ (`counter_led`) 実機動作確認済み。
- **課題**: スイッチ入力、チャタリング防止（デバウンス）、ワンショットパルス生成。

### Phase 2: 論理回路基礎 (ゲート & MUX & Adder)
- MUX (2:1, 4:1)、デコーダ、エンコーダ、半加算器、全加算器、4bit加算器、コンパレータ、シフタの設計。

### Phase 3: ALU設計 (4bitから8bitへ)
- 算術論理演算器 (ALU) の設計。
- **実績**: 4bit ALU (`alu4`) の設計およびシミュレーション確認済み。
- **課題**: 8bit ALUへの拡張、および実機（DIPスイッチやLED）での演算動作テスト。

### Phase 4: レジスタ & 状態機械 (FSM)
- フリップフロップ、Enable/Reset付きレジスタ、PC (Program Counter)、レジスタファイル、有限状態機械 (FSM) の設計。

### Phase 5: 最小データパスの統合
- PC、命令ROM、レジスタファイル、ALU、制御ユニットを接続したマルチサイクルCPUの骨格設計。

### Phase 6: 独自ISA設計
- 8bitデータ、16bit命令幅、R0-R7の8レジスタを持つ最小命令セット (Setia-8 / TinyCPU) の策定。

### Phase 7 & 8: CPU実装 & 実機動作検証
- 段階的に命令を実装し、シミュレーション検証後、Tang Nano 9Kの実機でプログラムを実行。LEDやUART経由で実行結果を確認。

---

## 💻 開発フロー & コマンド

本プロジェクトは `Makefile` により、フォーマット・シミュレーション・実機合成の一連のフローが自動化されています。

### 1. コードの自動フォーマット
コーディング規約に従って `.verible-format` 設定に基づきコードを整形します。
```bash
make fmt
```

### 2. シミュレーション & 波形確認
`iverilog` を用いてシミュレーションを実行し、`GTKWave` で信号波形を確認します。
*(現在は `alu4` が対象)*
```bash
# シミュレーションの実行 (VCD波形ファイルの出力)
make sim

# GTKWaveで波形を観測
make wave
```

### 3. 実機合成 & 書き込み (Tang Nano 9K)
物理制約ファイル `constraints/tangnano9k.cst` に基づき、論理合成、配置配線、書き込みまでをワンストップで行います。
*(現在は `counter_led` が実機ターゲット)*
```bash
# 論理合成 (Yosys)
make synth

# 配置配線 (nextpnr-himbaechel)
make pnr

# ビットストリームパック (gowin_pack)
make pack

# 実機 (Tang Nano 9K) への書き込み
make prog
```
すべてを一度に行う場合は、以下を実行します：
```bash
make prog
```

### 4. クリーンアップ
ビルド成果物やシミュレーションの一時ファイルを削除します。
```bash
make clean
```

---

## 📐 重要なコーディング規約

1. **同期リセットの徹底**
   ```systemverilog
   always_ff @(posedge clk) begin
       if (reset) begin
           q <= '0;
       end else begin
           q <= d;
       end
   end
   ```
2. **組み合わせ回路におけるデフォルト代入**
   `always_comb` を用いる際、意図しないラッチの生成を防ぐため、必ずデフォルト値を記述します。
   ```systemverilog
   always_comb begin
       y = '0;
       case (op)
           ...
           default: y = '0;
       endcase
   end
   ```
3. **テストベンチでの波形出力指定**
   シミュレーション結果を可視化するため、テストベンチの `initial` ブロック冒頭に以下を記述します。
   ```systemverilog
   $dumpfile("sim/<module_name>.vcd");
   $dumpvars(0, <tb_name>);
   ```
