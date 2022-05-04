@echo off
chcp 932
%~d0
cd /d %~dp0\HL-Client
npm install
cmd /k
