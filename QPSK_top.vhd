library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity QPSK_top is
    port(
        data_in   : in std_logic;
        ready_in  : in std_logic;
        clk       : in std_logic;
        rst       : in std_logic;
        valid_out : out std_logic;
        Q         :out std_logic_vector(15 downto 0);
        I         :out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of QPSK_top is
     signal clk_50_t  : std_logic;
     signal clk_100_t : std_logic;
     signal locked_t    : std_logic;
     signal valid_out_t : std_logic;
     signal data_out_t  : std_logic;
     signal fec_data_out : std_logic_vector (0 downto 0);
     signal fec_data_out_valid : std_logic;
     signal inter_data_out : std_logic;
     signal inter_valid_out : std_logic;
    
     component Clock_100MHz is
        port (
            refclk   : in  std_logic := '0'; --  refclk.clk
            rst      : in  std_logic := '0'; --   reset.reset
            outclk_0 : out std_logic;        -- outclk0.clk
            outclk_1 : out std_logic;        -- outclk1.clk
            locked   : out std_logic         --  locked.export
        );
    end component Clock_100MHz;

     component prbs is
        port(
            clk, rst, ready_in, data_in: in std_logic;
            data_out,valid_out: out std_logic
        );
        end component prbs;

    
    component fec is
        port(
           clk_50mhz, clk_100mhz, reset: in std_logic;
           data_in: in std_logic;
           data_in_valid: in std_logic;
           data_out:  out STD_LOGIC_VECTOR (0 DOWNTO 0);
           data_out_valid: out STD_LOGIC
        );
    end component fec;

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

      
begin

    pll: Clock_100MHz
    port map( refclk => clk, rst => rst, outclk_0 => clk_50_t, outclk_1 => clk_100_t, locked => locked_t);

    prbs_block: prbs
    port map( clk => clk_50_t, rst => rst, ready_in => ready_in, data_in =>data_in,
    data_out => data_out_t, valid_out => valid_out_t);

    fec_block: fec
    port map( clk_50mhz => clk_50_t, clk_100mhz => clk_100_t, reset => rst, data_in => data_out_t, 
    data_in_valid => valid_out_t, data_out => fec_data_out, data_out_valid => fec_data_out_valid);

    inter_block: inter_top
    port map( data_in => fec_data_out(0) ,ready_in => fec_data_out_valid, clk => clk_100_t, rst => rst,
    data_out => inter_data_out, valid_out => inter_valid_out);

    modulation_block: modulation
      port map( data_in => inter_data_out, ready_in => inter_valid_out, clk => clk_100_t, clk_2 => clk_50_t, rst => rst, valid_out => valid_out, Q => Q, I => I);

end architecture;