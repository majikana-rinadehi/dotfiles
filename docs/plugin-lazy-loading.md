# プラグインの遅延読み込み最適化

Zinitのturbo modeを活用してzshプラグインの遅延読み込みを実装し、シェル起動時間を最適化します。

## 最適化の概要

### パフォーマンス改善結果
- **最適化前:** 0.475秒
- **最適化後:** 0.410秒 (平均)
- **改善率:** 約13.7%の起動時間短縮

## 実装された遅延読み込み設定

### 1. zsh-autosuggestions (1秒後に読み込み)
```bash
# Load zsh-autosuggestions with zinit (lazy loading with turbo mode)
zinit ice wait"1" lucid
zinit light zsh-users/zsh-autosuggestions
```

**理由:** 自動補完候補はユーザーが入力を開始してから必要になるため、遅延読み込みが適している。

### 2. zsh-completions (2秒後に読み込み)
```bash
# Load zsh-completions with zinit (lazy loading with turbo mode)
zinit ice wait"2" lucid
zinit light zsh-users/zsh-completions
```

**理由:** 補完機能はTabキーを押した時に必要になるため、起動時の即座読み込みは不要。

### 3. zoxide (3秒後に読み込み)
```bash
# zoxide setup (lazy loading with turbo mode)
zinit ice wait"3" lucid as"command" from"gh-r" \
  mv"zoxide*/zoxide -> zoxide" \
  atclone"chmod +x zoxide && ./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide
```

**理由:** ディレクトリ移動ツールは実際に移動コマンドを使用する時に必要になるため。

## 即座読み込みを維持するプラグイン

### 1. powerlevel10k
```bash
zinit ice depth=1; zinit light romkatv/powerlevel10k
```

**理由:** プロンプトテーマは起動時に即座に表示される必要があるため。

### 2. zsh-syntax-highlighting
```bash
zinit light zsh-users/zsh-syntax-highlighting
```

**理由:** 構文ハイライトは入力時の視覚的フィードバックとして即座に必要。

## Zinitのturbo mode設定解説

### 基本的な遅延読み込み設定
```bash
zinit ice wait"<秒数>" lucid
zinit light <プラグイン名>
```

### パラメータ説明
- **wait"N"**: N秒後に読み込み
- **lucid**: 読み込み時のメッセージを抑制
- **as"command"**: バイナリとして扱う
- **from"gh-r"**: GitHub Releasesからダウンロード

### 高度な設定例
```bash
# 条件付き読み込み
zinit ice wait"1" lucid if"[[ $OSTYPE == darwin* ]]"
zinit light <macOS専用プラグイン>

# 依存関係のある読み込み
zinit ice wait"2" lucid has"git"
zinit light <Git依存プラグイン>

# トリガー条件での読み込み
zinit ice wait lucid trigger-load'!man'
zinit light <man拡張プラグイン>
```

## パフォーマンス計測方法

### 起動時間の測定
```bash
# 複数回測定して平均を取る
time zsh -i -c exit
time zsh -i -c exit
time zsh -i -c exit
```

### Zinitの詳細タイミング確認
```bash
# Zinitの読み込み時間を表示
zinit times

# プラグインの読み込み状態確認
zinit list
```

## トラブルシューティング

### 遅延読み込みが機能しない場合

1. **Zinit設定の確認**
```bash
zinit self-update
zinit update --all
```

2. **プラグインの依存関係確認**
```bash
zinit report <プラグイン名>
```

3. **手動での読み込みテスト**
```bash
zinit load <プラグイン名>
```

### パフォーマンスの追加最適化

1. **不要なプラグインの削除**
   - 使用していないプラグインを特定して削除

2. **条件付き読み込みの活用**
   - OS固有のプラグインは条件付きで読み込み

3. **バイナリプラグインの最適化**
   - GitHub Releasesからのバイナリダウンロードを活用

## ベストプラクティス

### 1. 読み込み順序の設計
- テーマ: 即座読み込み
- 構文ハイライト: 即座読み込み  
- 補完系: 1-2秒遅延
- ツール系: 3-5秒遅延

### 2. lucidオプションの活用
すべての遅延読み込みでlucidを使用してメッセージを抑制

### 3. 定期的なパフォーマンス測定
設定変更後は必ず起動時間を測定して効果を確認

## 参考リンク

- [Zinit Turbo Mode Documentation](https://github.com/zdharma-continuum/zinit#turbo-mode-zsh--53)
- [Zinit Performance Tips](https://github.com/zdharma-continuum/zinit/wiki/Performance)