# Git Worktree機能の使用ガイド

このドキュメントでは、dotfilesプロジェクトで利用可能なGit Worktree機能について説明します。

## 概要

Git Worktreeは、同一リポジトリの複数のブランチを同時に異なるディレクトリで作業することを可能にする機能です。これにより、以下のような利点があります：

- 複数の機能開発を並行して進められる
- ブランチ切り替えによるビルド時間の短縮
- 異なるブランチでのテストを同時実行可能
- hotfixなど緊急対応とfeature開発の両立

## Worktree管理スクリプト

dotfilesプロジェクトには、Worktreeを簡単に管理するためのスクリプトが含まれています。

### スクリプトの場所
```
scripts/worktree-manager.sh
```

`make install`実行後、`worktree-manager`コマンドとして`$HOME/bin`にシンボリックリンクされます。

## 基本的な使用方法

### 1. Worktreeの作成

新しい機能ブランチ用のWorktreeを作成：

```bash
# 基本的な作成方法
worktree-manager create feature/new-function

# カスタムパスを指定
worktree-manager create feature/new-function ../my-feature-work

# 短縮形も利用可能
worktree-manager c feature/new-function
```

### 2. Worktree一覧の確認

現在のWorktreeをすべて表示：

```bash
worktree-manager list

# 短縮形
worktree-manager l
```

出力例：
```
/Users/username/dotfiles    634945f [main]
/Users/username/new-function 1a2b3c4 [feature/new-function]
```

### 3. Worktreeの削除

不要になったWorktreeを削除：

```bash
worktree-manager delete ../new-function

# 短縮形
worktree-manager d ../new-function
```

### 4. Worktreeへの移動

指定したWorktreeディレクトリへの移動コマンドを表示：

```bash
worktree-manager move ../new-function

# 短縮形
worktree-manager m ../new-function
```

## Claude Codeとの統合

### 作業フロー

1. **新しい機能開発の開始**
   ```bash
   # 新しいWorktreeを作成
   worktree-manager create feature/issue-XX-description
   
   # Worktreeに移動
   cd ../issue-XX-description
   
   # Claude Codeを起動
   claude-code
   ```

2. **並行作業の管理**
   ```bash
   # 現在の作業状況を確認
   worktree-manager list
   
   # 別のWorktreeで緊急対応
   worktree-manager create hotfix/urgent-fix
   cd ../urgent-fix
   ```

3. **作業完了後の清理**
   ```bash
   # メインディレクトリに戻る
   cd ~/src/github.com/majikana-rinadehi/dotfiles
   
   # 不要なWorktreeを削除
   worktree-manager delete ../issue-XX-description
   ```

### Claude Codeでの注意点

- 各Worktreeは独立したワーキングディレクトリです
- Claude Codeのコンテキストは各Worktree固有です
- ファイル参照時は現在のWorktreeのパスを確認してください

## 実用例

### シナリオ1: 機能開発中の緊急対応

```bash
# 現在feature/new-dashboardで作業中
cd ~/dotfiles  # メインリポジトリに戻る

# 緊急修正用Worktreeを作成
worktree-manager create hotfix/critical-bug

# 緊急修正を実施
cd ../critical-bug
# ... 修正作業 ...

# PRを作成・マージ後、Worktreeを削除
worktree-manager delete ../critical-bug

# 元の作業に戻る
cd ../new-dashboard
```

### シナリオ2: 複数機能の並行開発

```bash
# 機能A用のWorktree
worktree-manager create feature/user-auth

# 機能B用のWorktree  
worktree-manager create feature/data-export

# 両方の進捗を確認
worktree-manager list

# 作業を切り替えながら開発
cd ../user-auth    # 機能A作業
cd ../data-export  # 機能B作業
```

## トラブルシューティング

### よくある問題と解決方法

1. **Worktree作成時のエラー**
   ```
   エラー: パス '../feature-name' は既に存在します
   ```
   **解決方法**: 別のパス名を使用するか、既存のディレクトリを削除

2. **Worktree削除時のエラー**
   ```
   エラー: worktreeの削除に失敗しました
   ```
   **解決方法**: 
   - そのWorktreeで実行中のプロセスがないか確認
   - 未コミットの変更がないか確認

3. **移動時のパスエラー**
   ```
   エラー: パス '../feature-name' は存在しません
   ```
   **解決方法**: `worktree-manager list`で正確なパスを確認

### Git Worktreeの制限事項

- 同じブランチを複数のWorktreeで同時にチェックアウトできません
- サブモジュールを含むリポジトリでは追加設定が必要な場合があります
- 一部のGitフックは各Worktreeで個別に設定する必要があります

## 高度な使用方法

### 既存ブランチからWorktreeを作成

```bash
# 既存のリモートブランチをWorktreeとして作成
git worktree add -b local-branch ../existing-work origin/existing-branch
```

### Worktreeの手動管理

スクリプトを使わずに直接Gitコマンドを使用：

```bash
# 手動でWorktreeを作成
git worktree add -b feature/manual ../manual-work

# 手動でWorktreeを削除
git worktree remove ../manual-work

# Worktree一覧（詳細情報付き）
git worktree list --porcelain
```

## 参考リンク

- [Git Worktree公式ドキュメント](https://git-scm.com/docs/git-worktree)
- [Claude Code公式ドキュメント](https://docs.anthropic.com/en/docs/claude-code)
- [プロジェクトのワークフロー](./claude-task-workflow.md)