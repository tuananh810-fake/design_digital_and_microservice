library ieee;
use ieee.std_logic_1164.all;

entity fulladder is 
port (
    a,b : in std_logic;
    cin : in std_logic;
    cout : out std_logic;
    sum : out std_logic
);
end fulladder;

architecture fulladder_bev of fulladder is
signal t0,t1,t2 : std_logic;

begin 
    t0 <= a xor b;
    t1 <= a and b;
    t2 <= cin and t0;
    sum <= cin xor t0;
    cout <= t2 or t1;
end fulladder_bev;