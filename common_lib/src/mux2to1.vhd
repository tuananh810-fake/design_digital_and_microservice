library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is   
    generic (
        datawidth : integer := 8
    ); 
    port(
        sel     : in std_logic;
        x_i,y_i : in std_logic_vector (datawidth-1 downto 0);
        f       : out std_logic_vector (datawidth-1 downto 0)
    );
end mux2to1;

architecture rtl of mux2to1 is
begin
    f <= x_i when sel = '1' else y_i;
end architecture rtl;
