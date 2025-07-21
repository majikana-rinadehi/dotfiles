# Git Worktree機能の使用ガイド

Git Worktreeを使って同一リポジトリの複数ブランチを並行開発できる機能の使用方法を説明します。

## 概要

Git Worktreeの利点：
- 複数の機能開発を並行実行
- ブランチ切り替え時間の短縮
- hotfix対応と機能開発の両立

## Worktree管理スクリプト

`scripts/worktree-manager.sh`が`make install`後に`worktree-manager`コマンドとして利用可能になります。

## 基本コマンド

### Worktreeの作成
```bash
worktree-manager create feature/new-function
worktree-manager create feature/new-function ../custom-path
worktree-manager c feature/new-function  # 短縮形
```

### 一覧表示
```bash
worktree-manager list
worktree-manager l  # 短縮形
```

### 削除
```bash
worktree-manager delete ../feature-path
worktree-manager d ../feature-path  # 短縮形
```

### 移動
```bash
worktree-manager move ../feature-path
worktree-manager m ../feature-path  # 短縮形
```

## Claude Codeとの統合

### 基本ワークフロー
```bash
# 新機能開発開始
worktree-manager create feature/issue-XX-description
cd ../issue-XX-description
claude-code

# 作業完了後の清理
cd ~/dotfiles
worktree-manager delete ../issue-XX-description
```

## 実用例

### 並行開発
```bash
# 複数機能を同時開発
worktree-manager create feature/user-auth
worktree-manager create feature/data-export

# 進捗確認と切り替え
worktree-manager list
cd ../user-auth    # 機能A
cd ../data-export  # 機能B
```

### 緊急対応
```bash
# 機能開発中に緊急修正が必要
cd ~/dotfiles
worktree-manager create hotfix/critical-bug
cd ../critical-bug
# ... 緊急修正 ...
worktree-manager delete ../critical-bug
cd ../original-feature  # 元の作業に戻る
```

## トラブルシューティング

### よくあるエラー

**パス既存エラー**
```
エラー: パス '../feature-name' は既に存在します
```
解決方法：別のパス名を使用するか既存ディレクトリを削除

**削除失敗エラー**
```
エラー: worktreeの削除に失敗しました
```
解決方法：実行中プロセスがないか確認、未コミット変更を確認

**パス不存在エラー**
```
エラー: パス '../feature-name' は存在しません
```
解決方法：`worktree-manager list`で正確なパスを確認

### 制限事項
- 同じブランチを複数Worktreeで同時チェックアウト不可
- サブモジュール含むリポジトリでは追加設定が必要な場合がある

## 高度な使用方法

### 直接Gitコマンドを使用
```bash
# 既存ブランチからWorktree作成
git worktree add -b local-branch ../existing-work origin/existing-branch

# 手動でWorktree管理
git worktree add -b feature/manual ../manual-work
git worktree remove ../manual-work
git worktree list --porcelain
```

## 参考リンク
- [Git Worktree公式ドキュメント](https://git-scm.com/docs/git-worktree)
- [プロジェクトのワークフロー](./claude-task-workflow.md)