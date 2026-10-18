library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mylib.all;

entity gcd_datapath is   
    generic (
        datawidth : integer := 8
    ); 
    port(
        rst,clk : in std_logic;
        x_i,y_i : in std_logic_vector (datawidth-1 downto 0);
        x_sel,y_sel : in std_logic;
        x_ld,y_ld : in std_logic;
        gcd_ld : in std_logic;
        x_neq_y,x_lt_y : out std_logic;
        gcd_o  : out std_logic_vector(datawidth-1 downto 0)
    );
end gcd_datapath;

architecture rtl of gcd_datapath is
    -- signal
signal  x_src,y_src : std_logic_vector(datawidth-1 downto 0);
signal x,y : std_logic_vector(datawidth-1 downto 0);
signal xsuby,ysubx : std_logic_vector(datawidth-1 downto 0);
signal gcd_src : std_logic_vector(datawidth-1 downto 0);
constant zero  : std_logic_vector(datawidth-1 downto 0):= (others => '0');

begin
    -- mux2to1 
mux2to1_X : mux2to1
generic map (datawidth => datawidth)
port map (
    sel => x_sel,
    x_i => x_i,
    y_i => xsuby,
    f   => x_src
);
mux2to1_Y : mux2to1
generic map (datawidth => datawidth)
port map (
    sel => y_sel,
    x_i => y_i,
    y_i => ysubx,
    f   => y_src
);
    -- regn
regn_X : regn
generic map (datawidth => datawidth) 
port map(
    clk => clk,
    rst => rst,
    en => x_ld,
    d => x_src,
    o => x
);
regn_Y : regn 
generic map (datawidth => datawidth)
port map(
    clk => clk,
    rst => rst,
    en => y_ld,
    d => y_src,
    o => y
);
regn_o : regn 
generic map (datawidth => datawidth)
port map(
    clk => clk,
    rst => rst,
    en => gcd_ld,
    d => gcd_src,
    o => gcd_o
);
    -- x = 0 
    gcd_src <= y when (x = zero) else x;
    -- compare not equal
    x_neq_y <= '0' when (x = y) or (x = zero) or (y = zero) else '1';
    -- compare less than
    x_lt_y <= '1' when x < y else '0';
    -- x sub y 
    xsuby <= x-y;
    -- y sub x
    ysubx <= y-x;

end architecture rtl;
