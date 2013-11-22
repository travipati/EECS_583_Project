#include <stdio.h>
int i;

int main(){
	i = 1;
	for (i = 0; i< 10; ++i){
		if (i > 98){
			printf("i = %d \n",i);
		}
	}
	printf("done \n");

}