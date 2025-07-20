# Zinitの基本的な使い方

Zinitは高速で柔軟なZshプラグインマネージャーです。

## 基本コマンド

```bash
zinit help                      # ヘルプを表示
zinit list                      # インストール済みプラグイン一覧
zinit report <プラグイン名>     # プラグインの詳細情報
zinit zstatus                   # 統計情報を表示
```

## プラグインのインストール

### GitHubリポジトリから
```bash
# 基本形
zinit light <ユーザー名>/<リポジトリ名>

# 遅延読み込み
zinit ice wait lucid
zinit light <ユーザー名>/<リポジトリ名>

# 条件付き読み込み
zinit ice if"[[ $OSTYPE == darwin* ]]"
zinit light <ユーザー名>/<リポジトリ名>
```

### Oh My Zshのプラグイン
```bash
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh
```

### スニペット
```bash
zinit snippet https://example.com/script.sh
zinit snippet /path/to/local/file.zsh
```

## プラグインの更新・削除

```bash
zinit update --all              # すべて更新
zinit update <プラグイン名>     # 特定のプラグインを更新
zinit unload <プラグイン名>     # アンロード
zinit delete <プラグイン名>     # 完全削除
zinit delete --clean            # 未使用プラグインをクリーンアップ
```

## よく使う設定例

```bash
# 必須プラグイン
zinit light zsh-users/zsh-syntax-highlighting  # シンタックスハイライト
zinit light zsh-users/zsh-completions          # 自動補完の強化
zinit light zsh-users/zsh-autosuggestions      # 履歴から補完候補

# Git連携
zinit ice wait lucid
zinit snippet OMZ::plugins/git/git.plugin.zsh

# fzf（ファジーファインダー）
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

# turbo mode（遅延読み込み）
zinit ice wait'0' lucid
zinit light <プラグイン名>
```

## トラブルシューティング

```bash
zinit times                     # 読み込み時間を確認
zinit compile --all            # ファイルを再コンパイル
zinit cclear                   # キャッシュをクリア
```

## 参考リンク

- [Zinit公式ドキュメント](https://github.com/zdharma-continuum/zinit)