library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package mylib is

component mux2to1 is   
    generic (
        datawidth : integer := 8
    ); 
    port(
        sel     : in std_logic;
        x_i,y_i : in std_logic_vector (datawidth-1 downto 0);
        f       : out std_logic_vector (datawidth-1 downto 0)
    );
end component;

component regn is   
    generic (
        datawidth : integer := 16
    ); 
    port(
        rst,clk : in std_logic;
        en : in std_logic;
        d : in std_logic_vector (datawidth-1 downto 0);
        o   : out std_logic_vector (datawidth-1 downto 0)
    );
end component;

component fulladder is 
port (
    a,b : in std_logic;
    cin : in std_logic;
    cout : out std_logic;
    sum : out std_logic
);
end component;

component tri_state is
port(
    c,a : in std_logic;
    y : out std_logic
);
end component;

component mux4to1 is
port(
    sel : in std_logic_vector(2 downto 0);
    w : in std_logic_vector(3 downto 0);
    f : out std_logic
);
end component;

component dmux2to4 is
port(
    en : in std_logic;
    w : in std_logic_vector(1 downto 0);
    y : out std_logic_vector(3 downto 0)
);
end component;

component mag_1bit is
    port(
        a,b : in std_logic;
        gt,eq,lt : out std_logic
    );
end component;

end package mylib;