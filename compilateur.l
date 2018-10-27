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
")" {l+=strlen(yytext);return PF;} 
"(" {l+=strlen(yytext);return PO;}
"ENDFOR" {l+=strlen(yytext);return ENDFOR;}
"FOR" {l+=strlen(yytext);return FOR;}
"ENDIF" {l+=strlen(yytext);return ENDIF;}
"ELSE" {l+=strlen(yytext);return ELSE;}
"THEN" {l+=strlen(yytext);return THEN;}
"IF" {l+=strlen(yytext);return IF;}
"FAUX" {l+=strlen(yytext);return FAUX;}
"VRAI" {l+=strlen(yytext);return VRAI;}
"!=" {l+=strlen(yytext);return DIFF;}
"==" {l+=strlen(yytext);return DEGALE;}
"<=" {l+=strlen(yytext);return INFE;}
">=" {l+=strlen(yytext);return SUPE;}
"=" {l+=strlen(yytext);return EGALE;}
"<" {l+=strlen(yytext);return INF;}
">" {l+=strlen(yytext);return SUP;}
"|" {l+=strlen(yytext);return OR;}
"&" {l+=strlen(yytext);return AND;}
"!" {l+=strlen(yytext);return NOT;}
"+" {l+=strlen(yytext);return ADD;}
"-" {l+=strlen(yytext);return MOINS;}
"/" {l+=strlen(yytext);return DIV;}
"*" {l+=strlen(yytext);return MULT;}
"define" {l+=strlen(yytext);return DEFINE;}
"UFLOAT" {l+=strlen(yytext);return UFLOATCH;}
"UINT" {l+=strlen(yytext);return UINTCH;}
"," {l+=strlen(yytext);return VIRG;}
";" {l+=strlen(yytext);return PV;}
"DEC" {l+=strlen(yytext);return DEC;}
"INST" { l+=strlen(yytext); return INST;}
"FIN" {l+=strlen(yytext);return FIN;}
{Uint} {l+=strlen(yytext);return UINT;}
{Ufloat} {l+=strlen(yytext);return UFLOAT;}
{idf} {l+=strlen(yytext);return IDF;}
. {printf("\nErreur lexical: le mot %s n'est pas reconnu a la ligne %d et la colonne %d \n",yytext,yylineno,l);l=0;}
%%
int yywrap(void)
{
return 0;
}