# Git Worktree Manager

複数ブランチでの同時作業を効率化するgit worktree管理ツールです。

## 概要

git worktreeを使うことで、同一リポジトリで複数のブランチを同時に操作できます。これにより以下の問題が解決されます：

- ブランチ切り替え時の頻繁なstash/commit
- 作業中のコンテキスト損失
- コードレビュー時の作業中断

## 基本的な使い方

### コマンド形式
```bash
worktree-manager <command> [options]
# または短縮形
wt <command> [options]
```

### 主要コマンド

#### 新しいworktreeを作成
```bash
wt add feature-branch          # ../feature-branchに作成
wt add feature-branch ./work   # ./workに作成
```

#### worktree一覧を表示
```bash
wt list
```

#### worktreeを選択して移動（pecoを使用）
```bash
wt select
```

#### worktreeを削除（pecoで選択）
```bash
wt remove
```

#### 不要なworktreeエントリを削除
```bash
wt prune
```

#### ヘルプを表示
```bash
wt help
```

## 使用例

### 1. 新機能開発とバグ修正を並行作業

```bash
# メインの作業ディレクトリ
cd ~/projects/myapp
git checkout main

# 新機能用のworktreeを作成
wt add feature-auth ../myapp-feature-auth

# バグ修正用のworktreeを作成  
wt add hotfix-login ../myapp-hotfix-login

# worktree一覧を確認
wt list
# /Users/user/projects/myapp         abcd123 [main]
# /Users/user/projects/myapp-feature-auth  efgh456 [feature-auth]
# /Users/user/projects/myapp-hotfix-login  ijkl789 [hotfix-login]

# 新機能開発に移動
cd ../myapp-feature-auth
# 新機能を実装...

# バグ修正に移動
cd ../myapp-hotfix-login  
# バグ修正を実装...

# メインに戻る
cd ~/projects/myapp
```

### 2. コードレビュー時の活用

```bash
# 現在の作業を中断せずにレビュー用worktreeを作成
wt add review-pr-123 ../review-pr-123

# レビュー用ディレクトリに移動
cd ../review-pr-123

# PRブランチをチェックアウト
git checkout origin/feature-new-ui

# レビュー完了後、worktreeを削除
wt remove
# pecoでreview-pr-123を選択して削除
```

### 3. pecoを使った快適なナビゲーション

```bash
# worktree間の移動
wt select
# ↓ pecoで選択
# > /Users/user/projects/myapp
#   /Users/user/projects/myapp-feature-auth
#   /Users/user/projects/myapp-hotfix-login
```

## 依存関係

- **peco**: worktreeの選択機能で使用
- **git 2.5+**: worktree機能が必要

## 注意事項

- worktreeは同一リポジトリ内で同じブランチを複数チェックアウトできません
- 各worktreeは独立したワーキングディレクトリを持ちます
- worktree削除時は、未コミットの変更がないことを確認してください

## トラブルシューティング

### pecoが見つからない場合
```bash
# macOS (Homebrew)
brew install peco

# Ubuntu/Debian
sudo apt install peco
```

### worktreeが削除できない場合
```bash
# 強制削除
git worktree remove --force <path>

# または手動でディレクトリを削除後
git worktree prune
```