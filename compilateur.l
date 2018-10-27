%{
#include <stdio.h>
#include <string.h>
#include "syntaxique.tab.h"
int l=0;
%}
%option yylineno
espace " "
chiffre [0-9]
separateur (","|";"|"+"|"-"|"/"|">"|"<"|"("|")"|"!"|"&"|"*"|"=")
Uint (0|[1-9]{chiffre}*)
Ufloat {Uint}\.{chiffre}+
idf ([a-z]|([a-z](([a-z0-9]|_)*[a-z0-9])))
commentaire "<<".+">>"
erreurtiret ("_"{idf}|{idf}"_"|"_"{idf}"_")
%%
"DEC" {l+=strlen(yytext);return DEC;}
"INST" { l+=strlen(yytext); return INST;}
"FIN" {l+=strlen(yytext);return FIN;}
{idf} {l+=strlen(yytext);return IDF;} 
. {printf("\nErreur lexical: le mot %s n'est pas reconnu a la ligne %d et la colonne %d \n",yytext,yylineno,l);l=0;}
%%
int yywrap(void)
{
return 0;
}