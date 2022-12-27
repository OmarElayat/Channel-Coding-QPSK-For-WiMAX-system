library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity modulation is
  port (
    data_in   :in  std_logic; 
    ready_in  :in  std_logic;
    clk       :in  std_logic;
    clk_2     :in  std_logic;                     
    rst       :in  std_logic;
    valid_out :out std_logic;
    Q         :out std_logic_vector(15 downto 0);
    I         :out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of modulation is
    signal b_r :std_logic_vector(1 downto 0);
    signal c : std_logic;
	signal Q_t, I_t : std_logic_vector(15 downto 0);
    signal valid_t : std_logic;
begin
    out_ff: process(clk_2,rst,valid_t,Q_t,I_t)
    begin
        if(rst = '1')then
            valid_out <= '0';
            Q <= (others =>'0');
            I <= (others =>'0');
        elsif(rising_edge(clk_2))then
            if(valid_t = '1')then
                valid_out <= valid_t;
                Q <= Q_t;
                I <= I_t;
            else
                valid_out <= '0';
                Q <= (others =>'0');
                I <= (others =>'0');
            end if;
        end if;
    end process;
    shifter: process(clk,rst,data_in,ready_in)
    begin
        if(rst = '1')then
            b_r <= (others =>'0');
            c <= '0';
            valid_t <= '0';
        elsif(rising_edge(clk))then
            if(ready_in = '1')then
                c <= c xor '1';
                b_r(0) <= data_in;
                b_r(1) <= b_r(0);
            end if;
            valid_t <= c and ready_in;
        end if;
    end process;
    I_t <= x"5a7f" when (b_r(0) = '0') else x"a581";
    Q_t <= x"5a7f" when (b_r(1) = '0') else x"a581";
end architecture;