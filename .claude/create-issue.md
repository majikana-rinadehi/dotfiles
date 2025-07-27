# GitHub Issue作成コマンド

GitHub Issue作成用のClaudeコマンドです。

## 使用方法

```
/create-issue タイトル "詳細説明"
```

## 実行内容

以下のコマンドを実行してGitHub Issueを作成します：

```bash
gh issue create --title "$1" --body "$2"
```

## 例

```
/create-issue "新機能の実装" "詳細な機能説明をここに記載します"
```

このコマンドにより、指定されたタイトルと本文でGitHub Issueが作成されます。