#include <stdint.h>
#include <Pipes.h>

#define _BITCAST_(Type,val) *((Type*)&val)

uint64_t getSlice64(uint64_t reg, uint8_t h, uint8_t l)
{
	reg = reg << (63 - h);
	reg = reg >> (63 - h + l);
	return reg;
}

uint8_t getBit64(uint64_t reg, uint8_t pos)
{
	return getSlice64(reg, pos, pos);
}

uint64_t setSlice64(uint64_t reg, uint8_t h, uint8_t l, uint64_t value)
{
	uint64_t mask = -1;
	mask = mask >> (63 - h + l);
	value = value & mask;
	value = value << l;

	mask = mask << l;
	reg = reg & ~mask;
	reg = reg | value;
	return reg;
}

uint64_t setBit64(uint64_t reg, uint8_t pos, uint8_t value)
{
	return setSlice64(reg, pos, pos, value);
}

double fdiv32(double a, double b)
{
	uint64_t n = _BITCAST_(uint64_t,a);
	uint64_t d = _BITCAST_(uint64_t,b);

	uint64_t n_val = getSlice64(n, 62, 0);
	uint64_t d_val = getSlice64(d, 62, 0);

	uint8_t s_n = getBit64(n, 63);
	uint8_t s_d = getBit64(d, 63);

	uint16_t e1 = getSlice64(n, 62, 52);
	uint16_t e2 = getSlice64(d, 62, 52);

	uint16_t e1_new = (n_val == 0) ? 0 : (e1 - e2 + 1022);
	uint16_t e2_new = 1022;

	uint64_t n1 = setSlice64(n, 62, 52, e1_new);
	uint64_t d1 = setSlice64(d, 62, 52, e2_new);

	uint64_t n_new = setBit64(n1, 63, 0);
	uint64_t d_new = setBit64(d1, 63, 0);

	double a_new = _BITCAST_(double,n_new);
	double b_new = _BITCAST_(double,d_new);

	//double x = fpsub64(2.8235294818878173828125 , fpmul64(1.88235294818878173828125 , b_new));
	//Make initial guess as (48/17 - (32/17)*divisor) for fast convergence
	double x = 2.8235294818878173828125 - (1.88235294818878173828125 * b_new);// (48/17 - (32/17) * b_new)

	int i = 0;

	for(; i < 4; i++)
	{
		//x = fpmul64(x , fpsub64(2 , fpmul64(b_new , x)));
		x = x * (2 - (b_new * x));
	}
		
	// AHIR does not return nan and inf. Hence commented out. Will work in s/w.
	
	//uint64_t tmp = 0x7ff0000000000000;
	//uint64_t tmp1 = 0x7fffffffffffffff;

	//double inf = _BITCAST_(double,tmp);
	//double nan = _BITCAST_(double,tmp1);

	double res = 0;


	//res = ((n_val == 0) && (d_val == 0)) ? nan : res;
	//res = ((n_val != 0) && (d_val == 0)) ? inf : res;

	//res = ((n_val != 0) && (d_val != 0)) ? fpmul64(a_new , x) : res;
	res = ((n_val != 0) && (d_val != 0)) ? (a_new * x) : res;

	//res = (s_n ^ s_d) ? -res : res; Working in s/w. Simulation very slow in AHIR. Provided work around as below.

	uint64_t res_uint = _BITCAST_(uint64_t,res);
	res_uint = setBit64(res_uint, 63, s_n ^ s_d);

	res = _BITCAST_(double,res_uint);

	return res;
}

float fpmul32f(float x, float y)
{
	return(x*y);//Optmize by using shift and add...
}

float fpadd32f(float x, float y)
{
	return(x+y);
}

float fpsub32f(float x, float y)
{
	return(x-y);
}


uint32_t fpadd32fi(uint32_t x, uint32_t y)
{
	return(x+y);
}

uint32_t fpsub32fi(uint32_t x, uint32_t y)
{
	return(x-y);
}

float rotor_flux_calc(float id, float flux_rotor_prev){
	
	float temp_a = 0, temp_b = 0, temp_c = 0;
	float temp_flux_n = 0,temp_flux_d = 0;
	float flux_rotor = 0;
	
	temp_a = fpmul32f(flux_rotor_prev,0.999952);
	temp_b = fpmul32f(0.8096,id);
	temp_c = fpmul32f(0.000048,temp_b);	
	flux_rotor = fpadd32f(temp_c,temp_a);
	return(flux_rotor);
}
float omega_calc(float Lm, float iq, float tau_r, float flux_rotor){
	float temp_omega_n = 0,temp_omega_d = 0;
	float omega_r = 0;
	temp_omega_n = fpmul32f(0.8096,iq);
	temp_omega_d = fpmul32f(tau_r,flux_rotor);
	omega_r = fdiv32(temp_omega_n,temp_omega_d);
	return(omega_r);
}

float theta_calc(float omega_r, float omega_m, float del_t, float theta_prev){
	float temp_a = 0, temp_b = 0;
	float theta = 0;
	temp_a = fpadd32f(omega_r,omega_m);
	temp_b = fpmul32f(temp_a,del_t);
	theta = fpadd32f(theta_prev,temp_b);
	return(theta);
}

float iq_err_calc(float torque_ref, float flux_rotor){

	float temp_d = 0;
	float temp_iq_n = 0,temp_iq_d = 0;
	float iq_err = 0;

	/*
	if (flux_rotor<0.001)
		flux_rotor = 0.001;
	else flux_rotor = flux_rotor;*/
	

	temp_iq_n = fpmul32f(3.367,torque_ref);
	temp_iq_d = fpmul32f(9.7152,flux_rotor);

	iq_err = fdiv32(temp_iq_n,temp_iq_d);
	return(iq_err);
}

void vector_control_daemon(){

	float id = 0; float iq = 0; float torque_ref = 0; float flux_ref = 0; float speed = 0; 
	float speed_ref = 0, speed_ref_temp = 0;
	float torque_sat_high = 20, torque_sat_low = -20;
	float speed_err = 0, int_speed_err = 0, prop_speed_err = 0;
	float flux_err = 0, int_flux_err = 0, prop_flux_err = 0, flux_add = 0;
	float Kp = 10, Ki = 5;
	float Kp_n = 40, Ki_n = 50;
	float Lm = 0.8096;
	float Lr = 0.84175;
	float tau_r = 0.103919753;
	float flux_rotor = 0;
	float flux_rotor_prev = 0;
	float del_t = 50e-6;
	float flux_ref_prev = 0;
	float tau_new = 0;
	float theta = 0;
	float theta_prev = 0;
	float omega_r = 0;
	float omega_m = 314.1592654;
	float id_err = 0;
	float iq_err = 0;
	float poles = 4;
	float nf = 0.300;
	float constant_1 = 9.7152;
	float speed_err_prev = 0;
	float int_speed_err_temp_0 = 0;
	float int_speed_err_temp_1 = 0;
	float int_speed_err_temp_2 = 0;
	float int_flux_err_temp_0 = 0;
	float int_flux_err_temp_1 = 0;
	float int_flux_err_temp_2 = 0;
	float flux_ref_calc_temp_1 = 0;
	float flux_ref_calc_temp_2 = 0;
	float id_prev = 0;
	float temp_flux_1 = 0;
	float temp_flux_2 = 0;
	float flux_rotor_lpf = 0;
	float flux_rotor_lpf_prev = 0;
	float temp_spd_1 = 0;
	float temp_spd_2 = 0;
	float spd_lpf = 0;
	float spd_lpf_prev = 0;
	float del_t_2 = 25e-6;
	float flux_err_prev = 0;
	float int_speed_err_prev = 0;
	
	while(1){
	
		//Read Data from motor
		id  = read_float32("in_data1");
		iq  = read_float32("in_data2");
		speed  = read_float32("in_data3");
		speed_ref_temp  = read_float32("in_data4");	
		omega_m  = read_float32("in_data5");
				
		if(speed_ref < speed_ref_temp)
			speed_ref = speed_ref + 0.05;
		else if(speed_ref > speed_ref_temp)
			speed_ref = speed_ref - 0.05;
		else speed_ref = speed_ref;
		
		
		//Generation of Reference Values
		
		temp_spd_1 = fpmul32f(spd_lpf_prev,0.3);
		temp_spd_2 = fpmul32f(0.7,speed);	
		spd_lpf = fpadd32f(temp_spd_2,temp_spd_1);
		spd_lpf_prev = spd_lpf;
		
		speed_err = fpsub32f(speed_ref,spd_lpf);
		//Torque Reference Value Calculations
		int_speed_err_temp_0 = fpadd32f(speed_err,speed_err_prev);
		int_speed_err_temp_1 = fpmul32f(250e-6,int_speed_err_temp_0);
		int_speed_err = fpadd32f(int_speed_err_temp_1,int_speed_err_prev);
		int_speed_err_prev = int_speed_err;
		
		if (int_speed_err < -10.0)
			int_speed_err = -10.0;
		else if (int_speed_err > 10.0)
			int_speed_err = 10.0;
		else
			int_speed_err = int_speed_err;
	
		prop_speed_err = fpmul32f(speed_err,5);
	
		torque_ref = fpadd32f(int_speed_err,prop_speed_err);
		
		if (torque_ref < torque_sat_low)
			torque_ref = torque_sat_low;
		else if (torque_ref > torque_sat_high)
			torque_ref = torque_sat_high;
		else
			torque_ref = torque_ref;
		
		//Flux Reference Value Calculations

		flux_ref = nf;
		
		//Vector Control Begins Here
				
		flux_rotor =  rotor_flux_calc( del_t,  Lm,  id,  flux_rotor_prev,  tau_new, tau_r);
		omega_r =  omega_calc( Lm,  iq,  tau_r,  flux_rotor);
		theta =  theta_calc( omega_r,  omega_m,  del_t,  theta_prev);
		iq_err = iq_err_calc( torque_ref, flux_rotor);
		
		//iD Calculations
		
		temp_flux_1 = fpmul32f(flux_rotor_lpf_prev,0.994986);
		temp_flux_2 = fpmul32f(0.005014,flux_rotor);	
		flux_rotor_lpf = fpadd32f(temp_flux_2,temp_flux_1);
		
		flux_rotor_lpf_prev = flux_rotor_lpf;
		
		flux_err = fpsub32f(flux_ref,flux_rotor_lpf);
		flux_err_prev = flux_err;
		int_flux_err_temp_1 = fpmul32f(del_t,flux_err);
		int_flux_err_temp_2 = fpmul32f(int_flux_err_temp_1,int_flux_err_temp_2);
		int_flux_err = fpmul32f(Ki_n,int_flux_err_temp_2); 		
		
		if (int_flux_err < -1)
			int_flux_err = -1;
		else if (int_flux_err > 1)
			int_flux_err = 1;
		else
			int_flux_err = int_flux_err;
		
		prop_flux_err = fpmul32f(flux_err,Kp_n);
		
		flux_add = fpadd32f(int_flux_err,prop_flux_err);
		
		if (flux_add < -2)
			flux_add = -2;
		else if (flux_add > 2)
			flux_add = 2 ;
		else
			flux_add = flux_add;
		
		id_err = fdiv32(flux_add,Lm);

		
		flux_ref_prev = flux_ref;
		id_prev = id;

		flux_rotor_prev = flux_rotor;
		theta_prev = theta;
		
		//Write Back Generated Data
		write_float32("out_data1",id_err);
		write_float32("out_data2",iq_err);
		write_float32("out_data3",theta);
		write_float32("out_data4",flux_rotor);
	}
}
