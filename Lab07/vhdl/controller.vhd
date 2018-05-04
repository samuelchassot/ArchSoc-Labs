library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        imm_signed : out std_logic;
        sel_b      : out std_logic;
        op_alu     : out std_logic_vector(5 downto 0);
        read       : out std_logic;
        write      : out std_logic;
        sel_pc     : out std_logic;
        branch_op  : out std_logic;
        sel_mem    : out std_logic;
        rf_wren    : out std_logic;
        pc_sel_imm : out std_logic;
        pc_sel_a   : out std_logic;
        sel_ra     : out std_logic;
        rf_retaddr : out std_logic_vector(4 downto 0);
        sel_rC     : out std_logic
    );
end controller;

architecture synth of controller is

begin
    rf_retaddr <= "11111";

op_alu_sel : process(op, opx)
  begin
    
    case(op) is
      
      when "111010" =>            --0x3A

        case(opx) is
          
          when "110001" =>        --0x31
            op_alu <= "000" & opx(5 downto 3);

          when "111001" =>        --0x39
            op_alu <= "001" & opx(5 downto 3);

          when "001000" =>        --0x08
            op_alu <= "011" & opx(5 downto 3);

          when "010000" =>        --0x10
            op_alu <= "011" & opx(5 downto 3);

          when "000110" =>        --0x06 
            op_alu <= "100" & opx(5 downto 3);

          when "001110" =>          --0x0E
            op_alu <= "100" & opx(5 downto 3);

          when "010110" =>          --0x16
            op_alu <= "100" & opx(5 downto 3);

          when "011110" =>          --0x1E
            op_alu <= "100" & opx(5 downto 3);

          when "010011" =>          --0x13
            op_alu <= "110" & opx(5 downto 3);

          when "011011" =>          --0x1B
            op_alu <= "110" & opx(5 downto 3);

          when "111011" =>          --0x3B
            op_alu <= "110" & opx(5 downto 3);

          when "010010" =>          --0x12
            op_alu <= "110" & opx(5 downto 3);

          when "011010" =>          --0x1A
            op_alu <= "110" & opx(5 downto 3);

          when "111010" =>          --0x3A
            op_alu <= "110" & opx(5 downto 3);


          when others =>
            op_alu <= "000000";
            
        end case;

      when "000100" =>            --0x04
        op_alu <= "000000";

      when "010111" =>            --0x17
        op_alu <= "000000";

      when "010101" =>            --0x15
        op_alu <= "000000";

      when "001100" =>            --0x0C
        op_alu <= "100001";

      when "010100" =>            --0x14
        op_alu <= "100010";

      when "011100" =>            --0x1C
        op_alu <= "100011";

      -- branch conditions

      when "000110" =>        --0x06 branch without condition
        op_alu <= "011100";

      when "001110" =>          --0x0E
        op_alu <= "011001";

      when "010110" =>          --0x16
        op_alu <= "011010";

      when "011110" =>          --0x1E
        op_alu <= "011011";

      when "100110" =>          --0x26
        op_alu <= "011100";

      when "101110" =>          --0x2E
        op_alu <= "011101";

      when "110110" =>          --0x36
        op_alu <= "011110";

      -- end branch conditions
        
      when others =>
        op_alu <= "000000";
        
    end case;

  end process;  -- op_alu_sel

  out_sel_proc : process( op, opx )
  begin
    case(op) is
          
          when "111010" =>              --0X3A

            case(opx) is

              when "000101" =>           --0x05
                    branch_op  <= '0';
                    imm_signed <= '0';    
                    pc_sel_a   <= '1';
                    pc_sel_imm <= '0';

                    rf_wren <= '0';


                    sel_b    <= '0';
                    sel_mem  <= '0';
                    sel_pc   <= '0';
                    sel_ra   <= '0';
                    sel_rC   <= '0';

                    read  <= '0';
                    write <= '0';

              when "001101" =>           --0x0D
                    branch_op  <= '0';
                    imm_signed <= '0';    
                    pc_sel_a   <= '1';
                    pc_sel_imm <= '0';

                    rf_wren <= '0';


                    sel_b    <= '0';
                    sel_mem  <= '0';
                    sel_pc   <= '0';
                    sel_ra   <= '0';
                    sel_rC   <= '0';

                    read  <= '0';
                    write <= '0';

              when "010010" =>            --0x12
                    branch_op  <= '0';
                    imm_signed <= '0';   
                    pc_sel_a   <= '0';
                    pc_sel_imm <= '0';

                    rf_wren <= '1';


                    sel_b    <= '0';    -- to take the immediate value
                    sel_mem  <= '0';
                    sel_pc   <= '0';
                    sel_ra   <= '0';
                    sel_rC   <= '1';

                    read  <= '0';
                    write <= '0';

              when "011010" =>            --0x1A
                    branch_op  <= '0';
                    imm_signed <= '0';    
                    pc_sel_a   <= '0';
                    pc_sel_imm <= '0';

                    rf_wren <= '1';


                    sel_b    <= '0';    -- to take the immediate value
                    sel_mem  <= '0';
                    sel_pc   <= '0';
                    sel_ra   <= '0';
                    sel_rC   <= '1';

                    read  <= '0';
                    write <= '0';

              when "111010" =>            --0x3A
                    branch_op  <= '0';
                    imm_signed <= '0';
                    pc_sel_a   <= '0';
                    pc_sel_imm <= '0';

                    rf_wren <= '1';


                    sel_b    <= '0';    -- to take the immediate value
                    sel_mem  <= '0';
                    sel_pc   <= '0';
                    sel_ra   <= '0';
                    sel_rC   <= '1';

                    read  <= '0';
                    write <= '0';

              when others =>
                    branch_op  <= '0';
                    imm_signed <= '0';    
                    pc_sel_a   <= '0';
                    pc_sel_imm <= '0';

                    rf_wren <= '1';


                    sel_b    <= '1';
                    sel_mem  <= '0';
                    sel_pc   <= '0';
                    sel_ra   <= '0';
                    sel_rC   <= '1';

                    read  <= '0';
                    write <= '0';
                
            end case;

          when "000100" =>              --0X04
                branch_op  <= '0';
                imm_signed <= '1';
                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '1';

                sel_b    <= '0';
                sel_mem  <= '0';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '0';
                write <= '0';

          when "001100" =>            --0x0C
                branch_op  <= '0';
                imm_signed <= '0';      -- because de immediate value is take unsigned
                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '1';

                sel_b    <= '0';
                sel_mem  <= '0';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '0';
                write <= '0';

          when "010100" =>            --0x14
                branch_op  <= '0';
                imm_signed <= '0';      -- because de immediate value is take unsigned
                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '1';

                sel_b    <= '0';
                sel_mem  <= '0';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '0';
                write <= '0';

          when "011100" =>            --0x1C
                branch_op  <= '0';
                imm_signed <= '0';      -- because de immediate value is take unsigned
                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '1';

                sel_b    <= '0';
                sel_mem  <= '0';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '0';
                write <= '0';

          when "010111" =>              --0X17
                branch_op  <= '0';
                imm_signed <= '1';
                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '0';

                sel_b    <= '0';
                sel_mem  <= '1';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '1';
                write <= '0';

          when "010101" =>              --0X15
                branch_op  <= '0';
                imm_signed <= '1';
                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '0';

                sel_b    <= '0';
                sel_mem  <= '0';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '0';
                write <= '1';

          when "000110" =>          --0x06
                branch_op  <= '1';
                imm_signed <= '1';
                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '0';

                sel_b    <= '1';
                sel_mem  <= '0';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '0';
                write <= '0';

          when "001110" =>          --0x0E
                branch_op  <= '1';
                imm_signed <= '1';


                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '0';

                sel_b    <= '1';
                sel_mem  <= '0';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '0';
                write <= '0';

          when "010110" =>          --0x16
                branch_op  <= '1';
                imm_signed <= '1';


                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '0';

                sel_b    <= '1';
                sel_mem  <= '0';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '0';
                write <= '0';

          when "011110" =>          --0x1E
                branch_op  <= '1';
                imm_signed <= '1';


                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '0';

                sel_b    <= '1';
                sel_mem  <= '0';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '0';
                write <= '0';

          when "100110" =>          --0x26
                branch_op  <= '1';
                imm_signed <= '1';


                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '0';

                sel_b    <= '1';
                sel_mem  <= '0';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '0';
                write <= '0';

         when "101110" =>          --0x2E
                branch_op  <= '1';
                imm_signed <= '1';


                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '0';

                sel_b    <= '1';
                sel_mem  <= '0';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '0';
                write <= '0';

          when "110110" =>          --0x36
                branch_op  <= '1';
                imm_signed <= '1';


                pc_sel_a   <= '0';
                pc_sel_imm <= '0';

                rf_wren <= '0';

                sel_b    <= '1';
                sel_mem  <= '0';
                sel_pc   <= '0';
                sel_ra   <= '0';
                sel_rC   <= '0';

                read  <= '0';
                write <= '0';

          when "000000" =>           --0x00
                branch_op  <= '0';
                imm_signed <= '0';


                pc_sel_a   <= '0';
                pc_sel_imm <= '1';

                rf_wren <= '1';

                sel_b    <= '0';
                sel_mem  <= '0';
                sel_pc   <= '1';
                sel_ra   <= '1';
                sel_rC   <= '0';

                read  <= '0';
                write <= '0';
            when others =>
            
        end case;
      
  end process ; -- out_sel_proc

end synth;
