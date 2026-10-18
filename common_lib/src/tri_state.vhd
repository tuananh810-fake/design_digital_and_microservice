library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tri_state is
port(
    c,a : in std_logic;
    y : out std_logic;
);
end tri_state;
architecture bev of tri_state is
begin 
y <= 'a' when (c = '1') else (others => 'z');
end bev;

