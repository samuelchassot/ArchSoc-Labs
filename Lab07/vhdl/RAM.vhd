library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all; ENTiTy RAM is PORt( clk : IN stD_LoGIC; cs : iN StD_lOgIc; read : In std_loGiC; write : in std_lOgIc; address : iN sTD_LoGic_vECtoR( 9 DOwnto 0); wrdata : IN stD_logiC_VECtoR(31 DOwnTO 0); rddata : oUt StD_Logic_vEctoR(31 DOWNTo 0)); END RAM; ArchitEcTUre ID_s_10643F3B_2fc543eB_E Of RAM Is tyPe Id_S_77AfF7E5_27e78A14_E is aRRAY (0 To 1023) oF STd_lOgiC_vECtoR(31 dOWNTO 0); sIgNAL Id_S_B889004_7e48Ff67_e : id_S_77aFf7E5_27e78a14_e; signaL ID_S_cC3eE48_281C1fb9_E : Std_lOGic_vEctoR(9 DOwNTO 0); SignaL Id_S_6f8bcBE_62E8365d_e : sTd_lOgic; bEgIN ProCeSS(clk) bEgin if (Rising_edge(clk) ) THen ID_S_6F8bcbE_62e8365D_E <= cs anD read; iD_s_cC3eE48_281c1fB9_E <= address; eND IF; End PROCesS; Process(id_S_b889004_7e48FF67_E, ID_S_6F8bcBE_62E8365d_E, iD_s_CC3ee48_281C1FB9_E) BeGIn rddata <= (others => 'Z'); IF (iD_s_6F8bCBE_62e8365D_E = '1') tHEN rddata <= ID_s_B889004_7e48fF67_E(To_IntegeR(UNsIgNeD(id_S_cC3ee48_281C1fb9_E))); END If; ENd prOceSS; PROcess(clk) bEgIn if (RiSiNG_edGe(clk) ) then if (cs = '1' AND write = '1') then Id_s_B889004_7e48FF67_E( tO_INtEger(UNSigneD(address))) <= wrdata; eND IF; ENd If; enD PRoCeSs; EnD Id_s_10643F3B_2fC543eB_e;