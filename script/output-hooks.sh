#!/bin/sh

header () {
  printf "\r  [ \033[00;34mINSTALL\033[0m ] %-10s$1\n" "======="
}

info () {
  printf "\r\t  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r\t  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\t\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\t\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}
