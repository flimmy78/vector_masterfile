#include <stdio.h>
#include <stdint.h>
#include <Pipes.h>
float  fdiv(float , float );

int main(int argc, char* argv[])
{
  if(argc < 3)
  {
     fprintf(stderr, "%s <float> <float >\n", argv[0]);
     return(1);
  }
  	uint64_t h=1,i=1,j=1,k=1,l=1,d=1,e=1,f=1,g=1;
  float  c = fdiv(atof(argv[1]), atof(argv[2]));
  /*	uint64_t	d = read_uint64("in_data1");
	uint64_t	e = read_uint64("in_data2");
	uint64_t	f = read_uint64("in_data3");
	uint64_t	g = read_uint64("in_data4");*/
  

  fprintf(stdout,"Result = %f.\n Mantissa_a :: %lu. \nMantissa_b :: %lu. \n Man_before_while :: %lu. \n Man_after_while :: %lu. \n Man_after_shifting :: %d. \n exp_after_shifting :: %d. \n exp_after_shifting :: %d. \n exp_a :: %d. \nexp_b :: %d. \n", c,d,e,f,g,h,i,j,k,l);
  return(0);
}

