library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mylib.all;

entity datapath is
    generic (
        N          : integer := 256;
        DATA_WIDTH : integer := 16;
        ADDR_WIDTH : integer := 8
    );
    port(
        clk,rst                             : in STD_LOGIC;
        ram_rdata                           : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        sel_wdata,sel_min,sel_i,sel_j       : in STD_LOGIC;
        sel_addr                            : in STD_LOGIC_VECTOR(1 DOWNTO 0);
        en_i,en_j,en_min,en_mv,en_t         : in STD_LOGIC;
        ram_addr                            : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        ram_wdata                           : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        lt,i_eq,j_eq                        : out STD_LOGIC
    );
end datapath;

architecture Behavioral of datapath is
    signal i_src,j_src,min_src          : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal i_reg,j_reg,min_reg          : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal i_add,j_add                  : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal ram_min_val,ram_temp         : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
begin
    -- add
i_add <= std_logic_vector(unsigned(i_reg) + 1);
j_add <= std_logic_vector(unsigned(j_reg) + 1);
    -- mux 2to1
i_src     <= (others=>'0')     when sel_i     =     '0' else i_add;
j_src     <= i_add             when sel_j     =     '0' else j_add;
min_src   <= i_reg             when sel_min   =     '0' else j_reg;
ram_wdata <= ram_min_val       when sel_wdata =     '0' else ram_temp;
    -- mux3to1
ram_addr <= i_reg   when sel_addr = '00' else
         <= j_reg   when sel_addr = '01' else
         <= min_reg when sel_addr = '10' else
         (others=>'0');
    -- REGN

REG_I : regn port map (
    clk => clk,
    rst => rst,
    en => en_i,
    d_in => i_src,
    d_out => i_reg
);
REG_J : regn port map (
    clk => clk,
    rst => rst,
    en => en_j,
    d_in => j_src,
    d_out => j_reg
);
REG_MIN : regn port map (
    clk => clk,
    rst => rst,
    en => en_min,
    d_in => min_src,
    d_out => min_reg
);
REG_T : regn port map (
    clk => clk,
    rst => rst,
    en => en_t,
    d_in => ram_rdata,
    d_out => ram_temp
);
REG_MV : regn port map (
    clk => clk,
    rst => rst,
    en => en_mv,
    d_in => ram_rdata,
    d_out => ram_min_val
);
    -- eq lt
    i_eq <= '1' when to_integer(unsigned(i_reg)) = N-2 else '0';
    j_eq <= '1' when to_integer(unsigned(j_reg)) = N-1 else '0';
    lt   <= '1' when unsigned(ram_rdata) < unsigned(ram_min_val) else '0';
end Behavioral;