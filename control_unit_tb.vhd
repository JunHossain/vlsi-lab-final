library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit_tb is
end control_unit_tb;

architecture behavior of control_unit_tb is

    component control_unit
        Port ( opcode  : in  STD_LOGIC_VECTOR(3 downto 0);
               alu_sel : out STD_LOGIC_VECTOR(2 downto 0);
               acc_we  : out STD_LOGIC;
               z_we    : out STD_LOGIC);
    end component;

    signal opcode  : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal alu_sel : STD_LOGIC_VECTOR(2 downto 0);
    signal acc_we  : STD_LOGIC;
    signal z_we    : STD_LOGIC;

begin

    uut: control_unit port map (opcode => opcode, alu_sel => alu_sel,
                                acc_we => acc_we, z_we => z_we);

    stim_proc: process
        variable errors : integer := 0;

        -- applies an opcode and compares the three control outputs
        procedure check (op      : STD_LOGIC_VECTOR(3 downto 0);
                         exp_sel : STD_LOGIC_VECTOR(2 downto 0);
                         exp_acc : STD_LOGIC;
                         exp_z   : STD_LOGIC;
                         msg     : string) is
        begin
            opcode <= op;
            wait for 50 ns;
            if not (alu_sel = exp_sel and acc_we = exp_acc and z_we = exp_z) then
                report "FAIL: " & msg severity error;
                errors := errors + 1;
            end if;
        end procedure;

    begin
        --     opcode  alu_sel  acc_we z_we
        check ("0000", "000",   '0',   '0', "0000 NOP");
        check ("0001", "000",   '1',   '1', "0001 LDI");
        check ("0010", "001",   '1',   '1', "0010 ADD");
        check ("0100", "010",   '1',   '1', "0100 AND");
        check ("0110", "011",   '1',   '1', "0110 XOR");
        check ("1001", "100",   '1',   '1', "1001 SHR");

        -- every opcode that is not in Set 7 must do nothing (NOP)
        check ("0011", "000",   '0',   '0', "0011 unused");
        check ("0101", "000",   '0',   '0', "0101 unused");
        check ("0111", "000",   '0',   '0', "0111 unused");
        check ("1000", "000",   '0',   '0', "1000 unused");
        check ("1010", "000",   '0',   '0', "1010 unused");
        check ("1011", "000",   '0',   '0', "1011 unused");
        check ("1100", "000",   '0',   '0', "1100 unused");
        check ("1101", "000",   '0',   '0', "1101 unused");
        check ("1110", "000",   '0',   '0', "1110 unused");
        check ("1111", "000",   '0',   '0', "1111 unused");

        if errors = 0 then
            report "PASS: control_unit works" severity note;
        else
            report "FAIL: " & integer'image(errors) & " check(s) failed" severity error;
        end if;
        wait;
    end process;

end behavior;
