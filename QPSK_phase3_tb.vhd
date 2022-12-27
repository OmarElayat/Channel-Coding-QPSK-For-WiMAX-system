library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity QPSK_phase3_tb is end entity QPSK_phase3_tb;

architecture QPSK_arch of QPSK_phase3_tb is
    component QPSK_phase3 port(
        clk, rst, load: in std_logic;
        pass: out std_logic
    );
    end component QPSK_phase3;
signal clk_t, rst_t, load_t, load_tt :std_logic := '0';
signal pass_t: std_logic;
constant PERIOD : time := 10 ns; 
begin
    clk_t <= not clk_t after PERIOD/2;
    dut: QPSK_phase3
      port map (clk => clk_t, rst => rst_t, load => load_tt, pass => pass_t);
    process
          variable test_pass: boolean;
    begin
        rst_t <= '1'; wait for (30* PERIOD);

        rst_t <= '0';
        load_tt<= '1';
        wait until rising_edge(clk_t);
        --load_t <= '1';

        wait for (96* PERIOD);
      --  load_t <= '0';
        wait for (2* 192 * PERIOD);
        if (pass_t = '1')
            then
                 test_pass := true;
            else
                 test_pass := false;
            end if;
            assert test_pass
                report "test failed."
                severity note;
    end process ;

end architecture QPSK_arch;