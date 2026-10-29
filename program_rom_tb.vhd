library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_rom_tb is
end program_rom_tb;

architecture behavior of program_rom_tb is

    component program_rom
        Port ( addr  : in  STD_LOGIC_VECTOR(3 downto 0);
               instr : out STD_LOGIC_VECTOR(11 downto 0));
    end component;

    signal addr  : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal instr : STD_LOGIC_VECTOR(11 downto 0);

begin

    uut: program_rom port map (addr => addr, instr => instr);

    stim_proc: process
        variable errors : integer := 0;

        -- puts an address on the ROM and compares the instruction word
        procedure check (a : integer; exp_instr : STD_LOGIC_VECTOR(11 downto 0)) is
        begin
            addr <= STD_LOGIC_VECTOR(to_unsigned(a, 4));
            wait for 50 ns;
            if instr /= exp_instr then
                report "FAIL: wrong word at address " & integer'image(a) severity error;
                errors := errors + 1;
            end if;
        end procedure;

    begin
        check (0,  x"1F3");   -- LDI 0xF3
        check (1,  x"43C");   -- AND 0x3C
        check (2,  x"611");   -- XOR 0x11
        check (3,  x"900");   -- SHR
        check (4,  x"230");   -- ADD 0x30
        check (5,  x"640");   -- XOR 0x40
        for i in 6 to 15 loop
            check (i, x"000");   -- unused locations = NOP
        end loop;

        check (3, x"900");    -- jump back: ROM is combinational, no clock needed

        if errors = 0 then
            report "PASS: program_rom works" severity note;
        else
            report "FAIL: " & integer'image(errors) & " check(s) failed" severity error;
        end if;
        wait;
    end process;

end behavior;
