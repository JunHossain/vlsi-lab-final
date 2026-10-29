library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_8bit_tb is
end alu_8bit_tb;

architecture behavior of alu_8bit_tb is

    component alu_8bit
        Port ( acc     : in  STD_LOGIC_VECTOR(7 downto 0);
               operand : in  STD_LOGIC_VECTOR(7 downto 0);
               alu_sel : in  STD_LOGIC_VECTOR(2 downto 0);
               result  : out STD_LOGIC_VECTOR(7 downto 0);
               zero    : out STD_LOGIC);
    end component;

    signal acc     : STD_LOGIC_VECTOR(7 downto 0) := x"00";
    signal operand : STD_LOGIC_VECTOR(7 downto 0) := x"00";
    signal alu_sel : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal result  : STD_LOGIC_VECTOR(7 downto 0);
    signal zero    : STD_LOGIC;

begin

    uut: alu_8bit port map (acc => acc, operand => operand, alu_sel => alu_sel,
                            result => result, zero => zero);

    stim_proc: process
        variable errors : integer := 0;

        -- applies the inputs and compares result and zero flag
        procedure check (a       : STD_LOGIC_VECTOR(7 downto 0);
                         op      : STD_LOGIC_VECTOR(7 downto 0);
                         sel     : STD_LOGIC_VECTOR(2 downto 0);
                         exp_res : STD_LOGIC_VECTOR(7 downto 0);
                         exp_z   : STD_LOGIC;
                         msg     : string) is
        begin
            acc <= a;  operand <= op;  alu_sel <= sel;
            wait for 50 ns;
            if not (result = exp_res and zero = exp_z) then
                report "FAIL: " & msg severity error;
                errors := errors + 1;
            end if;
        end procedure;

    begin
        --     acc    operand sel    result  zero
        check (x"00", x"F3", "000", x"F3", '0', "LDI 0xF3");
        check (x"55", x"00", "000", x"00", '1', "LDI 0x00 gives zero flag");

        check (x"10", x"30", "001", x"40", '0', "ADD 0x10 + 0x30");
        check (x"FF", x"01", "001", x"00", '1', "ADD wraps to 0x00, carry discarded");

        check (x"F3", x"3C", "010", x"30", '0', "AND 0xF3 and 0x3C");
        check (x"F0", x"0F", "010", x"00", '1', "AND gives 0x00");

        check (x"30", x"11", "011", x"21", '0', "XOR 0x30 xor 0x11");
        check (x"40", x"40", "011", x"00", '1', "XOR same value gives 0x00");

        check (x"21", x"00", "100", x"10", '0', "SHR 0x21");
        check (x"FF", x"00", "100", x"7F", '0', "SHR 0xFF, 0 enters the MSB");
        check (x"01", x"00", "100", x"00", '1', "SHR 0x01 gives 0x00");

        if errors = 0 then
            report "PASS: alu_8bit works" severity note;
        else
            report "FAIL: " & integer'image(errors) & " check(s) failed" severity error;
        end if;
        wait;
    end process;

end behavior;
