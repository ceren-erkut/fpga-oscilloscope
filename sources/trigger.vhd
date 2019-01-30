library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.std_logic_textio.all; 
use IEEE.NUMERIC_STD.ALL; 
library UNISIM;
use UNISIM.VComponents.all;

entity trigger is Port (eoc_clock: in std_logic;
                        xlevel : out std_logic_vector(9 downto 0);
                        ylevel : out std_logic_vector(8 downto 0);
                        datain : in std_logic_vector(8 downto 0); 
                        trig_level : in integer;
                        read_address : inout std_logic_vector(11 downto 0));
end trigger;
  
architecture Behavioral of trigger is
  
signal trig_enable : std_logic:= '0';
signal enable_trigram : std_logic:= '0';
signal trig_address : integer range 0 to 1024;
signal update_address : integer range 0 to 4095 := 0;
type ram_type is array (0 to 1023) of std_logic_vector(8 downto 0);
signal trigram : ram_type;

begin
  
read_address <= std_logic_vector(to_unsigned(update_address, 12));

process(eoc_clock) 
begin
  
  if rising_edge(eoc_clock) then
    if to_integer(signed(datain)) = trig_level and trig_enable = '0' then
      trig_enable <= '1';
      trigram(0) <= datain;
      trig_address <= 1;
      enable_trigram <= '0';
    elsif trig_enable = '0' and enable_trigram = '0'then
      update_address <= update_address+1;
      ylevel <= datain;
      if trig_address < 1024 then
        xlevel <= std_logic_vector(to_unsigned(trig_address,10)); 
        trig_address <= trig_address + 1;
      else
        trig_address <= 0;
      end if;
      enable_trigram <= '0';
      trig_enable <= '0';
    elsif trig_enable = '1' and enable_trigram = '0' then
      if trig_address < 800 then 
        trigram(trig_address) <= datain; 
        update_address <= update_address+1; 
        trig_address <= trig_address + 1;
      else
        enable_trigram <= '1'; trig_address <= 0;
      end if;
    elsif enable_trigram = '1' then
      if trig_address < 1024 then
        ylevel <= trigram(trig_address);
        xlevel <= std_logic_vector(to_unsigned(trig_address,10)); 
        trig_address <= trig_address + 1;
      else
        trig_address <= 0; 
        enable_trigram <= '1'; 
        trig_enable <= '0';
      end if;
    end if;
  end if;
    
end process;
    
end Behavioral;
