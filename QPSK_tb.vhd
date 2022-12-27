library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity QPSK_tb is end entity QPSK_tb;

architecture QPSK_arch of QPSK_tb is
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
signal clk_t, rst, ready_in_t,t : std_logic := '0';
signal valid_out_t,data_in_t: std_logic;
signal Q_t,I_t: std_logic_vector(15 downto 0);
signal data_in_rom: std_logic_vector(0 to 95) := X"ACBCD2114DAE1577C6DBF4C9";
signal data_in_rom_2: std_logic_vector(0 to 95) := X"2114DAE1577C6DBF4C9ACBCD";
signal data_out_rom: std_logic_vector(0 to 95) := X"558AC4A53A1724E163AC2BF9";
constant PERIOD : time := 20 ns; 
begin
    clk_t <= not clk_t after PERIOD/2;
    dut_top: QPSK_top
      port map( data_in => data_in_t, ready_in => ready_in_t, clk => clk_t, rst => rst,
        valid_out => valid_out_t, Q => Q_t, I => I_t);
      
    process
          variable test_pass: boolean;
    begin
        rst <= '1'; wait for 5*PERIOD;
        ready_in_t <= '1';
        wait until falling_edge(clk_t);
        rst <= '0';
		  for i in 0 to 5 loop
			for i in 0 to 95 loop
            data_in_t <= data_in_rom(i);
            wait until rising_edge(clk_t);
				wait for 1 ps;
            wait until falling_edge(clk_t);
			end loop;
        end loop;
--        for i in 0 to 95 loop
--            data_in_t <= data_in_rom(i);
--            wait until rising_edge(clk_t);
--            wait for 1 ps;
--            wait until falling_edge(clk_t);
--        end loop;
        wait for PERIOD;
        ready_in_t <= '0';
        data_in_t <= '0';
        wait for PERIOD;
        ready_in_t <= '0';
        data_in_t <= '1';
        wait for PERIOD;
        ready_in_t <= '0';
        data_in_t <= '0';
        wait;
    end process ;

end architecture QPSK_arch;