@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
rem Why, Windows, won't you help me defend you? Alas, you don't do case 
rem sensitivity, except when you do case sensitivity... thanks. And you 
rem don't have a concise method for upcasing/downcasing... I bet powershell
rem could do it...
