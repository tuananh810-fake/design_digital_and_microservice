library ieee;
use ieee.std_logic_1164.all;

entity mux4to1 is
port(
    sel : in std_logic_vector(2 downto 0);
    w : in std_logic_vector(3 downto 0);
    f : out std_logic
);
end mux4to1;

architecture bev of mux4to1 is
begin
f <= w(0) when sel = "00" else
     w(1) when sel = "00" else
     w(2) when sel = "00" else
     w(3);
end bev;
