library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ahir;
use ahir.memory_subsystem_package.all;
use ahir.types.all;
use ahir.subprograms.all;
use ahir.components.all;
use ahir.basecomponents.all;
use ahir.operatorpackage.all;
use ahir.utilities.all;
use ahir.functionLibraryComponents.all;
library work;
use work.ahir_system_global_package.all;
library GhdlLink;
use GhdlLink.Utility_Package.all;
use GhdlLink.Vhpi_Foreign.all;

entity vf_speed_take2 is
  port(clk : in bit;
    speed : in bit_vector(2 downto 0):="011";
    t_r,t_rb,t_y,t_yb,t_b,t_bb : out bit);
  end entity;
  
architecture behav of vf_speed_take2 is

component ahir_system is -- 
    port (-- 
      clk : in std_logic;
      reset : in std_logic;
      in_data_pipe_write_data: in std_logic_vector(15 downto 0);
      in_data_pipe_write_req : in std_logic_vector(0 downto 0);
      in_data_pipe_write_ack : out std_logic_vector(0 downto 0);
      out_data3_pipe_read_data: out std_logic_vector(15 downto 0);
      out_data3_pipe_read_req : in std_logic_vector(0 downto 0);
      out_data3_pipe_read_ack : out std_logic_vector(0 downto 0);
      out_data4_pipe_read_data: out std_logic_vector(15 downto 0);
      out_data4_pipe_read_req : in std_logic_vector(0 downto 0);
      out_data4_pipe_read_ack : out std_logic_vector(0 downto 0)); -- 
    -- 
end component;

signal count_tri : integer := 0;
signal count_sin : integer := 0;
signal a : integer := 0;
signal t_var : bit := '0';
signal r : integer := 0 ;
signal y : integer := 120;
signal b : integer := 240;
signal sin_r,sin_y,sin_b : integer := 0;
signal ma : integer := 10;
signal fm : integer := 2222;

begin

ahir_system_instance: ahir_system -- 
port map ( -- 
	clk => clk,
	reset => reset,
	in_data_pipe_write_data  => in_data_pipe_write_data, 
	in_data_pipe_write_req  => in_data_pipe_write_req, 
	in_data_pipe_write_ack  => in_data_pipe_write_ack,
	out_data3_pipe_read_data  => out_data3_pipe_read_data, 
	out_data3_pipe_read_req  => out_data3_pipe_read_req, 
	out_data3_pipe_read_ack  => out_data3_pipe_read_ack ,
	out_data4_pipe_read_data  => out_data4_pipe_read_data, 
	out_data4_pipe_read_req  => out_data4_pipe_read_req, 
	out_data4_pipe_read_ack  => out_data4_pipe_read_ack ); 

	ma <= out_data3_pipe_read_data;
	fm <= out_data3_pipe_read_data;
        

process(clk)	
  		
begin  
	
if(clk'event and clk='1') then

  if count_tri >= 2 then
    count_tri <= 0;
  else
    count_tri<= count_tri + 1;
  end if;
  
  if count_sin >= fm then
    count_sin <= 0;
  else
    count_sin<= count_sin + 1;
  end if;
  
  if count_tri >= 2 then
  	 if a=1000 then
  	   t_var<='0';
  	 end if ;
  	 if a=-1000 then
  	   t_var<='1';
  	 end if;
  	 if t_var='0' then	
  	   a<=a-1;
  	 end if ;
  	 if t_var='1' then
  	   a<=a+1;
  	 end if;
	end if;
	
	if count_sin >= fm then
	  if r=359 then
	    r<=0;
	  else
	    r <= r+1;
	  end if;
	  
	  if y=359 then
	    y<=0;
	  else
	    y <= y+1;
	  end if;
	  
	  if b=359 then
	    b<=0;
	  else
	    b <= b+1;
	  end if;
	end if;
	
	if ma*sin_r > a then
	  t_r <= '1';
	  t_rb<= '0'; 
	else
	  t_r <= '0';
	  t_rb<= '1';
	end if;
	
	if ma*sin_y > a then
	  t_y <= '1';
	  t_yb<= '0'; 
	else
	  t_y <= '0';
	  t_yb<= '1';
	end if;
	
	if ma*sin_b > a then
	  t_b <= '1';
	  t_bb<= '0'; 
	else
	  t_b <= '0';
	  t_bb<= '1';
	end if;
end if;
end process;


sin_r <= 
   0 when r=    0 else 
   2 when r=    1 else 
   3 when r=    2 else 
   5 when r=    3 else 
   7 when r=    4 else 
   9 when r=    5 else 
  10 when r=    6 else 
  12 when r=    7 else 
  14 when r=    8 else 
  16 when r=    9 else 
  17 when r=   10 else 
  19 when r=   11 else 
  21 when r=   12 else 
  22 when r=   13 else 
  24 when r=   14 else 
  26 when r=   15 else 
  28 when r=   16 else 
  29 when r=   17 else 
  31 when r=   18 else 
  33 when r=   19 else 
  34 when r=   20 else 
  36 when r=   21 else 
  37 when r=   22 else 
  39 when r=   23 else 
  41 when r=   24 else 
  42 when r=   25 else 
  44 when r=   26 else 
  45 when r=   27 else 
  47 when r=   28 else 
  48 when r=   29 else 
  50 when r=   30 else 
  52 when r=   31 else 
  53 when r=   32 else 
  54 when r=   33 else 
  56 when r=   34 else 
  57 when r=   35 else 
  59 when r=   36 else 
  60 when r=   37 else 
  62 when r=   38 else 
  63 when r=   39 else 
  64 when r=   40 else 
  66 when r=   41 else 
  67 when r=   42 else 
  68 when r=   43 else 
  69 when r=   44 else 
  71 when r=   45 else 
  72 when r=   46 else 
  73 when r=   47 else 
  74 when r=   48 else 
  75 when r=   49 else 
  77 when r=   50 else 
  78 when r=   51 else 
  79 when r=   52 else 
  80 when r=   53 else 
  81 when r=   54 else 
  82 when r=   55 else 
  83 when r=   56 else 
  84 when r=   57 else 
  85 when r=   58 else 
  86 when r=   59 else 
  87 when r=   60 else 
  87 when r=   61 else 
  88 when r=   62 else 
  89 when r=   63 else 
  90 when r=   64 else 
  91 when r=   65 else 
  91 when r=   66 else 
  92 when r=   67 else 
  93 when r=   68 else 
  93 when r=   69 else 
  94 when r=   70 else 
  95 when r=   71 else 
  95 when r=   72 else 
  96 when r=   73 else 
  96 when r=   74 else 
  97 when r=   75 else 
  97 when r=   76 else 
  97 when r=   77 else 
  98 when r=   78 else 
  98 when r=   79 else 
  98 when r=   80 else 
  99 when r=   81 else 
  99 when r=   82 else 
  99 when r=   83 else 
  99 when r=   84 else 
 100 when r=   85 else 
 100 when r=   86 else 
 100 when r=   87 else 
 100 when r=   88 else 
 100 when r=   89 else 
 100 when r=   90 else 
 100 when r=   91 else 
 100 when r=   92 else 
 100 when r=   93 else 
 100 when r=   94 else 
 100 when r=   95 else 
  99 when r=   96 else 
  99 when r=   97 else 
  99 when r=   98 else 
  99 when r=   99 else 
  98 when r=  100 else 
  98 when r=  101 else 
  98 when r=  102 else 
  97 when r=  103 else 
  97 when r=  104 else 
  97 when r=  105 else 
  96 when r=  106 else 
  96 when r=  107 else 
  95 when r=  108 else 
  95 when r=  109 else 
  94 when r=  110 else 
  93 when r=  111 else 
  93 when r=  112 else 
  92 when r=  113 else 
  91 when r=  114 else 
  91 when r=  115 else 
  90 when r=  116 else 
  89 when r=  117 else 
  88 when r=  118 else 
  87 when r=  119 else 
  87 when r=  120 else 
  86 when r=  121 else 
  85 when r=  122 else 
  84 when r=  123 else 
  83 when r=  124 else 
  82 when r=  125 else 
  81 when r=  126 else 
  80 when r=  127 else 
  79 when r=  128 else 
  78 when r=  129 else 
  77 when r=  130 else 
  75 when r=  131 else 
  74 when r=  132 else 
  73 when r=  133 else 
  72 when r=  134 else 
  71 when r=  135 else 
  69 when r=  136 else 
  68 when r=  137 else 
  67 when r=  138 else 
  66 when r=  139 else 
  64 when r=  140 else 
  63 when r=  141 else 
  62 when r=  142 else 
  60 when r=  143 else 
  59 when r=  144 else 
  57 when r=  145 else 
  56 when r=  146 else 
  54 when r=  147 else 
  53 when r=  148 else 
  52 when r=  149 else 
  50 when r=  150 else 
  48 when r=  151 else 
  47 when r=  152 else 
  45 when r=  153 else 
  44 when r=  154 else 
  42 when r=  155 else 
  41 when r=  156 else 
  39 when r=  157 else 
  37 when r=  158 else 
  36 when r=  159 else 
  34 when r=  160 else 
  33 when r=  161 else 
  31 when r=  162 else 
  29 when r=  163 else 
  28 when r=  164 else 
  26 when r=  165 else 
  24 when r=  166 else 
  22 when r=  167 else 
  21 when r=  168 else 
  19 when r=  169 else 
  17 when r=  170 else 
  16 when r=  171 else 
  14 when r=  172 else 
  12 when r=  173 else 
  10 when r=  174 else 
   9 when r=  175 else 
   7 when r=  176 else 
   5 when r=  177 else 
   3 when r=  178 else 
   2 when r=  179 else 
   0 when r=  180 else 
  -2 when r=  181 else 
  -3 when r=  182 else 
  -5 when r=  183 else 
  -7 when r=  184 else 
  -9 when r=  185 else 
 -10 when r=  186 else 
 -12 when r=  187 else 
 -14 when r=  188 else 
 -16 when r=  189 else 
 -17 when r=  190 else 
 -19 when r=  191 else 
 -21 when r=  192 else 
 -22 when r=  193 else 
 -24 when r=  194 else 
 -26 when r=  195 else 
 -28 when r=  196 else 
 -29 when r=  197 else 
 -31 when r=  198 else 
 -33 when r=  199 else 
 -34 when r=  200 else 
 -36 when r=  201 else 
 -37 when r=  202 else 
 -39 when r=  203 else 
 -41 when r=  204 else 
 -42 when r=  205 else 
 -44 when r=  206 else 
 -45 when r=  207 else 
 -47 when r=  208 else 
 -48 when r=  209 else 
 -50 when r=  210 else 
 -52 when r=  211 else 
 -53 when r=  212 else 
 -54 when r=  213 else 
 -56 when r=  214 else 
 -57 when r=  215 else 
 -59 when r=  216 else 
 -60 when r=  217 else 
 -62 when r=  218 else 
 -63 when r=  219 else 
 -64 when r=  220 else 
 -66 when r=  221 else 
 -67 when r=  222 else 
 -68 when r=  223 else 
 -69 when r=  224 else 
 -71 when r=  225 else 
 -72 when r=  226 else 
 -73 when r=  227 else 
 -74 when r=  228 else 
 -75 when r=  229 else 
 -77 when r=  230 else 
 -78 when r=  231 else 
 -79 when r=  232 else 
 -80 when r=  233 else 
 -81 when r=  234 else 
 -82 when r=  235 else 
 -83 when r=  236 else 
 -84 when r=  237 else 
 -85 when r=  238 else 
 -86 when r=  239 else 
 -87 when r=  240 else 
 -87 when r=  241 else 
 -88 when r=  242 else 
 -89 when r=  243 else 
 -90 when r=  244 else 
 -91 when r=  245 else 
 -91 when r=  246 else 
 -92 when r=  247 else 
 -93 when r=  248 else 
 -93 when r=  249 else 
 -94 when r=  250 else 
 -95 when r=  251 else 
 -95 when r=  252 else 
 -96 when r=  253 else 
 -96 when r=  254 else 
 -97 when r=  255 else 
 -97 when r=  256 else 
 -97 when r=  257 else 
 -98 when r=  258 else 
 -98 when r=  259 else 
 -98 when r=  260 else 
 -99 when r=  261 else 
 -99 when r=  262 else 
 -99 when r=  263 else 
 -99 when r=  264 else 
-100 when r=  265 else 
-100 when r=  266 else 
-100 when r=  267 else 
-100 when r=  268 else 
-100 when r=  269 else 
-100 when r=  270 else 
-100 when r=  271 else 
-100 when r=  272 else 
-100 when r=  273 else 
-100 when r=  274 else 
-100 when r=  275 else 
 -99 when r=  276 else 
 -99 when r=  277 else 
 -99 when r=  278 else 
 -99 when r=  279 else 
 -98 when r=  280 else 
 -98 when r=  281 else 
 -98 when r=  282 else 
 -97 when r=  283 else 
 -97 when r=  284 else 
 -97 when r=  285 else 
 -96 when r=  286 else 
 -96 when r=  287 else 
 -95 when r=  288 else 
 -95 when r=  289 else 
 -94 when r=  290 else 
 -93 when r=  291 else 
 -93 when r=  292 else 
 -92 when r=  293 else 
 -91 when r=  294 else 
 -91 when r=  295 else 
 -90 when r=  296 else 
 -89 when r=  297 else 
 -88 when r=  298 else 
 -87 when r=  299 else 
 -87 when r=  300 else 
 -86 when r=  301 else 
 -85 when r=  302 else 
 -84 when r=  303 else 
 -83 when r=  304 else 
 -82 when r=  305 else 
 -81 when r=  306 else 
 -80 when r=  307 else 
 -79 when r=  308 else 
 -78 when r=  309 else 
 -77 when r=  310 else 
 -75 when r=  311 else 
 -74 when r=  312 else 
 -73 when r=  313 else 
 -72 when r=  314 else 
 -71 when r=  315 else 
 -69 when r=  316 else 
 -68 when r=  317 else 
 -67 when r=  318 else 
 -66 when r=  319 else 
 -64 when r=  320 else 
 -63 when r=  321 else 
 -62 when r=  322 else 
 -60 when r=  323 else 
 -59 when r=  324 else 
 -57 when r=  325 else 
 -56 when r=  326 else 
 -54 when r=  327 else 
 -53 when r=  328 else 
 -52 when r=  329 else 
 -50 when r=  330 else 
 -48 when r=  331 else 
 -47 when r=  332 else 
 -45 when r=  333 else 
 -44 when r=  334 else 
 -42 when r=  335 else 
 -41 when r=  336 else 
 -39 when r=  337 else 
 -37 when r=  338 else 
 -36 when r=  339 else 
 -34 when r=  340 else 
 -33 when r=  341 else 
 -31 when r=  342 else 
 -29 when r=  343 else 
 -28 when r=  344 else 
 -26 when r=  345 else 
 -24 when r=  346 else 
 -22 when r=  347 else 
 -21 when r=  348 else 
 -19 when r=  349 else 
 -17 when r=  350 else 
 -16 when r=  351 else 
 -14 when r=  352 else 
 -12 when r=  353 else 
 -10 when r=  354 else 
  -9 when r=  355 else 
  -7 when r=  356 else 
  -5 when r=  357 else 
  -3 when r=  358 else 
  -2 when r=  359 else 
   0 ;


sin_y <=

  87 when y=   0 else 
  86 when y=   1 else 
  85 when y=   2 else 
  84 when y=   3 else 
  83 when y=   4 else 
  82 when y=   5 else 
  81 when y=   6 else 
  80 when y=   7 else 
  79 when y=   8 else 
  78 when y=   9 else 
  77 when y=  10 else 
  75 when y=  11 else 
  74 when y=  12 else 
  73 when y=  13 else 
  72 when y=  14 else 
  71 when y=  15 else 
  69 when y=  16 else 
  68 when y=  17 else 
  67 when y=  18 else 
  66 when y=  19 else 
  64 when y=  20 else 
  63 when y=  21 else 
  62 when y=  22 else 
  60 when y=  23 else 
  59 when y=  24 else 
  57 when y=  25 else 
  56 when y=  26 else 
  54 when y=  27 else 
  53 when y=  28 else 
  52 when y=  29 else 
  50 when y=  30 else 
  48 when y=  31 else 
  47 when y=  32 else 
  45 when y=  33 else 
  44 when y=  34 else 
  42 when y=  35 else 
  41 when y=  36 else 
  39 when y=  37 else 
  37 when y=  38 else 
  36 when y=  39 else 
  34 when y=  40 else 
  33 when y=  41 else 
  31 when y=  42 else 
  29 when y=  43 else 
  28 when y=  44 else 
  26 when y=  45 else 
  24 when y=  46 else 
  22 when y=  47 else 
  21 when y=  48 else 
  19 when y=  49 else 
  17 when y=  50 else 
  16 when y=  51 else 
  14 when y=  52 else 
  12 when y=  53 else 
  10 when y=  54 else 
   9 when y=  55 else 
   7 when y=  56 else 
   5 when y=  57 else 
   3 when y=  58 else 
   2 when y=  59 else 
   0 when y=  60 else 
  -2 when y=  61 else 
  -3 when y=  62 else 
  -5 when y=  63 else 
  -7 when y=  64 else 
  -9 when y=  65 else 
 -10 when y=  66 else 
 -12 when y=  67 else 
 -14 when y=  68 else 
 -16 when y=  69 else 
 -17 when y=  70 else 
 -19 when y=  71 else 
 -21 when y=  72 else 
 -22 when y=  73 else 
 -24 when y=  74 else 
 -26 when y=  75 else 
 -28 when y=  76 else 
 -29 when y=  77 else 
 -31 when y=  78 else 
 -33 when y=  79 else 
 -34 when y=  80 else 
 -36 when y=  81 else 
 -37 when y=  82 else 
 -39 when y=  83 else 
 -41 when y=  84 else 
 -42 when y=  85 else 
 -44 when y=  86 else 
 -45 when y=  87 else 
 -47 when y=  88 else 
 -48 when y=  89 else 
 -50 when y=  90 else 
 -52 when y=  91 else 
 -53 when y=  92 else 
 -54 when y=  93 else 
 -56 when y=  94 else 
 -57 when y=  95 else 
 -59 when y=  96 else 
 -60 when y=  97 else 
 -62 when y=  98 else 
 -63 when y=  99 else 
 -64 when y= 100 else 
 -66 when y= 101 else 
 -67 when y= 102 else 
 -68 when y= 103 else 
 -69 when y= 104 else 
 -71 when y= 105 else 
 -72 when y= 106 else 
 -73 when y= 107 else 
 -74 when y= 108 else 
 -75 when y= 109 else 
 -77 when y= 110 else 
 -78 when y= 111 else 
 -79 when y= 112 else 
 -80 when y= 113 else 
 -81 when y= 114 else 
 -82 when y= 115 else 
 -83 when y= 116 else 
 -84 when y= 117 else 
 -85 when y= 118 else 
 -86 when y= 119 else 
 -87 when y= 120 else 
 -87 when y= 121 else 
 -88 when y= 122 else 
 -89 when y= 123 else 
 -90 when y= 124 else 
 -91 when y= 125 else 
 -91 when y= 126 else 
 -92 when y= 127 else 
 -93 when y= 128 else 
 -93 when y= 129 else 
 -94 when y= 130 else 
 -95 when y= 131 else 
 -95 when y= 132 else 
 -96 when y= 133 else 
 -96 when y= 134 else 
 -97 when y= 135 else 
 -97 when y= 136 else 
 -97 when y= 137 else 
 -98 when y= 138 else 
 -98 when y= 139 else 
 -98 when y= 140 else 
 -99 when y= 141 else 
 -99 when y= 142 else 
 -99 when y= 143 else 
 -99 when y= 144 else 
-100 when y= 145 else 
-100 when y= 146 else 
-100 when y= 147 else 
-100 when y= 148 else 
-100 when y= 149 else 
-100 when y= 150 else 
-100 when y= 151 else 
-100 when y= 152 else 
-100 when y= 153 else 
-100 when y= 154 else 
-100 when y= 155 else 
 -99 when y= 156 else 
 -99 when y= 157 else 
 -99 when y= 158 else 
 -99 when y= 159 else 
 -98 when y= 160 else 
 -98 when y= 161 else 
 -98 when y= 162 else 
 -97 when y= 163 else 
 -97 when y= 164 else 
 -97 when y= 165 else 
 -96 when y= 166 else 
 -96 when y= 167 else 
 -95 when y= 168 else 
 -95 when y= 169 else 
 -94 when y= 170 else 
 -93 when y= 171 else 
 -93 when y= 172 else 
 -92 when y= 173 else 
 -91 when y= 174 else 
 -91 when y= 175 else 
 -90 when y= 176 else 
 -89 when y= 177 else 
 -88 when y= 178 else 
 -87 when y= 179 else 
 -87 when y= 180 else 
 -86 when y= 181 else 
 -85 when y= 182 else 
 -84 when y= 183 else 
 -83 when y= 184 else 
 -82 when y= 185 else 
 -81 when y= 186 else 
 -80 when y= 187 else 
 -79 when y= 188 else 
 -78 when y= 189 else 
 -77 when y= 190 else 
 -75 when y= 191 else 
 -74 when y= 192 else 
 -73 when y= 193 else 
 -72 when y= 194 else 
 -71 when y= 195 else 
 -69 when y= 196 else 
 -68 when y= 197 else 
 -67 when y= 198 else 
 -66 when y= 199 else 
 -64 when y= 200 else 
 -63 when y= 201 else 
 -62 when y= 202 else 
 -60 when y= 203 else 
 -59 when y= 204 else 
 -57 when y= 205 else 
 -56 when y= 206 else 
 -54 when y= 207 else 
 -53 when y= 208 else 
 -52 when y= 209 else 
 -50 when y= 210 else 
 -48 when y= 211 else 
 -47 when y= 212 else 
 -45 when y= 213 else 
 -44 when y= 214 else 
 -42 when y= 215 else 
 -41 when y= 216 else 
 -39 when y= 217 else 
 -37 when y= 218 else 
 -36 when y= 219 else 
 -34 when y= 220 else 
 -33 when y= 221 else 
 -31 when y= 222 else 
 -29 when y= 223 else 
 -28 when y= 224 else 
 -26 when y= 225 else 
 -24 when y= 226 else 
 -22 when y= 227 else 
 -21 when y= 228 else 
 -19 when y= 229 else 
 -17 when y= 230 else 
 -16 when y= 231 else 
 -14 when y= 232 else 
 -12 when y= 233 else 
 -10 when y= 234 else 
  -9 when y= 235 else 
  -7 when y= 236 else 
  -5 when y= 237 else 
  -3 when y= 238 else 
  -2 when y= 239 else 
   0 when y= 240 else 
   2 when y= 241 else 
   3 when y= 242 else 
   5 when y= 243 else 
   7 when y= 244 else 
   9 when y= 245 else 
  10 when y= 246 else 
  12 when y= 247 else 
  14 when y= 248 else 
  16 when y= 249 else 
  17 when y= 250 else 
  19 when y= 251 else 
  21 when y= 252 else 
  22 when y= 253 else 
  24 when y= 254 else 
  26 when y= 255 else 
  28 when y= 256 else 
  29 when y= 257 else 
  31 when y= 258 else 
  33 when y= 259 else 
  34 when y= 260 else 
  36 when y= 261 else 
  37 when y= 262 else 
  39 when y= 263 else 
  41 when y= 264 else 
  42 when y= 265 else 
  44 when y= 266 else 
  45 when y= 267 else 
  47 when y= 268 else 
  48 when y= 269 else 
  50 when y= 270 else 
  52 when y= 271 else 
  53 when y= 272 else 
  54 when y= 273 else 
  56 when y= 274 else 
  57 when y= 275 else 
  59 when y= 276 else 
  60 when y= 277 else 
  62 when y= 278 else 
  63 when y= 279 else 
  64 when y= 280 else 
  66 when y= 281 else 
  67 when y= 282 else 
  68 when y= 283 else 
  69 when y= 284 else 
  71 when y= 285 else 
  72 when y= 286 else 
  73 when y= 287 else 
  74 when y= 288 else 
  75 when y= 289 else 
  77 when y= 290 else 
  78 when y= 291 else 
  79 when y= 292 else 
  80 when y= 293 else 
  81 when y= 294 else 
  82 when y= 295 else 
  83 when y= 296 else 
  84 when y= 297 else 
  85 when y= 298 else 
  86 when y= 299 else 
  87 when y= 300 else 
  87 when y= 301 else 
  88 when y= 302 else 
  89 when y= 303 else 
  90 when y= 304 else 
  91 when y= 305 else 
  91 when y= 306 else 
  92 when y= 307 else 
  93 when y= 308 else 
  93 when y= 309 else 
  94 when y= 310 else 
  95 when y= 311 else 
  95 when y= 312 else 
  96 when y= 313 else 
  96 when y= 314 else 
  97 when y= 315 else 
  97 when y= 316 else 
  97 when y= 317 else 
  98 when y= 318 else 
  98 when y= 319 else 
  98 when y= 320 else 
  99 when y= 321 else 
  99 when y= 322 else 
  99 when y= 323 else 
  99 when y= 324 else 
 100 when y= 325 else 
 100 when y= 326 else 
 100 when y= 327 else 
 100 when y= 328 else 
 100 when y= 329 else 
 100 when y= 330 else 
 100 when y= 331 else 
 100 when y= 332 else 
 100 when y= 333 else 
 100 when y= 334 else 
 100 when y= 335 else 
  99 when y= 336 else 
  99 when y= 337 else 
  99 when y= 338 else 
  99 when y= 339 else 
  98 when y= 340 else 
  98 when y= 341 else 
  98 when y= 342 else 
  97 when y= 343 else 
  97 when y= 344 else 
  97 when y= 345 else 
  96 when y= 346 else 
  96 when y= 347 else 
  95 when y= 348 else 
  95 when y= 349 else 
  94 when y= 350 else 
  93 when y= 351 else 
  93 when y= 352 else 
  92 when y= 353 else 
  91 when y= 354 else 
  91 when y= 355 else 
  90 when y= 356 else 
  89 when y= 357 else 
  88 when y= 358 else 
  87 when y= 359 else 
  87;
  
  
  sin_b <=

 -87 when b=   0 else 
 -87 when b=   1 else 
 -88 when b=   2 else 
 -89 when b=   3 else 
 -90 when b=   4 else 
 -91 when b=   5 else 
 -91 when b=   6 else 
 -92 when b=   7 else 
 -93 when b=   8 else 
 -93 when b=   9 else 
 -94 when b=  10 else 
 -95 when b=  11 else 
 -95 when b=  12 else 
 -96 when b=  13 else 
 -96 when b=  14 else 
 -97 when b=  15 else 
 -97 when b=  16 else 
 -97 when b=  17 else 
 -98 when b=  18 else 
 -98 when b=  19 else 
 -98 when b=  20 else 
 -99 when b=  21 else 
 -99 when b=  22 else 
 -99 when b=  23 else 
 -99 when b=  24 else 
-100 when b=  25 else 
-100 when b=  26 else 
-100 when b=  27 else 
-100 when b=  28 else 
-100 when b=  29 else 
-100 when b=  30 else 
-100 when b=  31 else 
-100 when b=  32 else 
-100 when b=  33 else 
-100 when b=  34 else 
-100 when b=  35 else 
 -99 when b=  36 else 
 -99 when b=  37 else 
 -99 when b=  38 else 
 -99 when b=  39 else 
 -98 when b=  40 else 
 -98 when b=  41 else 
 -98 when b=  42 else 
 -97 when b=  43 else 
 -97 when b=  44 else 
 -97 when b=  45 else 
 -96 when b=  46 else 
 -96 when b=  47 else 
 -95 when b=  48 else 
 -95 when b=  49 else 
 -94 when b=  50 else 
 -93 when b=  51 else 
 -93 when b=  52 else 
 -92 when b=  53 else 
 -91 when b=  54 else 
 -91 when b=  55 else 
 -90 when b=  56 else 
 -89 when b=  57 else 
 -88 when b=  58 else 
 -87 when b=  59 else 
 -87 when b=  60 else 
 -86 when b=  61 else 
 -85 when b=  62 else 
 -84 when b=  63 else 
 -83 when b=  64 else 
 -82 when b=  65 else 
 -81 when b=  66 else 
 -80 when b=  67 else 
 -79 when b=  68 else 
 -78 when b=  69 else 
 -77 when b=  70 else 
 -75 when b=  71 else 
 -74 when b=  72 else 
 -73 when b=  73 else 
 -72 when b=  74 else 
 -71 when b=  75 else 
 -69 when b=  76 else 
 -68 when b=  77 else 
 -67 when b=  78 else 
 -66 when b=  79 else 
 -64 when b=  80 else 
 -63 when b=  81 else 
 -62 when b=  82 else 
 -60 when b=  83 else 
 -59 when b=  84 else 
 -57 when b=  85 else 
 -56 when b=  86 else 
 -54 when b=  87 else 
 -53 when b=  88 else 
 -52 when b=  89 else 
 -50 when b=  90 else 
 -48 when b=  91 else 
 -47 when b=  92 else 
 -45 when b=  93 else 
 -44 when b=  94 else 
 -42 when b=  95 else 
 -41 when b=  96 else 
 -39 when b=  97 else 
 -37 when b=  98 else 
 -36 when b=  99 else 
 -34 when b= 100 else 
 -33 when b= 101 else 
 -31 when b= 102 else 
 -29 when b= 103 else 
 -28 when b= 104 else 
 -26 when b= 105 else 
 -24 when b= 106 else 
 -22 when b= 107 else 
 -21 when b= 108 else 
 -19 when b= 109 else 
 -17 when b= 110 else 
 -16 when b= 111 else 
 -14 when b= 112 else 
 -12 when b= 113 else 
 -10 when b= 114 else 
  -9 when b= 115 else 
  -7 when b= 116 else 
  -5 when b= 117 else 
  -3 when b= 118 else 
  -2 when b= 119 else 
   0 when b= 120 else 
   2 when b= 121 else 
   3 when b= 122 else 
   5 when b= 123 else 
   7 when b= 124 else 
   9 when b= 125 else 
  10 when b= 126 else 
  12 when b= 127 else 
  14 when b= 128 else 
  16 when b= 129 else 
  17 when b= 130 else 
  19 when b= 131 else 
  21 when b= 132 else 
  22 when b= 133 else 
  24 when b= 134 else 
  26 when b= 135 else 
  28 when b= 136 else 
  29 when b= 137 else 
  31 when b= 138 else 
  33 when b= 139 else 
  34 when b= 140 else 
  36 when b= 141 else 
  37 when b= 142 else 
  39 when b= 143 else 
  41 when b= 144 else 
  42 when b= 145 else 
  44 when b= 146 else 
  45 when b= 147 else 
  47 when b= 148 else 
  48 when b= 149 else 
  50 when b= 150 else 
  52 when b= 151 else 
  53 when b= 152 else 
  54 when b= 153 else 
  56 when b= 154 else 
  57 when b= 155 else 
  59 when b= 156 else 
  60 when b= 157 else 
  62 when b= 158 else 
  63 when b= 159 else 
  64 when b= 160 else 
  66 when b= 161 else 
  67 when b= 162 else 
  68 when b= 163 else 
  69 when b= 164 else 
  71 when b= 165 else 
  72 when b= 166 else 
  73 when b= 167 else 
  74 when b= 168 else 
  75 when b= 169 else 
  77 when b= 170 else 
  78 when b= 171 else 
  79 when b= 172 else 
  80 when b= 173 else 
  81 when b= 174 else 
  82 when b= 175 else 
  83 when b= 176 else 
  84 when b= 177 else 
  85 when b= 178 else 
  86 when b= 179 else 
  87 when b= 180 else 
  87 when b= 181 else 
  88 when b= 182 else 
  89 when b= 183 else 
  90 when b= 184 else 
  91 when b= 185 else 
  91 when b= 186 else 
  92 when b= 187 else 
  93 when b= 188 else 
  93 when b= 189 else 
  94 when b= 190 else 
  95 when b= 191 else 
  95 when b= 192 else 
  96 when b= 193 else 
  96 when b= 194 else 
  97 when b= 195 else 
  97 when b= 196 else 
  97 when b= 197 else 
  98 when b= 198 else 
  98 when b= 199 else 
  98 when b= 200 else 
  99 when b= 201 else 
  99 when b= 202 else 
  99 when b= 203 else 
  99 when b= 204 else 
 100 when b= 205 else 
 100 when b= 206 else 
 100 when b= 207 else 
 100 when b= 208 else 
 100 when b= 209 else 
 100 when b= 210 else 
 100 when b= 211 else 
 100 when b= 212 else 
 100 when b= 213 else 
 100 when b= 214 else 
 100 when b= 215 else 
  99 when b= 216 else 
  99 when b= 217 else 
  99 when b= 218 else 
  99 when b= 219 else 
  98 when b= 220 else 
  98 when b= 221 else 
  98 when b= 222 else 
  97 when b= 223 else 
  97 when b= 224 else 
  97 when b= 225 else 
  96 when b= 226 else 
  96 when b= 227 else 
  95 when b= 228 else 
  95 when b= 229 else 
  94 when b= 230 else 
  93 when b= 231 else 
  93 when b= 232 else 
  92 when b= 233 else 
  91 when b= 234 else 
  91 when b= 235 else 
  90 when b= 236 else 
  89 when b= 237 else 
  88 when b= 238 else 
  87 when b= 239 else 
  87 when b= 240 else 
  86 when b= 241 else 
  85 when b= 242 else 
  84 when b= 243 else 
  83 when b= 244 else 
  82 when b= 245 else 
  81 when b= 246 else 
  80 when b= 247 else 
  79 when b= 248 else 
  78 when b= 249 else 
  77 when b= 250 else 
  75 when b= 251 else 
  74 when b= 252 else 
  73 when b= 253 else 
  72 when b= 254 else 
  71 when b= 255 else 
  69 when b= 256 else 
  68 when b= 257 else 
  67 when b= 258 else 
  66 when b= 259 else 
  64 when b= 260 else 
  63 when b= 261 else 
  62 when b= 262 else 
  60 when b= 263 else 
  59 when b= 264 else 
  57 when b= 265 else 
  56 when b= 266 else 
  54 when b= 267 else 
  53 when b= 268 else 
  52 when b= 269 else 
  50 when b= 270 else 
  48 when b= 271 else 
  47 when b= 272 else 
  45 when b= 273 else 
  44 when b= 274 else 
  42 when b= 275 else 
  41 when b= 276 else 
  39 when b= 277 else 
  37 when b= 278 else 
  36 when b= 279 else 
  34 when b= 280 else 
  33 when b= 281 else 
  31 when b= 282 else 
  29 when b= 283 else 
  28 when b= 284 else 
  26 when b= 285 else 
  24 when b= 286 else 
  22 when b= 287 else 
  21 when b= 288 else 
  19 when b= 289 else 
  17 when b= 290 else 
  16 when b= 291 else 
  14 when b= 292 else 
  12 when b= 293 else 
  10 when b= 294 else 
   9 when b= 295 else 
   7 when b= 296 else 
   5 when b= 297 else 
   3 when b= 298 else 
   2 when b= 299 else 
   0 when b= 300 else 
  -2 when b= 301 else 
  -3 when b= 302 else 
  -5 when b= 303 else 
  -7 when b= 304 else 
  -9 when b= 305 else 
 -10 when b= 306 else 
 -12 when b= 307 else 
 -14 when b= 308 else 
 -16 when b= 309 else 
 -17 when b= 310 else 
 -19 when b= 311 else 
 -21 when b= 312 else 
 -22 when b= 313 else 
 -24 when b= 314 else 
 -26 when b= 315 else 
 -28 when b= 316 else 
 -29 when b= 317 else 
 -31 when b= 318 else 
 -33 when b= 319 else 
 -34 when b= 320 else 
 -36 when b= 321 else 
 -37 when b= 322 else 
 -39 when b= 323 else 
 -41 when b= 324 else 
 -42 when b= 325 else 
 -44 when b= 326 else 
 -45 when b= 327 else 
 -47 when b= 328 else 
 -48 when b= 329 else 
 -50 when b= 330 else 
 -52 when b= 331 else 
 -53 when b= 332 else 
 -54 when b= 333 else 
 -56 when b= 334 else 
 -57 when b= 335 else 
 -59 when b= 336 else 
 -60 when b= 337 else 
 -62 when b= 338 else 
 -63 when b= 339 else 
 -64 when b= 340 else 
 -66 when b= 341 else 
 -67 when b= 342 else 
 -68 when b= 343 else 
 -69 when b= 344 else 
 -71 when b= 345 else 
 -72 when b= 346 else 
 -73 when b= 347 else 
 -74 when b= 348 else 
 -75 when b= 349 else 
 -77 when b= 350 else 
 -78 when b= 351 else 
 -79 when b= 352 else 
 -80 when b= 353 else 
 -81 when b= 354 else 
 -82 when b= 355 else 
 -83 when b= 356 else 
 -84 when b= 357 else 
 -85 when b= 358 else 
 -86 when b= 359 else 
 -87 ; 

end behav;


