library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.std_logic_unsigned.all;

entity Top is

Port (clk : in STD_LOGIC;
      clockout : out STD_LOGIC;
      adc : in std_logic_vector(1 downto 0); 
      Hsync, Vsync : out std_logic;
      led : out std_logic_vector(15 downto 0);
      ps2_clk : IN STD_LOGIC;
      ps2_data : IN STD_LOGIC;
      vgaR, vgaB, vgaG : out std_logic_vector(3 downto 0));
end Top;

architecture Behavioral of Top is
      
component clk_div is Port (clkin : in std_logic;
                        clkout : out std_logic ); 
end component; 
      
component keyboard is port (clk: in std_logic;
                        ps2_clk : IN STD_LOGIC;
                        ps2_data : IN STD_LOGIC; 
                        userlevel : out integer);
end component;
      
component ramex is port (clock : in std_logic; 
                         eoc_out : in std_logic;
                         write_address : in std_logic_vector(11 downto 0); 
                         read_address : in std_logic_vector(11 downto 0);
                         dataout : out std_logic_vector(8 downto 0); -- y axis pixel value
end component; 
                         
component trigger is port (eoc_clock: in std_logic;
                           --triggered: out std_logic;
                           xlevel : out std_logic_vector(9 downto 0); -- goes to display 
                           ylevel : out std_logic_vector(8 downto 0); -- goes to display 
                           datain : in std_logic_vector(8 downto 0); -- comes from ramex
                           trig_level : in integer; -- comes from keyboard 
                           read_address : inout std_logic_vector(11 downto 0));-- goes to ramex

end component; 
                         
component xadc_wiz_0 is port (write_address : out std_logic_vector(11 downto 0);
                              daddr_in : in STD_LOGIC_VECTOR (6 downto 0); -- Address bus for the dynamic reconfiguration port
                              den_in : in STD_LOGIC; -- Enable Signal for the dynamic reconfiguration port
                              di_in : in STD_LOGIC_VECTOR (15 downto 0); -- Input data bus for the dynamic reconfiguration port
                              dwe_in : in STD_LOGIC; -- Write Enable for the dynamic reconfiguration port
                              do_out : out STD_LOGIC_VECTOR (15 downto 0); -- Output data bus for dynamic reconfiguration port
                              drdy_out: out STD_LOGIC;-- Data ready signal for the dynamic reconfiguration
                              dclk_in: in STD_LOGIC; -- Clock input for the dynamic reconfiguration port
                              reset_in: in STD_LOGIC;-- Reset signal for the System Monitor control logic
                              vauxp14: in STD_LOGIC;-- Auxiliary Channel 14
                              vauxn14: in STD_LOGIC;
                              busy_out: out STD_LOGIC;
                              channel_out: out STD_LOGIC_VECTOR (4 downto 0); -- Channel Selection Outputs
                              eoc_out: inout STD_LOGIC; -- End of Conversion Signal
                              eos_out: out STD_LOGIC; -- End of Sequence Signal
                              alarm_out: out STD_LOGIC; -- OR'ed output of all the Alarms
                              vp_in: in STD_LOGIC;-- Analog Input Pair
                              vn_in: in STD_LOGIC);
end component; 
                         
component Vga1 Port (clk : in STD_LOGIC;
                     Rin, Bin, Gin : in std_logic_vector(3 downto 0);
                     Hsync, Vsync, display, Halfclock : out std_logic;
                     VgaR, VgaB, VgaG : out std_logic_vector(3 downto 0); 
                     pixel_X : out std_logic_vector(10 downto 0);
                     pixel_Y : out std_logic_vector(9 downto 0));
end component;
                         
component font_rom Port (mp1: in std_logic;
                         mp2: in std_logic;
                         mp3: in std_logic; 
                         selectchar11: in integer; 
                         selectchar12: in integer;
                         selectchar21: in integer; 
                         selectchar22: in integer; 
                         selectchar31: in integer; 
                         selectchar32: in integer; 
                         userlevel : in integer;
                         display, Halfclock : in std_logic;
                         Rin, Bin, Gin : out std_logic_vector(3 downto 0); 
                         pixel_X : in std_logic_vector(10 downto 0); 
                         selectedY : in std_logic_vector(8 downto 0); 
                         selectedX : in std_logic_vector(9 downto 0); 
                         pixel_Y : in std_logic_vector(9 downto 0));
end component; 
                         
component bintodec Port (reading : in std_logic_vector(11 downto 0); 
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
end component;
                         
signal selectchar11 : integer; signal selectchar12 : integer; signal selectchar21 : integer; signal selectchar22 : integer; signal selectchar31 : integer; signal selectchar32 : integer; signal userlevell : integer;
signal mp1: std_logic; signal mp2: std_logic; signal mp3: std_logic;
signal reading: std_logic_vector(11 downto 0); signal Halfclock : std_logic; signal displayy : std_logic;
signal Rin, Bin, Gin : std_logic_vector(3 downto 0); signal pixel_X : std_logic_vector(10 downto 0); signal pixel_Y : std_logic_vector(9 downto 0); signal eoc: std_logic:= '1';
signal triggered: std_logic; signal ps2_clkkk: std_logic; signal clk_signal: std_logic; signal clockoutt: std_logic;
signal write_add: std_logic_vector(11 downto 0);
signal dataout : std_logic_vector(8 downto 0); -- y axis pixel value
signal trig_level : integer:=0; signal read_add: std_logic_vector(11 downto 0);
signal selectpixY : std_logic_vector(8 downto 0);
signal selectpixX : std_logic_vector(9 downto 0);
signal ylevel : std_logic_vector(8 downto 0);
signal xlevel : std_logic_vector(9 downto 0);
                         
begin
                         
led(11 downto 0) <= reading(11 downto 0); 
clk_signal <= clk;
clockout <= clockoutt;
                         
u1: clk_div port map(clkin => clk_signal,
                     clkout => clockoutt); 
u3: ramex port map (clock => clk_signal, 
                    write_address => write_add, 
                    read_address => read_add, 
                    eoc_out => eoc,
                    reading => reading,
                    dataout => dataout);
u7: trigger port map (eoc_clock => eoc,
                      xlevel=> selectpixX,
                      ylevel => selectpixY,
                      datain=> dataout, 
                      trig_level=> trig_level,
                      read_address => read_add);
u6: xadc_wiz_0 port map (write_address => write_add, 
                         daddr_in => "0011110",
                         den_in=> eoc,
                         di_in=> (others => '0'),
                         dwe_in=> '0',
                         do_out(15 downto 4) => reading(11 downto 0),
                         do_out(3 downto 0) => led(15 downto 12),
                         drdy_out => open,

dclk_in
reset_in
vauxp14
vauxn14
busy_out =>open, channel_out => open, eoc_out => eoc, eos_out => open, alarm_out => open, vp_in => '0',
vn_in => '0' );
u8: bintodec port map (
reading => reading, clk => clk_signal, mp1 =>mp1,
mp2 =>mp2,
mp3 =>mp3,
selectchar11 => selectchar11, selectchar12 => selectchar12, selectchar21 => selectchar21, selectchar22 => selectchar22, selectchar31 => selectchar31, selectchar32 => selectchar32
);
u11: keyboard
port map(
ps2_clk => ps2_clk,
ps2_data => ps2_data,
clk => halfclock,
userlevel => trig_level --userlevell );
u4: Vga1
port map(clk => clk_signal, Rin => Rin,
Bin => Bin, Gin => Gin,
Hsync => Hsync, Vsync => Vsync,
display => displayy,
Halfclock => Halfclock,
VgaR => VgaR, VgaB => VgaB, VgaG => VgaG, pixel_X => pixel_X, pixel_Y => pixel_Y);
u5: font_rom
port map(display => displayy,
=> clk_signal, => '0',
=> adc(0),---------------------- channel 14 => adc(1),
Halfclock => Halfclock,

Rin => Rin, Bin => Bin, Gin => Gin,
pixel_X => pixel_X, pixel_Y => pixel_Y,
selectedY => selectpixY, selectedX => selectpixX,
userlevel => userlevell,
mp1 =>mp1, mp2 =>mp2, mp3 =>mp3,
selectchar11 => selectchar11, selectchar12 => selectchar12, selectchar21 => selectchar21, selectchar22 => selectchar22, selectchar31 => selectchar31, selectchar32 => selectchar32);
end Behavioral;
