#include <stdio.h>
#include <string.h>

typedef struct 
{
char operateur[100];
char operand1[100];
char operand2[100];
char rez[100];	
}quadruplet;

quadruplet table[1000];
int n=0;

void inserer_quadruplet(char* operand1,char* operand2,char* operateur,char* rez){
	quadruplet q;
	strcpy(q.operand1,operand1);
	strcpy(q.operand2,operand2);
	strcpy(q.operateur,operateur);
	strcpy(q.rez,rez);
	table[n] = q;
	n++;
}

void maj_branchement (char* adresse,int num){
	if(num >= n)
		return;
	strcpy(table[num].operand1,adresse);
	
}

/*void inserer_quadruplet1(quadruplet q){
	q.rez = 0;
	table[n] = q;
	table[n].rez = 0;
	n++;
}*/

void ecrire_table(quadruplet* q){
	int i;
	FILE* fic = fopen("quadruplet_resultat.txt" , "w");
	
	for(i=0;i<n;i++)	
		fprintf(fic, "%d - (%s,%s,%s,%s) \n",i+1,q[i].operateur,q[i].operand1,q[i].operand2,q[i].rez);
	fclose(fic);
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


