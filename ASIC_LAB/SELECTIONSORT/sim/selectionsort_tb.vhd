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


    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal start_i   : std_logic := '0';
    signal done_o    : std_logic;
    signal ext_addr  : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal rdata_out : std_logic_vector(DATA_WIDTH-1 downto 0);


    component selectionsort_top is
        generic (
            N          : integer := 256;
            DATA_WIDTH : integer := 16;
            ADDR_WIDTH : integer := 8
        );
        port(
            clk       : in  std_logic;
            rst       : in  std_logic;
            start_i   : in  std_logic;
            done_o    : out std_logic;
            ext_addr  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            rdata_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
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
            clk       => clk,
            rst       => rst,
            start_i   => start_i,
            done_o    => done_o,
            ext_addr  => ext_addr,
            rdata_out => rdata_out
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
        type ram_array_t is array (0 to N-1) of integer;
        variable read_arr  : ram_array_t;
        variable is_sorted : boolean := true;
    begin
        
        rst      <= '1';
        start_i  <= '0';
        ext_addr <= (others => '0');
        wait for CLK_PERIOD * 3;


        rst <= '0';
        wait for CLK_PERIOD * 2;

        start_time := now;
        start_i <= '1';
        wait for CLK_PERIOD;

        wait until done_o = '1';
        end_time := now;

        wait until rising_edge(clk);
        start_i <= '0';

        for k in 0 to N-1 loop
            ext_addr <= std_logic_vector(to_unsigned(k, ADDR_WIDTH));
            wait until rising_edge(clk);
            wait for 1 ns;
            read_arr(k) := to_integer(unsigned(rdata_out));
            report "   RAM[" & integer'image(k) & "] = " & integer'image(read_arr(k)) severity note;
        end loop;

        -- Kiem tra xem mang da duoc sap xep tang dan chua
        is_sorted := true;
        for k in 0 to N-2 loop
            if read_arr(k) > read_arr(k+1) then
                is_sorted := false;
            end if;
        end loop;


        wait for CLK_PERIOD * 5;
        finish;
        wait;
    end process;

end Behavioral;
