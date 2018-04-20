library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arith_unit is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;
        start   : in  std_logic;
        sel     : in  std_logic;
        A, B, C : in  unsigned(7 downto 0);
        D       : out unsigned(31 downto 0);
        done    : out std_logic
    );
end arith_unit;

-- =============================================================================
-- =============================== COMBINATORIAL ===============================
-- =============================================================================

architecture combinatorial of arith_unit is
    component multiplier
        port(
            A, B : in  unsigned(7 downto 0);
            P    : out unsigned(15 downto 0)
        );
    end component;

    component multiplier16
        port(
            A, B : in  unsigned(15 downto 0);
            P    : out unsigned(31 downto 0)
        );
    end component;

    signal sl1, sr1, sr2 : unsigned(7 downto 0);
    signal sl2, sl3, sl4, sl5, sl6, sr3, sr4, s5, sA : unsigned(15 downto 0);
    signal sl7, sr6 : unsigned(31 downto 0);
    constant five : unsigned(7 downto 0) := "00000101";
    

begin
    -- left branch of the tree
    sl1 <= B when sel = '0' else C;
    
    sl3 <= "00000000" & C;

    m1 : multiplier port map (
        A => A;
        B => sl1;
        P => sl2
    );

    sl4 <= sl3 + sl2;

    sl5 <= sl4 when sel = '0' else sl2;
    sl6 <= sr5 when sel = '0' else sl2;

    m3 : multiplier16 port map(
        A => sl5;
        B => sl6;
        P => sl7
    );

    -- right branch of the tree

    sr1 <= five when sel = '0' else B;
    sr2 <= A when sel = '0' else B;

    sA <= "00000000" & A;
    sr3 <= B when sel = '0' else shift_left(sA, 1);

    m2 : multiplier port map(
        A => sr1;
        B => sr2;
        P => sr4
    );
    
    sr5 <= sr4 + sr3;

    sr6 <= sr5 + sl7;

    -- final multiplexer

    D <= sl7 when sel = '0' else sr6;

    done <= start;



end combinatorial;

-- =============================================================================
-- ============================= 1 STAGE PIPELINE ==============================
-- =============================================================================

architecture one_stage_pipeline of arith_unit is
    component multiplier
        port(
            A, B : in  unsigned(7 downto 0);
            P    : out unsigned(15 downto 0)
        );
    end component;

    component multiplier16
        port(
            A, B : in  unsigned(15 downto 0);
            P    : out unsigned(31 downto 0)
        );
    end component;

begin

end one_stage_pipeline;

-- =============================================================================
-- ============================ 2 STAGE PIPELINE I =============================
-- =============================================================================

architecture two_stage_pipeline_1 of arith_unit is
    component multiplier
        port(
            A, B : in  unsigned(7 downto 0);
            P    : out unsigned(15 downto 0)
        );
    end component;

    component multiplier16
        port(
            A, B : in  unsigned(15 downto 0);
            P    : out unsigned(31 downto 0)
        );
    end component;

begin
end two_stage_pipeline_1;

-- =============================================================================
-- ============================ 2 STAGE PIPELINE II ============================
-- =============================================================================

architecture two_stage_pipeline_2 of arith_unit is
    component multiplier
        port(
            A, B : in  unsigned(7 downto 0);
            P    : out unsigned(15 downto 0)
        );
    end component;

    component multiplier16_pipeline
        port(
            clk     : in  std_logic;
            reset_n : in  std_logic;
            A, B    : in  unsigned(15 downto 0);
            P       : out unsigned(31 downto 0)
        );
    end component;

begin
end two_stage_pipeline_2;
