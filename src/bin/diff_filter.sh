#!/bin/bash

BASE_REMOTE=origin
BASE_BRANCH=develop
#BASE_BRANCH=master

git fetch $BASE_REMOTE $BASE_BRANCH
git branch $BASE_BRANCH $BASE_REMOTE/$BASE_BRANCH
diff_list=()
# このブランチのコミットのリスト
commit_list=`git --no-pager log --no-merges $BASE_REMOTE/$BASE_BRANCH...HEAD | grep -e '^commit' | sed -e "s/^commit \(.\{8\}\).*/\1/"`

echo "コミット一覧"
echo $commit_list

echo "変更したファイル一覧"
echo `git --no-pager diff --diff-filter=ACMR $BASE_REMOTE/$BASE_BRANCH...HEAD --name-only`


# web/config/database.ymlだったらwebをとって下記でアクセスできる
# /config/database.yml
for f in `git --no-pager diff --diff-filter=ACMR $BASE_REMOTE/$BASE_BRANCH...HEAD --name-only`; do
  for c in $commit_list; do
    diffs=`cd .. && git --no-pager blame --show-name -s $f | grep $c | sed -e "s/^[^ ]* *\([^ ]*\) *\([0-9]*\)*).*$/\1:\2/"`
#    diffs=`git --no-pager blame --show-name -s $f | grep $c | sed -e "s/^[^ ]* *\([^ ]*\) *\([0-9]*\)*).*$/\1:\2/"`
    echo $diffs
    for ln in $diffs; do
      diff_list+=( $ln )
    done
  done
done

# 差分一覧
echo "diff_list"
echo "${array[*]}"

err_count=0
while read -r ln; do
  for m in ${diff_list[@]}; do
    if [[ ${ln} =~ ^$m ]]; then
      echo $ln
      err_count=$((err_count+1))
      break
    fi
  done
done < /dev/stdin

if [ $err_count -ne 0 ]; then
  echo -e "\033[0;31mERROR FOUND, check above messages.\033[0;39m"
  exit 1
fi
