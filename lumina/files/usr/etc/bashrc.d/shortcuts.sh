#!/usr/bin/env bash

# Search Youtube
function @youtube {
  [ $# -eq 0 ] && xdg-open "https://youtube.com/" && return
  xdg-open "https://youtube.com/results?search_query=$*"
}

# Search Google
function @google {
  xdg-open "https://google.com/search?q=$*"
}

# Search DuckDuckGo
function @search {
  xdg-open "https://duckduckgo.com/?q=$*"
}

# Get domain IP address
function @ip-resolver {
  local USAGE="usage: ip-resolver <domain-name> [<domain-name>..]"
  [ "$1" == "-h" ] && (>&2 echo $USAGE) && return
  [ $# -eq 0 ] && (>&2 echo $USAGE) && return
  while [ "$1" != "" ]; do
    echo "$1 " ; dig +short @resolver1.opendns.com $1 ; shift
  done
}

# Get country / location information of an IP address
function @ip-locator {
  local USAGE="usage: ip-locator <ip> [<ip>..]"
  [ "$1" == "-h" ] && (>&2 echo $USAGE) && return
  curl ipinfo.io/$1 && shift
  while [ "$1" != "" ]; do
    curl ipinfo.io/$1
    shift
  done
}

alias publicip='curl -s http://ip4only.me/api/ | cut -d"," -f2'
alias dnstest='while true; do dig www.google.com | grep time; sleep 2; done'
