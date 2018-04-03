library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    port(
        -- bus interface
        clk     : in std_logic;
        reset_n : in std_logic;
        cs      : in std_logic;
        read    : in std_logic;
        write   : in std_logic;
        address : in std_logic_vector(1 downto 0);
        wrdata  : in std_logic_vector(31 downto 0);

        irq    : out std_logic;
        rddata : out std_logic_vector(31 downto 0)
    );
end timer;

architecture synth of timer is

    signal status  : std_logic_vector(31 downto 0);  --register file
    signal control : std_logic_vector(31 downto 0);
    signal period  : std_logic_vector(31 downto 0);
    signal counter : std_logic_vector(31 downto 0);

    signal s_TO        : std_logic;
    signal s_ITO       : std_logic;
    signal s_cont      : std_logic;
    signal s_start     : std_logic;
    signal s_stop      : std_logic;
    signal s_run       : std_logic;
    signal enable_read : std_logic;
    signal s_address   : std_logic_vector (1 downto 0);

    constant c_zero     : std_logic_vector (31 downto 0) := (others => '0');
    signal s_newCounter : std_logic_vector (31 downto 0);


begin

    s_TO         <= status(0);
    s_ITO        <= control(0);
    s_cont       <= control(1);
    s_start      <= control(2);
    s_stop       <= control(3);
    s_run        <= status(1);
    s_newCounter <= std_logic_vector(unsigned(counter) - unsigned(c_zero(31 downto 1) & '1'));


    irq <= s_TO and s_ITO;


    clock : process(clk, reset_n, s_start, s_stop, counter, s_run)
    begin
        if reset_n = '0' then
            status  <= (others => '0');
            control <= (others => '0');
            period  <= (others => '0');
            counter <= (others => '0');


        elsif (rising_edge(clk)) then
            --decrementing counter
            if s_run = '1' then
                counter <= s_newCounter;
            end if;

            if counter = c_zero then
                counter <= period;
            end if;


            --enable
            enable_read <= cs and read;
            s_address   <= address;

            --write

            if(cs = '1' and write = '1') then
                    case (address) is
                        when "00" =>
                            if wrdata(0) = '0' then
                                status(0) <= '0';
                            end if;
                        when "01" =>
                            control(3 downto 0) <= wrdata(3 downto 0);
                        when "10" =>
                            period    <= wrdata;
                            status(1) <= '0';  --run = 0
                            counter   <= wrdata;
                        when others =>
                    end case;
            end if;



        end if;

        --start/stop control

        if s_start = '1' then
            status(1)  <= '1';
            control(2) <= '0';
        end if;

        if s_stop = '1' then
            status(1)  <= '0';
            control(3) <= '0';
        end if;

        --timeout
        if counter = c_zero and s_run = '1' then
            status(0) <= '1';

            if s_cont = '0' then
                status(1) <= '0';       -- setting run to 0
            end if;
        end if;


        
    end process;  -- clock


    read_proc : process(enable_read, s_address, clk)
        begin
            rddata <= (others => 'Z');
            if(enable_read = '1') then
                case(s_address) is
            
                    when "00" =>
                        rddata <= c_zero(31 downto 2) & status(1 downto 0);
                    when "01" =>
                        rddata <= c_zero(31 downto 2) & control(1 downto 0);
                    when "10" =>
                        rddata <= period;
                    when "11" =>
                        rddata <= counter;
                    when others =>
                        rddata <= (others => 'Z');
                
                end case;
            end if;
    
    end process;  -- read_proc






end synth;
