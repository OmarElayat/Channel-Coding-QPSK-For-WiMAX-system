library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sipo is
  port (
    data_out_r   :out std_logic_vector (191 downto 0);
    data_in   :in  std_logic;
    ready_in :in  std_logic;
    clk    :in  std_logic;    
    rst  :in  std_logic;      
    shift_done: out std_logic;
	 sipo_ready_out :out std_logic
    );
end entity;

architecture rtl of sipo is
    signal count_reg : integer:= 0;
	 signal reg: std_logic_vector (191 downto 0);
	 signal ready_r: std_logic_vector (191 downto 0);
begin
    process (clk, rst,ready_in) begin
        if (rst = '1') then
            reg <= (others=>'0');
            count_reg <= 0;
            ready_r <= (others=>'0');
        elsif (rising_edge(clk)) then
            if (ready_in = '1') then
                count_reg <= count_reg + 1;
					 if (count_reg = 192) then
                    count_reg <= 1;
                end if;
                reg(0) <= data_in;
                reg(191 downto 1) <= reg(190 downto 0);
            else
                count_reg <= 0;
            end if;
            ready_r(0) <= ready_in; 
			ready_r(191 downto 1) <= ready_r(190 downto 0);
        end if;
    end process;
	 sipo_ready_out <= ready_r(191);
	 data_out_r <= reg;
    shift_done <= '1' when (count_reg = 192) else '0';
end architecture;