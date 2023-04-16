%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>    
#include <string>
#include <vector>
#include <iostream>
#include <map>
#include <stack>
#include <fstream>
#include <filesystem>
#include <chrono>
#include <thread>

using namespace std;

enum ins {NOP,LOAD,STORE,ADD,SUB,MUL,DIV,PRN,IN,JMP,JZ,CMP,
          EQUAL,INFERIOR,INFEQUAL,SUPERIOR,SUPEQUAL,DIFFERENT,
          OPEN_FILE,READ_FILE,CLOSE_FILE,WRITE_FILE,CLEAR_FILE,INFO_FILE,
          FOR_LOOP};


// Fonction pour imprimer le nom correspondant à une instruction
string print_instuction(ins i) {
  switch (i) {
    case ADD     : return "ADD";
    case MUL     : return "MUL";
    case SUB     : return "SUB";

    case LOAD    : return "LOAD";
    case STORE   : return "STORE";
    
    case JMP     : return "JMP";
    case JZ      : return "JZ";     
    
    case PRN     : return "PRN";
    case IN      : return "IN";

    

    case OPEN_FILE : return "OPEN_FILE";
    case READ_FILE : return "READ_FILE";
    case CLOSE_FILE : return "CLOSE_FILE";
    case WRITE_FILE : return "WRITE_FILE";
    case CLEAR_FILE : return "CLEAR_FILE";
    case INFO_FILE : return "INFO_FILE";

    case FOR_LOOP : return "FOR_LOOP";

    case NOP     : return "NOP";

    case EQUAL     : return "EQUAL";
    case INFERIOR     : return "INFERIOR";
    case INFEQUAL     : return "INFEQUAL";
    case SUPERIOR     : return "SUPERIOR";
    case SUPEQUAL     : return "SUPEQUAL";
    case DIFFERENT     : return "DIFFERENT";

    default      : return "";
  }
}


// Classe instruction 
class instruction{
    public:
    instruction (const ins &c, const double &v=0, const string &n="")
                {code = c; valeur = v; variable = n;};
    ins code = NOP;
    double valeur = 0;
    string variable = "";
};

// Un programme est un vecteur d'instructions
vector <instruction> programme;

// La table de symbole est une map qui associe les variables à leurs valeurs
map<string, double> table_variables;

// compteur d'instructions
int ic = 0;

// Fonction pour ajouter rapidement une instruction au programme
int add_instruction(const ins &c, const double &v=0, const string &n="") {
      programme.push_back(instruction(c,v,n));
      ic++; 
      return 0; 
   }; 


void display_stack(stack<int> p) {
    int a = 0;
    for (auto i : programme) {
        cout << a++ << '\t'
             << print_instuction (i.code) << '\t' 
             << i.valeur  << '\t'
             << i.variable << '\n';
    }
}

void sleep(int milliseconds) {
  std::this_thread::sleep_for(std::chrono::milliseconds(milliseconds));
}


// LA VM !!
// Fonction qui exécute le code généré
int runProgram (const vector <instruction> &programme){
  stack<int> Pile;
  double x1, x2,x3;
  int index = 0;
  bool fileOPen = false;
  string nomFichier = "input_text.txt";
  string ligne;
  fstream fichier;
  filesystem::path cheminAbsolu = std::filesystem::canonical(nomFichier);

  ic = 0;
  instruction i (NOP);

  while (ic < programme.size()) {
  // for (auto i : programme){
    i = programme[ic];
    switch (i.code) {
        case LOAD:  if (i.variable=="") // Il n'y a pas de nom de variable
                   { 
                    Pile.push(i.valeur); 
                  }
                   else    // il s'agit d'une variable, je consulte la table
                   { Pile.push(table_variables[i.variable]); }
                   ic++;
                   break;
        case STORE:  // AFFECTATION
                     // Récupère la tête de pile et la stocke dans la table 
                     // en utilisant le nom de la variable qui est dans l'instruction
                     x1 = Pile.top();  Pile.pop();
                     table_variables[i.variable] = x1;
                     ic++;
                     break;

        case ADD:  x1 = Pile.top();  Pile.pop();  // Rrécupérer la tête de pile;
                   x2 = Pile.top();  Pile.pop();  // Rrécupérer la tête de pile;
                   Pile.push(x1+x2);
                   ic++;
                   break;

        case SUB:  x1 = Pile.top();  Pile.pop();  // Rrécupérer la tête de pile;
                   x2 = Pile.top();  Pile.pop();  // Rrécupérer la tête de pile;
                   Pile.push(x2-x1);
                   ic++;
                   break;

        case MUL:  x1 = Pile.top();  Pile.pop();  // Rrécupérer la tête de pile;
                   x2 = Pile.top();  Pile.pop();  // Rrécupérer la tête de pile;
                   Pile.push(x2*x1);
                   ic++;
                   break;

        case DIV:  
                    x1 = Pile.top();  Pile.pop();  // Rrécupérer la tête de pile;
                    x2 = Pile.top();  Pile.pop();  // Rrécupérer la tête de pile;
                    Pile.push(x2/x1);
                    ic++;
                    break;
        case IN:  // Lit une valeur du clavier pour la stocker dans une variable
                  // A CODER

                  break;
        case PRN: // imprime ce qu'il trouve en tête de pile
                  x1 = Pile.top();  Pile.pop();
                  cout << "| " << x1 << '\n';
                  ic++;
                  break;

        case JMP :
               // SAUT INCONDITIONNEL
               // remplace ic par l'adresse qui est dans la valeur du JMP
               ic = i.valeur;
               break;

        case JZ :  
               // SAUT CONDITIONNEL
               // ne fait le jump que si tête de pile contient 0
              x1 = Pile.top();  Pile.pop();
              if (x1 == 0)
                  ic = i.valeur;
              else ic++;
               break;
        case EQUAL :  
               // SAUT CONDITIONNEL
               x1 = Pile.top();  Pile.pop();
               x2 = Pile.top();  Pile.pop();
               if (x1 != x2)
                    ic = i.valeur;
               else ic++;
               Pile.push(x2);
                Pile.push(x1);
               break;
        case INFERIOR :
                // SAUT CONDITIONNEL
                x1 = Pile.top();  Pile.pop();
                x2 = Pile.top();  Pile.pop();
                if (x1 <= x2)
                      ic = i.valeur;
                else ic++;
                Pile.push(x2);
                Pile.push(x1);
                break;
        case INFEQUAL :
                // SAUT CONDITIONNEL
                x1 = Pile.top();  Pile.pop();
                x2 = Pile.top();  Pile.pop();
                if (x1 < x2)
                      ic = i.valeur;
                else ic++;
                Pile.push(x2);
                Pile.push(x1);
                break;
        case SUPERIOR :
                // SAUT CONDITIONNEL
                x1 = Pile.top();  Pile.pop();
                x2 = Pile.top();  Pile.pop();
                if (x1 >= x2)
                      ic = i.valeur;
                else ic++;
                Pile.push(x2);
                Pile.push(x1);
                break;
        case SUPEQUAL :
                // SAUT CONDITIONNEL
                x1 = Pile.top();  Pile.pop();
                x2 = Pile.top();  Pile.pop();
                if (x1 > x2)
                      ic = i.valeur;
                else ic++;
                Pile.push(x2);
                Pile.push(x1);
                break;
        case DIFFERENT :
                // SAUT CONDITIONNEL
                x1 = Pile.top();  Pile.pop();
                x2 = Pile.top();  Pile.pop();
                if (x1 == x2)
                      ic = i.valeur;
                else ic++;
                Pile.push(x2);
                Pile.push(x1);
                break;
        case OPEN_FILE:
                fichier.open(nomFichier, std::ios::in | std::ios::out);
                ic++;
                break;
        case CLOSE_FILE:
                // Fermer le fichier
                fichier.close();
                ic++;
                break;
        case READ_FILE:
                if (fichier.is_open()) {
                fichier.seekg(0, std::ios::beg);

                    cout << ">> Lecture du fichier" << endl;
                    if (fichier.peek() == std::ifstream::traits_type::eof()) {
                        std::cout << "\t>> Le fichier est vide." << std::endl;
                    } else {
                        while (std::getline(fichier, ligne)) {
                            std::cout << "\t|"<<ligne << std::endl;
                        }
                    }
                } else {
                    std::cout << "Impossible d'ouvrir le fichier." << std::endl;
                }
                fichier.clear();  // Réinitialiser les indicateurs d'erreur
            fichier.seekg(0, std::ios::beg);  
                ic++;
                break;
        case WRITE_FILE:
                if (fichier.is_open()) {
                  x1=table_variables[i.variable];
                  fichier.seekp(0, std::ios::end);
                  fichier <<i.variable<<" = " <<x1 << endl;
                  cout << ">> Ecriture dans le fichier" << endl;
                } else {
                    std::cout << ">> Impossible d'ouvrir le fichier : " << nomFichier << std::endl;
                }
                ic++;
                break;
        case CLEAR_FILE:
                if (fichier.is_open()) {
                  fichier.close();
                  fichier.open(nomFichier, std::ios::out | std::ios::trunc);
                  if (fichier.is_open()) {
                      fichier.close();
                      std::cout << ">> Le contenu du fichier a été vidé." << std::endl;
                      fichier.open(nomFichier, std::ios::in | std::ios::out);

                  } else {
                      std::cout << "Impossible d'ouvrir le fichier" << std::endl;
                  }
                } else {
                    std::cout << ">> Impossible d'ouvrir le fichier : " << nomFichier << std::endl;
                }
                ic++;
                break;
        case INFO_FILE:
        
                if (fichier.is_open()) {
                  fichier.seekp(0);
                  fichier.seekg(0, std::ios::beg);
                  int nbLettres = 0;
                  int nbEspaces = 0;
                  int nbCaracteres = 0;
                  int nbLignes = 0;
                  // Lire le contenu du fichier ligne par ligne
                  while (std::getline(fichier, ligne)) {
                      nbLignes++;

                      for (char c : ligne) {
                          nbCaracteres++;
                          if (std::isalpha(c)) {
                              nbLettres++;
                          } else if (std::isspace(c)) {
                              nbEspaces++;
                          }
                      }
                  }
                  // Get size in bytes
                  uintmax_t tailleFichier = std::filesystem::file_size(nomFichier);


                  cout << ">> Informations sur le fichier :" << endl;
                  cout << "\t| Nom du fichier : " << nomFichier << endl;
                  cout << "\t| Chemin du fichier : " << cheminAbsolu << endl;
                  cout << "\t| Taille du fichier : " << tailleFichier << " octets" << endl;
                  cout << "\t| Nombre de lignes : " << nbLignes << endl;
                  cout << "\t| Nombre d'espaces : " << nbEspaces << endl;
                  cout << "\t| Nombre de lettres : " << nbLettres << endl;
                  cout << "\t| Nombre de caractères : " << nbCaracteres << endl;
                  fichier.clear();  // Réinitialiser les indicateurs d'erreur
                  fichier.seekg(0, std::ios::beg);  

                } else {
                    std::cout << ">> Impossible d'ouvrir le fichier : " << nomFichier << std::endl;
                }
                ic++;
                break;
        case FOR_LOOP:
                
                
                // PAS
                x1 = Pile.top();  Pile.pop();
                // Boucle jusque
                x2 = Pile.top();  Pile.pop(); 
                // Boucle à partir de
                x3 = Pile.top();  Pile.pop();
                
                if(index==0){
                  cout << ">> Boucle POUR" << endl;
                  cout << "\t| De "<< x3<<endl;
                  cout << "\t| A "<< x2<<endl;;
                  cout << "\t| Avec un pas de "<< x1<<endl<<endl;
                } 
                if (x3>=x2){
                  ic = i.valeur;
                  index=0;
                  cout << ">>Fin de la boucle POUR \n" << endl;
                } else {
                  cout << "\t| Valeur de l'index : "<<index<<endl;
                  table_variables[i.variable]=x3;
                  index+=x1;
                  x3+=x1;
                  Pile.push(x3);
                  Pile.push(x2);
                  Pile.push(x1);



                  ic++;
                }
                break;

       

  }}
}
  // éléments qui proviennent de l'analyse lexicale
  extern int yylex ();
  extern char* yytext;
  extern FILE *yyin;
  int yyerror(char *s);

%}


%code requires
  {
    typedef struct adr {
        int jmp; 
        int jz;
    } type_adresse;
  }

%union
{
    #include <string>
    double valeur;
    char   variable[256];
    char   commentaire[256];
    type_adresse adresse;
}

%token <valeur> INT
%token <valeur> FLOAT

%token SIN
%token MAIN
%token AFFECT
%token ETIQUETTE
%token <variable> IDENTIFICATEUR
%token TYPEINT
%token TYPEFLOAT
%token PRINT
%token <adresse> IF
%token THEN
%token ELSE
%token ENDIF
%token GOTO

%token DANS
%token COMMENT
%token EGAL
%token INF
%token SUP
%token INFEQ
%token SUPEQ
%token DIFF
%token OPEN
%token CLOSE
%token READ
%token INFILE
%token WRITE
%token CLEAR
%token INFO
%token <adresse> FOR
%token TO
%token STEP
%token FROM
%token <adresse> WHILE

%left '+' '-'
%left '*' '/'

%%
programme    : includes definitions MAIN '(' ')' '{'  instructions  '}'   {}

includes     : {}

definitions  : {}

instructions : etiquette instruction ';'  instructions {} 
             | {}

etiquette    : ETIQUETTE ':' {}
             | {}

instruction  : INT 
             | type IDENTIFICATEUR'=' expression  { add_instruction(STORE, 0, $2); }
             | COMMENT {cout << ">> Commentaire : " << yylval.commentaire<< endl;}
             | AFFECT expression DANS IDENTIFICATEUR  { add_instruction(STORE, 0, $4); }
             | PRINT expression  { add_instruction(PRN); }
             | IF '(' expression ')'  { $1.jz = ic;
                                        add_instruction(JZ); }
               THEN instructions   { $1.jmp = ic;
                                     add_instruction(JMP); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jz].valeur = ic;
                                   } 
               else ENDIF  {   // C'est à cette instant qu'on sait où va le JMP
                               programme[$1.jmp].valeur = ic;
                           }
              | IF '(' expression EGAL expression ')'  { $1.jz = ic;
                                        add_instruction(EQUAL); }
               THEN instructions   { $1.jmp = ic;
                                     add_instruction(JMP); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jz].valeur = ic;
                                   } 
               else ENDIF  {   // C'est à cette instant qu'on sait où va le JMP
                               programme[$1.jmp].valeur = ic;
                           }
              | IF '(' expression INF expression ')'  { $1.jz = ic;
                                        add_instruction(INFERIOR); }
               THEN instructions   { $1.jmp = ic;
                                     add_instruction(JMP); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jz].valeur = ic;
                                   } 
               else ENDIF  {   // C'est à cette instant qu'on sait où va le JMP
                               programme[$1.jmp].valeur = ic;
                           }
              | IF '(' expression SUP expression ')'  { $1.jz = ic;
                                        add_instruction(SUPERIOR); }
               THEN instructions   { $1.jmp = ic;
                                     add_instruction(JMP); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jz].valeur = ic;
                                   } 
               else ENDIF  {   // C'est à cette instant qu'on sait où va le JMP
                               programme[$1.jmp].valeur = ic;
                           }
              | IF '(' expression INFEQ expression ')'  { $1.jz = ic;
                                        add_instruction(INFEQUAL); }
               THEN instructions   { $1.jmp = ic;
                                     add_instruction(JMP); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jz].valeur = ic;
                                   } 
               else ENDIF  {   // C'est à cette instant qu'on sait où va le JMP
                               programme[$1.jmp].valeur = ic;
                           }
              | IF '(' expression SUPEQ expression ')'  { $1.jz = ic;
                                        add_instruction(SUPEQUAL); }
               THEN instructions   { $1.jmp = ic;
                                     add_instruction(JMP); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jz].valeur = ic;
                                   } 
               else ENDIF  {   // C'est à cette instant qu'on sait où va le JMP
                               programme[$1.jmp].valeur = ic;
                           }
              | IF '(' expression DIFF expression ')'  { $1.jz = ic;
                                        add_instruction(DIFFERENT); }
               THEN instructions   { $1.jmp = ic;
                                     add_instruction(JMP); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jz].valeur = ic;
                                   } 
               else ENDIF  {   // C'est à cette instant qu'on sait où va le JMP
                               programme[$1.jmp].valeur = ic;
                           }
            | GOTO ETIQUETTE   { // A VOUS DE LE FAIRE !!!!
                                 // Temporairement on y met la valeur 6
                                 add_instruction(JMP, 6); 
                               }
            
            | WHILE '(' expression DIFF expression ')'  { $1.jz = ic;
                                    add_instruction(DIFFERENT); }
                '{' instructions { $1.jmp=$1.jz;
                                    add_instruction(JMP,$1.jmp-2); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jmp].valeur = ic;
                                   }
                '}'  {   // C'est à cette instant qu'on sait où va le JMP
                                programme[$1.jz].valeur = ic;
            }
            | WHILE '(' expression SUP expression ')'  { $1.jz = ic;
                                    add_instruction(SUPERIOR); }
                '{' instructions { $1.jmp=$1.jz;
                                    add_instruction(JMP,$1.jmp-2); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jmp].valeur = ic;
                                   }
                '}'  {   // C'est à cette instant qu'on sait où va le JMP
                                programme[$1.jz].valeur = ic;
            }
            | WHILE '(' expression INF expression ')'  { $1.jz = ic;
                                    add_instruction(INFERIOR); }
                '{' instructions { $1.jmp=$1.jz;
                                    add_instruction(JMP,$1.jmp-2); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jmp].valeur = ic;
                                   }
                '}'  {   // C'est à cette instant qu'on sait où va le JMP
                                programme[$1.jz].valeur = ic;
            }
            | WHILE '(' expression EGAL expression ')'  { $1.jz = ic;
                                    add_instruction(EQUAL); }
                '{' instructions { $1.jmp=$1.jz;
                                    add_instruction(JMP,$1.jmp-2); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jmp].valeur = ic;
                                   }
                '}'  {   // C'est à cette instant qu'on sait où va le JMP
                                programme[$1.jz].valeur = ic;
            }
            | WHILE '(' expression INFEQ expression ')'  { $1.jz = ic;
                                    add_instruction(INFEQUAL); }
                '{' instructions { $1.jmp=$1.jz;
                                    add_instruction(JMP,$1.jmp-2); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jmp].valeur = ic;
                                   }
                '}'  {   // C'est à cette instant qu'on sait où va le JMP
                                programme[$1.jz].valeur = ic;
            }
            | WHILE '(' expression SUPEQ expression ')'  { $1.jz = ic;
                                    add_instruction(SUPEQUAL); }
                '{' instructions { $1.jmp=$1.jz;
                                    add_instruction(JMP,$1.jmp-2); 
                                     // C'est à cet instant qu'on sait où va le JZ
                                     programme[$1.jmp].valeur = ic;
                                   }
                '}'  {   // C'est à cette instant qu'on sait où va le JMP
                                programme[$1.jz].valeur = ic;
            }
            | FOR IDENTIFICATEUR FROM expression TO expression STEP expression {
                                      
                                      

                                        $1.jz = ic;

                                        add_instruction(FOR_LOOP,0,$2);
            }'{' instructions {     
                                    add_instruction(STORE,0,$2);
                                    add_instruction(LOAD,0,$2);
                                    
                                    $1.jmp=$1.jz;
                                    add_instruction(JMP,$1.jz); 
                                    
                                    // C'est à cet instant qu'on sait où va le JZ
                                    programme[$1.jmp].valeur = ic;
                                    }
            '}'{programme[$1.jz].valeur = ic;}             
            | OPEN {add_instruction(OPEN_FILE);}
            | CLOSE {add_instruction(CLOSE_FILE);}
            | READ {add_instruction(READ_FILE);}
            | CLEAR {add_instruction(CLEAR_FILE);}
            | INFO {add_instruction(INFO_FILE);}
            | WRITE IDENTIFICATEUR INFILE{add_instruction(WRITE_FILE,0,$2);}
            |  {   }

else : ELSE instructions   {}
     |                     {}

type : TYPEINT {   }
     | TYPEFLOAT  {    }
     |      {     }

expression : INT     { add_instruction(LOAD, $1); }
           | FLOAT   { add_instruction(LOAD, $1); }
           | IDENTIFICATEUR {  add_instruction(LOAD, 0, $1); }
           | expression '+' expression { add_instruction(ADD);}
           | expression '-' expression { add_instruction(SUB);}
           | expression '*' expression { add_instruction(MUL);}
           | expression '/' expression { add_instruction(DIV);}
           | '(' expression ')' {}
%%

int yyerror(char *s) {					
    printf("%s : %s\n", s, yytext);
}

int main(int argc, char** argv) {
    printf("\nBonjour cher Monsieur, bienvenue dans notre compilateur !\n");
    
    if ( argc > 1 )
        yyin = fopen( argv[1], "r" );
    else
        yyin = stdin;

    yyparse();

    /* printf("\nLE CODE GÉNÉRÉ : _________________\n");
    
    int a = 0;
    for (auto i : programme) {
        cout << a++ << '\t'
             << print_instuction (i.code) << '\t' 
             << i.valeur  << '\t'
             << i.variable << '\n';
    }

   printf("\nÉXÉCUTION DU CODE SUR LA VM : _________________\n"); */

   runProgram(programme);

    return 0;
}