#include <stdio.h>
#include <stdio.h>
#include <malloc.h>
#include <mem.h>
//--Définition des structures

typedef struct Cellule Cellule;
struct Cellule{
    char nom[1500];
    char type[1500];
    char nature[1500];
    Cellule *svt;
};
typedef Cellule* Liste;

//-- En têtes de fonctions --//

void afficher_liste(Liste L); //Affiche les éléments d'une liste
Liste rechercher(Liste L,char *ch); //Rechercehr un nom dans une liste
void inserer_element_liste(Liste *liste,Liste Element); //Inserer un élément déja alloué dans une liste
Liste creer_liste(); //Créer une liste

//-- Définition des fonctions --//

Liste creer_cellule(char* nom,char* type,char* nature){
    Liste C = malloc (sizeof (Cellule));
    strcpy (C->nom,nom);
    strcpy (C->type,type);
    strcpy (C->nature,nature);
    return C;
}

void afficher_liste(Liste L){
    for(Liste P=L;P!=NULL;P=P->svt)
    {
        printf (" %s : %s-%s ",P->nom,P->nature,P->type);
    }
}

Liste rechercher(Liste L,char *ch){
    for(Liste P=L;P!=NULL;P=P->svt)
    {
        if(strcmp (P->nom,ch)==0)
        {
            return P;
        }
    }
    return NULL;
}


void inserer_element_liste(Liste *liste,Liste Element){
    Element->svt=NULL;
    if(*liste == NULL)
    {
        *liste = Element;
        return;
    }
    Liste P;
    for(P=*liste;P->svt!=NULL;P=P->svt);
    P->svt = Element;
}


Liste creer_liste(){
    printf ("Donnez le nombre d'éléments a créer \n");
    int nb;
    Liste L = NULL;
    Liste P;
    scanf ("%d",&nb);
    for(int i=0;i<nb;i++){
        Liste C = malloc (sizeof (Cellule));
        char ch[2000];
        int t;
        printf ("Donnez le nom du %d eme élement \n",i+1);
        scanf ("%s",ch);
        C = creer_cellule (ch,"CONSTANTE","NATURELLE");
        inserer_element_liste (&L,C);
    }
    return L;
}



//Main
int main () {
    printf ("Hello, World!\n");
    Liste L = creer_liste ();
    printf ("La liste est sur %s \n",L->nom);
    afficher_liste (L);
    /*printf ("Donnez une chaine \n");
    char ch[1500];
    scanf ("%s",ch);
    rechercher (L,ch);*/
    return 0;
}