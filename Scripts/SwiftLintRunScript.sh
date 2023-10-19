#!/bin/sh

#  SwiftLintRunScript.sh
#  Manifests
#
#  Created by 오 국 원 on 2022/11/15.
#

#export PATH="$PATH:/opt/homebrew/bin"
#
#if which swiftlint >/dev/null; then
#    swiftlint
#
#else
#    echo "warning: SwiftLint not installed, download form https://github.com/realm/SwiftLint"
#fi


#
#export PATH="$PATH:/opt/homebrew/bin"
#
#if which swiftlint > /dev/null; then
#    swiftlint
#else
#    echo "warning: SwiftLint not installed, download form https://github.com/realm/SwiftLint"
#fi

export PATH="$PATH:/opt/homebrew/bin"

# 현재 스크립트의 디렉토리 경로를 가져옴
SCRIPT_DIR=$(dirname "$0")

# .swiftlint.yml 파일의 경로 설정
CONFIG_PATH="$SCRIPT_DIR/.swiftlint.yml"

if which swiftlint > /dev/null; then
    swiftlint --config "$CONFIG_PATH"
else
    echo "warning: SwiftLint not installed, download form https://github.com/realm/SwiftLint"
fi
