#! /usr/local/bin/zsh
cd /TopStor
echo ready > out  &
nc -lk 2236 < out >/dev/null 
