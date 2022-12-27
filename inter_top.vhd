library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity inter_top is
    port(
        data_in : in std_logic;
        ready_in : in std_logic;
        clk : in std_logic;
        rst : in std_logic;
        data_out : out std_logic;
        valid_out : out std_logic
    );
end entity;
architecture rtl of inter_top is
    signal  inter_in: std_logic_vector(191 downto 0);
    signal inter_out: std_logic_vector(191 downto 0);
    --signal inter_t: std_logic_vector(191 downto 0);
    signal shift_done_r_r : std_logic;
	 signal sipo_piso_ready: std_logic;
    
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
      component sipo is
        port (
          data_out_r   :out std_logic_vector (191 downto 0);
          data_in   :in  std_logic;
          ready_in :in  std_logic;  
          clk    :in  std_logic;    
          rst  :in  std_logic;      
          shift_done: out std_logic;
			 sipo_ready_out : out std_logic
          );
      end component;
      
begin
    piso_r: piso
        port map(data_out_r => data_out, data_in => inter_out ,ready_in => sipo_piso_ready,shift_done => shift_done_r_r, clk => clk, rst => rst, shift_valid => valid_out);
    sipo_r: sipo
        port map(data_out_r => inter_in, data_in => data_in, ready_in => ready_in, clk => clk, rst => rst, shift_done => shift_done_r_r, sipo_ready_out => sipo_piso_ready);
inter_proc : process(shift_done_r_r,inter_in)
variable mk : integer := 0;
begin
    if(shift_done_r_r = '1')then
    for i in 0 to 191 loop
        mk := 12 * (i mod 16) + to_integer(shift_right(to_unsigned(i,32),4));
        inter_out(mk) <= inter_in(i);
    end loop;
	 else inter_out <= inter_in;
    end if;
end process;


end architecture;