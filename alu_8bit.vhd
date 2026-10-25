library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_8bit is
    Port ( acc     : in  STD_LOGIC_VECTOR(7 downto 0);
           operand : in  STD_LOGIC_VECTOR(7 downto 0);
           alu_sel : in  STD_LOGIC_VECTOR(2 downto 0);
           result  : out STD_LOGIC_VECTOR(7 downto 0);
           zero    : out STD_LOGIC);
end alu_8bit;

architecture Behavioral of alu_8bit is
    signal res : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(acc, operand, alu_sel)
    begin
        case alu_sel is
            when "000"  => res <= operand;                                              -- LDI
            when "001"  => res <= STD_LOGIC_VECTOR(UNSIGNED(acc) + UNSIGNED(operand));  -- ADD (carry discarded)
            when "010"  => res <= acc and operand;                                      -- AND
            when "011"  => res <= acc xor operand;                                      -- XOR
            when "100"  => res <= '0' & acc(7 downto 1);                                -- SHR (0 enters MSB)
            when others => res <= acc;
        end case;
    end process;

    result <= res;
    zero   <= '1' when res = "00000000" else '0';
end Behavioral;
