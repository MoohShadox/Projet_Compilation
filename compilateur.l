%{
#include <stdio.h>
#include <string.h>
#include "table_symbole.h"
FILE* fichier = NULL;
int l=0;
Liste L;
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
finf EOF
%%
"DEC" {l+=strlen(yytext); inserer_element_liste(&L,creer_cellule(yytext,"MOT CLEF","CONSTANT"));afficher_liste(L);}
"INST" { l+=strlen(yytext); inserer_element_liste(&L,creer_cellule(yytext,"MOT CLEF","CONSTANT"));afficher_liste(L);}
"FIN" {l+=strlen(yytext); inserer_element_liste(&L,creer_cellule(yytext,"MOT CLEF","CONSTANT"));afficher_liste(L);}
"IF" { l+=strlen(yytext); inserer_element_liste(&L,creer_cellule(yytext,"MOT CLEF","CONSTANT"));afficher_liste(L);}
"ELSE" {l+=strlen(yytext); inserer_element_liste(&L,creer_cellule(yytext,"MOT CLEF","CONSTANT"));afficher_liste(L);}
"ENDIF" { l+=strlen(yytext); inserer_element_liste(&L,creer_cellule(yytext,"MOT CLEF","CONSTANT"));afficher_liste(L);}
"FOR" { l+=strlen(yytext); inserer_element_liste(&L,creer_cellule(yytext,"MOT CLEF","CONSTANT"));afficher_liste(L);}
"ENDFOR" { l+=strlen(yytext); inserer_element_liste(&L,creer_cellule(yytext,"MOT CLEF","CONSTANT"));afficher_liste(L);}
"FINIF" { l+=strlen(yytext); inserer_element_liste(&L,creer_cellule(yytext,"MOT CLEF","CONSTANT"));afficher_liste(L);}
{espace} {l+=strlen(yytext);}
{separateur} {l+=strlen(yytext); inserer_element_liste(&L,creer_cellule(yytext,"SEPARATEUR","CONSTANT"));afficher_liste(L);}
{Uint} {if(atoi(yytext)<32768) printf("le mot %s est de type Uint \n",yytext); else printf("Erreur \n");l+=strlen(yytext);inserer_element_liste(&L,creer_cellule(yytext,"UINT","CONSTANTE"));afficher_liste(L);}
{Ufloat} { l+=strlen(yytext); inserer_element_liste(&L,creer_cellule(yytext,"UFLOAT","CONSTANTE"));afficher_liste(L);}
{idf} { if(strlen(yytext)>7) printf("\n"); else printf(" \n");l+=strlen(yytext); inserer_element_liste(&L,creer_cellule(yytext,"IDENTIFIANT","VARIABLE"));afficher_liste(L);}
{erreurtiret} {printf("Impossible de prendre un identifiant contenant un tiret au début ou a la fin\n");}
{commentaire} {printf("commentaire");}
<<EOF>> {printf("J'ai la fin \n");return 0;}
. {printf("\nErreur lexical: le mot %s n'est pas reconnu a la ligne %d et la colonne %d \n",yytext,yylineno,l);l=0;}
%%
int main(int argc,char* argv[])
{
    if(argc!=2)
    {
        printf ("Erreur relative au nombre d'arguments, usage : analyseur chemin \n");
        return -1;
    }
    fichier = fopen(argv[1], "r+");
    if(fichier == NULL){
        printf ("Fichier innexistant\n");
        return -2;
    }
    yyin = fichier;
    yylex();

    return 0;
}
int yywrap(void)
{
return 0;
}