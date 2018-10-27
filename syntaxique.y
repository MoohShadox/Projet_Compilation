%{
#include<stdio.h>
extern FILE* yyin;
%}

%union
{char* chaine;
int entier;
}

%token DEC FIN INST IDF

%%
S : IDF DEC INST FIN

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
