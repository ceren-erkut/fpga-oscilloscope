library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.std_logic_unsigned.all;

entity Vga1 is Port(clk : in STD_LOGIC;
                    Rin, Bin, Gin : in std_logic_vector(3 downto 0);
                    Hsync, Vsync, display, Halfclock : out std_logic;
                    VgaR, VgaB, VgaG : out std_logic_vector(3 downto 0); 
                    pixel_X : out std_logic_vector(10 downto 0);
                    pixel_Y : out std_logic_vector(9 downto 0));
end Vga1;
  
--The Screen 800x600 at 72HZ architecture Behavioral of Vga1 is
  
architecture Behavioral of Vga1 is
  
signal Hclock : std_logic:= '0';
signal Vclock : std_logic:= '0';
signal V_OK : std_logic:= '0';
signal H_OK : std_logic:= '0';
signal Screen : std_logic:= '0';
signal V_counter : std_logic_vector(9 downto 0):= "0000000000";
signal H_counter : std_logic_vector(10 downto 0):= "00000000000";

begin
  
Screen <= V_OK and H_OK; 
display <= Screen;
VgaR <= Rin when Screen <= '1' else "0000"; 
VgaB <= Bin when Screen <= '1' else "0000"; 
VgaG <= Gin when Screen <= '1' else "0000";

process (clk) 
begin
  
  if(rising_edge(clk)) then 
    Hclock <= not Hclock;
  end if; 
    
end process;
    
Halfclock <= hclock; 
  
process (H_OK)
begin

  if (rising_edge(Hclock)) then
    if(H_counter = 0) then 
      Hsync <= '1';
    elsif ( H_counter = 120) then 
      Hsync <= '0';
      Vclock <= '0';
    elsif (H_counter = 184) then 
      H_OK <= '1';
    elsif (H_counter = 983) then 
      H_OK <= '0';
    end if;
    H_counter <= H_counter + 1;
    if (H_counter = 1040) then 
      H_counter <= "00000000000"; 
      Vclock <= '1';
    end if;
    Pixel_X <= H_counter - 184; 
  end if;
    
end process;
    
process (V_OK) 
    begin
      if (rising_edge(Vclock)) then
        if (V_counter = 0) then 
          Vsync <= '1';
        elsif (V_counter = 6) then 
          Vsync <= '0';
        elsif (V_counter = 29) then
          V_OK <= '1';
        elsif (V_counter = 628) then
          V_OK <= '0'; 
        end if;
        V_counter <= V_counter + 1; 
        if (V_counter = 666) then
          V_counter <= (others => '0'); 
        end if;
        pixel_Y <= V_counter - 29; 
      end if;
end process;
        
end Behavioral;
        
