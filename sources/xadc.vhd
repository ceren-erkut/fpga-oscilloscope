library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.std_logic_textio.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity xadc is port(write_address : out std_logic_vector(11 downto 0);
