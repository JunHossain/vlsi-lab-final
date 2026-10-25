library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_rom is
    Port ( addr  : in  STD_LOGIC_VECTOR(3 downto 0);
           instr : out STD_LOGIC_VECTOR(11 downto 0));
end program_rom;

architecture Behavioral of program_rom is

    type rom_type is array (0 to 15) of STD_LOGIC_VECTOR(11 downto 0);

    -- Set 7 program: instr = opcode (4 bit) & operand (8 bit)
    constant ROM : rom_type := (
        0      => x"1F3",   -- LDI 0xF3
        1      => x"43C",   -- AND 0x3C
        2      => x"611",   -- XOR 0x11
        3      => x"900",   -- SHR
        4      => x"230",   -- ADD 0x30
        5      => x"640",   -- XOR 0x40
        others => x"000"    -- NOP
    );

begin
    instr <= ROM(to_integer(UNSIGNED(addr)));
end Behavioral;
