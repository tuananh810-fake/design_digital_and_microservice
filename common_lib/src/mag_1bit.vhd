library ieee;
use ieee.std_logic_1164.all;

entity mag_1bit is
    port(
        a,b : in std_logic;
        gt,eq,lt : out std_logic
    );
end mag_1bit;

architecture mag_1bit_bev of mag_1bit is

begin 
gt <= '1' when a>b else
    '0';
lt <= '1' when a<b else 
   '0';
eq <= '1' when a=b else 
   '0';
end mag_1bit_bev;