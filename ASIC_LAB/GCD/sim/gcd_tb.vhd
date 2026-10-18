library ieee;
use ieee.std_logic_1164.all;
use work.mylib.all;

entity gcd_tb is   
end gcd_tb;

architecture rtl of gcd_tb is
constant TB_DATAWIDTH : integer := 8;
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
    -- signal
signal        rst,clk : std_logic := '0';
signal        start_i : std_logic := '0';
signal        x_i,y_i : std_logic_vector (tb_datawidth-1 downto 0) := (others => '0');
signal        gcd_o   : std_logic_vector (tb_datawidth-1 downto 0) := (others => '0');
signal        done_o  : std_logic;

begin
DUT : gcd
    generic map(datawidth => tb_datawidth)
    port map (
    rst    => rst,
    clk    => clk, 
    start_i=>start_i,
    x_i    => x_i,
    y_i    => y_i,
    gcd_o  => gcd_o,
    done_o => done_o
);

CLOCK : process
begin
    wait for 5 ns;
    clk <= not clk;
end process;

RESET : process 
begin
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    wait;
end process;

STIM_PROC : process
begin
    wait for 30 ns;
    
    x_i <= x"0C"; -- 12
    y_i <= x"12"; -- 18
    start_i <= '1';
    wait for 10 ns; 
    start_i <= '0';
    wait until done_o = '1'; 
    wait for 100 ns;
    
    x_i <= x"18"; -- 24
    y_i <= x"10"; -- 16
    start_i <= '1';
    wait for 10 ns; 
    start_i <= '0';
    wait until done_o = '1'; 
    wait for 100 ns;

    x_i <= x"05"; -- 5
    y_i <= x"0F"; -- 15
    start_i <= '1';
    wait for 10 ns; 
    start_i <= '0';
    wait until done_o = '1'; 
    wait for 100 ns;

    x_i <= x"22"; -- 34
    y_i <= x"02"; -- 2
    start_i <= '1';
    wait for 10 ns; 
    start_i <= '0';
    wait until done_o = '1'; 
    wait for 100 ns;

    x_i <= x"03"; -- 3
    y_i <= x"19"; -- 25
    start_i <= '1';
    wait for 10 ns; 
    start_i <= '0';
    wait until done_o = '1'; 
    wait for 100 ns;

    x_i <= x"0A"; -- 10
    y_i <= x"36"; -- 54
    start_i <= '1';
    wait for 10 ns; 
    start_i <= '0';
    wait until done_o = '1'; 
    wait for 100 ns;

    x_i <= x"00"; -- 0 
    y_i <= x"09"; -- 9 
    start_i <= '1';
    wait for 10 ns; 
    start_i <= '0';
    wait until done_o = '1'; 
    wait for 100 ns;

    x_i <= x"23"; -- 35
    y_i <= x"0E"; -- 14
    start_i <= '1';
    wait for 10 ns; 
    start_i <= '0';
    wait until done_o = '1'; 
    wait for 100 ns;

    x_i <= x"0C"; -- 12
    y_i <= x"0C"; -- 12
    start_i <= '1';
    wait for 10 ns; 
    start_i <= '0';
    wait until done_o = '1'; 
    wait for 100 ns;

    wait;
end process;
end architecture rtl;
