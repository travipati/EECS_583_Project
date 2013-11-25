#include <stdio.h>
int i;
int numitr;

int main(){
	numitr = 3;
	int j;
	int k;
	j = 0;
	i = 1;
	for (k = 0; k < numitr; k++){
		for (i = 0; i < numitr+1; ++i){
			j++;
		}
	}
	printf("done, j= %d \n",j);

}