library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity prbs_tb is end entity prbs_tb;

architecture prbs_arch of prbs_tb is
    component prbs is
        port (
            clk, rst, ready_in, data_in: in std_logic;
            data_out,valid_out: out std_logic
        );
    end component prbs;
signal clk_t, rst, ready_in_t, valid_out_t,data_in_t: std_logic := '0';
signal data_out_t: std_logic;
signal data_in_rom: std_logic_vector(0 to 95) := X"ACBCD2114DAE1577C6DBF4C9";
signal data_out_rom: std_logic_vector(0 to 95) := X"558AC4A53A1724E163AC2BF9";
constant PERIOD : time := 10 ns; 
begin
    clk_t <= not clk_t after PERIOD/2;
    dut: prbs
      port map( clk => clk_t , rst  => rst, ready_in => ready_in_t, data_in => data_in_t, data_out => data_out_t, valid_out => valid_out_t);
      process
          variable test_pass: boolean;
    begin
        rst <= '1'; wait for 5*PERIOD;
        ready_in_t <= '1';
        wait until falling_edge(clk_t);
        rst <= '0';
        for i in 0 to 95 loop
            data_in_t <= data_in_rom(i);
            wait until rising_edge(clk_t);
			wait for 1 ps;
        if (data_out_t = data_out_rom(i) and valid_out_t='1')
            then
                 test_pass := true;
            else
                 test_pass := false;
            end if;
            assert test_pass
                report "test failed."
                severity note;
            wait until falling_edge(clk_t);
        end loop;
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

end architecture prbs_arch;