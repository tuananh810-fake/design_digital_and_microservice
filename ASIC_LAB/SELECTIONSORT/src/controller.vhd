library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mylib.all;

entity controller is
    generic (
        N          : integer := 64;
        DATA_WIDTH : integer := 7;
        ADDR_WIDTH : integer := 6
    );
    port(
        clk, rst                            : in  STD_LOGIC;
        start_i                             : in  STD_LOGIC;
        lt, i_eq, j_eq                      : in  STD_LOGIC;
        sel_wdata, sel_min, sel_i, sel_j    : out STD_LOGIC;
        sel_addr                            : out STD_LOGIC_VECTOR(1 DOWNTO 0);
        en_i, en_j, en_min, en_mv, en_t     : out STD_LOGIC;
        ram_we                              : out STD_LOGIC;
        done_o                              : out STD_LOGIC
    );
end controller;

architecture Behavioral of controller is
    type State is (S0, S1, S1_READ, S2_ADDR, S2_COMP, S3, S4, S5, S6, S7, S8, S9);
    signal current_state, next_state : State := S0;
begin

    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= S0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    process(current_state, start_i, lt, i_eq, j_eq)
    begin
        case current_state is
            when S0 =>
                if start_i = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;

            when S1 =>
                next_state <= S1_READ;

            when S1_READ =>
                next_state <= S2_ADDR;

            when S2_ADDR =>
                next_state <= S2_COMP;

            when S2_COMP =>
                if lt = '1' then
                    next_state <= S3;
                else
                    next_state <= S4;
                end if;

            when S3 =>
                if j_eq = '1' then
                    next_state <= S5;
                else
                    next_state <= S2_ADDR;
                end if;

            when S4 =>
                if j_eq = '1' then
                    next_state <= S5;
                else
                    next_state <= S2_ADDR;
                end if;

            when S5 =>
                next_state <= S6;

            when S6 =>
                if i_eq = '1' then
                    next_state <= S8;
                else
                    next_state <= S7;
                end if;

            when S7 =>
                next_state <= S1;

            when S8 =>
                if start_i = '0' then
                    next_state <= S9;
                else
                    next_state <= S8;
                end if;

            when S9 =>
                next_state <= S0;

            when others =>
                next_state <= S0;
        end case;
    end process;

    process(current_state)
    begin
        sel_i      <= '0';
        sel_j      <= '0';
        sel_min    <= '0';
        sel_wdata  <= '0';
        sel_addr   <= "00";
        en_i       <= '0';
        en_j       <= '0';
        en_min     <= '0';
        en_mv      <= '0';
        en_t       <= '0';
        ram_we     <= '0';
        done_o     <= '0';

        case current_state is
            when S0 =>
                sel_i     <= '0';
                en_i      <= '1';
                sel_j     <= '0';
                sel_min   <= '0';
            when S1 =>
                sel_j     <= '0';
                en_j      <= '1';
                sel_min   <= '0';
                en_min    <= '1';
                sel_addr  <= "00";
            when S1_READ =>
                en_t      <= '1';
                en_mv     <= '1';
            when S2_ADDR =>
                sel_addr  <= "01";
            when S2_COMP =>
                sel_addr  <= "01";
            when S3 =>
                sel_addr  <= "01";
                sel_min   <= '1';
                en_min    <= '1';
                en_mv     <= '1';
                sel_j     <= '1';
                en_j      <= '1';
            when S4 =>
                sel_j     <= '1';
                en_j      <= '1';
            when S5 =>
                sel_addr  <= "00";
                sel_wdata <= '0';
                ram_we    <= '1';
            when S6 =>
                sel_addr  <= "10";
                sel_wdata <= '1';
                ram_we    <= '1';
            when S7 =>
                sel_i     <= '1';
                en_i      <= '1';
            when S8 =>
                done_o    <= '1';
            when S9 =>
                done_o    <= '0';
            when others =>
                null;
        end case;
    end process;
end Behavioral;