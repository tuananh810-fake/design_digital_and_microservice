library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.mylib.all;


entity gcd_top is
port(
    clk : in std_logic
);
end gcd_top;

architecture Behavioral of gcd_top is
constant datawidth : integer := 8;
signal        rst     : std_logic_vector (0 downto 0);
signal        start_i : std_logic_vector(0 downto 0);
signal        x_i,y_i : std_logic_vector (datawidth-1 downto 0);
signal        gcd_o   : std_logic_vector (datawidth-1 downto 0);
signal        done_o  : std_logic_vector(0 downto 0);

 -- component
component gcd is   
    generic (
        datawidth : integer := 8
    ); 
    port(
        rst,clk : in std_logic;
        start_i : in std_logic;
        x_i,y_i : in std_logic_vector (datawidth-1 downto 0);
        gcd_o   : out std_logic_vector (datawidth-1 downto 0);
        done_o  : out std_logic
    );
end component;

component vio_0 is
port(
    clk : in std_logic;
    probe_in0 : in std_logic_vector(0 downto 0);
    probe_in1 : in std_logic_vector(datawidth-1 downto 0);
    probe_out0 : out std_logic_vector(0 downto 0);
    probe_out1 : out std_logic_vector(0 downto 0);
    probe_out2 : out std_logic_vector(datawidth-1 downto 0);
    probe_out3 : out std_logic_vector(datawidth-1 downto 0)
);
end component ;
component ila_0 is
port(
    clk : in std_logic;
    probe0 : in std_logic_vector(0 downto 0);
    probe1 : in std_logic_vector(0 downto 0);
    probe2 : in std_logic_vector(0 downto 0);
    probe3 : in std_logic_vector(datawidth-1 downto 0);
    probe4 : in std_logic_vector(datawidth-1 downto 0);
    probe5 : in std_logic_vector(datawidth-1 downto 0)
);
end component;

begin
MYVIO : vio_0
port map (
    clk         => clk,
    probe_in0   => done_o,
    probe_in1   => gcd_o,
    probe_out0  => rst,
    probe_out1  => start_i,
    probe_out2  => x_i,
    probe_out3  => y_i 
);

MYGCD : gcd 
port map (
    clk      => clk,
    done_o   => done_o(0),
    gcd_o    => gcd_o,
    rst      => rst(0),
    start_i  => start_i(0),
    x_i      => x_i,
    y_i      => y_i 
);

MYILA : ila_0
port map(
    clk => clk,
    probe0 => rst,
    probe1 => start_i,
    probe2 => done_o,
    probe3 => x_i,
    probe4 => y_i,
    probe5 => gcd_o 
);
end Behavioral;
