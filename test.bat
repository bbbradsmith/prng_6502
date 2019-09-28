@del ..\output\test.c.s
@del ..\output\*.o
@del ..\output\test.bin

cc65\bin\ca65 -o output\common.o -g common.s
@IF ERRORLEVEL 1 GOTO error

cc65\bin\ca65 -o output\galois16.o -g galois16.s
@IF ERRORLEVEL 1 GOTO error

cc65\bin\ca65 -o output\galois24.o -g galois24.s
@IF ERRORLEVEL 1 GOTO error

cc65\bin\ca65 -o output\galois32.o -g galois32.s
@IF ERRORLEVEL 1 GOTO error

cc65\bin\ca65 -o output\xorshift.o -g xorshift.s
@IF ERRORLEVEL 1 GOTO error

cc65\bin\cc65 -o output\test.c.s -T -O -g test.c
@IF ERRORLEVEL 1 GOTO error

cc65\bin\ca65 -o output\test.c.o -g output\test.c.s
@IF ERRORLEVEL 1 GOTO error

cc65\bin\ld65 -o output\test.bin -C test.cfg -m output\test.bin.map output\test.c.o output\common.o output\galois16.o output\galois24.o output\galois32.o output\xorshift.o sim6502.lib
@IF ERRORLEVEL 1 GOTO error

cc65\bin\sim65 output\test.bin
@IF ERRORLEVEL 1 GOTO error

@echo.
@echo.
@echo Build and test successful!
@pause
@GOTO end
:error
@echo.
@echo.
@echo Build or test error!
@pause
:end