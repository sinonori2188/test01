@echo off
chcp 932
%~d0
cd /d %~dp0\HL-Client
node hl-client.js HL**** ***** 1
cmd /k
