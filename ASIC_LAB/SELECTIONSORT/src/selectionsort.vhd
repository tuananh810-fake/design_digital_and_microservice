library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mylib.all;

entity selectionsort is
    generic (
        N          : integer := 256;
        DATA_WIDTH : integer := 16;
        ADDR_WIDTH : integer := 8
    );
    port(
        clk, rst    : in  STD_LOGIC;
        start_i     : in  STD_LOGIC;
        ram_rdata   : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
        done_o      : out STD_LOGIC;
        ram_we      : out STD_LOGIC;
        ram_addr    : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
        ram_wdata   : out STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
    );
end selectionsort;

architecture Behavioral of selectionsort is

    component datapath is
        generic (
            N          : integer := 256;
            DATA_WIDTH : integer := 16;
            ADDR_WIDTH : integer := 8
        );
        port(
            clk, rst                            : in  STD_LOGIC;
            ram_rdata                           : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            sel_wdata, sel_min, sel_i, sel_j    : in  STD_LOGIC;
            sel_addr                            : in  STD_LOGIC_VECTOR(1 DOWNTO 0);
            en_i, en_j, en_min, en_mv, en_t     : in  STD_LOGIC;
            ram_addr                            : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            ram_wdata                           : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            lt, i_eq, j_eq                      : out STD_LOGIC
        );
    end component;

    component controller is
        generic (
            N          : integer := 256;
            DATA_WIDTH : integer := 16;
            ADDR_WIDTH : integer := 8
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
    end component;

    -- Tín hiệu nội bộ kết nối giữa Datapath và Controller
    signal sel_wdata, sel_min, sel_i, sel_j : STD_LOGIC;
    signal sel_addr                         : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal en_i, en_j, en_min, en_mv, en_t  : STD_LOGIC;
    signal lt, i_eq, j_eq                   : STD_LOGIC;

begin

    U1 : datapath
        generic map (
            N          => N,
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk       => clk,
            rst       => rst,
            ram_rdata => ram_rdata,
            sel_wdata => sel_wdata,
            sel_min   => sel_min,
            sel_i     => sel_i,
            sel_j     => sel_j,
            sel_addr  => sel_addr,
            en_i      => en_i,
            en_j      => en_j,
            en_min    => en_min,
            en_mv     => en_mv,
            en_t      => en_t,
            ram_addr  => ram_addr,
            ram_wdata => ram_wdata,
            lt        => lt,
            i_eq      => i_eq,
            j_eq      => j_eq
        );

    U2 : controller
        generic map (
            N          => N,
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk       => clk,
            rst       => rst,
            start_i   => start_i,
            lt        => lt,
            i_eq      => i_eq,
            j_eq      => j_eq,
            sel_wdata => sel_wdata,
            sel_min   => sel_min,
            sel_i     => sel_i,
            sel_j     => sel_j,
            sel_addr  => sel_addr,
            en_i      => en_i,
            en_j      => en_j,
            en_min    => en_min,
            en_mv     => en_mv,
            en_t      => en_t,
            ram_we    => ram_we,
            done_o    => done_o
        );

end Behavioral;