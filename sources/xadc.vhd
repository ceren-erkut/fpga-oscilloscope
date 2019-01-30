library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.std_logic_textio.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity xadc is port(write_address : out std_logic_vector(11 downto 0);
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
end xadc;
  
architecture xilinx of xadc is
attribute CORE_GENERATION_INFO : string;
attribute CORE_GENERATION_INFO of xilinx : architecture is "xadc_wiz_0,xadc_wiz_v3_3_0,{component_name=xadc_wiz_0,enable_axi=false,enable_axi4stream =false,dclk_frequency=100,enable_busy=true,enable_convst=false,enable_convstclk=false,enable_dc lk=true,enable_drp=true,enable_eoc=true,enable_eos=true,enable_vbram_alaram=false,enable_vcc ddro_alaram=false,enable_Vccint_Alaram=false,enable_Vccaux_alaram=falseenable_vccpaux_alara m=false,enable_vccpint_alaram=false,ot_alaram=false,user_temp_alaram=false,timing_mode=conti nuous,channel_averaging=None,sequencer_mode=off,startup_channel_selection=single_channel}";

signal FLOAT_VCCAUX_ALARM : std_logic;
signal FLOAT_VCCINT_ALARM : std_logic;
signal FLOAT_USER_TEMP_ALARM : std_logic;
signal FLOAT_VBRAM_ALARM : std_logic;
signal FLOAT_MUXADDR : std_logic_vector (4 downto 0); 
signal aux_channel_p : std_logic_vector (15 downto 0); 
signal aux_channel_n : std_logic_vector (15 downto 0); 
signal alm_int : std_logic_vector (7 downto 0);
signal current_add : integer range 0 to 4095 := 0;

begin
  
alarm_out <= alm_int(7);
aux_channel_p(0) <= '0'; aux_channel_n(0) <= '0';
aux_channel_p(1) <= '0'; aux_channel_n(1) <= '0';
aux_channel_p(2) <= '0'; aux_channel_n(2) <= '0';
aux_channel_p(3) <= '0'; aux_channel_n(3) <= '0';
aux_channel_p(4) <= '0'; aux_channel_n(4) <= '0';
aux_channel_p(5) <= '0'; aux_channel_n(5) <= '0';
aux_channel_p(6) <= '0'; aux_channel_n(6) <= '0';
aux_channel_p(7) <= '0'; aux_channel_n(7) <= '0';
aux_channel_p(8) <= '0'; aux_channel_n(8) <= '0';
aux_channel_p(9) <= '0'; aux_channel_n(9) <= '0';
aux_channel_p(10) <= '0'; aux_channel_n(10) <= '0';
aux_channel_p(11) <= '0'; aux_channel_n(11) <= '0';
aux_channel_p(12) <= '0'; aux_channel_n(12) <= '0';
aux_channel_p(13) <= '0'; aux_channel_n(13) <= '0';
aux_channel_p(14) <= vauxp14; aux_channel_n(14) <= vauxn14;
aux_channel_p(15) <= '0'; aux_channel_n(15) <= '0';

U0: XADC generic map(
INIT_40 => X"341E", -- config reg 0 "241E" "041e" |average 256|bipolar|continuous|14th channel|
INIT_41 => X"31AF", -- config reg 1 "2... "31AF" |single ch|||| INIT_42 => X"0400", -- config reg 2 DIV is 4 "0A00"
INIT_48 => X"0100", -- Sequencer channel selection INIT_49 => X"0000", -- Sequencer channel selection INIT_4A => X"0000", -- Sequencer Average selection INIT_4B => X"0000", -- Sequencer Average selection INIT_4C => X"0000", -- Sequencer Bipolar selection INIT_4D => X"0000", -- Sequencer Bipolar selection INIT_4E => X"0000", -- Sequencer Acq time selection INIT_4F => X"0000", -- Sequencer Acq time selection INIT_50 => X"B5ED", -- Temp alarm trigger
INIT_51 => X"57E4", -- Vccint upper alarm limit INIT_52 => X"A147", -- Vccaux upper alarm limit INIT_53 => X"CA33", -- Temp alarm OT upper INIT_54 => X"A93A", -- Temp alarm reset
INIT_55 => X"52C6", -- Vccint lower alarm limit INIT_56 => X"9555", -- Vccaux lower alarm limit INIT_57 => X"AE4E", -- Temp alarm OT reset INIT_58 => X"5999", -- Vccbram upper alarm limit INIT_5C => X"5111", -- Vccbram lower alarm limit SIM_DEVICE => "7SERIES",
SIM_MONITOR_FILE => "design.txt" )

port map (
CONVST => '0',
CONVSTCLK => '0',
DADDR(6 downto 0) => daddr_in(6 downto 0),
DCLK => dclk_in,
DEN => den_in,
DI(15 downto 0) => di_in(15 downto 0),
DWE => dwe_in,
RESET => reset_in,
VAUXN(15 downto 0) => aux_channel_n(15 downto 0), VAUXP(15 downto 0) => aux_channel_p(15 downto 0), ALM => alm_int,
BUSY => busy_out,
CHANNEL(4 downto 0) => channel_out(4 downto 0), DO(15 downto 0) => do_out(15 downto 0),
DRDY => drdy_out,
EOC => eoc_out,
EOS => eos_out,
JTAGBUSY => open,
JTAGLOCKED => open,
JTAGMODIFIED => open,
OT => open,
MUXADDR => FLOAT_MUXADDR, 
VN => vn_in,
VP => vp_in);

process(eoc_out)
  
begin
  
  if rising_edge(eoc_out) then
    if current_add < 4096 then 
      current_add <= current_add+1;
    else
      current_add <= 0;
    end if; 
  end if;
    
end process;
    
write_address <= std_logic_vector(to_unsigned(current_add, 12));
      
end xilinx;
  
  
  


