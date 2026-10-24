library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mylib.all;


entity selectionsort is
    generic (
        DATA_WIDTH : integer := 16;
        ADDR_WIDTH : integer := 8
    );
    port(
        clk,rst : in STD_LOGIC;
        start_i : in STD_LOGIC;
        ram_rdata : in STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
        done_o : out STD_LOGIC;
        ram_we : out STD_LOGIC;
        ram_addr : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
        ram_wdata : out STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
    );
end selectionsort

architecture Behavioral of selectionsort is
component datapath is
end component;
component controller is
end component;


begin

end Behavioral;