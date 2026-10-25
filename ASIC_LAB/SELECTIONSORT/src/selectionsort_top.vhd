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
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        start_i   : in  STD_LOGIC;
        done_o    : out STD_LOGIC;
        ext_addr  : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0); 
        rdata_out : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) 
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

    signal sort_done      : STD_LOGIC;
    signal sort_we        : STD_LOGIC;
    signal sort_addr      : STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
    signal sort_wdata     : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

    signal ram_we         : STD_LOGIC;
    signal ram_addr       : STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
    signal ram_wdata      : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    signal ram_rdata      : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

    signal sort_completed : STD_LOGIC := '0';
begin

    -- Ghi nhận trạng thái hoàn thành sắp xếp để giữ quyền đọc cho ext_addr kể cả khi start_i về '0'
    process(clk, rst)
    begin
        if rst = '1' then
            sort_completed <= '0';
        elsif rising_edge(clk) then
            if sort_done = '1' then
                sort_completed <= '1';
            elsif start_i = '1' and sort_done = '0' then
                sort_completed <= '0';
            end if;
        end if;
    end process;

    -- Multiplex RAM: khi đã sort xong thì đọc từ ext_addr bên ngoài, khi đang sort thì kết nối với selectionsort
    ram_addr  <= ext_addr   when (sort_done = '1' or sort_completed = '1') else sort_addr;
    ram_we    <= '0'        when (sort_done = '1' or sort_completed = '1') else sort_we;
    ram_wdata <= sort_wdata;

    rdata_out <= ram_rdata;
    done_o    <= sort_done;

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
            done_o    => sort_done,
            ram_we    => sort_we,
            ram_addr  => sort_addr,
            ram_wdata => sort_wdata
        );

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
