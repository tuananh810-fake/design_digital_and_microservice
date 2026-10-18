library ieee;
use ieee.std_logic_1164.all;

entity regn is   
    generic (
        datawidth : integer := 8
    ); 
    port(
        rst,clk : in std_logic;
        en : in std_logic;
        d : in std_logic_vector (datawidth-1 downto 0);
        o   : out std_logic_vector (datawidth-1 downto 0)
    );
end regn;

architecture rtl of regn is
    
    
begin
process (rst,clk)
begin
    if(rst = '1') then 
        o <= (others => '0');
    elsif rising_edge(clk) then
        if (en = '1') then 
            o <= d;
        end if;
    end if;
end process;
end architecture rtl;
