#include <stdio.h>

int main(){
    int a =1;
    int b = 2;
    int c = (a&&b);
    int d = (a||b);
    printf("o E é %d\n", c);
    printf("o OU é %d\n", d);

    return 0;
}