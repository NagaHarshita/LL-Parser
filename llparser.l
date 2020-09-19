%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    int n=0;
    char* variables;
    int size = 0;
    char** productions;
    int* len;
    
%}

arrow "->"
variables [A-Z]

%%
{arrow}.* { 
    char** newPtr = realloc(productions, size * sizeof(*productions));
    productions = newPtr;
    char* newChar = (char *)malloc((strlen(yytext) - 3)* sizeof(char));
    productions[size-1] = newChar;
    int* newLen = (int *)realloc(len,sizeof(int) * size);
    len = newLen;
    len[size-1] = (strlen(yytext) - 3);
    for(int i = 3;i<strlen(yytext);i++){
        productions[size-1][i-3] = yytext[i];
    }
}
{variables} { 
    size++;
    void* newPtr = realloc(variables, size * sizeof(char));
    variables = newPtr;
    variables[size-1] = yytext[0];
}


%%


int main(int argc, char **argv){
    FILE *file;
    file = fopen("grammar", "r");
    if(!file){
        printf("Could not Open the File");
        exit(0);
    }
    yyin = file;
    yylex();
    for(int i=0;i<size;i++){
        printf("%c : ", variables[i]);
        for(int j=0;j<len[i];j++){
            printf("%c",productions[i][j]);
        }
        printf("\n");
    }

    return 0;
}

int yywrap(void){
    return 1;
}