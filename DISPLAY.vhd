LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY DISPLAY IS
PORT(
	CLK_1,CLK_2,CLK_800: IN STD_LOGIC;--1Hz：分隔符闪烁；2Hz：数码管闪烁；800Hz：数码管动态刷新
	DIS_OUT: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);--数码管译码输出
	DIS_BIT_SEL_OUT: OUT STD_LOGIC_VECTOR(5 DOWNTO 0);--数码管选位输出
	
	HMS_E5,HMS_E4,HMS_E3,HMS_E2,HMS_E1,HMS_E0: IN STD_LOGIC_VECTOR(3 DOWNTO 0);--时钟数码管
	HMS_D5,HMS_D4,HMS_D3,HMS_D2,HMS_D1,HMS_D0: IN STD_LOGIC_VECTOR(3 DOWNTO 0);--信号输入
	
	CAL_E5,CAL_E4,CAL_E3,CAL_E2,CAL_E1,CAL_E0: IN STD_LOGIC_VECTOR(3 DOWNTO 0);--日历数码管
	CAL_D5,CAL_D4,CAL_D3,CAL_D2,CAL_D1,CAL_D0: IN STD_LOGIC_VECTOR(3 DOWNTO 0);--信号输入
	
	STOPW_D5,STOPW_D4,STOPW_D3,STOPW_D2,STOPW_D1,STOPW_D0: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	--秒表信号输入
	TIMER_E5,TIMER_E4,TIMER_E3,TIMER_E2,TIMER_E1,TIMER_E0: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	TIMER_D5,TIMER_D4,TIMER_D3,TIMER_D2,TIMER_D1,TIMER_D0: IN STD_LOGIC_VECTOR(3 DOWNTO 0);--信号输入
	
	ALM_E5,ALM_E4,ALM_E3,ALM_E2,ALM_E1,ALM_E0: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	ALM_D5,ALM_D4,ALM_D3,ALM_D2,ALM_D1,ALM_D0: IN STD_LOGIC_VECTOR(3 DOWNTO 0);--信号输入
	
	MODE_NUM: IN STD_LOGIC_VECTOR(2 DOWNTO 0);--模式信号输入
	SET_NUM: IN STD_LOGIC_VECTOR(2 DOWNTO 0);--位选信号输入
	HMS_START,STOPW_START,CAL_START,TIMER_START,ALM_START: IN STD_LOGIC;--模式运行状态信号输入
	TIMER_FINISH: IN STD_LOGIC--倒计时运行结束状态输入
);
END ENTITY DISPLAY;

ARCHITECTURE BEHAVE OF DISPLAY IS
SIGNAL DIS_BIT_SEL: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL DIS5,DIS4,DIS3,DIS2,DIS1,DIS0: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL DISF,DISE,DISD,DISC,DISB,DISA: STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
DISP1:
	PROCESS(CLK_800, DIS_BIT_SEL)
	BEGIN
		IF(CLK_800'EVENT AND CLK_800='1') THEN
			IF(DIS_BIT_SEL="110") THEN
				DIS_BIT_SEL<="000";--循环改变位选，000->110，6个数码管
			ELSE
				DIS_BIT_SEL<=DIS_BIT_SEL+1;
			END IF;
		
			IF(DIS_BIT_SEL="000") THEN--选择最右1位数码管
				DIS_BIT_SEL_OUT<="111110";
				CASE DIS0 IS
										-- "abcdefgh"
					WHEN "0000"=>DIS_OUT<="00000011";
					WHEN "0001"=>DIS_OUT<="10011111";
					WHEN "0010"=>DIS_OUT<="00100101";
					WHEN "0011"=>DIS_OUT<="00001101";
					WHEN "0100"=>DIS_OUT<="10011001";
					WHEN "0101"=>DIS_OUT<="01001001";
					WHEN "0110"=>DIS_OUT<="01000001";
					WHEN "0111"=>DIS_OUT<="00011111";
					WHEN "1000"=>DIS_OUT<="00000001";
					WHEN "1001"=>DIS_OUT<="00001001";
					WHEN OTHERS=>DIS_OUT<="11111111";
				END CASE;
			ELSIF(DIS_BIT_SEL="001") THEN--选择右第2位数码管
				DIS_BIT_SEL_OUT<="111101";
				CASE DIS1 IS
										-- "abcdefgh"
					WHEN "0000"=>DIS_OUT<="00000011";
					WHEN "0001"=>DIS_OUT<="10011111";
					WHEN "0010"=>DIS_OUT<="00100101";
					WHEN "0011"=>DIS_OUT<="00001101";
					WHEN "0100"=>DIS_OUT<="10011001";
					WHEN "0101"=>DIS_OUT<="01001001";
					WHEN "0110"=>DIS_OUT<="01000001";
					WHEN "0111"=>DIS_OUT<="00011111";
					WHEN "1000"=>DIS_OUT<="00000001";
					WHEN "1001"=>DIS_OUT<="00001001";
					WHEN OTHERS=>DIS_OUT<="11111111";
				END CASE;
			ELSIF(DIS_BIT_SEL="010") THEN--选择右第3位数码管
				DIS_BIT_SEL_OUT<="111011";
				CASE DIS2 IS
										-- "abcdefgh"
					WHEN "0000"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="00000010";--用于数码管闪烁
									ELSE
										DIS_OUT<="00000011";--当在对应模式的运行状态
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="00000010";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="00000011";
									END IF;
									
					WHEN "0001"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="10011110";
									ELSE
										DIS_OUT<="10011111";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="10011110";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="10011111";
									END IF;
									
					WHEN "0010"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="00100100";
									ELSE
										DIS_OUT<="00100101";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="00100100";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="00100101";
									END IF;
									
					WHEN "0011"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="00001100";
									ELSE
										DIS_OUT<="00001101";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="00001100";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="00001101";
									END IF;
									
					WHEN "0100"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="10011000";
									ELSE
										DIS_OUT<="10011001";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="10011000";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="10011001";
									END IF;
									
					WHEN "0101"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="01001000";
									ELSE
										DIS_OUT<="01001001";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="01001000";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="01001001";
									END IF;
									
					WHEN "0110"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="01000000";
									ELSE
										DIS_OUT<="01000001";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="01000000";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="01000001";
									END IF;
									
					WHEN "0111"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="00011110";
									ELSE
										DIS_OUT<="00011111";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="00011110";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="00011111";
									END IF;
									
					WHEN "1000"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="00000000";
									ELSE
										DIS_OUT<="00000001";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="00000000";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="00000001";
									END IF;
									
					WHEN "1001"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="00001000";
									ELSE
										DIS_OUT<="00001001";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="00001000";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="00001001";
									END IF;
									
					WHEN OTHERS=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="11111110";
									ELSE
										DIS_OUT<="11111111";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="11111110";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="11111111";
									END IF;
									
				END CASE;
			ELSIF(DIS_BIT_SEL="011") THEN--选择左第3位数码管
				DIS_BIT_SEL_OUT<="110111";
				CASE DIS3 IS
										-- "abcdefgh"
					WHEN "0000"=>DIS_OUT<="00000011";
					WHEN "0001"=>DIS_OUT<="10011111";
					WHEN "0010"=>DIS_OUT<="00100101";
					WHEN "0011"=>DIS_OUT<="00001101";
					WHEN "0100"=>DIS_OUT<="10011001";
					WHEN "0101"=>DIS_OUT<="01001001";
					WHEN "0110"=>DIS_OUT<="01000001";
					WHEN "0111"=>DIS_OUT<="00011111";
					WHEN "1000"=>DIS_OUT<="00000001";
					WHEN "1001"=>DIS_OUT<="00001001";
					WHEN OTHERS=>DIS_OUT<="11111111";
				END CASE;
			ELSIF(DIS_BIT_SEL="100") THEN--选择左第2位数码管
				DIS_BIT_SEL_OUT<="101111";
				CASE DIS4 IS
										-- "abcdefgh"
					WHEN "0000"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="00000010";
									ELSE
										DIS_OUT<="00000011";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="00000010";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="00000010";
									END IF;
									
					WHEN "0001"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="10011110";
									ELSE
										DIS_OUT<="10011111";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="10011110";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="10011110";
									END IF;
									
					WHEN "0010"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="00100100";
									ELSE
										DIS_OUT<="00100101";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="00100100";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="00100100";
									END IF;
									
					WHEN "0011"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="00001100";
									ELSE
										DIS_OUT<="00001101";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="00001100";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="00001100";
									END IF;
									
					WHEN "0100"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="10011000";
									ELSE
										DIS_OUT<="10011001";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="10011000";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="10011000";
									END IF;
									
					WHEN "0101"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="01001000";
									ELSE
										DIS_OUT<="01001001";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="01001000";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="01001000";
									END IF;
									
					WHEN "0110"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="01000000";
									ELSE
										DIS_OUT<="01000001";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="01000000";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="01000000";
									END IF;
									
					WHEN "0111"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="00011110";
									ELSE
										DIS_OUT<="00011111";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="00011110";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="00011110";
									END IF;
									
					WHEN "1000"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="00000000";
									ELSE
										DIS_OUT<="00000001";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="00000000";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="00000000";
									END IF;
									
					WHEN "1001"=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="00001000";
									ELSE
										DIS_OUT<="00001001";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="00001000";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="00001000";
									END IF;
									
					WHEN OTHERS=>	IF(CLK_1='1' AND ((MODE_NUM="000" AND HMS_START='1') OR (MODE_NUM="010" AND STOPW_START='1') OR (MODE_NUM="011" AND TIMER_START='1'))) THEN
										DIS_OUT<="11111110";
									ELSE
										DIS_OUT<="11111111";
									END IF;
									
									IF(MODE_NUM="001") THEN
										DIS_OUT<="11111110";
									END IF;
									
									IF(MODE_NUM="100") THEN
										DIS_OUT<="11111110";
									END IF;
									
				END CASE;
			ELSIF(DIS_BIT_SEL="101") THEN--选择最左1位数码管
				DIS_BIT_SEL_OUT<="011111";
				CASE DIS5 IS
										-- "abcdefgh"
					WHEN "0000"=>DIS_OUT<="00000011";
					WHEN "0001"=>DIS_OUT<="10011111";
					WHEN "0010"=>DIS_OUT<="00100101";
					WHEN "0011"=>DIS_OUT<="00001101";
					WHEN "0100"=>DIS_OUT<="10011001";
					WHEN "0101"=>DIS_OUT<="01001001";
					WHEN "0110"=>DIS_OUT<="01000001";
					WHEN "0111"=>DIS_OUT<="00011111";
					WHEN "1000"=>DIS_OUT<="00000001";
					WHEN "1001"=>DIS_OUT<="00001001";
					WHEN OTHERS=>DIS_OUT<="11111111";
				END CASE;
			END IF;
		END IF;
	END PROCESS DISP1;

DISP2:
	PROCESS(CLK_800,CLK_1)
	BEGIN
		IF(CLK_800'EVENT AND CLK_800='1') THEN
			IF(MODE_NUM="000" AND SET_NUM="110") THEN
				DIS5<=HMS_D5;--显示在时钟模式且在运行模式下的数据
				DIS4<=HMS_D4;
				DIS3<=HMS_D3;
				DIS2<=HMS_D2;
				DIS1<=HMS_D1;
				DIS0<=HMS_D0;
			ELSIF(MODE_NUM="001" AND SET_NUM="110") THEN
				DIS5<=CAL_D5;--显示在日历模式且在运行模式下的数据
				DIS4<=CAL_D4;
				DIS3<=CAL_D3;
				DIS2<=CAL_D2;
				DIS1<=CAL_D1;
				DIS0<=CAL_D0;
			ELSIF(MODE_NUM="010") THEN
				DIS5<=STOPW_D5;--显示在秒表模式且在运行模式下的数据
				DIS4<=STOPW_D4;
				DIS3<=STOPW_D3;
				DIS2<=STOPW_D2;
				DIS1<=STOPW_D1;
				DIS0<=STOPW_D0;
			ELSIF(MODE_NUM="011") THEN
				DIS5<=TIMER_D5;--显示在倒计时模式且在运行模式下的数据
				DIS4<=TIMER_D4;
				DIS3<=TIMER_D3;
				DIS2<=TIMER_D2;
				DIS1<=TIMER_D1;
				DIS0<=TIMER_D0;
			ELSIF(MODE_NUM="100" AND SET_NUM="110") THEN
				DIS5<=ALM_D5;--显示在闹钟模式且在运行模式下的数据
				DIS4<=ALM_D4;
				DIS3<=ALM_D3;
				DIS2<=ALM_D2;
				DIS1<=ALM_D1;
				DIS0<=ALM_D0;
			END IF;
			
			IF(MODE_NUM="000" AND SET_NUM="101" AND HMS_START='0') THEN
				IF(CLK_2='1') THEN--显示在时钟模式且不在运行时
					DIS5<=HMS_E5;
					DIS4<=HMS_E4;
					DIS3<=HMS_E3;
					DIS2<=HMS_E2;
					DIS1<=HMS_E1;
					DIS0<=HMS_E0;
				ELSE
					DIS5<="1111";--闪烁最左位数码管
					DIS4<=HMS_E4;--“1111”可使数码管全灭
					DIS3<=HMS_E3;
					DIS2<=HMS_E2;
					DIS1<=HMS_E1;
					DIS0<=HMS_E0;
				END IF;
			ELSIF(MODE_NUM="000" AND SET_NUM="100" AND HMS_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=HMS_E5;
					DIS4<=HMS_E4;
					DIS3<=HMS_E3;
					DIS2<=HMS_E2;
					DIS1<=HMS_E1;
					DIS0<=HMS_E0;
				ELSE
					DIS5<=HMS_E5;
					DIS4<="1111";--闪烁左第2位数码管
					DIS3<=HMS_E3;
					DIS2<=HMS_E2;
					DIS1<=HMS_E1;
					DIS0<=HMS_E0;
				END IF;
			ELSIF(MODE_NUM="000" AND SET_NUM="011" AND HMS_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=HMS_E5;
					DIS4<=HMS_E4;
					DIS3<=HMS_E3;
					DIS2<=HMS_E2;
					DIS1<=HMS_E1;
					DIS0<=HMS_E0;
				ELSE
					DIS5<=HMS_E5;
					DIS4<=HMS_E4;
					DIS3<="1111";--闪烁左第3位数码管
					DIS2<=HMS_E2;
					DIS1<=HMS_E1;
					DIS0<=HMS_E0;
				END IF;
			ELSIF(MODE_NUM="000" AND SET_NUM="010" AND HMS_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=HMS_E5;
					DIS4<=HMS_E4;
					DIS3<=HMS_E3;
					DIS2<=HMS_E2;
					DIS1<=HMS_E1;
					DIS0<=HMS_E0;
				ELSE
					DIS5<=HMS_E5;
					DIS4<=HMS_E4;
					DIS3<=HMS_E3;
					DIS2<="1111";--闪烁右第3位数码管
					DIS1<=HMS_E1;
					DIS0<=HMS_E0;
				END IF;
			ELSIF(MODE_NUM="000" AND SET_NUM="001" AND HMS_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=HMS_E5;
					DIS4<=HMS_E4;
					DIS3<=HMS_E3;
					DIS2<=HMS_E2;
					DIS1<=HMS_E1;
					DIS0<=HMS_E0;
				ELSE
					DIS5<=HMS_E5;
					DIS4<=HMS_E4;
					DIS3<=HMS_E3;
					DIS2<=HMS_E2;
					DIS1<="1111";--闪烁右第2位数码管
					DIS0<=HMS_E0;
				END IF;
			ELSIF(MODE_NUM="000" AND SET_NUM="000" AND HMS_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=HMS_E5;
					DIS4<=HMS_E4;
					DIS3<=HMS_E3;
					DIS2<=HMS_E2;
					DIS1<=HMS_E1;
					DIS0<=HMS_E0;
				ELSE
					DIS5<=HMS_E5;
					DIS4<=HMS_E4;
					DIS3<=HMS_E3;
					DIS2<=HMS_E2;
					DIS1<=HMS_E1;
					DIS0<="1111";--闪烁最右位数码管
				END IF;
			END IF;
			
			IF(MODE_NUM="001" AND SET_NUM="101" AND CAL_START='0') THEN
				IF(CLK_2='1') THEN--显示在日历模式且不在运行时
					DIS5<=CAL_E5;
					DIS4<=CAL_E4;
					DIS3<=CAL_E3;
					DIS2<=CAL_E2;
					DIS1<=CAL_E1;
					DIS0<=CAL_E0;
				ELSE
					DIS5<="1111";
					DIS4<=CAL_E4;
					DIS3<=CAL_E3;
					DIS2<=CAL_E2;
					DIS1<=CAL_E1;
					DIS0<=CAL_E0;
				END IF;
			ELSIF(MODE_NUM="001" AND SET_NUM="100" AND CAL_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=CAL_E5;
					DIS4<=CAL_E4;
					DIS3<=CAL_E3;
					DIS2<=CAL_E2;
					DIS1<=CAL_E1;
					DIS0<=CAL_E0;
				ELSE
					DIS5<=CAL_E5;
					DIS4<="1111";
					DIS3<=CAL_E3;
					DIS2<=CAL_E2;
					DIS1<=CAL_E1;
					DIS0<=CAL_E0;
				END IF;
			ELSIF(MODE_NUM="001" AND SET_NUM="011" AND CAL_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=CAL_E5;
					DIS4<=CAL_E4;
					DIS3<=CAL_E3;
					DIS2<=CAL_E2;
					DIS1<=CAL_E1;
					DIS0<=CAL_E0;
				ELSE
					DIS5<=CAL_E5;
					DIS4<=CAL_E4;
					DIS3<="1111";
					DIS2<=CAL_E2;
					DIS1<=CAL_E1;
					DIS0<=CAL_E0;
				END IF;
			ELSIF(MODE_NUM="001" AND SET_NUM="010" AND CAL_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=CAL_E5;
					DIS4<=CAL_E4;
					DIS3<=CAL_E3;
					DIS2<=CAL_E2;
					DIS1<=CAL_E1;
					DIS0<=CAL_E0;
				ELSE
					DIS5<=CAL_E5;
					DIS4<=CAL_E4;
					DIS3<=CAL_E3;
					DIS2<="1111";
					DIS1<=CAL_E1;
					DIS0<=CAL_E0;
				END IF;
			ELSIF(MODE_NUM="001" AND SET_NUM="001" AND CAL_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=CAL_E5;
					DIS4<=CAL_E4;
					DIS3<=CAL_E3;
					DIS2<=CAL_E2;
					DIS1<=CAL_E1;
					DIS0<=CAL_E0;
				ELSE
					DIS5<=CAL_E5;
					DIS4<=CAL_E4;
					DIS3<=CAL_E3;
					DIS2<=CAL_E2;
					DIS1<="1111";
					DIS0<=CAL_E0;
				END IF;
			ELSIF(MODE_NUM="001" AND SET_NUM="000" AND CAL_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=CAL_E5;
					DIS4<=CAL_E4;
					DIS3<=CAL_E3;
					DIS2<=CAL_E2;
					DIS1<=CAL_E1;
					DIS0<=CAL_E0;
				ELSE
					DIS5<=CAL_E5;
					DIS4<=CAL_E4;
					DIS3<=CAL_E3;
					DIS2<=CAL_E2;
					DIS1<=CAL_E1;
					DIS0<="1111";
				END IF;
			END IF;
			
			IF(MODE_NUM="011" AND SET_NUM="101" AND TIMER_START='0') THEN
				IF(CLK_2='1') THEN--显示在倒计时模式且不在运行时
					DIS5<=TIMER_E5;
					DIS4<=TIMER_E4;
					DIS3<=TIMER_E3;
					DIS2<=TIMER_E2;
					DIS1<=TIMER_E1;
					DIS0<=TIMER_E0;
				ELSE
					DIS5<="1111";
					DIS4<=TIMER_E4;
					DIS3<=TIMER_E3;
					DIS2<=TIMER_E2;
					DIS1<=TIMER_E1;
					DIS0<=TIMER_E0;
				END IF;
			ELSIF(MODE_NUM="011" AND SET_NUM="100" AND TIMER_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=TIMER_E5;
					DIS4<=TIMER_E4;
					DIS3<=TIMER_E3;
					DIS2<=TIMER_E2;
					DIS1<=TIMER_E1;
					DIS0<=TIMER_E0;
				ELSE
					DIS5<=TIMER_E5;
					DIS4<="1111";
					DIS3<=TIMER_E3;
					DIS2<=TIMER_E2;
					DIS1<=TIMER_E1;
					DIS0<=TIMER_E0;
				END IF;
			ELSIF(MODE_NUM="011" AND SET_NUM="011" AND TIMER_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=TIMER_E5;
					DIS4<=TIMER_E4;
					DIS3<=TIMER_E3;
					DIS2<=TIMER_E2;
					DIS1<=TIMER_E1;
					DIS0<=TIMER_E0;
				ELSE
					DIS5<=TIMER_E5;
					DIS4<=TIMER_E4;
					DIS3<="1111";
					DIS2<=TIMER_E2;
					DIS1<=TIMER_E1;
					DIS0<=TIMER_E0;
				END IF;
			ELSIF(MODE_NUM="011" AND SET_NUM="010" AND TIMER_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=TIMER_E5;
					DIS4<=TIMER_E4;
					DIS3<=TIMER_E3;
					DIS2<=TIMER_E2;
					DIS1<=TIMER_E1;
					DIS0<=TIMER_E0;
				ELSE
					DIS5<=TIMER_E5;
					DIS4<=TIMER_E4;
					DIS3<=TIMER_E3;
					DIS2<="1111";
					DIS1<=TIMER_E1;
					DIS0<=TIMER_E0;
				END IF;
			ELSIF(MODE_NUM="011" AND SET_NUM="001" AND TIMER_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=TIMER_E5;
					DIS4<=TIMER_E4;
					DIS3<=TIMER_E3;
					DIS2<=TIMER_E2;
					DIS1<=TIMER_E1;
					DIS0<=TIMER_E0;
				ELSE
					DIS5<=TIMER_E5;
					DIS4<=TIMER_E4;
					DIS3<=TIMER_E3;
					DIS2<=TIMER_E2;
					DIS1<="1111";
					DIS0<=TIMER_E0;
				END IF;
			ELSIF(MODE_NUM="011" AND SET_NUM="000" AND TIMER_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=TIMER_E5;
					DIS4<=TIMER_E4;
					DIS3<=TIMER_E3;
					DIS2<=TIMER_E2;
					DIS1<=TIMER_E1;
					DIS0<=TIMER_E0;
				ELSE
					DIS5<=TIMER_E5;
					DIS4<=TIMER_E4;
					DIS3<=TIMER_E3;
					DIS2<=TIMER_E2;
					DIS1<=TIMER_E1;
					DIS0<="1111";
				END IF;
			ELSIF(MODE_NUM="011" AND TIMER_FINISH='1') THEN
				IF(CLK_2='1') THEN
					DIS5<="0000";
					DIS4<="0000";
					DIS3<="0000";
					DIS2<="0000";
					DIS1<="0000";
					DIS0<="0000";
				ELSE
					DIS5<="1111";
					DIS4<="1111";
					DIS3<="1111";
					DIS2<="1111";
					DIS1<="1111";
					DIS0<="1111";
				END IF;	
			END IF;
			
			IF(MODE_NUM="100" AND SET_NUM="101" AND ALM_START='0') THEN
				IF(CLK_2='1') THEN--显示在闹钟模式且不在运行时
					DIS5<=ALM_E5;
					DIS4<=ALM_E4;
					DIS3<=ALM_E3;
					DIS2<=ALM_E2;
					DIS1<=ALM_E1;
					DIS0<=ALM_E0;
				ELSE
					DIS5<="1111";
					DIS4<=ALM_E4;
					DIS3<=ALM_E3;
					DIS2<=ALM_E2;
					DIS1<=ALM_E1;
					DIS0<=ALM_E0;
				END IF;
			ELSIF(MODE_NUM="100" AND SET_NUM="100" AND ALM_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=ALM_E5;
					DIS4<=ALM_E4;
					DIS3<=ALM_E3;
					DIS2<=ALM_E2;
					DIS1<=ALM_E1;
					DIS0<=ALM_E0;
				ELSE
					DIS5<=ALM_E5;
					DIS4<="1111";
					DIS3<=ALM_E3;
					DIS2<=ALM_E2;
					DIS1<=ALM_E1;
					DIS0<=ALM_E0;
				END IF;
			ELSIF(MODE_NUM="100" AND SET_NUM="011" AND ALM_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=ALM_E5;
					DIS4<=ALM_E4;
					DIS3<=ALM_E3;
					DIS2<=ALM_E2;
					DIS1<=ALM_E1;
					DIS0<=ALM_E0;
				ELSE
					DIS5<=ALM_E5;
					DIS4<=ALM_E4;
					DIS3<="1111";
					DIS2<=ALM_E2;
					DIS1<=ALM_E1;
					DIS0<=ALM_E0;
				END IF;
			ELSIF(MODE_NUM="100" AND SET_NUM="010" AND ALM_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=ALM_E5;
					DIS4<=ALM_E4;
					DIS3<=ALM_E3;
					DIS2<=ALM_E2;
					DIS1<=ALM_E1;
					DIS0<=ALM_E0;
				ELSE
					DIS5<=ALM_E5;
					DIS4<=ALM_E4;
					DIS3<=ALM_E3;
					DIS2<="1111";
					DIS1<=ALM_E1;
					DIS0<=ALM_E0;
				END IF;
			ELSIF(MODE_NUM="100" AND SET_NUM="001" AND ALM_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=ALM_E5;
					DIS4<=ALM_E4;
					DIS3<=ALM_E3;
					DIS2<=ALM_E2;
					DIS1<=ALM_E1;
					DIS0<=ALM_E0;
				ELSE
					DIS5<=ALM_E5;
					DIS4<=ALM_E4;
					DIS3<=ALM_E3;
					DIS2<=ALM_E2;
					DIS1<="1111";
					DIS0<=ALM_E0;
				END IF;
			ELSIF(MODE_NUM="100" AND SET_NUM="000" AND ALM_START='0') THEN
				IF(CLK_2='1') THEN
					DIS5<=ALM_E5;
					DIS4<=ALM_E4;
					DIS3<=ALM_E3;
					DIS2<=ALM_E2;
					DIS1<=ALM_E1;
					DIS0<=ALM_E0;
				ELSE
					DIS5<=ALM_E5;
					DIS4<=ALM_E4;
					DIS3<=ALM_E3;
					DIS2<=ALM_E2;
					DIS1<=ALM_E1;
					DIS0<="1111";
				END IF;
			END IF;
		END IF;
	END PROCESS DISP2;
END ARCHITECTURE BEHAVE;