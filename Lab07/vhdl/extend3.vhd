library ieee;
use ieee.std_logic_1164.all;

entity extend3 is
    port(
        imm16  : in  std_logic_vector(15 downto 0);
        signed : in  std_logic;
        imm32  : out std_logic_vector(31 downto 0)
    );
end extend3;

architecture synth of extend3 is
begin

imm32 <= (31 downto 16 => '0') & imm16 when signed = '0' else  (31 downto 16 => imm16(15)) & imm16;

end synth;
