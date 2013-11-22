#include <stdio.h>
int i;

int main(){
	i = 1;
	for (i = 0; i< 10000; ++i){
		if (i > 20000){
			printf("i = %d \n",i);
		}
		if (i > 30000){
			printf("i = %d \n", i);
		}
		if (i > 40000){
			printf("i = %d \n", i);
		}
		if (i > 50000){
			printf("i = %d \n", i);
		}
		if (i > 60000){
			printf("i = %d \n", i);
		}
		if (i > 70000){
			printf("i = %d \n", i);
		}
	}
	printf("done \n");

}