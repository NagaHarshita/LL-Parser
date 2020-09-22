%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include<ctype.h> 
    #include<stdbool.h>
    typedef struct cfg grammar;
    typedef struct parse ll;
    void findfollow(char c, int ind);
    int findInd(char c);
    // char* f; 
    struct cfg{
        char variables[100]; /* Stores the variables */
        char terminals[100];
        char productions[100][100]; /* Each variable has a productions which is a string */
        int size;
        int terminalLen;
    };

    grammar CFG;
    ll LL;

    // char LL.first[10][100]; 
    
    char f[100], first[100]; 
    int count, n = 0;
    int visited[100];

    struct parse{
        char first[100][100];
        char follow[100][100];
        int firstLen[100];
        int followLen[100];
        int m;
        char table[100][100][100];
        int tableLen[100][100];
    };
    char* token;
%}

variables [A-Z]

%%

.*[\n] { 
    char c[10];
    c[0] = yytext[0];
    c[1] = '\0';
    char del[] = "->";
    strncat(c, del, 2);
    char split[100];
    for(int i=3;i<strlen(yytext)-1;i++){
        split[i-3] = yytext[i];
    }
    split[strlen(yytext)-4] = '\0';
    token = strtok(split, "|");
    while(token != NULL){
        char t[10] ;
        strcpy(t,c);
        char* p = token;
        strncat(t, p, strlen(p));
        strcpy(CFG.productions[CFG.size], t);
        CFG.size++;
        token = strtok(NULL, "|");
    }
};
. ;

%%


void removeDuplicates(int ind){
    int i, j, k;
    int size = LL.followLen[ind];
    for(i=0; i<size; i++){
        for(j=i+1; j<size; j++)
        {
            /* If any duplicate found */
            if(LL.follow[ind][i] == LL.follow[ind][j])
            {
                /* Delete the current duplicate element */
                for(k=j; k<size; k++)
                {
                    LL.follow[ind][k] = LL.follow[ind][k + 1];
                }

                /* Decrement size after removing duplicate element */
                size--;

                /* If shifting of elements occur then don't increment j */
                j--;
            }
        }
    }
    LL.followLen[ind] = size;
}

void removeDuplicatesInTerminals(){
    int i, j, k;
    int size = CFG.terminalLen;
    for(i=0; i<size; i++){
        for(j=i+1; j<size; j++)
        {
            /* If any duplicate found */
            if(CFG.terminals[i] == CFG.terminals[j])
            {
                /* Delete the current duplicate element */
                for(k=j; k<size; k++)
                {
                    CFG.terminals[k] = CFG.terminals[k + 1];
                }

                /* Decrement size after removing duplicate element */
                size--;

                /* If shifting of elements occur then don't increment j */
                j--;
            }
        }
    }
    CFG.terminalLen = size;
}


void findfirst(char c, int q1, int q2) 
{ 
    
    printf("%c\n", c);
	int j; 
	// The case where we 
	// encounter a Terminal 
	if(!(isupper(c))) { 
		first[n++] = c; 
	} 
	for(j = 0; j < count; j++) 
	{ 
		if(CFG.productions[j][0] == c) 
		{ 
			if(CFG.productions[j][3] == '#') 
			{ 
				if(CFG.productions[q1][q2] == '\0') 
					first[n++] = '#'; 
				else if(CFG.productions[q1][q2] != '\0'
						&& (q1 != 0 || q2 != 0) ) 
				{ 
					
					findfirst(CFG.productions[q1][q2], q1, (q2+1)); 
				} 
				else
					first[n++] = '#'; 
			} 
			else if(!isupper(CFG.productions[j][3])) 
			{ 
				first[n++] = CFG.productions[j][3]; 
			} 
			else
			{ 
				// Recursion to calculate First of 
				// New Non-Terminal we encounter 
				// at the beginning 
                if(CFG.productions[j][3]!=c)
				    findfirst(CFG.productions[j][3], j, 3); 
			} 
		} 
	}
    // visited[k] = 1; 
} 


void First(){
    
    // Stores the final result 
    // of the First Sets 
    int m = 0; 

    // Stores the productions rules 
    int k; 
    char ck; 
    int e; 

    int jm = 0; 
	int km = 0; 
	int i, choice; 
	char c, ch; 
	count = CFG.size; 

    int kay; 
	char done[count]; 
	int ptr = -1; 

	for(k = 0; k < count; k++) { 
		for(kay = 0; kay < 100; kay++) { 
			LL.first[k][kay] = '!'; 
		} 
	} 
	int point1 = 0, point2, xxx; 
	
	for(k = 0; k < count; k++) 
	{ 
		c = CFG.productions[k][0]; 
		point2 = 0; 
		xxx = 0; 
		
		// Checking if First of c has 
		// already been calculated 
		for(kay = 0; kay <= ptr; kay++) 
			if(c == done[kay]) 
				xxx = 1; 
				
		if (xxx == 1) 
			continue; 
		
		// Function call	 
		findfirst(c, 0, 0); 
		ptr += 1; 
		
		// Adding c to the calculated list 
		done[ptr] = c;
		LL.first[point1][point2++] = c; 
		
		// Printing the First Sets of the grammar 
		for(i = 0 + jm; i < n; i++) { 
			int lark = 0, chk = 0; 
			
			for(lark = 0; lark < point2; lark++) { 
				
				if (first[i] == LL.first[point1][lark]) 
				{ 
					chk = 1; 
					break; 
				} 
			} 
			if(chk == 0){ 
				LL.first[point1][point2++] = first[i]; 
			} 

		} 
		jm = n; 
        LL.firstLen[point1] = point2;
		point1++; 
        
	} 
    LL.m = point1;
    
}

int findInd(char c){
    for(int i=0;i<LL.m;i++){
        if(c==LL.first[i][0]){
            return i;
        }
    }
    return -1;
}

void addFollow(char c, int i, int j, int ind){
    int point = LL.followLen[ind] > 0 ? LL.followLen[ind] : 1;
    if(!(isupper(c))){
        LL.follow[ind][point++] = c;
        LL.followLen[ind] = point;
        return;
    }
    int k = findInd(c);
    if(k==-1){
        return;
    }
    
    if(visited[k]!=true){
        findfollow(CFG.productions[i][j], k);
    }
    for(int p=1;p<LL.followLen[k];p++){
        LL.follow[ind][point++] = LL.follow[k][p];
        LL.followLen[ind] = point;
    }
}


void addFirst(char c, int i, int j, int ind){
    int point = LL.followLen[ind]>0 ? LL.followLen[ind] : 1;
    if(islower(c)){
        LL.follow[ind][point++] = c;
        LL.followLen[ind] = point;
        return;
    }
    int k = findInd(c);
    if(k==-1){
        return;
    }
    int flag=0;
    
    {
        for(int p=1;p<LL.firstLen[k];p++){
            if(LL.first[k][p]=='#'){
                flag=1;
            }else{
                LL.follow[ind][point++] = LL.first[k][p];
                LL.followLen[ind] = point;
            }
        }
    }
    
    if(flag==1){
        if(CFG.productions[i][j+1]!='\0' || CFG.productions[i][j+1]!=0){
            addFirst(CFG.productions[i][j+1], i, j+1, ind);
        }else{
            addFollow(CFG.productions[i][j], i, j, ind);
        }
    }
}


void findfollow(char c, int ind){
    int point = 1;
    if(visited[ind]==0){
        visited[ind] = 1;
        if(CFG.productions[0][0]==c){
            LL.follow[0][point++]='$';
            LL.followLen[ind] = point; 
        }

        for(int i=0;i<CFG.size;i++){
            for(int j=3;j<strlen(CFG.productions[i]);j++){
                if(CFG.productions[i][j]=='#' || islower(CFG.productions[i][j])){
                    CFG.terminals[CFG.terminalLen] = CFG.productions[i][j];
                    CFG.terminalLen++;
                }
                if(CFG.productions[i][j]==c){
                    if(CFG.productions[i][j+1]!='\0'){
                        addFirst(CFG.productions[i][j+1], i, j+1, ind);   
                    }else{
                        if(CFG.productions[i][j+1]=='\0' && c!=CFG.productions[i][0]){
                            addFollow(CFG.productions[i][0], i, 0, ind);
                        }
                    }   
                }
            }
        }
        removeDuplicates(ind);
        
        // visited[ind] = 1;
    }
    
}

void Follow(){
    for(int i=0;i<LL.m;i++){
        LL.follow[i][0] = LL.first[i][0];
    }
    for(int i=0;i<LL.m;i++){
        findfollow(LL.follow[i][0], i);
    }
    removeDuplicatesInTerminals();
}

int getInd(char c){
    for(int i=0;i<CFG.terminalLen;i++){
        if(CFG.terminals[i]==c)
            return i;
    }
    return -1;
}

void parseAddFollow(char c, int i, int j, int ind){
    
    if(!(isupper(c))){
        int ind1 = getInd(c);
        int point = LL.tableLen[ind][ind1] > 0 ? LL.tableLen[ind][ind1] : 0;
        LL.table[ind][ind1][point++] = i;
        LL.tableLen[ind][ind1] = point;
        return;
    }
    int k = findInd(c);
    if(k==-1){
        return;
    }

    for(int p=1;p<LL.followLen[k];p++){
        int ind1 = getInd(LL.follow[k][p]);
        int point = LL.tableLen[ind][ind1] > 0 ? LL.tableLen[ind][ind1] : 0;
        LL.table[ind][ind1][point++] = i;
        LL.tableLen[ind][ind1] = point;
    }
}


void parseAddFirst(char c, int i, int j, int ind){

    if(islower(c)){
        int ind1 = getInd(c);
        int point = LL.tableLen[ind][ind1]>0 ? LL.tableLen[ind][ind1] : 0;
        LL.table[ind][ind1][point++] = i;
        LL.tableLen[ind][ind1] = point;
        return;
    }
    if(c=='#'){
        parseAddFollow(CFG.productions[i][0], i, 0, ind);
        return;
    }
    
    int flag=0;
    int k = findInd(c);
    {
        for(int p=1;p<LL.firstLen[k];p++){
            if(LL.first[k][p]=='#'){
                flag=1;
            }else{
                int ind1 = getInd(LL.first[k][p]);
                int point = LL.tableLen[ind][ind1]>0 ? LL.tableLen[ind][ind1] : 0;
                LL.table[ind][ind1][point++] = i;
                LL.tableLen[ind][ind1] = point;
            }
        }
    }
    
    if(flag==1){
        if(CFG.productions[i][j+1]!='\0' || CFG.productions[i][j+1]!=0){
            parseAddFirst(CFG.productions[i][j+1], i, j+1, ind);
        }else{
            parseAddFollow(CFG.productions[i][j], i, j, ind);
        }
    }
}

void parseTable(){
    for(int i=0;i<CFG.size;i++){
        int ind = findInd(CFG.productions[i][0]);
        parseAddFirst(CFG.productions[i][3], i, 3, ind);
    }
}



int main(int argc, char **argv){
    FILE *file;
    file = fopen("grammar", "r");
    CFG.size = 0;
    if(!file){
        printf("Could not Open the File");
        exit(0);
    }
    yyin = file;
    
    yylex();
    for(int i=0;i<LL.m;i++){
        visited[i] = 0;
    }
    

    printf("********** Printing Productions ***********\n");
    for(int i=0;i<CFG.size;i++){
        printf("%s\n", CFG.productions[i]);
    }
    First();
    for(int i=0;i<LL.m;i++){
        visited[i] = 0;
    }
    printf("********** Printing First **********\n");
    for(int i=0;i<LL.m;i++){
        printf("%c : [", LL.first[i][0]);
        for(int j=1;j<LL.firstLen[i]-1;j++){
            printf("%c, ", LL.first[i][j]);
        }
        if(LL.firstLen[i]>=1){
            printf("%c", LL.first[i][LL.firstLen[i]-1]);
        }
        printf("]\n");
        
    }
    CFG.terminalLen = 0;
    Follow();
    
    printf("*************Printing Terminals *************\n");
    for(int i=0;i<CFG.terminalLen;i++){
        printf("%c ", CFG.terminals[i]);
    }
    printf("\n");

    
    printf("************** Printing Follow ***********\n");
    for(int i=0;i<LL.m;i++){
        printf("%c : [", LL.follow[i][0]);
        for(int j=1;j<LL.followLen[i]-1;j++){
            printf("%c, ", LL.follow[i][j]);
        }
        if(LL.followLen[i]>=1){
            printf("%c", LL.follow[i][LL.followLen[i]-1]);
        }
        printf("]\n");
    }
    parseTable();
    printf("*************Printing Table****************\n");
    for(int i=0;i<LL.m;i++){
        int ind = findInd(LL.first[i][0]);
        for(int j=0;j<CFG.terminalLen;j++){
            int ind1 = getInd(CFG.terminals[j]);
            if( LL.tableLen[ind][ind1]>0){
                printf("%c : %c- ", LL.first[i][0], CFG.terminals[j]);
                for(int k=0;k<LL.tableLen[ind][ind1];k++){
                    printf("%s, ", CFG.productions[LL.table[ind][ind1][k]]);
                }
                printf("\n");
            }
            
        }
        printf("\n");
    }

    return 0;   
}

int yywrap(void){
    return 1;
}