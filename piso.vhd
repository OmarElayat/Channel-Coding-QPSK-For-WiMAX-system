-- --old piso

-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.std_logic_unsigned.all;

-- entity piso is
--   port (
--     data_out_r   :out std_logic;
--     data_in      :in  std_logic_vector (191 downto 0);
-- 	 ready_in : in std_logic;
--     shift_done         :in  std_logic;         
--     clk          :in  std_logic;                     
--     rst        :in  std_logic;
--     shift_valid : out std_logic
--   );
-- end entity;

-- architecture rtl of piso is
--     signal temp :std_logic_vector (191 downto 0);
--     signal count: integer;
-- begin
--     process (clk, rst,data_in,shift_done,ready_in,temp) begin
--         if (rst = '1') then
--             temp <= (others=>'0');
--         elsif (shift_done = '1') then
--             temp <= data_in;
--         elsif (rising_edge(clk)) then
--             if(ready_in = '1')then
-- 					data_out_r <= temp(191);
-- 					temp <= temp(190 downto 0) & '0';
-- 				end if;
--         end if;
--     end process;
--     shift_valid <= ready_in;
-- end architecture;

--old piso

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity piso is
  port (
    data_out_r   :out std_logic;
    data_in      :in  std_logic_vector (191 downto 0);
	 ready_in : in std_logic;
    shift_done         :in  std_logic;         
    clk          :in  std_logic;                     
    rst        :in  std_logic;
    shift_valid : out std_logic
  );
end entity;

architecture rtl of piso is
    signal temp :std_logic_vector (191 downto 0);
    signal count: integer;
    signal ready_in_r: std_logic;
    signal ready_in_r_r: std_logic;
begin
    ff: process(clk,rst,ready_in)
    begin
        if(rst = '1')then
            ready_in_r <= '0';
        elsif(rising_edge(clk))then
            ready_in_r <= ready_in;
            ready_in_r_r <= ready_in_r;
        end if;
    end process;
    process (clk, rst,data_in,shift_done,ready_in_r,temp) begin
        if (rst = '1') then
            temp <= (others=>'0');
        elsif (rising_edge(clk)) then
            if (shift_done = '1') then
                temp <= data_in;
            elsif(ready_in_r = '1')then
					data_out_r <= temp(191);
					temp <= temp(190 downto 0) & '0';
				end if;
        end if;
    end process;
    shift_valid <= ready_in_r_r;
end architecture;