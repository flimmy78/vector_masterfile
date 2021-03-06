#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

uint32_t udiv32(uint32_t dividend, uint32_t divisor) 
{
   uint32_t remainder = 0;
   uint32_t quotient = 0xffffffff;
   remainder = 0;
   if(divisor == 0)
   {
	return(quotient);
   }
   else if(divisor == 1)
   {
	return(dividend);
   }
   else if(divisor > dividend)
   {
	quotient = 0;
	remainder = dividend;
	return(quotient);
   }
   else
   {
	quotient = 0;
	while(dividend >= divisor)
	{
		uint32_t curr_quotient = 1;
       		uint32_t dividend_by_2 = (dividend >> 1);
		uint32_t shifted_divisor = divisor;

		while(1)
		{
			if(shifted_divisor < dividend_by_2)
			{
				shifted_divisor = (shifted_divisor << 1);
				curr_quotient = (curr_quotient << 1);
			}
			else	
		  		break;
		}

		quotient += curr_quotient;
		dividend -= shifted_divisor;
	}

	remainder = dividend;
   }
   return(quotient);
}

