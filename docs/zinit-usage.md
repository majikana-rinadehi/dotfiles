# Zinitの基本的な使い方

Zinitは高速で柔軟なZshプラグインマネージャーです。このドキュメントでは、Zinitの基本的な使い方について説明します。

## 目次

- [基本コマンド](#基本コマンド)
- [プラグインのインストール](#プラグインのインストール)
- [プラグインの更新・削除](#プラグインの更新削除)
- [よく使うコマンドの例](#よく使うコマンドの例)

## 基本コマンド

### Zinitのヘルプを表示

```bash
zinit help
```

### インストール済みプラグインの一覧表示

```bash
zinit list
```

### プラグインの詳細情報を表示

```bash
zinit report <プラグイン名>
```

### Zinitの統計情報を表示

```bash
zinit zstatus
```

## プラグインのインストール

### 基本的なインストール方法

#### GitHubリポジトリからインストール

```bash
# .zshrcに追加
zinit light <ユーザー名>/<リポジトリ名>

# 例：
zinit light zsh-users/zsh-syntax-highlighting
```

#### より高度なインストール（ice修飾子を使用）

```bash
# 遅延読み込み
zinit ice wait lucid
zinit light <ユーザー名>/<リポジトリ名>

# 条件付き読み込み
zinit ice if"[[ $OSTYPE == darwin* ]]"
zinit light <ユーザー名>/<リポジトリ名>
```

### Oh My Zshのプラグインをインストール

```bash
# OMZのライブラリを読み込む
zinit snippet OMZ::lib/git.zsh

# OMZのプラグインを読み込む
zinit snippet OMZ::plugins/git/git.plugin.zsh
```

### スニペット（単一ファイル）のインストール

```bash
# URLから直接インストール
zinit snippet https://example.com/script.sh

# ローカルファイルをインストール
zinit snippet /path/to/local/file.zsh
```

## プラグインの更新・削除

### すべてのプラグインを更新

```bash
zinit update --all
```

### 特定のプラグインを更新

```bash
zinit update <プラグイン名>

# 例：
zinit update zsh-users/zsh-syntax-highlighting
```

### プラグインの削除

```bash
# プラグインをアンロード
zinit unload <プラグイン名>

# プラグインを完全に削除
zinit delete <プラグイン名>

# 例：
zinit delete zsh-users/zsh-syntax-highlighting
```

### 未使用のプラグインをクリーンアップ

```bash
zinit delete --clean
```

## よく使うコマンドの例

### プラグインの管理

```bash
# インストール済みプラグインの確認
zinit list

# すべてのプラグインを一括更新
zinit update --all

# プラグインの読み込み時間を確認
zinit times
```

### トラブルシューティング

```bash
# コンパイル済みファイルを再生成
zinit compile --all

# キャッシュをクリア
zinit cclear

# プラグインの状態を確認
zinit report <プラグイン名>
```

### 便利な設定例

```bash
# .zshrcでの設定例

# シンタックスハイライト（コマンド入力時の構文強調）
zinit light zsh-users/zsh-syntax-highlighting

# 自動補完の強化
zinit light zsh-users/zsh-completions

# コマンド履歴から補完候補を表示
zinit light zsh-users/zsh-autosuggestions

# Gitのエイリアスとプロンプト表示
zinit ice wait lucid
zinit snippet OMZ::plugins/git/git.plugin.zsh

# fzfとの連携（ファジーファインダー）
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf
```

### パフォーマンスの最適化

```bash
# turbo mode（遅延読み込み）の使用
zinit ice wait'0' lucid
zinit light <プラグイン名>

# 条件付き読み込み
zinit ice wait lucid if'[[ -n "$TMUX" ]]'
zinit light <tmux関連プラグイン>

# 読み込み完了後にメッセージを表示
zinit ice wait lucid atload'echo "プラグイン読み込み完了"'
zinit light <プラグイン名>
```

## 参考リンク

- [Zinit公式ドキュメント](https://github.com/zdharma-continuum/zinit)
- [Zinit Wiki](https://github.com/zdharma-continuum/zinit/wiki)
- [Awesome Zsh Plugins](https://github.com/unixorn/awesome-zsh-plugins)