%{
#include <stdio.h>
#include <string.h>
#include "syntaxique.tab.h"
int l=0;
extern YYSTYPE yylval;
%}
%option yylineno
chiffre [0-9]
Uint (0|[1-9]{chiffre}*)
Ufloat {Uint}\.{chiffre}+
SuiteNon ((!!)*)
idf ([a-z]|([a-z](([a-z0-9]|_)*[a-z0-9])))
commentaire "<<".+">>"
erreurtiret ("_"{idf}|{idf}"_"|"_"{idf}"_")
SL [\n]
%%
")" {l+=yyleng;return PF;} 
"(" {l+=yyleng;return PO;}
"ENDFOR" {l+=yyleng;return ENDFOR;}
"FOR" {l+=yyleng;return FOR;}
"ENDIF" {l+=yyleng;return ENDIF;}
"ELSE" {l+=yyleng;return ELSE;}
"THEN" {l+=yyleng;return THEN;}
"IF" {l+=yyleng;return IF;}
"FAUX" {l+=yyleng;return FAUX;}
"VRAI" {l+=yyleng;return VRAI;}
"!=" {l+=yyleng;return DIFF;}
"==" {l+=yyleng;return DEGALE;}
"<=" {l+=yyleng;return INFE;}
">=" {l+=yyleng;return SUPE;}
"=" {l+=yyleng;return EGALE;}
"<" {l+=yyleng;return INF;}
">" {l+=yyleng;return SUP;}
"|" {l+=yyleng;return OR;}
"&" {l+=yyleng;return AND;}
{SuiteNon} {printf("Suite de non détectée et traitée \n");}
"!" {l+=yyleng;return NOT;}
"+" {l+=yyleng;return ADD;}
"-" {l+=yyleng;return MOINS;}
"/" {l+=yyleng;return DIV;}
"*" {l+=yyleng;return MULT;}
"define" {l+=yyleng;return DEFINE;}
"Ufloat" {yylval.chaine=strdup(yytext);l+=yyleng;return UFLOATCH;}
"Uint" {yylval.chaine=strdup(yytext);l+=yyleng;return UINTCH;}
"," {l+=yyleng;return VIRG;}
";" {l+=yyleng;return PV;}
"DEC" {l+=yyleng;return DEC;}
"INST" {l+=yyleng; return INST;}
"FIN" {l+=yyleng;return FIN;}
{Uint} {yylval.entier=atoi(yytext);l+=yyleng;return UINT;}
{Ufloat} {l+=yyleng;return UFLOAT;}
{idf} {yylval.chaine = strdup(yytext);l+=yyleng;return IDF;}
{commentaire} {yylval.chaine = strdup(yytext);l+=yyleng;}
" " {l+=yyleng;}
{SL} { l=0;}
. {printf("\nErreur lexical: le mot %s n'est pas reconnu a la ligne %d et la colonne %d \n",yytext,yylineno,l);l=0;}
%%
int yywrap(void)
{
return 0;
}