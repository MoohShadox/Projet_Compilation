%{
#include <stdio.h>
#include <string.h>
#include "syntaxique.tab.h"
int l=0;
%}
%option yylineno
chiffre [0-9]
Uint (0|[1-9]{chiffre}*)
Ufloat {Uint}\.{chiffre}+
idf ([a-z]|([a-z](([a-z0-9]|_)*[a-z0-9])))
commentaire "<<".+">>"
erreurtiret ("_"{idf}|{idf}"_"|"_"{idf}"_")
%%
")" {printf("PF\n");l+=strlen(yytext);return PF;} 
"(" {printf("PO\n");l+=strlen(yytext);return PO;}
"ENDFOR" {printf("ENDFOR\n");l+=strlen(yytext);return ENDFOR;}
"FOR" {printf("FOR\n");l+=strlen(yytext);return FOR;}
"ENDIF" {printf("ENDIF\n");l+=strlen(yytext);return ENDIF;}
"ELSE" {printf("ELSE\n");l+=strlen(yytext);return ELSE;}
"THEN" {printf("THEN\n");l+=strlen(yytext);return THEN;}
"IF" {printf("IF\n");l+=strlen(yytext);return IF;}
"FAUX" {printf("FAUX\n");l+=strlen(yytext);return FAUX;}
"VRAI" {printf("VRAI\n");l+=strlen(yytext);return VRAI;}
"!=" {printf("DIFF\n");l+=strlen(yytext);return DIFF;}
"==" {printf("DEGALE\n");l+=strlen(yytext);return DEGALE;}
"<=" {printf("INFE\n");l+=strlen(yytext);return INFE;}
">=" {printf("SUPE\n");l+=strlen(yytext);return SUPE;}
"=" {printf("EGALE\n");l+=strlen(yytext);return EGALE;}
"<" {printf("INF\n");l+=strlen(yytext);return INF;}
">" {printf("SUP\n");l+=strlen(yytext);return SUP;}
"|" {printf("OR\n");l+=strlen(yytext);return OR;}
"&" {printf("AND\n");l+=strlen(yytext);return AND;}
"!" {printf("NOT\n");l+=strlen(yytext);return NOT;}
"+" {printf("ADD\n");l+=strlen(yytext);return ADD;}
"-" {printf("MOINS\n");l+=strlen(yytext);return MOINS;}
"/" {printf("DIV\n");l+=strlen(yytext);return DIV;}
"*" {printf("MULT\n");l+=strlen(yytext);return MULT;}
"define" {printf("DEFINE\n");l+=strlen(yytext);return DEFINE;}
"UFLOAT" {printf("UFLOATCH\n");l+=strlen(yytext);return UFLOATCH;}
"UINT" {printf("UNINTCH\n");l+=strlen(yytext);return UINTCH;}
"," {printf("V\n");l+=strlen(yytext);return VIRG;}
";" {printf("PV\n");l+=strlen(yytext);return PV;}
"DEC" {printf("DEC\n");l+=strlen(yytext);return DEC;}
"INST" {printf("INST\n");l+=strlen(yytext); return INST;}
"FIN" {printf("Fin\n");l+=strlen(yytext);return FIN;}
{Uint} {printf("Entier\n");l+=strlen(yytext);return UINT;}
{Ufloat} {printf("Float\n");l+=strlen(yytext);return UFLOAT;}
{idf} {printf("IDF\n");l+=strlen(yytext);return IDF;}
" " {l+=strlen(yytext);}
. {printf("\nErreur lexical: le mot %s n'est pas reconnu a la ligne %d et la colonne %d \n",yytext,yylineno,l);l=0;}
%%
int yywrap(void)
{
return 0;
}