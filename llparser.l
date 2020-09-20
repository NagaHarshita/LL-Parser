%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include<ctype.h> 
    #include<stdbool.h>
    typedef struct cfg grammar;
    typedef struct parseTable ll;
    void findfollow(char c, int ind);
    // char* f; 
    struct cfg{
        char variables[100]; /* Stores the variables */
        char productions[100][100]; /* Each variable has a CFG.productions which is a string */
        int size;
    };

    grammar CFG;
    ll LL;

    // char LL.first[10][100]; 
    
    char f[10], first[10]; 
    int count, n = 0;
    int visited[10];

    struct parseTable{
        char first[100][100];
        char follow[100][100];
        int firstLen[100];
        int followLen[100];
        int m;
    };
    char* token;

%}

arrow "->"
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




void findfirst(char c, int q1, int q2) 
{ 
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
						&& (q1 != 0 || q2 != 0)) 
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
				findfirst(CFG.productions[j][3], j, 3); 
			} 
		} 
	} 
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

    // Initializing the LL.first array 
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
            printf("*%c\n", CFG.productions[i][j+1]);
            addFirst(CFG.productions[i][j+1], i, j+1, ind);
        }else{
            printf("#%c\n", CFG.productions[i][j+1]);
            addFollow(CFG.productions[i][j], i, j, ind);
        }
    }
}


void findfollow(char c, int ind){
    int point = 1;
    if(visited[ind]==0){
        if(CFG.productions[0][0]==c){
            LL.follow[0][point++]='$';
            LL.followLen[ind] = point; 
        }

        for(int i=0;i<CFG.size;i++){
            for(int j=3;j<strlen(CFG.productions[i]);j++){
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
        visited[ind] = 1;
    }
    
}

void Follow(){
    for(int i=0;i<LL.m;i++){
        LL.follow[i][0] = LL.first[i][0];
    }
    for(int i=0;i<LL.m;i++){
        findfollow(LL.follow[i][0], i);
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
    First();
    Follow();

    printf("********** Printing Productions ***********\n");
    for(int i=0;i<CFG.size;i++){
        printf("%s\n", CFG.productions[i]);
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
    

    return 0;   
}

int yywrap(void){
    return 1;
}