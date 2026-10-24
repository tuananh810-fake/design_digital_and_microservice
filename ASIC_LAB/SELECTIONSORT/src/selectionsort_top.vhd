library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mylib.all;
entity selectionsort_top is
    generic (
        N          : integer := 256;
        DATA_WIDTH : integer := 16;
        ADDR_WIDTH : integer := 8
    );
    port(
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        start_i : in  STD_LOGIC;
        done_o  : out STD_LOGIC
    );
end selectionsort_top;
architecture Behavioral of selectionsort_top is

    component selectionsort is
        generic (
            N          : integer := 256;
            DATA_WIDTH : integer := 16;
            ADDR_WIDTH : integer := 8
        );
        port(
            clk       : in  STD_LOGIC;
            rst       : in  STD_LOGIC;
            start_i   : in  STD_LOGIC;
            ram_rdata : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
            done_o    : out STD_LOGIC;
            ram_we    : out STD_LOGIC;
            ram_addr  : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
            ram_wdata : out STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
        );
    end component;
    -- 2. Component Bộ nhớ RAM (Tương thích với module ram trong ram.sv)
    component ram is
        generic (
            DATA_WIDTH : integer := 16;
            ADDR_WIDTH : integer := 8
        );
        port(
            clk   : in  STD_LOGIC;
            we    : in  STD_LOGIC;
            addr  : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
            wdata : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
            rdata : out STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
        );
    end component;
    -- Tín hiệu bus kết nối nội bộ giữa Selection Sort Core và RAM
    signal ram_we    : STD_LOGIC;
    signal ram_addr  : STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
    signal ram_wdata : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    signal ram_rdata : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
begin
    -- Instance lõi Selection Sort
    U_SELECTIONSORT : selectionsort
        generic map (
            N          => N,
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk       => clk,
            rst       => rst,
            start_i   => start_i,
            ram_rdata => ram_rdata,
            done_o    => done_o,
            ram_we    => ram_we,
            ram_addr  => ram_addr,
            ram_wdata => ram_wdata
        );
    -- Instance khối RAM
    U_RAM : ram
        generic map (
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk   => clk,
            we    => ram_we,
            addr  => ram_addr,
            wdata => ram_wdata,
            rdata => ram_rdata
        );
end Behavioral;
