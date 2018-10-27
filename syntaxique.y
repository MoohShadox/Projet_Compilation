%{
#include<stdio.h>
extern FILE* yyin;
%}

%union
{char* chaine;
int entier;
}

%token DEC FIN INST
%token <chaine> IDF
%token <entier> UINT

%%
S :DEC D INST {printf("Programme correcte \n");}
;
D :UINT IDF {printf("déclaration de %s \n",$2);}
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
