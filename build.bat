@echo off

haxe -m ProjectCreator.hx --interp -D %*

IF %1 == "hashlink" (
    lime test hl
) ELSE (
    lime test %*
)