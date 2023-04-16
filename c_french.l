%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <iostream>:
  #include "c_french.bison.hpp"
  using namespace std;
%}

%%
\/\*(.|[\r\n])*?\*\/  {               
                                      string comment= yytext;
                                      comment.erase(0,2);
                                      comment.erase(comment.size()-2,2);
                                      cout << ">> Commentaire : " << comment << endl;
                                      return ';' ;}
[0-9]+                                { yylval.valeur = atof(yytext); 
                                        return INT; }
[0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?   { yylval.valeur = atof(yytext); 
                                        return FLOAT; }

main|principale {return MAIN;} 

"On place"     { return AFFECT;}
"est égal à"  { return EGAL;}
"est inférieur à" { return INF;}
"est supérieur à" { return SUP;}
"est inférieur ou égal à" { return INFEQ;}
"est supérieur ou égal à" { return SUPEQ;}
"est différent de" { return DIFF;}


"Ouvrir le fichier texte" { return OPEN;}
"Fermer le fichier texte" { return CLOSE;}
"Lire le fichier texte" { return READ;}
"Vide le fichier texte" { return CLEAR;}
"Donne moi les caractéristiques du fichier" { return INFO;}
Ecris { return WRITE;}
"dans le fichier texte" { return INFILE;}


Afficher     { return PRINT;}
dans           { return  DANS; }

int   { return TYPEINT; }
float  { return TYPEFLOAT; }

pour    { return FOR; }
"allant de" { return FROM; }
"à" { return TO; }
"par pas de" { return STEP; }

"Tant que" {return WHILE;}

si       { return IF; }
alors    { return THEN; }
sinon    { return ELSE;}
fin_si    { return ENDIF;}
aller     { return GOTO; }

[_a-zA-Z][_a-zA-Z0-9]*   {  strcpy( yylval.variable, yytext);
                            return IDENTIFICATEUR; }
@[_a-z][_a-z]*   {  strcpy( yylval.variable, yytext);
                            return ETIQUETTE; }
"{"    {  return '{'; }
"}"    {  return '}'; }
";"    {  return ';'; }
"="    {  return '='; }
\(     {  return '('; }
\)     {  return ')'; }
"+"    {  return '+';  }
"-"    {  return '-';  }
"*"    {  return '*';  }
"/"    {  return '/';  }
":"    {  return ':';  }
[ \t]                {   } 
\n|\r  { }
.                    {  printf ("Lex error %c\n", yytext[0]); return 0; }


%%

int yywrap() {}

