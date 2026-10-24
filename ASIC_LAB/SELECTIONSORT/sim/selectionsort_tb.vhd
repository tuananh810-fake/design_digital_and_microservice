library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity selectionsort_tb is
end selectionsort_tb;

architecture Behavioral of selectionsort_tb is

    constant N          : integer := 8;
    constant DATA_WIDTH : integer := 16;
    constant ADDR_WIDTH : integer := 8;
    constant CLK_PERIOD : time    := 10 ns;


    signal clk     : std_logic := '0';
    signal rst     : std_logic := '0';
    signal start_i : std_logic := '0';
    signal done_o  : std_logic;


    component selectionsort_top is
        generic (
            N          : integer := 256;
            DATA_WIDTH : integer := 16;
            ADDR_WIDTH : integer := 8
        );
        port(
            clk     : in  std_logic;
            rst     : in  std_logic;
            start_i : in  std_logic;
            done_o  : out std_logic
        );
    end component;

begin

    UUT : selectionsort_top
        generic map (
            N          => N,
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk     => clk,
            rst     => rst,
            start_i => start_i,
            done_o  => done_o
        );


    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;


    stim_process : process
        variable start_time : time;
        variable end_time   : time;
    begin
        
        rst <= '1';
        start_i <= '0';
        wait for CLK_PERIOD * 3;


        rst <= '0';
        wait for CLK_PERIOD * 2;

        start_time := now;
        start_i <= '1';
        wait for CLK_PERIOD;

        wait until done_o = '1';
        end_time := now;


        wait for CLK_PERIOD * 2;
        start_i <= '0';
        wait for CLK_PERIOD * 5;

        wait;
    end process;

end Behavioral;
