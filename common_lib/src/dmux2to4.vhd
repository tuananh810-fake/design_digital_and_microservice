library ieee;
use ieee.std_logic_1164.all;

entity dmux2to4 is
port(
    en : in std_logic;
    w : in std_logic_vector(1 downto 0);
    y : out std_logic_vector(3 downto 0)
);
end dmux2to4;

architecture dmux2to4_bev of dmux2to4 is
signal t : std_logic_vector(2 downto 0);
begin 
t <= en & w;
with t select
y <= "1000" when "100",
     "0100" when "101",
     "0010" when "110",
     "0001" when "111",
     "0000" when others;   
end dmux2to4_bev;