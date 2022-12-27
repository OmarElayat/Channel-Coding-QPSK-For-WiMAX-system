library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity modulation_tb is end entity modulation_tb;

architecture tb of modulation_tb is
    component modulation is
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
    end component modulation;
signal clk_t, clk2_t, rst_t, ready_in_t, data_in_t: std_logic := '0';
signal Q_t: std_logic_vector(15 downto 0);
signal I_t: std_logic_vector(15 downto 0);
signal test: std_logic_vector(15 downto 0);
signal q_rom: std_logic_vector(0 to 1535) := X"5A7F_5A7F_A581_A581_5A7F_5A7F_5A7F_5A7F_5A7F_A581_A581_5A7F_A581_A581_A581_A581_5A7F_5A7F_5A7F_A581_A581_A581_5A7F_A581_A581_A581_5A7F_5A7F_A581_5A7F_5A7F_5A7F_A581_A581_5A7F_A581_5A7F_5A7F_A581_5A7F_5A7F_5A7F_5A7F_A581_5A7F_5A7F_A581_A581_5A7F_5A7F_A581_5A7F_5A7F_5A7F_5A7F_5A7F_A581_A581_A581_5A7F_A581_A581_5A7F_A581_5A7F_5A7F_A581_5A7F_A581_A581_5A7F_A581_5A7F_5A7F_A581_A581_A581_5A7F_5A7F_5A7F_A581_5A7F_5A7F_5A7F_A581_5A7F_5A7F_A581_A581_A581_A581_5A7F_5A7F_5A7F_A581_A581";
signal data_in_rom: std_logic_vector(0 to 191) := X"4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E";
signal data_out_rom: std_logic_vector(0 to 1535) := X"A581_5A7F_5A7F_A581_5A7F_5A7F_A581_5A7F_A581_A581_A581_A581_A581_A581_5A7F_5A7F_A581_5A7F_5A7F_5A7F_A581_A581_5A7F_5A7F_5A7F_5A7F_A581_A581_A581_A581_A581_A581_A581_A581_A581_5A7F_5A7F_A581_A581_5A7F_5A7F_5A7F_5A7F_5A7F_5A7F_A581_5A7F_5A7F_A581_A581_5A7F_5A7F_A581_A581_5A7F_A581_A581_5A7F_5A7F_A581_5A7F_5A7F_5A7F_A581_5A7F_5A7F_5A7F_A581_5A7F_5A7F_5A7F_5A7F_A581_5A7F_A581_A581_A581_A581_A581_A581_5A7F_5A7F_5A7F_5A7F_5A7F_5A7F_A581_5A7F_5A7F_A581_A581_A581_5A7F_A581_A581_5A7F";

signal valid_out_tt: std_logic;
constant PERIOD : time := 10 ns; 
begin
    clk_t <= not clk_t after PERIOD/2;
    clk2_t <= not clk2_t after PERIOD;
    dut: modulation
    port map(data_in => data_in_t, ready_in =>ready_in_t, clk =>clk_t, clk_2 =>clk2_t, rst =>rst_t, valid_out => valid_out_tt, Q => Q_T, I => I_t);
    process
    variable test_pass: boolean;
    begin
        rst_t <= '1'; wait for (2* PERIOD);
        rst_t <= '0';
        wait for PERIOD;

        for i in 0 to 181 loop
            ready_in_t <= '1';
            data_in_t <= data_in_rom(i);
            wait for PERIOD;
        end loop;
        ready_in_t <= '0';
        data_in_t <= '1';
        wait for PERIOD;
        ready_in_t <= '0';
        data_in_t <= '0';
        wait for 2*PERIOD;
        for j in 182 to 191 loop
            ready_in_t <= '1';
            data_in_t <= data_in_rom(j);
            wait for PERIOD;
        end loop;
        ready_in_t <= '0';
        data_in_t <= '1';
        wait;

    end process ;

end architecture tb;