library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity inter_tb is end entity inter_tb;

architecture tb of inter_tb is
    component inter_top is
            port(
                data_in : in std_logic;
                ready_in : in std_logic;
                clk : in std_logic;
                rst : in std_logic;
                data_out : out std_logic;
                valid_out : out std_logic
            );
    end component inter_top;
signal clk_t, rst_t, ready_in_t, data_in_t: std_logic := '0';
signal data_out_t: std_logic;
signal valid_out_t: std_logic;
signal data_in_rom: std_logic_vector(0 to 191) := X"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
signal data_out_rom: std_logic_vector(0 to 191) := X"4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E";
constant PERIOD : time := 10 ns; 
begin
    clk_t <= not clk_t after PERIOD/2;
    dut: inter_top
    port map(
        data_in => data_in_t, ready_in =>ready_in_t, clk =>clk_t, rst =>rst_t, data_out => data_out_t, valid_out => valid_out_t);
    process
          variable test_pass: boolean;
    begin
        rst_t <= '1'; wait for (2* PERIOD);

        rst_t <= '0';
        wait for PERIOD;
        
        for i in 0 to 191 loop
            ready_in_t <= '1';
            data_in_t <= data_in_rom(i);
            wait until falling_edge(clk_t);
        end loop;
        ready_in_t <= '0';
        wait until valid_out_t = '1';
        for i in 0 to 191 loop
        wait until falling_edge(clk_t);
        if ((data_out_t = data_out_rom(i)) and (valid_out_t = '1'))then
            test_pass := true;
            else
                 test_pass := false;
        end if;
            assert test_pass
                report "test failed."
                severity note;
        end loop;


        for i in 0 to 191 loop
            ready_in_t <= '1';
            data_in_t <= data_in_rom(i);
            wait until falling_edge(clk_t);
        end loop;
        ready_in_t <= '0';
        wait until valid_out_t = '1';
        for i in 0 to 191 loop
        wait until falling_edge(clk_t);
        if ((data_out_t = data_out_rom(i)) and (valid_out_t = '1'))then
            test_pass := true;
            else
                 test_pass := false;
        end if;
            assert test_pass
                report "test failed."
                severity note;
        end loop;

        wait;
    end process ;

end architecture tb;