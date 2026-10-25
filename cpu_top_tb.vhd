library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_top_tb is
end cpu_top_tb;

architecture behavior of cpu_top_tb is

    component cpu_top
        Port ( clk   : in  STD_LOGIC;
               reset : in  STD_LOGIC;
               q     : out STD_LOGIC_VECTOR(7 downto 0);
               z     : out STD_LOGIC;
               pc    : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

    signal clk      : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '1';
    signal q        : STD_LOGIC_VECTOR(7 downto 0);
    signal z        : STD_LOGIC;
    signal pc       : STD_LOGIC_VECTOR(3 downto 0);
    signal sim_done : STD_LOGIC := '0';

    constant clk_period : time := 50 ns;

begin

    uut: cpu_top port map (clk => clk, reset => reset, q => q, z => z, pc => pc);

    -- clock: stops after the last instruction so the waveform stays clean
    clk_process: process
    begin
        while sim_done = '0' loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    stim_proc: process
        variable errors : integer := 0;

        -- waits for the next rising edge, then compares ACC (q), Z and the
        -- next PC with the expected values from Appendix B
        procedure check (exp_q  : STD_LOGIC_VECTOR(7 downto 0);
                         exp_z  : STD_LOGIC;
                         exp_pc : STD_LOGIC_VECTOR(3 downto 0);
                         msg    : string) is
        begin
            wait until rising_edge(clk);
            wait for 10 ns;
            if not (q = exp_q and z = exp_z and pc = exp_pc) then
                report "FAIL: " & msg severity error;
                errors := errors + 1;
            end if;
        end procedure;

    begin
        --     ACC     Z    next PC
        check (x"00", '1', x"0", "cycle 0: RESET");
        reset <= '0';
        check (x"F3", '0', x"1", "cycle 1: LDI 0xF3");
        check (x"30", '0', x"2", "cycle 2: AND 0x3C");
        check (x"21", '0', x"3", "cycle 3: XOR 0x11");
        check (x"10", '0', x"4", "cycle 4: SHR");
        check (x"40", '0', x"5", "cycle 5: ADD 0x30");
        check (x"00", '1', x"6", "cycle 6: XOR 0x40");

        if errors = 0 then
            report "PASS: all cycles match Appendix B (Set 7)" severity note;
        else
            report "FAIL: " & integer'image(errors) & " cycle(s) did not match" severity error;
        end if;

        sim_done <= '1';
        wait;
    end process;

end behavior;
