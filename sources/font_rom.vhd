library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.std_logic_unsigned.all; 
use ieee.numeric_std.ALL;

entity font_rom is
Port (
selectchar11: in integer; selectchar12: in integer; selectchar21: in integer; selectchar22: in integer; selectchar31: in integer; selectchar32: in integer; userlevel: in integer; mp1: in std_logic;
mp2: in std_logic;
mp3: in std_logic;
display, Halfclock : in std_logic;
Rin, Bin, Gin : out std_logic_vector(3 downto 0); pixel_X : in std_logic_vector(10 downto 0); pixel_Y : in std_logic_vector(9 downto 0); selectedY : in std_logic_vector(8 downto 0); selectedX: in std_logic_vector(9 downto 0)
);
end font_rom;
architecture Behavioral of font_rom is
