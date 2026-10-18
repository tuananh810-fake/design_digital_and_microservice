library ieee;
use ieee.std_logic_1164.all;
use work.mylib.all;

entity gcd_controller is   
    port(
        rst,clk         : in std_logic;
        done_o          : out std_logic;
        start_i         : in std_logic;
        x_neq_y,x_lt_y  : in std_logic;
        x_sel,y_sel     : out std_logic;
        x_ld,y_ld       : out std_logic;
        gcd_ld          : out std_logic
    );
end gcd_controller;

architecture rtl of gcd_controller is
    Type state_type is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12);
    Signal state : state_type; 
    
begin
process(clk,rst)
begin
    if (rst = '1') then
        state <= S0;
    elsif rising_edge(clk) then
        case state is 
            when S0 => 
                state <= S1;
            when S1 => 
                if (start_i = '1') then state <= S2; else state <= S1; end if;
            when S2 => 
                state <= S3;
            when S3 => 
                state <= S4;
            when S4 => 
                if (x_neq_y = '1') then state <= S5; else state <= S9; end if;
            when S5 => 
                if (x_lt_y = '1') then state <= S6; else state <= S7; end if;
            when S6 =>
                state <= S8;
            when S7 => 
                state <= S8;
            when S8 =>
                state <= S4;
            when S9 =>
                state <= S10;
            when S10 =>
                state <= S11;
            when S11 => 
                if (start_i = '0') then state <= S12; else state <= S11; end if;
            when S12 =>
                state <= S0;
            when others =>
                state <= S0;
        end case;
    end if; 
end process; 
    -- combinational logic
    x_sel <= '1' when state = S2 else '0';
    y_sel <= '1' when state = S3 else '0';
    x_ld <= '1' when (state = S2 or state = S7) else '0';
    y_ld <= '1' when (state = S3 or state = S6) else '0';
    gcd_ld <= '1' when state = S9 else '0';
    done_o <= '1' when (state = S10 or state = S11) else '0';
end architecture rtl;
