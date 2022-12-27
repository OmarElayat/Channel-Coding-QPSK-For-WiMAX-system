library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity piso_tb is end entity piso_tb;

architecture tb of piso_tb is
    component piso is
        port (
          data_out_r   :out std_logic;
          data_in      :in  std_logic_vector (191 downto 0); 
		  ready_in : in std_logic;
          shift_done         :in  std_logic;         
          clk          :in  std_logic;                     
          rst        :in  std_logic;
          shift_valid : out std_logic                      
        );
      end component piso;
signal clk_t, rst_t, ready_in_t,shift_done_r_r: std_logic := '0';
signal data_out_t: std_logic;
signal valid_out_t: std_logic;
signal data_in_t : std_logic_vector(0 to 191);
signal data_in_rom: std_logic_vector(0 to 191) := X"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
signal data_out_rom: std_logic_vector(0 to 191) := X"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
constant PERIOD : time := 10 ns; 
begin
    clk_t <= not clk_t after PERIOD/2;
    dut: piso
    port map(data_out_r => data_out_t, data_in => data_in_t ,ready_in => ready_in_t,shift_done => shift_done_r_r, clk => clk_t, rst => rst_t, shift_valid => valid_out_t);
process
          variable test_pass: boolean;
    begin
        rst_t <= '1'; 
        data_in_t <= (others=>'0');
        wait for (PERIOD);
        rst_t <= '0';
        shift_done_r_r <= '1';
        data_in_t <= data_in_rom;
        wait for (PERIOD);
        shift_done_r_r <= '0';
            ready_in_t <= '1';
            for i in 0 to 191 loop
                wait until falling_edge(clk_t);
                if (data_out_t = data_out_rom(i))then
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