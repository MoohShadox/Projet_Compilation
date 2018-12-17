%{
#include <stdio.h>
#include "table_symbole.h"
#include<string.h>
#include "quadruplets.h"
extern FILE* yyin;
extern int l;
extern yylineno;
Liste table_symboles;
char tp[20];
char var[100];
int cpt = 0;
int nbr_erreur = 0;
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
%type <tuple> PRODUIT ADDITION VAL NBR EXPR COMPARAISON BOOLVAL EXPP3 EXPP2 EXPP1 C D E Z Y
%type <entier> A B
%type <chaine> TYPE
%%
S :IDF DEC BD INST BI FIN {if (nbr_erreur==0) printf("Programme correcte \n"); else printf("Le nombre d'erreur : %d \n",nbr_erreur); ecrire_table(table); }
;
BD :DECL PV BD 
	|DECL PV
;
EIDF :IDF VIRG EIDF {Liste P;
	P = rechercher(table_symboles,$1);
	if(P==NULL)
		inserer_element_liste(&table_symboles,creer_cellule($1,"INCONNU","IDENTIFIANT"));
	else
	{
	nbr_erreur++;
	printf("ERROR ligne %d : Erreur double declaration de %s\n" , yylineno , $1); nbr_erreur++;
	}
	}
	|IDF {Liste P;
	P = rechercher(table_symboles,$1);
	if(P==NULL)
		inserer_element_liste(&table_symboles,creer_cellule($1,"INCONNU","IDENTIFIANT"));
	else
	{
	nbr_erreur++;
	printf("ERROR ligne %d : Erreur double declaration de %s\n" , yylineno , $1); nbr_erreur++;
	}
	}
;
TYPE :UINTCH {strcpy(tp,$1);$$=strdup($1);}
	| UFLOATCH {strcpy(tp,$1);$$=strdup($1);}
;
DECL :TYPE EIDF {definir_inconnus(tp,table_symboles);}
	|DEFINE UINTCH IDF EGALE UINT {
	Liste P;
	P = rechercher(table_symboles,$3);
	if(P==NULL)
		{
		inserer_element_liste(&table_symboles,creer_cellule($3,$2,"CONSTANTE"));
		char var2[14]; 
		sprintf(var2,"%d",$5);
		inserer_quadruplet(var2,"",":=",$3);
		}
	else
	{
	nbr_erreur++;
	printf("ERROR ligne %d : Erreur double declaration de %s\n" , yylineno , $3); nbr_erreur++;
	}
	}
	|DEFINE UFLOATCH IDF EGALE UFLOAT {
	Liste P;
	P = rechercher(table_symboles,$3);
	if(P==NULL)
		{
		inserer_element_liste(&table_symboles,creer_cellule($3,$2,"CONSTANTE"));
		char var2[14]; 
		sprintf(var2,"%f",$5);
		inserer_quadruplet(var2,"",":=",$3);
		}
	else
	{
	nbr_erreur++;
	printf("ERROR ligne %d : Erreur double declaration de %s \n" , yylineno , $3); nbr_erreur++;
	}
	}
PRODUIT :PRODUIT MULT ADDITION {
if($1.type != NULL && $3.type != NULL && strcmp($1.type,$3.type)==0)
{
$$.type = $1.type;
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet($1.nom,$3.nom,"*",var);
$$.nom = strdup(var);
}else{
$$.type = NULL;
 printf("ERREUR ligne %d : Variables de types incompatibles \n" , yylineno);  nbr_erreur++;
 $$.type = NULL;
 }
 }
		|PRODUIT DIV ADDITION {
if($1.type != NULL && $3.type != NULL && strcmp($1.type,$3.type)==0)
{
$$.type = $1.type;
sprintf(var,"T%d",cpt);
cpt++;
$$.nom = strdup(var);
inserer_quadruplet($1.nom,$3.nom,"/",var);
}else{
$$.type = NULL;
 printf("ERREUR ligne %d : Variables de types incompatibles \n" , yylineno); nbr_erreur++;
 $$.type = NULL;
 }
 }
		|ADDITION {$$.type = $1.type;$$.nom = $1.nom;}
;
ADDITION :ADDITION MOINS VAL {
if($1.type != NULL && $3.type != NULL && strcmp($1.type,$3.type)==0)
{
$$.type = $1.type;
sprintf(var,"T%d",cpt);
cpt++;
$$.nom = strdup(var);
inserer_quadruplet($1.nom,$3.nom,"-",var);
}else{
$$.type = NULL;
 printf("ERREUR ligne %d : Variables de types incompatibles \n" , yylineno);   nbr_erreur++;
 $$.type = NULL;
 }
 }
		|ADDITION ADD VAL {
if($1.type != NULL && $3.type != NULL && strcmp($1.type,$3.type)==0)
{
$$.type = $1.type;
sprintf(var,"T%d",cpt);
cpt++;
$$.nom = strdup(var);
inserer_quadruplet($1.nom,$3.nom,"+",var);
}else{
$$.type = NULL;
 printf("ERREUR ligne %d : Variables de types incompatibles \n" , yylineno);    nbr_erreur++;
 $$.type = NULL;
 }
 }
		|VAL {$$.type = $1.type;$$.nom = $1.nom;}
;
VAL :NBR {$$.type = $1.type; $$.nom=strdup($1.nom);}
	|IDF {Liste P; P = rechercher(table_symboles,$1);if(P!=NULL) { $$.type = strdup(P->type);$$.nom = strdup(P->nom); } else {$$.type = NULL; printf("Erreur de non declaration \n");}}
	|PO PRODUIT PF {$$.type = strdup($2.type); $$.nom=strdup($2.nom);}
;
NBR :UINT {$$.type = strdup("Uint");char ch[1500];sprintf(ch,"%d",$1);$$.nom = strdup(ch);}
	|UFLOAT {$$.type = strdup("Ufloat");char ch[1500];sprintf(ch,"%f",$1);$$.nom = strdup(ch);}
;
EXPP1 : NOT EXPP1 {int qc=n;char var2[15];sprintf(var2,"%d",qc+4);inserer_quadruplet(var2,$2.nom,"BZ","");char ch[15];sprintf(ch,"T%d",cpt);cpt++;inserer_quadruplet("0","",":=",ch);sprintf(var2,"%d",qc+5);inserer_quadruplet(var2,"","BR","");inserer_quadruplet("1","",":=",ch);$$.nom = strdup(ch);}
		|EXPP2 {$$.nom = strdup($1.nom);}
;
EXPP2 : Y EXPP3
{
int qc = n;
char var[15];
char var2[15];
sprintf(var2,"%d",qc+4);
maj_branchement(var2,atoi($1.type));
inserer_quadruplet(var2,$2.nom,"BZ","");
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet("1","",":=",var);
sprintf(var2,"%d",n+3);
inserer_quadruplet(var2,"","BR","");
inserer_quadruplet("0","",":=",var);
$$.nom = strdup(var);
}
		| EXPP3 {$$.nom = strdup($1.nom);}
;
Y : EXPP2 AND {inserer_quadruplet("",$1.nom,"BZ","");char var2[15];
sprintf(var2,"%d",n-1);$$.nom = strdup($1.nom);$$.type = strdup(var2);}
;
EXPP3 : Z BOOLVAL {
int qc = n;
char var[15];
char var2[15];
sprintf(var2,"%d",qc+4);
maj_branchement(var2,atoi($1.type));
inserer_quadruplet(var2,$2.nom,"BNZ","");
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet("0","",":=",var);
sprintf(var2,"%d",n+3);
inserer_quadruplet(var2,"","BR","");
inserer_quadruplet("1","",":=",var);
$$.nom = strdup(var);
}
	| BOOLVAL {$$.nom = strdup($1.nom);}
;
Z : EXPP3 OR {inserer_quadruplet("",$1.nom,"BNZ","");char var2[15];
sprintf(var2,"%d",n-1);$$.nom = strdup($1.nom);$$.type = strdup(var2);}
;		
BOOLVAL : COMPARAISON {$$.nom = strdup($1.nom);}
		| PO EXPP1 PF {$$.nom = strdup($2.nom);}
;
COMPARAISON : EXPR SUP EXPR {
int qc = n;
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet($1.nom,$3.nom,"-",var);
char var2[15];
sprintf(var2,"%d",qc+5);
inserer_quadruplet(var2,var,"BP","");
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet("0","",":=",var);
sprintf(var2,"%d",qc+6);
inserer_quadruplet("",var2,"BR","");
inserer_quadruplet("1","",":=",var);
$$.nom = strdup(var);
} 
		| EXPR INF EXPR
{
int qc = n;
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet($1.nom,$3.nom,"-",var);
char var2[15];
sprintf(var2,"%d",qc+5);
inserer_quadruplet(var2,var,"BL","");
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet("0","",":=",var);
sprintf(var2,"%d",qc+6);
inserer_quadruplet("",var2,"BR","");
inserer_quadruplet("1","",":=",var);
$$.nom = strdup(var);
} 
		| EXPR INFE EXPR
{
int qc = n;
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet($1.nom,$3.nom,"-",var);
char var2[15];
sprintf(var2,"%d",qc+5);
inserer_quadruplet(var2,var,"BLE","");
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet("0","",":=",var);
sprintf(var2,"%d",qc+6);
inserer_quadruplet("",var2,"BR","");
inserer_quadruplet("1","",":=",var);
$$.nom = strdup(var);
} 
		| EXPR SUPE EXPR
{
int qc = n;
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet($1.nom,$3.nom,"-",var);
char var2[15];
sprintf(var2,"%d",qc+5);
inserer_quadruplet(var2,var,"BPE","");
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet("0","",":=",var);
sprintf(var2,"%d",qc+6);
inserer_quadruplet("",var2,"BR","");
inserer_quadruplet("1","",":=",var);
$$.nom = strdup(var);
} 
		| EXPR DEGALE EXPR
{
int qc = n;
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet($1.nom,$3.nom,"-",var);
char var2[15];
sprintf(var2,"%d",qc+5);
inserer_quadruplet(var2,var,"BZ","");
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet("0","",":=",var);
sprintf(var2,"%d",qc+6);
inserer_quadruplet("",var2,"BR","");
inserer_quadruplet("1","",":=",var);
$$.nom = strdup(var);
} 
		| EXPR DIFF EXPR
{
int qc = n;
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet($1.nom,$3.nom,"-",var);
char var2[15];
sprintf(var2,"%d",qc+5);
inserer_quadruplet(var2,var,"BNZ","");
sprintf(var,"T%d",cpt);
cpt++;
inserer_quadruplet("0","",":=",var);
sprintf(var2,"%d",qc+6);
inserer_quadruplet("",var2,"BR","");
inserer_quadruplet("1","",":=",var);
$$.nom = strdup(var);
} 
;
EXPR : PRODUIT {$$.nom = strdup($1.nom);}
;
BI : BI INSTR 
	| INSTR
;
INSTR : AFFECTATION PV
	| BOUCLE
	| CONDITION
;
AFFECTATION : IDF EGALE PRODUIT {
	Liste P;
	P = rechercher(table_symboles,$1);
	if(P==NULL){
		printf("ERREUR ligne %d : Identifiant '%s' non declare \n" , yylineno , $1);   nbr_erreur++;
		}
		else {
		if(strcmp(P->nature,"CONSTANTE")==0)
		{
			printf("ERREUR ligne %d : Affectation impossible a une constante \n" , yylineno);    nbr_erreur++;
		}
		else{
		if($3.type == NULL || strcmp($3.type,P->type)!=0 )
			{printf("ERREUR ligne %d : Variables de types incompatibles (%s et %s) \n" , yylineno,$3.type,P->type); nbr_erreur++;}	
			else{inserer_quadruplet($3.nom,"",":=",$1);}
		}
		
	}
}
;
CONDITION : B ELSE BI ENDIF {char var2[14]; sprintf(var2,"%d",n+1);maj_branchement(var2,$1);}
;
B : A BI {inserer_quadruplet("","","BR",""); $$=n-1;char var2[14]; sprintf(var2,"%d",n+1);maj_branchement(var2,$1);}
;
A : IF PO EXPP1 PF {inserer_quadruplet("",$3.nom,"BZ","");$$=n-1;}
;
BOUCLE : E BI ENDFOR {
char var2[14];
sprintf(var2,"%d",n+2);
inserer_quadruplet($1.type,"","BR","");
maj_branchement(var2,atoi($1.nom)-1);
}
;
E : D PV AFFECTATION PF {
inserer_quadruplet($1.type,"","BR","");
char var2[14];
sprintf(var2,"%d",n+1);
maj_branchement(var2,atoi($1.nom));
sprintf(var2,"%d",atoi($1.nom)+2);
$$.type = strdup(var2);
$$.nom = $1.nom;
}
;
D : C PV PO COMPARAISON PF  {
char var2[14]; 
sprintf(var2,"%d",n+1);
$$.nom=strdup(var2);
inserer_quadruplet("FinINST",$4.nom,"BZ","");
inserer_quadruplet("DebutInst","","BR","");
$$.type=$1.nom;
}
;
C : FOR PO AFFECTATION  {char var2[14]; sprintf(var2,"%d",n+1);$$.nom = strdup(var2);}
;
%%
int yyerror(char* msg){
printf("%s",msg);
nbr_erreur++;
printf(" ligne: %d Col:%d \n",yylineno,l);
return 1;
}
int main(){
yyin = fopen("code.txt","r");
yyparse();
return 0;
}
