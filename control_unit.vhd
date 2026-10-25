library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port ( opcode  : in  STD_LOGIC_VECTOR(3 downto 0);
           alu_sel : out STD_LOGIC_VECTOR(2 downto 0);
           acc_we  : out STD_LOGIC;
           z_we    : out STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is
begin
    process(opcode)
    begin
        -- default = NOP: nothing is written
        alu_sel <= "000";
        acc_we  <= '0';
        z_we    <= '0';

        case opcode is
            when "0001" =>                               -- LDI
                alu_sel <= "000"; acc_we <= '1'; z_we <= '1';
            when "0010" =>                               -- ADD
                alu_sel <= "001"; acc_we <= '1'; z_we <= '1';
            when "0100" =>                               -- AND
                alu_sel <= "010"; acc_we <= '1'; z_we <= '1';
            when "0110" =>                               -- XOR
                alu_sel <= "011"; acc_we <= '1'; z_we <= '1';
            when "1001" =>                               -- SHR
                alu_sel <= "100"; acc_we <= '1'; z_we <= '1';
            when others =>                               -- 0000 and every unused opcode
                null;
        end case;
    end process;
end Behavioral;
