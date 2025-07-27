# コミット・プッシュコマンド

変更をコミットし、リモートにプッシュするClaudeコマンドです。

## 使用方法

```
/commit-and-push "コミットメッセージ"
```

## 実行内容

以下の手順を実行します：

1. 現在のgit状態を確認
2. 全ての変更をステージング
3. コミットを作成
4. リモートにプッシュ

```bash
# 現在の状態を確認
git status

# 変更された全ファイルをステージング
git add .

# コミットを作成
git commit -m "$(cat <<'EOF'
$1

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# リモートにプッシュ
git push origin HEAD
```

## 例

```
/commit-and-push "新機能のユーザー認証を実装"
```

このコマンドにより、指定されたメッセージでコミットが作成され、リモートにプッシュされます。