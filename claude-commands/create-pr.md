# プルリクエスト作成コマンド

プルリクエストを作成するClaudeコマンドです。

## 使用方法

```
/create-pr "PR タイトル" "PR 概要"
```

## 実行内容

以下の手順を実行します：

1. 現在のgit状態を確認
2. ブランチとリモートの同期状況を確認
3. 全コミット履歴を確認
4. プルリクエストを作成

```bash
# 現在の状態を確認
git status

# diff確認
git diff

# ブランチの同期状況を確認
git log --oneline -10

# mainブランチとの差分を確認
git diff main...HEAD

# プルリクエストを作成
gh pr create --title "$1" --body "$(cat <<'EOF'
## 概要
$2

## 変更内容
- 変更点の詳細

## テスト計画
- [ ] 機能テストの実行
- [ ] 既存機能への影響確認

🤖 Generated with [Claude Code](https://claude.ai/code)
EOF
)"
```

## 例

```
/create-pr "新機能の追加" "ユーザー認証機能を追加しました"
```

このコマンドにより、指定されたタイトルと概要でプルリクエストが作成されます。