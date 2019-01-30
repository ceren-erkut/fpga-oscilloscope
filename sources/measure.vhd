library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;

entity measure is Port (adcin : in STD_LOGIC_VECTOR (11 downto 0);
                        clk : in STD_LOGIC; 
                        absmin : out integer; 
                        absmax : out integer; 
                        absvpp : out integer);
end measure;
  
architecture Behavioral of measure is
  
signal minn : integer := 2048; 
signal maxx : integer := -2048; 

begin
  
process(clk) 
begin
  if rising_edge(clk) then
    if to_integer(signed(adcin)) < minn then
      minn <= to_integer(signed(adcin));
    elsif to_integer(signed(adcin)) > maxx then
      maxx <= to_integer(signed(adcin));
    end if;
    absmin <= minn; 
    absmax <= maxx; 
    absvpp <= maxx - minn;
  end if;
    
end process;
    
end Behavioral;
