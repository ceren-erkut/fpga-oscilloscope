library IEEE;
use IEEE.STD_LOGIC_1164.ALL; use IEEE.std_logic_unsigned.all;
entity Vga1 is
Port ( clk : in STD_LOGIC;
Rin, Bin, Gin : in std_logic_vector(3 downto 0);
Hsync, Vsync, display, Halfclock : out std_logic;
VgaR, VgaB, VgaG : out std_logic_vector(3 downto 0); pixel_X : out std_logic_vector(10 downto 0);
pixel_Y : out std_logic_vector(9 downto 0));
end Vga1;
--The Screen 800x600 at 72HZ architecture Behavioral of Vga1 is
