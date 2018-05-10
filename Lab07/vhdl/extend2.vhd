library ieee;
use ieee.std_logic_1164.all;

entity extend2 is
    port(
        imm16  : in  std_logic_vector(15 downto 0);
        imm32  : out std_logic_vector(31 downto 0)
    );
end extend2;

architecture synth of extend2 is
begin

imm32 <= (31 downto 16 => '0') & imm16;

end synth;