library IEEE;
use ieee.std_logic_1164.all; use ieee.numeric_std.all; library UNISIM;
use UNISIM.VComponents.all;
entity bintodec is
Port (reading : in std_logic_vector(11 downto 0); clk : in STD_LOGIC;
mp1: out std_logic;
mp2: out std_logic;
mp3: out std_logic;
selectchar11: out integer;
selectchar12: out integer;
selectchar21: out integer;
selectchar22: out integer;
selectchar31: out integer;
selectchar32: out integer
);
end bintodec;
architecture Behavioral of bintodec is component measure is
port ( adcin : in STD_LOGIC_VECTOR (11 downto 0); clk : in STD_LOGIC;
absmin : out integer;
absmax : out integer;
absvpp : out integer); end component;
signal min : integer; signal max : integer; signal vpp : integer; signal m : integer; signal n : integer; signal k : integer; signal l : integer; signal p : integer; signal r : integer;
