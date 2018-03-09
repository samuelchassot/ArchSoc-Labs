library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_registers is
    port(
        clk       : in  std_logic;
        reset_n   : in  std_logic;
        write_n   : in  std_logic;
        backup_n  : in  std_logic;
        restore_n : in  std_logic;
        address   : in  std_logic_vector(2 downto 0);
        irq       : in  std_logic_vector(31 downto 0);
        wrdata    : in  std_logic_vector(31 downto 0);

        ipending  : out std_logic;
        rddata    : out std_logic_vector(31 downto 0)
    );
end control_registers;

architecture synth of control_registers is

    signal status  : std_logic_vector(31 downto 0);  --register file
    signal estatus : std_logic_vector(31 downto 0);
    signal bstatus  : std_logic_vector(31 downto 0);
    signal ienable : std_logic_vector(31 downto 0);
    signal ipending_reg : std_logic_vector(31 downto 0);
    signal cpuid : std_logic_vector(31 downto 0);

    constant c_zero     : std_logic_vector (31 downto 0) := (others => '0');
begin

    ipending_reg <= irq and ienable;
    ipending <= '1' when (status(0) = '1' and (not(ipending_reg = c_zero))) else '0';

    main : process( clk, reset_n )
    begin
        if(reset_n = '0') then
            status <= (others => '0');
            estatus <= (others => '0');
            bstatus <= (others => '0');
            ienable <= (others => '0');
            cpuid <= (others => '0');
            
        elsif (rising_edge(clk)) then

            --write process

            if(write_n = '0') then
                case (address) is
                    when "000" =>
                        status(0) <= wrdata(0);
                    when "011" =>
                        ienable <= wrdata;
                    when others =>
                end case;
            end if;



            -- backup_n
            if(backup_n ='0') then
                estatus(0) <= status(0);
                status(0) <= '0';
            end if;

            -- restore_
            if(restore_n ='0') then
                status(0) <= estatus(0);
            end if;

    end if;
       
    end process ; -- main


    read : process( address, status, estatus, bstatus, ienable, cpuid, ipending_reg)
    begin
        case (address) is

            when "000" =>
                rddata <= status;
    
            when "001" =>
                rddata <= estatus;
    
            when "010" =>
                rddata <= bstatus;
    
            when "011" =>
                rddata <= ienable;
    
            when "100" =>
                rddata <= ipending_reg;

            when "101" =>
                rddata <= cpuid;

            when others =>
        end case;
    end process ; -- read

end synth;
