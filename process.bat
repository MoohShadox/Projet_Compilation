win_flex compilateur.l
win_bison syntaxique.y
gcc lex.yy.c syntaxique.tab.c -o exec
exec
Pause