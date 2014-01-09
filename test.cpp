#include <stdio.h>
int main()
{
	int a;
	asm
	(
		"movl	eax, 120\
		add		ebx, ecx\
		add		a, eax"
		:"=r"(a)

	);
	printf("salam");
	return 0;
}