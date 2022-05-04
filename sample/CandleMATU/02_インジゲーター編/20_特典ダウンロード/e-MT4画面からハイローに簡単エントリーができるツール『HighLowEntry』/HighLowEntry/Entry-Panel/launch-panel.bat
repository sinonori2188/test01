@echo off
chcp 932
%~d0
cd /d %~dp0\HL-Panel
./node_modules/.bin/electron .
cmd /k
