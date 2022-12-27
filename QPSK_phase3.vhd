library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_misc.all;

entity QPSK_phase3 is
    port(
        clk, rst, load: in std_logic;
		  rst_out, load_out: out std_logic;
        pass: out std_logic
    );
    end entity QPSK_phase3;

architecture QPSK_phase3_arch of QPSK_phase3 is
    component QPSK_top is
        port(
        data_in   : in std_logic;
        ready_in  : in std_logic;
        clk       : in std_logic;
        rst       : in std_logic;
        valid_out : out std_logic;
        Q         :out std_logic_vector(15 downto 0);
        I         :out std_logic_vector(15 downto 0)
    );
    end component QPSK_top;

signal data_in_shift: std_logic_vector(0 to 95);
signal data_out_shift: std_logic_vector(0 to 95);
signal data_in_t: std_logic := '0';
signal data_out_t , valid_out_t, ready_in: std_logic;

signal rst_t: std_logic ;

-- signal q_rom: std_logic_vector(0 to 95) := X"306F1DC8D21320ED2D3889E3";
-- signal i_rom: std_logic_vector(0 to 95) := X"92FC8C3FE604CD9110BF0276";
signal q_rom, q_rom_test: std_logic_vector(0 to 95);
signal i_rom, i_rom_test: std_logic_vector(0 to 95);


--signal data_in_rom: std_logic_vector(0 to 95) := X"ACBCD2114DAE1577C6DBF4C9";
signal data_in_rom, pass_t_q, pass_t_i: std_logic_vector(0 to 95);
signal Q_t, I_t: std_logic_vector(15 downto 0);
signal c,cc: integer:= 0;
begin
    
    dut: QPSK_top
      port map( data_in => data_in_t
      ,ready_in  => ready_in
      ,clk       => clk
      ,rst       => rst_t
      ,valid_out => valid_out_t
      ,Q         => Q_t
      ,I         => I_t );

    process(clk,rst_t)
    begin
        if(rst_t = '1') then
            data_in_shift <= X"ACBCD2114DAE1577C6DBF4C9";
            q_rom <= X"306F1DC8D21320ED2D3889E3";
            i_rom <= X"92FC8C3FE604CD9110BF0276";
            q_rom_test <= (others=>'0');
            i_rom_test <= (others=>'0');
            c <= 0;
            cc <= 0;
             ready_in <= '0';
             data_in_t <= '0';
        elsif(rising_edge(clk)) then
				if(load = '1') then
            if(cc < 96) then
                ready_in <= '1';
                data_in_shift <= data_in_shift(1 to 95) & data_in_shift(0);
                data_in_t <= data_in_shift(0);
                cc <= cc + 1;
            else 
                ready_in <= '0';
                data_in_t <= '0';
            end if;
            end if;
            if(valid_out_t = '1')then
            q_rom_test <= q_rom_test(1 to 95) & Q_t(15);
            I_rom_test <= I_rom_test(1 to 95) & I_t(15);
            c <= c + 1;
				end if;
        end if;
    end process;

--    pass_pr :process(c , q_rom_test, i_rom_test , q_rom, i_rom)
--    begin
--        if(c = 96) then
--            pass_t_q <= q_rom_test xnor q_rom;
--            pass_t_i <= i_rom_test xnor i_rom;
--
--        end if;
--		  else
            pass_t_q <= q_rom_test xnor q_rom when (c=96) else (others=>'0');
            pass_t_i <= i_rom_test xnor i_rom when (c=96) else (others=>'0');		  
         --   pass <= and_reduce(pass_t_q and pass_t_i);
    --end process;
pass <= and_reduce(pass_t_q and pass_t_i);
rst_t <= not rst;
load_out <= load;
rst_out <= rst_t;
end architecture QPSK_phase3_arch;