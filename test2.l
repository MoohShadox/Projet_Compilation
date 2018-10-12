%{
#include <stdio.h>
#include <string.h>
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
%%
"DEC" {printf("Mot clef"); l+=strlen(yytext);}
"INST" {printf("Mot clef"); l+=strlen(yytext);}
"FIN" {printf("Mot clef"); l+=strlen(yytext);}
"IF" {printf("Mot clef"); l+=strlen(yytext);}
"ELSE" {printf("Mot clef"); l+=strlen(yytext);}
"ENDIF" {printf("Mot clef"); l+=strlen(yytext);}
"FOR" {printf("Mot clef"); l+=strlen(yytext);}
"ENDFOR" {printf("Mot clef"); l+=strlen(yytext);}
"FINIF" {printf("Mot clef"); l+=strlen(yytext);}
{espace} {l+=strlen(yytext);}
{separateur} {printf("Separateur \n"); l+=strlen(yytext);}
{Uint} {if(atoi(yytext)<32768) printf("le mot %s est de type Uint \n",yytext); else printf("Erreur \n");l+=strlen(yytext);}
{Ufloat} {printf("Ufloat \n"); l+=strlen(yytext);}
{idf} { if(strlen(yytext)>7) printf("trop long \n"); else printf("identifiant \n");l+=strlen(yytext);}
{commentaire} {printf("commentaire");}
. {printf("\nErreur lexical: le mot %s n'est pas reconnu a la ligne %d et la colonne %d \n",yytext,yylineno,l);l=0;}
%%
int main()
{
yylex();
return 0;
}
int yywrap(void)
{
return 0;
}