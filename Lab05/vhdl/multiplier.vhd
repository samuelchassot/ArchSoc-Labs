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

    -- 8-bit multiplier component declaration
    component multiplier
        port(
            A, B : in  unsigned(7 downto 0);
            P    : out unsigned(15 downto 0)
        );
    end component;

    signal a1b1, a1b2, a2b1, a2b2 : unsigned(15 downto 0);
    signal na1b1, na1b2, na2b1, na2b2  : unsigned(31 downto 0);
    signal a1, a2, b1, b2 : unsigned(7 downto 0);

begin

	a1 <= A(15 downto 8);
	a2 <= A(7 downto 0);
	b1 <= B(15 downto 8);
	b2 <= B(7 downto 0);
	
	m1 : multiplier port map(
		A => a1,
		B => b1,
		P => a1b1
	);

	m2 : multiplier port map(
		A => a1,
		B => b2,
		P => a1b2
	);

	m3 : multiplier port map(
		A => a2,
		B => b1,
		P => a2b1
	);

	m4 : multiplier port map(
		A => a2,
		B => b2,
		P => a2b2
	);

	na1b1 <= X"0000" & a1b1;
	na1b2 <= X"0000" & a1b2;
	na2b1 <= X"0000" & a2b1;
	na2b2 <= X"0000" & a2b2;


	P <= shift_left(na1b1, 16) + shift_left(na1b2, 8) + shift_left(na2b1, 8) + na2b2;



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

    signal a1b1, a1b2, a2b1, a2b2 : unsigned(15 downto 0);
    signal na1b1, na1b2, na2b1, na2b2  : unsigned(31 downto 0);
    signal a1, a2, b1, b2 : unsigned(7 downto 0);

begin

	a1 <= A(15 downto 8);
	a2 <= A(7 downto 0);
	b1 <= B(15 downto 8);
	b2 <= B(7 downto 0);
	
	m1 : multiplier port map(
		A => a1,
		B => b1,
		P => a1b1
	);

	m2 : multiplier port map(
		A => a1,
		B => b2,
		P => a1b2
	);

	m3 : multiplier port map(
		A => a2,
		B => b1,
		P => a2b1
	);

	m4 : multiplier port map(
		A => a2,
		B => b2,
		P => a2b2
	);

	register_process : process( clk,reset_n )
	begin
		if (reset_n = '0') then
			na1b1 <= X"00000000";
			na1b2 <= X"00000000";
			na2b1 <= X"00000000";
			na2b2 <= X"00000000";

		else
			if (rising_edge(clk)) then
			na1b1 <= X"0000" & a1b1;
			na1b2 <= X"0000" & a1b2;
			na2b1 <= X"0000" & a2b1;
			na2b2 <= X"0000" & a2b2;
			end if ;
		end if;
	end process ; -- register_process

	P <= shift_left(na1b1, 16) + shift_left(na1b2, 8) + shift_left(na2b1, 8) + na2b2;



end pipeline;
