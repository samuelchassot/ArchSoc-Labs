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
    signal sl2, sl3, sl4, sl5, sl6, sr3, sr4, sr5, sA, sB : unsigned(15 downto 0);
    signal sl7, sr6 : unsigned(31 downto 0);
    constant five : unsigned(7 downto 0) := "00000101";
    

begin
    -- left branch of the tree
    sl1 <= B when sel = '0' else C;
    
    sl3 <= "00000000" & C;

    m1 : multiplier port map (
        A => A,
        B => sl1,
        P => sl2
    );

    sl4 <= sl3 + sl2;

    sl5 <= sl4 when sel = '0' else sl2;
    sl6 <= sr5 when sel = '0' else sl2;

    m3 : multiplier16 port map(
        A => sl5,
        B => sl6,
        P => sl7
    );

    -- right branch of the tree

    sr1 <= five when sel = '0' else B;
    sr2 <= A when sel = '0' else B;

    sA <= "00000000" & A;
    sB <= "00000000" & B;
    sr3 <= sB when sel = '0' else shift_left(sA, 1);

    m2 : multiplier port map(
        A => sr1,
        B => sr2,
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

    signal sl1, sr1, sr2 : unsigned(7 downto 0);
    signal sl2, sl3, sl4, sl51, sl52, sl61, sl62, sr3, sr4, sr51, sr52, sA, sB : unsigned(15 downto 0);
    signal m1_in2, m2_in1, m2_in2 : unsigned(7 downto 0);
    signal m1_out, m2_out, m3_in1, m3_in2 : unsigned(15 downto 0);
    signal sl7, sr6, m3_out : unsigned(31 downto 0);
    signal start2, sel2 : std_logic; 
    constant five : unsigned(7 downto 0) := "00000101";
    

begin

    m1 : multiplier port map (
            A => A,
            B => m1_in2,
            P => m1_out
        );

    m2 : multiplier port map(
            A => m2_in1,
            B => m2_in2,
            P => m2_out
        );

    m3 : multiplier16 port map(
            A => m3_in1,
            B => m3_in2,
            P => m3_out
        );


    pipeline1 : process(sel, A, B, C, sl1, sl2, sl3, sl4, sl51, sl61, sr1, sr2, sr3, sr4, sr51, m2_out, m1_out)
    begin
    if (sel = '0') then

        sl1 <= B;
        else
            sl1 <= C;
    end if ;
    
        sl3 <= "00000000" & C;
        
    if (sel = '0') then

        sr1 <= five;
        else
            sr1 <= B;
    end if ;

    if (sel = '0') then

        sr2 <= A;
        else
            sr2 <= B;
    end if ;
    
        sA <= "00000000" & A;
        sB <= "00000000" & B;
    if (sel = '0') then

        sr3 <= sB;
        else
            sr3 <= shift_left(sA, 1);
    end if ;    

        m2_in1 <= sr1;
        m2_in2 <= sr2;
        sr4 <= m2_out;


        m1_in2 <= sl1;
        sl2 <= m1_out;

        sl4 <= sl3 + sl2;

        sr51 <= sr4 + sr3;


    if (sel = '0') then

        sl51 <= sl4;
        else
            sl51 <= sl2;
    end if ;

    if (sel = '0') then

        sl61 <= sr51;
        else
            sl61 <= sl2;
    end if ;
        
    end process ; -- thirdLevel

    register_proc : process( clk, reset_n )
    begin
        if(reset_n = '0') then
            sl52 <= "0000000000000000";
            sl62 <= "0000000000000000";
            sr52 <= "0000000000000000";
            start2 <= '0';

        else if( rising_edge(clk)) then
            sl52 <= sl51;
            sl62 <= sl61;
            sr52 <= sr51;
            start2 <= start;
            sel2 <= sel;
            end if;
        end if;
            
        
    end process ; -- register_proc

    pipeline2 : process(sl52, sl62, m3_out, sr52, sl7, sel2, sr6, start2)
    begin

        m3_in1 <= sl52;
        m3_in2 <= sl62;
        sl7 <= m3_out;

        sr6 <= sr52 + sl7;

    if (sel2 = '0') then
        D <= sl7;
        else
            D <= sr6;
    end if ;

        done <= start2;
    end process ; -- outMultiplexer


    
    

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
    signal sl1, sr1, sr2 : unsigned(7 downto 0);
    signal sl21,sl22, sl31,sl32, sl4, sl51, sl52, sl61, sl62, sr31,sr32, sr41,sr42, sr51, sr52, sA, sB : unsigned(15 downto 0);
    signal m1_in2, m2_in1, m2_in2 : unsigned(7 downto 0);
    signal m1_out, m2_out, m3_in1, m3_in2 : unsigned(15 downto 0);
    signal sl7, sr6, m3_out : unsigned(31 downto 0);
    signal start2, start3, sel2, sel3 : std_logic; 
    constant five : unsigned(7 downto 0) := "00000101";
    

begin

    m1 : multiplier port map (
            A => A,
            B => m1_in2,
            P => m1_out
        );

    m2 : multiplier port map(
            A => m2_in1,
            B => m2_in2,
            P => m2_out
        );

    m3 : multiplier16 port map(
            A => m3_in1,
            B => m3_in2,
            P => m3_out
        );


    pipeline1 : process(sel, A, B, C, sl1, sl21, sl31, sr1, sr2, sr31, sr41, m1_out, m2_out)
    begin
    if (sel = '0') then

        sl1 <= B;
        else
            sl1 <= C;
    end if ;
    
        
    if (sel = '0') then

        sr1 <= five;
        else
            sr1 <= B;
    end if ;

    if (sel = '0') then

        sr2 <= A;
        else
            sr2 <= B;
    end if ;

        sl31 <= "00000000" & C;
        sA <= "00000000" & A;
        sB <= "00000000" & B;
    if (sel = '0') then

        sr31 <= sB;
        else
            sr31 <= shift_left(sA, 1);
    end if ;    
        m2_in1 <= sr1;
        m2_in2 <= sr2;
        sr41 <= m2_out;

        m1_in2 <= sl1;
        sl21 <= m1_out;
    end process; -- pipeline1
    
    pipeline2 : process(sel2, sl22, sl32, sl4, sl51, sl61, sr32, sr42, sr51)
    begin

        sl4 <= sl32 + sl22;

        sr51 <= sr42 + sr32;


    if (sel2 = '0') then

        sl51 <= sl4;
        else
            sl51 <= sl22;
    end if ;

    if (sel2 = '0') then

        sl61 <= sr51;
        else
            sl61 <= sl22;
    end if ;
        
    end process ; -- thirdLevel

    register_proc : process( clk, reset_n )
    begin
        if(reset_n = '0') then
            sl52 <= "0000000000000000";
            sl62 <= "0000000000000000";
            sr52 <= "0000000000000000";
            sl22 <= "0000000000000000";
            sl32 <= "0000000000000000";
            sr42 <= "0000000000000000";
            sr32 <= "0000000000000000";
            start2 <= '0';
            start3 <= '0';
            sel2 <= '0';
            sel3 <= '0';

        else if( rising_edge(clk)) then
            sl52 <= sl51;
            sl62 <= sl61;
            sr52 <= sr51;
            sl22 <= sl21;
            sl32 <= sl31;
            sr42 <= sr41;
            sr32 <= sr31;
            
            start3 <= start2;
            sel3 <= sel2;
            start2 <= start;
            sel2 <= sel;

            end if;
        end if;
            
        
    end process ; -- register_proc

    pipeline3 :  process(sel3, start3, sl52, sl62, sl7, m3_out, sr52, sr6)
    begin

        m3_in1 <= sl52;
        m3_in2 <= sl62;
        sl7 <= m3_out;

        sr6 <= sr52 + sl7;

    if (sel3 = '0') then
        D <= sl7;
        else
            D <= sr6;
    end if ;

        done <= start3;
    end process ; -- outMultiplexer
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
