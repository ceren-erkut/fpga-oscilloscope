library IEEE;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
library UNISIM;
use UNISIM.VComponents.all;

entity bintodec is Port(reading : in std_logic_vector(11 downto 0); 
                        clk : in STD_LOGIC;
                        mp1: out std_logic;
                        mp2: out std_logic;
                        mp3: out std_logic;
                        selectchar11: out integer;
                        selectchar12: out integer;
                        selectchar21: out integer;
                        selectchar22: out integer;
                        selectchar31: out integer;
                        selectchar32: out integer);
end bintodec;
  
architecture Behavioral of bintodec is 
  
component measure is port(adcin : in STD_LOGIC_VECTOR (11 downto 0); 
                          clk : in STD_LOGIC;
                          absmin : out integer;
                          absmax : out integer;
                          absvpp : out integer); 
end component;
  
signal min : integer; 
signal max : integer; 
signal vpp : integer; 
signal m : integer; 
signal n : integer; 
signal k : integer; 
signal l : integer; 
signal p : integer; 
signal r : integer;
signal n24 : integer:= 24;

begin
  
u10: measure port map (clk => clk, absmin => min, absmax => max, absvpp => vpp, adcin => reading);

process(clk) 
begin
  
  if rising_edge(clk) then 
    m <= vpp*24/1000; 
    n <= vpp*24/10000;
    k <= max*24/1000; 
    l <= max*24/10000;
    p <= min*24/1000; 
    r <= min*24/10000;

    if n < 0 then
      selectchar11 <= -n;
      mp1 <= '0'; -- 1st number is minus
    else
      selectchar11 <= n; 
      mp1 <= '1';
    end if;
      
    if l < 0 then
      selectchar21 <= -l;
      mp2 <= '0'; -- 1st number is minus
    else
      selectchar21 <= l; 
      mp2 <= '1';
    end if;
        
    if r < 0 then
      selectchar31 <= -r;
      mp3 <= '0'; -- 1st number is minus
    else
      selectchar31 <= r; 
      mp3 <= '1';
    end if;
      
    if m-(10*n) > 0 then 
      selectchar12 <= m-(10*n);
    else
      selectchar12 <= (10*n)-m;
    end if;
      
    if k-(10*l) > 0 then 
      selectchar22 <= k-(10*l); 
    else
      selectchar22 <= (10*l)-k; 
    end if;
      
    if p-(10*r) > 0 then 
      selectchar32 <= p-(10*r); 
    else
      selectchar32 <= (10*r)-p; 
    end if;
      
end if;
  
end process;
  
end Behavioral;      
      
      
      
      
