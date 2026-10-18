library ieee;
use ieee.std_logic_1164.all;
use work.mylib.all;

entity gcd is   
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
end gcd;

architecture rtl of gcd is
    -- component
component gcd_datapath is   
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
end component;

component gcd_controller is   
    port(
        rst,clk         : in std_logic;
        done_o          : out std_logic;
        start_i         : in std_logic;
        x_neq_y,x_lt_y  : in std_logic;
        x_sel,y_sel     : out std_logic;
        x_ld,y_ld       : out std_logic;
        gcd_ld          : out std_logic
    );
end component;

    -- signal
signal x_sel,y_sel      : std_logic;
signal x_ld,y_ld        : std_logic;
signal gcd_ld           : std_logic;
signal x_neq_y,x_lt_y   : std_logic;

begin
DATAPATH: gcd_datapath   
    generic map (
        datawidth => datawidth 
    )
    port map (
        rst     => rst,
        clk     => clk, 
        x_i     => x_i,
        y_i     => y_i,  
        x_sel   => x_sel,
        y_sel   => y_sel, 
        x_ld    => x_ld,
        y_ld    => y_ld, 
        gcd_ld  => gcd_ld, 
        x_neq_y => x_neq_y,
        x_lt_y  => x_lt_y, 
        gcd_o   => gcd_o
    );
CONTROLLER: gcd_controller  
    port map (
        rst     => rst,
        clk     => clk,
        done_o  => done_o,
        start_i => start_i,
        x_neq_y => x_neq_y,
        x_lt_y  => x_lt_y,
        x_sel   => x_sel,
        y_sel   => y_sel,
        x_ld    => x_ld,   
        y_ld    => y_ld,
        gcd_ld  =>gcd_ld        
    );

end architecture rtl;
