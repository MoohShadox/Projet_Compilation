#include <stdio.h>
#include <string.h>

typedef struct 
{
char operateur[100];
char operand1[100];
char operand2[100];
char rez;	
}quadruplet;

quadruplet table[1000];
int n=0;

void inserer_quadruplet(char* operand1,char* operand2,char* operateur,char* rez){
	quadruplet q;
	strcpy(q.operand1,operand1);
	strcpy(q.operand2,operand2);
	strcpy(q.operateur,operateur);
	strcpy(q.operateur,rez);
	table[n] = q;
	n++;
}

void inserer_quadruplet1(quadruplet q){
	q.rez = 0;
	table[n] = q;
	table[n].rez = 0;
	n++;
}

void ecrire_table(quadruplet* q){
	int i;
	for(i=0;i<n;i++)
		printf("(%s,%s,%s,%d) \n",q[i].operateur,q[i].operand1,q[i].operand2,q[i].rez);
}

quadruplet lire_table(){
	quadruplet q;
	printf("donnez l'operateur : \n");
	scanf("%s",q.operateur);
	printf("%s\n",q.operateur);
	printf("donnez l'operand1 : \n");
	scanf("%s",q.operand1);
	printf("%s\n",q.operand1);
	printf("donnez l'operand2 : \n");
	scanf("%s",q.operand2);
	return q;
}


