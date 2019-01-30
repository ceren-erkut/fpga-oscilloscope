library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.Numeric_Std.all;

entity ramex is port (clock : in std_logic;
                      eoc_out : in std_logic;
                      write_address : in std_logic_vector(11 downto 0); 
                      read_address : in std_logic_vector(11 downto 0);
                      reading : in std_logic_vector(11 downto 0);
                      dataout : out std_logic_vector(8 downto 0) -- y axis pixel value
                     );
end entity ramex;

architecture Behavioral of ramex is

type ram_type is array (0 to 4095) of std_logic_vector(8 downto 0); 
signal ram : ram_type;
signal temp: std_logic_vector(8 downto 0); 

begin

process(clock) 
begin
  if rising_edge(clock) then 
    temp(8) <= reading(11); temp(7) <= reading(10); temp(6) <= reading(9); temp(5) <= reading(8); temp(4) <= reading(7); temp(3) <= reading(6); temp(2) <= reading(5); temp(1) <= reading(4); temp(0) <= reading(3); -- divided by 8
    ram(to_integer(unsigned(write_address))) <= temp;
    dataout <= ram(to_integer(unsigned(read_address))); 
  end if;
end process;
    
end architecture Behavioral;    
