%{
#include <stdio.h>
#include "table_symbole.h"
#include<string.h>
extern FILE* yyin;
Liste table_symboles;
char tp[20];
%}

%union
{char* chaine;
int entier;
float flottant;
}

%token DEC FIN INST VIRG PV DEFINE MULT DIV MOINS ADD NOT OR AND SUP INF EGALE SUPE INFE DEGALE DIFF VRAI FAUX IF THEN ELSE ENDIF FOR ENDFOR PO PF
%token <entier> UINT
%token <chaine> IDF UINTCH UFLOATCH
%token <flottant> UFLOAT

%%
S :IDF DEC BD INST BI FIN {printf("Programme correcte \n");afficher_liste(table_symboles);  }
;
BD :DECL PV BD 
	|DECL PV
;
EIDF :IDF VIRG EIDF {printf("Declaration de l'élement %s",$1);inserer_element_liste(&table_symboles,creer_cellule($1,"INCONNU","IDENTIFIANT"));}
	|IDF {printf("Declaration de l'élement %s \n",$1);inserer_element_liste(&table_symboles,creer_cellule($1,"INCONNU","IDENTIFIANT"));}
;
TYPE :UINTCH {strcpy(tp,$1);}
	| UFLOATCH {strcpy(tp,$1);}
;
DECL :TYPE EIDF {printf("Definition du type de l'ensemble a %s",tp);definir_inconnus(tp,table_symboles);}
	|DEFINE UINTCH IDF EGALE UINT {printf("Declaration de l'élement %s \n",$3);inserer_element_liste(&table_symboles,creer_cellule($3,$2,"CONSTANTE"));}
	|DEFINE UFLOATCH IDF EGALE UFLOAT {printf("Declaration de l'élement %s \n",$3);inserer_element_liste(&table_symboles,creer_cellule($3,$2,"CONSTANTE"));}
;
PRODUIT :ADDITION MULT ADDITION 
		|ADDITION DIV ADDITION
		|ADDITION
;
ADDITION :VAL MOINS VAL
		|VAL ADD VAL
		|VAL
;
VAL :NBR 
	|PO NBR PF
	|IDF
;
NBR :UINT 
	|UFLOAT
;
EXPP1 : NOT EXPP2 |
		EXPP2
;
EXPP2 : EXPP2 AND EXPP2
		| EXPP3
;
EXPP3 : EXPP3 OR EXPP3
		| BOOLVAL
;		
BOOLVAL : COMPARAISON 
		| FAUX
		| VRAI
		| PO COMPARAISON PF
;
COMPARAISON : EXPR SUP EXPR 
		| EXPR INF EXPR
		| EXPR INFE EXPR
		| EXPR SUPE EXPR
		| EXPR DEGALE EXPR
		| EXPR DIFF EXPR
;
EXPR : PRODUIT
;
BI : BI INSTR PV
	| INSTR PV
;
INSTR : AFFECTATION 
	| BOUCLE
	| CONDITION
;
AFFECTATION : IDF EGALE PRODUIT
;
CONDITION : IF PO EXPP1 PF BI ELSE BI ENDIF
;
BOUCLE : FOR PO AFFECTATION PV PO COMPARAISON PF PV AFFECTATION PF BI ENDFOR
;
%%
int yyerror(char* msg){
printf("%s",msg);
return 1;
}
int main(){
yyin = fopen("code.txt","r");
yyparse();
return 0;
}
