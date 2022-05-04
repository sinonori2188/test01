@echo off
chcp 932
%~d0
cd /d %~dp0\HL-Server
npm install
cmd /k
