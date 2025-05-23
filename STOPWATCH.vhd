LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY STOPWATCH IS
PORT(
	CLK_100: IN STD_LOGIC;
	RUNIN,CLRIN: IN STD_LOGIC;
	MODE_NUM: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	STOPW_D5,STOPW_D4,STOPW_D3,STOPW_D2,STOPW_D1,STOPW_D0: BUFFER STD_LOGIC_VECTOR(3 DOWNTO 0);
	STOPW_START: OUT STD_LOGIC
);
END ENTITY STOPWATCH;

ARCHITECTURE BEHAVE OF STOPWATCH IS
SIGNAL START: STD_LOGIC:='0';
SIGNAL CLR: STD_LOGIC:='1';

BEGIN
STOPW_START<=START;

START1:PROCESS(RUNIN)
BEGIN
	IF(MODE_NUM="010") THEN--在秒表模式且按下RUN键切换运行状态
		IF(RUNIN'EVENT AND RUNIN='1') THEN
			START<=NOT START;
		END IF;
	END IF;
END PROCESS START1;

CLR1:PROCESS(CLRIN)
BEGIN
	IF(MODE_NUM="010" AND CLRIN='1') THEN
		CLR<='1';--在秒表模式且按下CLR键输出清零信号
	ELSE
		CLR<='0';
	END IF;
END PROCESS CLR1;

RUN:PROCESS(CLK_100) IS
BEGIN
	IF(CLR='1') THEN--清零信号为高电平时清零
		STOPW_D0<="0000";
		STOPW_D1<="0000";
		STOPW_D2<="0000";
		STOPW_D3<="0000";
		STOPW_D4<="0000";
		STOPW_D5<="0000";
	ELSIF(CLK_100'EVENT AND CLK_100='1') THEN
		IF(START='1') THEN--100Hz信号控制自动进位
			IF(STOPW_D0="1001") THEN
				STOPW_D0<="0000";
				STOPW_D1<=STOPW_D1+1;
				
				IF(STOPW_D1="1001") THEN
					STOPW_D1<="0000";
					STOPW_D2<=STOPW_D2+1;
					
					IF(STOPW_D2="1001") THEN
						STOPW_D2<="0000";
						STOPW_D3<=STOPW_D3+1;
						
						IF(STOPW_D3="0101") THEN
							STOPW_D3<="0000";
							STOPW_D4<=STOPW_D4+1;
							
							IF(STOPW_D4="1001") THEN
								STOPW_D4<="0000";
								STOPW_D5<=STOPW_D5+1;
								
								IF(STOPW_D5="1001") THEN
									STOPW_D5<="0000";
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
			ELSE
				STOPW_D0<=STOPW_D0+1;
			END IF;
		END IF;
	END IF;
END PROCESS RUN;

END ARCHITECTURE BEHAVE;