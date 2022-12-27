--=============================
-- Listing 10.7 edge detector (Moore)
--=============================
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_misc.all;
entity fec is
   port(
      clk_50mhz, clk_100mhz, reset: in std_logic;
      data_in: in std_logic;
      data_in_valid: in std_logic;
      data_out:  out STD_LOGIC_VECTOR (0 DOWNTO 0);
		data_out_valid: out STD_LOGIC
   );
end fec;
   
architecture moore_arch of fec is

   component RAM_2port IS
   PORT
   (
		address_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		clock_a		: IN STD_LOGIC  := '1';
		clock_b		: IN STD_LOGIC ;
		data_a		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
   );
   END component RAM_2port;


   type state_type is ( idle, recieve, out_xy, transmit);
   signal state_reg, state_next: state_type;
   signal x,y: STD_LOGIC_VECTOR (0 DOWNTO 0);
   signal data_in_reg: std_logic;
   signal counter: unsigned (7 downto 0) := "00000000";
	signal counter_out: unsigned (8 downto 0) := "000000000";
   signal int_reg: std_logic_vector (5 downto 0);
   signal data_out_valid_d, data_out_valid_r,data_out_valid_rr : std_logic:= '0';

   signal address_a     : STD_LOGIC_VECTOR (7 DOWNTO 0);
   signal address_b     : STD_LOGIC_VECTOR (8 DOWNTO 0);
   signal data_a     : STD_LOGIC_VECTOR (1 DOWNTO 0);
   signal data_b     : STD_LOGIC_VECTOR (0 DOWNTO 0) := "0";
   signal wren_a     : STD_LOGIC  := '0';
   signal wren_b     : STD_LOGIC  := '0';
   signal q_a     : STD_LOGIC_VECTOR (1 DOWNTO 0);
   signal q_b     : STD_LOGIC_VECTOR (0 DOWNTO 0);
   
begin

         RAM_2portIns: RAM_2port
      PORT map 
      (
         address_a => address_a,
         address_b => address_b,
			clock_a => clk_50mhz,
			clock_b => clk_100mhz,
         data_a => data_a,
         data_b => data_b,
         wren_a => wren_a,
         wren_b => wren_b,
         q_b => q_b
      );


   process(clk_50mhz,reset)
   begin
      if (reset='1') then
         state_reg <= idle;
			counter <= "00000000";
			data_a <= (others => '0');
			int_reg <= "100111";
      elsif (clk_50mhz'event and clk_50mhz='1') then
         state_reg <= state_next;
		 if (state_reg = recieve or state_next = recieve or state_reg = out_xy or state_next = out_xy) then
				int_reg <= data_in_reg & int_reg(5 downto 1);
			--	else 
			--	int_reg <= "100111";
         end if;
			if (state_reg = recieve or state_reg = out_xy) then
            counter <= counter + 1;
            if (counter = 191) then
               counter <= "00000000";
            end if;
			   data_a <=  y&x;
				else 
				counter <= "00000000";
				data_a <= (others => '0');
         end if;
			
      end if;
   end process;

   process(clk_100mhz,reset)
   begin
      if (reset='1') then
         counter_out <= (others => '0');
         data_out_valid_r <= '0';
         data_out_valid_rr <= '0';
         data_out_valid_d <= '0';
         --data_out_valid <= '0';
      elsif (clk_100mhz'event and clk_100mhz='1') then
         data_out_valid_d <= '0';
         --data_out_valid <= '0';
         data_out_valid_r <= data_out_valid_d;
         data_out_valid_rr <= data_out_valid_r;
         if (state_next = out_xy or state_next = transmit or state_reg = transmit) then
               address_b <= std_logic_vector (counter_out);
               counter_out <= counter_out + 1;
               if (counter_out = 383) then
                  counter_out <= "000000000";
               end if;
         end if;
         if (state_reg = out_xy or state_reg = transmit) then
            data_out_valid_d <= '1';
            --data_out_valid <= '1';
         end if;
      end if;
   end process;
   -- next-state logic
   ctrl_fsm: process(state_reg,data_in_valid, counter, counter_out)
   begin
		state_next <= state_reg;
		address_a <= (others => '0');
      wren_a <= '1';
      wren_b <= '0';
      case state_reg is

         when idle =>
            if (data_in_valid = '1') then
               state_next <= recieve;            
            end if;

         when recieve =>
               address_a <= std_logic_vector (counter);
            if (counter >= 96) then
               state_next <= out_xy;
            end if;

         when out_xy =>
            address_a <= std_logic_vector (counter);
            if (data_in_valid = '0') then
                  state_next <= transmit;
            end if;

         when transmit =>
            if (counter_out = 191 or counter_out = 383) then
               state_next <= idle;
            end if;
      end case;
   end process ctrl_fsm;

   -- Moore output logic
   x(0) <= xor_reduce((data_in_reg & int_reg) and "1111001");
   y(0) <= xor_reduce((data_in_reg & int_reg) and "1011011");
   data_out <= q_b ;
	data_b <= (others => '0');
	data_in_reg <= data_in when data_in_valid = '1' else '0';
   data_out_valid <= data_out_valid_d or data_out_valid_r or data_out_valid_rr;
end moore_arch;