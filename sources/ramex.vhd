library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.Numeric_Std.all;

entity ramex is port (clock : in std_logic;
eoc_out : in std_logic;
write_address : in std_logic_vector(11 downto 0); read_address : in std_logic_vector(11 downto 0);
reading : in std_logic_vector(11 downto 0);
dataout : out std_logic_vector(8 downto 0) -- y axis pixel value
);
end entity ramex;
architecture Behavioral of ramex is
