%{
#include <stdio.h>
#include "table_symbole.h"
#include<string.h>
#include "quadruplets.h"
extern FILE* yyin;
Liste table_symboles;
char tp[20];
%}

%union
{char* chaine;
int entier;
float flottant;
struct tuple{
	char* nom;
	char* type;
}tuple;
}

%token DEC FIN INST VIRG PV DEFINE MULT DIV MOINS ADD NOT OR AND SUP INF EGALE SUPE INFE DEGALE DIFF VRAI FAUX IF THEN ELSE ENDIF FOR ENDFOR PO PF
%token <entier> UINT
%token <chaine> IDF UINTCH UFLOATCH
%token <flottant> UFLOAT
%type <tuple> PRODUIT ADDITION VAL NBR
%%
S :IDF DEC BD INST BI FIN {printf("Programme correcte \n");inserer_quadruplet("A","B","+","T1");afficher_liste(table_symboles);ecrire_table(table); }
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
	|DEFINE UINTCH IDF EGALE UINT {printf("Declaration de l xy'élement %s \n",$3);inserer_element_liste(&table_symboles,creer_cellule($3,$2,"CONSTANTE"));}
	|DEFINE UFLOATCH IDF EGALE UFLOAT {printf("Declaration de 10l'élement %s \n",$3);inserer_element_liste(&table_symboles,creer_cellule($3,$2,"CONSTANTE"));}
;
PRODUIT :PRODUIT MULT ADDITION {if($1.type != NULL && $3.type != NULL && strcmp($1.type,$3.type)==0){$$.type = $1.type;/*Insertion d'un quadruplet + Remonter la mémoire tempon en $1.nom*/}else{$$.type = NULL; printf("Erreur de typage \n");$$.type = NULL;}}
		|PRODUIT DIV ADDITION {if($1.type != NULL && $3.type != NULL && strcmp($1.type,$3.type)==0){$$.type = $1.type;/*Insertion d'un quadruplet + Remonter la mémoire tempon en $1.nom*/}else{$$.type = NULL; printf("Erreur de typage \n"); $$.type = NULL;}}
		|ADDITION {$$.type = $1.type;$$.nom = $1.nom;}
;
ADDITION :ADDITION MOINS VAL {if($1.type != NULL && $3.type != NULL && strcmp($1.type,$3.type)==0){$$.type = $1.type;/*Insertion d'un quadruplet + Remonter la mémoire tempon en $1.nom*/}else{$$.type = NULL; printf("Erreur de typage \n");$$.type = NULL;}}
		|ADDITION ADD VAL {if($1.type != NULL && $3.type != NULL && strcmp($1.type,$3.type)==0){$$.type = $1.type;/*Insertion d'un quadruplet + Remonter la mémoire tempon en $1.nom*/}else{$$.type = NULL; printf("Erreur de typage \n"); $$.type = NULL;}}
		|VAL {$$.type = $1.type;$$.nom = $1.nom;}
;
VAL :NBR {$$.type = $1.type; $$.nom=strdup($1.nom);}
	|IDF {Liste P; P = rechercher(table_symboles,$1);if(P!=NULL) { $$.type = strdup(P->type);$$.nom = strdup(P->nom); } else {$$.type = NULL; printf("Erreur de non déclaration \n");}}
	|PO PRODUIT PF
;
NBR :UINT {$$.type = strdup("UINT");char ch[1500];sprintf(ch,"%d",$1);$$.nom = strdup(ch);}
	|UFLOAT {$$.type = strdup("UFLOAT");char ch[1500];sprintf(ch,"%f",$1);$$.nom = strdup(ch);}
;
EXPP1 : NOT EXPP1 |
		EXPP2
;
EXPP2 : EXPP2 AND EXPP3
		| EXPP3
;
EXPP3 : EXPP3 OR BOOLVAL
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
INSTR : AFFECTATION {printf("affectation reconnue \n");}
	| BOUCLE
	| CONDITION
;
AFFECTATION : IDF EGALE PRODUIT {
	Liste P;
	P = rechercher(table_symboles,$1);
	if(P==NULL){
		printf("Erreur identifiant non déclaré \n");
		}
		else {
		if(strcmp(P->nature,"CONSTANTE")==0)
		{
			printf("Impossible d'affecter quelque chose a une constante.. \n");
		}
		else{
		if($3.type == NULL || strcmp($3.type,P->type)!=0 )
			{printf("L'affectation comporte une erreur de typage quelque part... \n");}
		}
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
