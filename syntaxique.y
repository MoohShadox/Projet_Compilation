%{
#include <stdio.h>
#include "table_symbole.h"
#include <string.h>
extern FILE* yyin;
Liste table_symboles;
char tp[20];
int i=0 ;
int b=1;
%}

%union
{char* chaine;
int entier;
float flottant;
}

%token DEC FIN INST  VIRG PV DEFINE  MULT DIV MOINS ADD NOT OR AND SUP INF EGALE SUPE INFE DEGALE DIFF VRAI FAUX IF THEN ELSE ENDIF FOR ENDFOR PO PF
%token <entier> UINT
%token <chaine> IDF
%token <chaine> UINTCH
%token <chaine> UFLOATCH
%token <flottant> UFLOAT
%type <chaine> PRODUIT VAL ADDITION NBR AFFECTATION

%%
S :IDF DEC BD INST BI FIN {  if (i ==0) printf("Programme correcte \n"); afficher_liste(table_symboles);}
;
BD :DECL PV BD 
	|DECL PV
;
EIDF :IDF VIRG EIDF {printf("Declaration de l'element %s",$1);inserer_element_liste(&table_symboles,creer_cellule($1,"INCONNU","IDENTIFIANT"));}
	|IDF {printf("Declaration de l'element %s \n",$1);inserer_element_liste(&table_symboles,creer_cellule($1,"INCONNU","IDENTIFIANT"));}
;
TYPE :UINTCH {strcpy(tp,$1);}
| UFLOATCH {strcpy(tp,$1);}
;
DECL :TYPE EIDF {printf("Definition du type de l'ensemble a %s",tp);definir_inconnus(tp,table_symboles);}
	|DEFINE UINTCH IDF EGALE UINT {printf("Declaration de l'element %s \n",$3);inserer_element_liste(&table_symboles,creer_cellule($3,$2,"CONSTANTE"));}
	|DEFINE UFLOATCH IDF EGALE UFLOAT {printf("Declaration de l'element %s \n",$3);inserer_element_liste(&table_symboles,creer_cellule($3,$2,"CONSTANTE"));}
;
PRODUIT :PRODUIT MULT PRODUIT {if($$!=NULL && strcmp($1,$3)==0) $$=$1; else {printf("erreur de typage \n");$$=NULL;}}
		|PRODUIT DIV PRODUIT {if($$!=NULL && strcmp($1,$3)==0) $$=$1; else {printf("erreur de typage \n");$$=NULL;}}
		|ADDITION {$$ = $1;}
		|PO ADDITION PF {$$ = $2;} 
;
ADDITION :ADDITION MOINS ADDITION {if($$!=NULL && strcmp($1,$3)==0) $$=$1; else {printf("erreur de typage \n");$$=NULL;}}
		|ADDITION ADD ADDITION {if($$!=NULL && strcmp($1,$3)==0) $$=$1; else {printf("erreur de typage \n");$$=NULL;};}
		|VAL {$$ = $1;}
;
VAL :NBR {$$ = $1; }
	|MOINS NBR {$$ = $2;}
	|IDF  {if (rechercher(table_symboles,$1) == NULL ) {printf("IDF %s non declare \n" , $1); i++;}}
;
NBR :UINT {$$ = "UINT";}
	|UFLOAT {$$ = "UFLOAT";}
	|PO PRODUIT PF 
;
EXPP1 : NOT EXPP2 |
		EXPP2
;
EXPP2 : EXPP2 AND EXPP2
		| EXPP3
;
EXPP3 : EXPP3 OR EXPP3
		| BOOLVAL
		| PO EXPP1 PF
;		
BOOLVAL : COMPARAISON 
		| FAUX
		| VRAI
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
AFFECTATION : IDF EGALE PRODUIT { if (rechercher(table_symboles,$1) == NULL ) { printf("IDF %s non declare \n" , $1); i++;}
else
{
Liste P;
P = rechercher(table_symboles,$1);
if($3==NULL || strcmp($3,P->type)!=0)
printf("Erreur quelque part... \n");
}
}
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
