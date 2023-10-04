setlocal
set fart1=fart1
if defined fart1 (
    echo fart1
    set fart2=fart2
    echo %fart1% %fart2%
) else (
    echo fart3
    set fart3=fart3
    echo %fart1% %fart3%
)
echo fart1 %fart1%
echo fart2 %fart2%
echo fart3 %fart3%
endlocal
