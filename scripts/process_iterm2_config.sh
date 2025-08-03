#!/bin/bash

# iTerm2設定ファイルのテンプレート処理スクリプト
# $USERなどの変数を実際の値に置換します

set -e

# 入力と出力のファイルパス
TEMPLATE_FILE="$1"
OUTPUT_FILE="$2"

if [ -z "$TEMPLATE_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "Usage: $0 <template_file> <output_file>"
    exit 1
fi

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file not found: $TEMPLATE_FILE"
    exit 1
fi

# テンプレートファイルを読み込んで変数を展開
echo "Processing iTerm2 configuration template..."

# sedを使用して$USERを実際のユーザー名に置換
sed "s|\$USER|$USER|g" "$TEMPLATE_FILE" > "$OUTPUT_FILE"

echo "iTerm2 configuration processed successfully."
echo "Output file: $OUTPUT_FILE"