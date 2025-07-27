# タスク開始ワークフローコマンド

タスク開始時の一連のワークフローを実行するClaudeコマンドです。

## 使用方法

```
/workflow-start issue番号 "タスクタイトル" "タスク詳細"
```

## 実行内容

以下の手順を一括で実行します：

1. GitHub Issueを作成
2. ワークツリーを作成・移動
3. 初期コミットを作成

```bash
# GitHub Issueを作成
gh issue create --title "$2" --body "$(cat <<'EOF'
## 概要
$3

## 実装予定
- [ ] 要件定義
- [ ] 設計
- [ ] 実装
- [ ] テスト
- [ ] ドキュメント更新

## 技術要件
（適宜追加）

## 成功基準
（適宜追加）
EOF
)"

# 現在の状態を確認・保存
git status
git checkout main
git pull origin main

# ワークツリーを作成
wt create feature/issue-$1-$(echo "$2" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

# 初期README更新（作業用）
echo "# Issue #$1: $2

## 概要
$3

## 作業ログ
- $(date): タスク開始
" > TASK_LOG.md

git add TASK_LOG.md
git commit -m "feat: issue #$1 のタスク開始

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

## 例

```
/workflow-start 42 "ユーザー認証機能の実装" "ログイン・ログアウト機能を追加する"
```

このコマンドにより、Issue作成からワークツリー作成まで一括で実行されます。