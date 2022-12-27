library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity prbs is
    port(
        clk, rst, ready_in, data_in: in std_logic;
        data_out,valid_out: out std_logic
    );
    end entity prbs;

architecture prbs_arch of prbs is
signal q: std_logic_vector(0 to 14);
signal reg_xor: std_logic;
begin
    shift_reg: process (clk,rst)
    begin
        if(rst = '1') then
            q <= "011011100010101";
				valid_out <= '0';
        elsif(rising_edge(clk)) then
                -- if (load = '1') then
                --     q <= seed; 
			   valid_out <= ready_in;		 
				if (ready_in = '1') then
				  q <= reg_xor & q(0 to 13);
				  data_out <= reg_xor xor data_in ;
				end if;		
        end if;
    end process ;
    reg_xor <= q(14) xor q(13);
 

end architecture prbs_arch;