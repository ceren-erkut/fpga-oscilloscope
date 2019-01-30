library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.std_logic_textio.all; 
use IEEE.NUMERIC_STD.ALL; 
library UNISIM;
use UNISIM.VComponents.all;

entity trigger is Port (eoc_clock: in std_logic;
xlevel : out std_logic_vector(9 downto 0); -- displaye gider
ylevel : out std_logic_vector(8 downto 0); -- displaye gider
datain : in std_logic_vector(8 downto 0); -- ramexten gelen level
trig_level : in integer;--std_logic_vector(8 downto 0); -- keyboarddan gelen trig level read_address : inout std_logic_vector(11 downto 0)-- ramexe gider
);
end trigger;
architecture Behavioral of trigger is
