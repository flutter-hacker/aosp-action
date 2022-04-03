#!/bin/bash

set -v # show current command
set -x

function checkResult() {
    if [ $? -ne 0 ]; then
        echo "Last command failed, exit."
        exit $?
    fi
}

pwd

export REPO=$(mktemp /tmp/repo.XXXXXXXXX)
curl -o ${REPO} https://storage.googleapis.com/git-repo-downloads/repo
gpg --recv-key 8BB9AD793E8E6153AF0F9A4416530D5E920F5C65
mkdir -p ~/bin/
curl -s https://storage.googleapis.com/git-repo-downloads/repo.asc | gpg --verify - ${REPO} && install -m 755 ${REPO} ~/bin/repo
export PATH=~/bin/:$PATH

repo version

df -h

cd ~ && mkdir aosp && cd aosp
git config --global user.name eggfly
git config --global user.email eggfly@qq.com
git config --global color.ui auto

repo init --depth=1 -u https://android.googlesource.com/platform/manifest
checkResult

sysctl -n hw.ncpu

repo sync -c -j`sysctl -n hw.ncpu`
checkResult

df -h

cd frameworks/base
git log


echo "Done!"
