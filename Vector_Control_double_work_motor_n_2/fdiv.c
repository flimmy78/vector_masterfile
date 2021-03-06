#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

float fdiv(float a, float b)
{
	uint32_t mantissa_a, mantissa_b;
	uint32_t exponent_a, exponent_b;
	uint32_t sign_a, sign_b;
	uint32_t sign;
	uint32_t exp;
	uint32_t man;
	uint32_t ival_a, ival_b;
	uint32_t temp;
	float out_div;

	ival_a = *((uint32_t *)&a);
	ival_b = *((uint32_t *)&b);


	exponent_a = ((ival_a & (0x7F800000))>>23);
	exponent_b = ((ival_b & (0x7F800000))>>23);

	mantissa_a = ((ival_a & (0x007FFFFF)) | (0x00800000))<<7;
	mantissa_b = ((ival_b & (0x007FFFFF)) | (0x00800000))>>3;
	
	sign_a = (ival_a & (0x80000000))>>31;
	sign_b = (ival_b & (0x80000000))>>31;

	sign = (sign_a ^ sign_b)<<31;
	exp = exponent_a - exponent_b;
	man = (udiv32(mantissa_a,mantissa_b));

	temp = man;
	while( ( (temp & (0x00800000)) != 0x00800000) && (temp !=0) )
	{
	man = (man << 1);
	exp = exp - 1;
	temp = man;
	}

	man = ((man)& (0x007FFFFF));
	exp = (exp + 140 ) <<23; // 128 + 7 + 8 -3

	temp = (sign | exp | man);

	out_div = *((float *)&temp); 

	return(out_div);
}
