#!/usr/bin/env bash

sed -i --follow-symlinks 's/enabled=0/enabled=1/g' /etc/yum.repos.d/google-chrome.repo
