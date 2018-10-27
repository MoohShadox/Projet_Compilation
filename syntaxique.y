%{
#include<stdio.h>
extern FILE* yyin;
%}

%union
{char* chaine;
int entier;
}

%token DEC FIN INST IDF UINT UFLOAT VRAI FAUX IF THAN ELSE
%token <chaine> IDF
%token <entier> UINT

%%
S :DEC BD INST BI FIN {printf("Programme correcte \n");}
;
BD :DECL ; BD 
	|DECL
;
EIDF :IDF,EIDF 
	|IDF
;
TYPE :"UINT" | "UFLOAT"
;
DECL :TYPE EIDF 
	|"define" "Uint" IDF = UINT 
	|"define" "Ufloat" IDF = UFLOAT
;
PRODUIT :ADDITION '*' ADDITION 
		|ADDITION '/'
		|ADDITION
;
ADDITION :VAL '-' VAL
		|VAL '+' VAL
		|VAL
;
VAL :NBR 
	|'-'NBR
;
NBR :UINT
	|UFLOAT
;
EXPP1 :'!'EXPP2
;
EXPP2 : EXPP2'&'EXPP2
		| EXPP3
;
EXPP3 : EXPP3'|'EXPP3
		| BOOLVAL
;		
BOOLVAL : COMPARAISON 
		| FAUX
		| VRAI
;
COMPARAISON : EXPR'>'EXPR 
		| EXPR'<'EXPR
		| EXPR'>'EXPR
		| EXPR'<='EXPR
		| EXPR'>='EXPR
		| EXPR '==' EXPR
		| EXPR '!=' EXPR
;
EXPR : IDF 
	| UINT
	| UFLOAT
	| PRODUIT
;
BI : BI ; INSTR
	| INSTR
;
INSTR : AFFECTATION 
	| BOUCLE
	| CONDITION
;
AFFECTATION : IDF '=' PRODUIT
CONDITION : IF EXPP1 THAN BI ELSE BI ENDIF
BOUCLE : FOR '(' AFFECTATION ';' '('CONDITION')' ';' AFFECTATION ')' BI ENDFOR
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
