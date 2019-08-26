#include <stdio.h>

#define SWAP(a,b) temp=a; a=b; b=temp;

int main(int argc, char *argv[])
{
    int a = 1;
    int temp = 2;

    SWAP(a,temp);
    printf("a=%d, temp=%d\n", a, temp);
}
