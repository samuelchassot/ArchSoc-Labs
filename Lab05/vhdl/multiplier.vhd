-- =============================================================================
-- ================================= multiplier ================================
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
    port(
        A, B : in  unsigned(7 downto 0);
        P    : out unsigned(15 downto 0)
    );
end multiplier;

architecture combinatorial of multiplier is
    signal pp0, pp1, pp2, pp3, pp4, pp5 ,pp6, pp7, pp8, pp9, pp10, pp11, pp12, pp13 : unsigned(15 downto 0);
    signal sB : unsigned(15 downto 0);
    constant zero : unsigned(15 downto 0) := (others => '0');
begin
    sB <= "00000000" & B;
    -- first level
    pp0 <= sB when A(0) = '1' else zero;
    pp1 <= shift_left(sB, 1) when A(1) = '1' else zero; 

    pp2 <= sB when A(2) = '1' else zero;  
    pp3 <= shift_left(sB, 1) when A(3) = '1' else zero; 

    pp4 <= sB when A(4) = '1' else zero; 
    pp5 <= shift_left(sB, 1) when A(5) = '1' else zero; 

    pp6 <= sB when A(6) = '1' else zero; 
    pp7 <= shift_left(sB, 1) when A(7) = '1' else zero; 

    --second level
    pp8 <= pp0 + pp1;
    pp9 <= shift_left(pp2 + pp3, 2);
    pp10 <= pp4 + pp5;
    pp11 <= shift_left(pp6 + pp7, 2);

    --third level
    pp12 <= pp8 + pp9;
    pp13 <= shift_left(pp10 + pp11, 4);
    
    P <= pp12 + pp13;
    
end combinatorial;

-- =============================================================================
-- =============================== multiplier16 ================================
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier16 is
    port(
        A, B : in  unsigned(15 downto 0);
        P    : out unsigned(31 downto 0)
    );
end multiplier16;

architecture combinatorial of multiplier16 is

    signal pp0, pp1, pp2, pp3, pp4, pp5 ,pp6, pp7, pp8, pp9, pp10, pp11, pp12, pp13, pp14, pp15 : unsigned(31 downto 0);
    signal pp16, pp17, pp18, pp19, pp20, pp21 ,pp22, pp23, pp24, pp25, pp26, pp27, pp28, pp29 : unsigned(31 downto 0);
    signal sB : unsigned(31 downto 0);
    constant zero : unsigned(31 downto 0) := (others => '0');
begin
    sB <= "0000000000000000" & B;
    --  first level
    pp0 <= sB when A(0) = '1' else zero;
    pp1 <= shift_left(sB, 1) when A(1) = '1' else zero; 

    pp2 <= sB when A(2) = '1' else zero;  
    pp3 <= shift_left(sB, 1) when A(3) = '1' else zero; 

    pp4 <= sB when A(4) = '1' else zero; 
    pp5 <= shift_left(sB, 1) when A(5) = '1' else zero; 

    pp6 <= sB when A(6) = '1' else zero; 
    pp7 <= shift_left(sB, 1) when A(7) = '1' else zero; 

    pp8 <= sB when A(8) = '1' else zero;
    pp9 <= shift_left(sB, 1) when A(9) = '1' else zero; 

    pp10 <= sB when A(10) = '1' else zero;  
    pp11 <= shift_left(sB, 1) when A(11) = '1' else zero; 

    pp12 <= sB when A(12) = '1' else zero; 
    pp13 <= shift_left(sB, 1) when A(13) = '1' else zero; 

    pp14 <= sB when A(14) = '1' else zero; 
    pp15 <= shift_left(sB, 1) when A(15) = '1' else zero; 

    --second level
    pp16 <= pp0 + pp1;
    pp17 <= shift_left(pp2 + pp3, 2);

    pp18 <= pp4 + pp5;
    pp19 <= shift_left(pp6 + pp7, 2);

    pp20 <= pp8 + pp9;
    pp21 <= shift_left(pp10 + pp11, 2);

    pp22 <= pp12 + pp13;
    pp23 <= shift_left(pp14 + pp15, 2);

    --third level
    pp24 <= pp16 + pp17;
    pp25 <= shift_left(pp18 + pp19, 4);
    pp26 <= pp20 + pp21;
    pp27 <= shift_left(pp22 + pp23, 4);

    --fourth level
    pp28 <= pp24 + pp25;
    pp29 <= shift_left(pp26 + pp27, 8);

    P <= pp28 + pp29;
    
end combinatorial;

-- =============================================================================
-- =========================== multiplier16_pipeline ===========================
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier16_pipeline is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;
        A, B    : in  unsigned(15 downto 0);
        P       : out unsigned(31 downto 0)
    );
end multiplier16_pipeline;

architecture pipeline of multiplier16_pipeline is

    -- 8-bit multiplier component declaration
    component multiplier
        port(
            A, B : in  unsigned(7 downto 0);
            P    : out unsigned(15 downto 0)
        );
    end component;

begin
end pipeline;
