library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    port(
        -- bus interface
        clk     : in  std_logic;
        reset_n : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        write   : in  std_logic;
        address : in  std_logic_vector(1 downto 0);
        wrdata  : in  std_logic_vector(31 downto 0);

        irq     : out std_logic;
        rddata  : out std_logic_vector(31 downto 0)
    );
end timer;

architecture synth of timer is

    signal status : std_logic_vector(31 downto 0) := (others => '0');
    signal control : std_logic_vector(31 downto 0) := (others => '0');
    signal period : std_logic_vector(31 downto 0) := (others => '0');
    signal counter : std_logic_vector(31 downto 0) := (others => '0');
    signal s_TO : std_logic;
    signal s_ITO : std_logic;
    signal s_cont : std_logic;
    signal s_start : std_logic;
    signal s_stop : std_logic;
    signal s_run : std_logic;


begin

    s_TO <= status(0);
    s_ITO <= control(0);
    s_cont <= control(1);
    s_start <= control(2);
    s_stop <= control(3);
    s_run <= status(1);
    
    
    irq <= s_TO and s_ITO;

    reset : process( reset_n )
    begin
        if reset_n = '0' then
            status <= (others => '0');
            control <= (others => '0');
            period <= (others => '0');
            counter <= (others => '0');
            end if ;

    end process ; -- reset


    timeout : process( counter )
    begin
        if counter = (others => '0') then
            status(0) <= '1';
            counter <= period;
        end if ;
    end process ; -- timeout


    start : process( s_start )
    begin
        if(rising_edge(s_start)) then
            status(1) <= '1';               -- setting run to 1
            control(2) <= '0';
        end if;
    end process ; -- start
    
    stop : process( s_stop )
    begin
        if(rising_edge(s_stop)) then
            status(1) <= '0';               -- setting run to 0
            control(3) <= '0';
        end if;
    end process ; -- stop

    period_changes : process( period )
    begin
        control(3) <= '1';
    end process ; -- period_changes


   
    

end synth;
