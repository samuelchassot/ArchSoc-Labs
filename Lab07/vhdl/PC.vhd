library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk       : in  std_logic;
        reset_n   : in  std_logic;
        sel_a     : in  std_logic;
        sel_imm   : in  std_logic;
        branch    : in  std_logic;
        a         : in  std_logic_vector(15 downto 0);
        d_imm     : in  std_logic_vector(15 downto 0);
        e_imm     : in  std_logic_vector(15 downto 0);
        pc_addr   : in  std_logic_vector(15 downto 0);
        addr      : out std_logic_vector(15 downto 0);
        next_addr : out std_logic_vector(15 downto 0)
    );
end PC;

architecture synth of PC is

  signal s_addr      : signed(15 downto 0);
  signal s_next_addr : signed(15 downto 0);

  signal s_addr_00, s_addr_01, s_addr_10 : signed(15 downto 0);

begin


  inc_address : process(clk, reset_n)
  begin
    if (reset_n = '0') then
      s_next_addr <= X"0000";
    else
      if rising_edge(clk) then
        s_next_addr <= s_addr;
      end if;
    end if;
  end process;  -- inc_address

  sel : process(s_addr_00,s_addr_10,s_addr_01, pc_addr, branch,e_imm,a, d_imm, sel_imm, sel_a, s_next_addr)
  begin
    s_addr_10 <= shift_left(signed(d_imm),2);

    if (branch = '1') then
        s_addr_00 <= signed(e_imm) + 4 + signed(pc_addr);
    else 
        s_addr_00 <= s_next_addr + 4;   
    end if ;

    s_addr_01 <= signed(a) + 4;

    if (sel_imm = '0') then
        if (sel_a = '0') then
            s_addr <= s_addr_00;
        else
            s_addr <= s_addr_01;
        end if ;
    else
        s_addr <= s_addr_10;
    end if ;

      
  end process ; -- sel

  addr <= std_logic_vector(s_addr);
  next_addr <= std_logic_vector(s_next_addr);



end synth;
