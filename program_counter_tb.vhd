library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity program_counter_tb is
end program_counter_tb;

architecture behavior of program_counter_tb is

    component program_counter
        Port ( clk   : in  STD_LOGIC;
               reset : in  STD_LOGIC;
               pc    : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

    signal clk      : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '1';
    signal pc       : STD_LOGIC_VECTOR(3 downto 0);
    signal sim_done : STD_LOGIC := '0';

    constant clk_period : time := 50 ns;

begin

    uut: program_counter port map (clk => clk, reset => reset, pc => pc);

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

        -- waits for the next rising edge, then compares pc with the expected value
        procedure check (exp_pc : STD_LOGIC_VECTOR(3 downto 0);
                         msg    : string) is
        begin
            wait until rising_edge(clk);
            wait for 10 ns;
            if pc /= exp_pc then
                report "FAIL: " & msg severity error;
                errors := errors + 1;
            end if;
        end procedure;

    begin
        check (x"0", "reset clears PC to 0");
        reset <= '0';
        check (x"1", "count 1");
        check (x"2", "count 2");
        check (x"3", "count 3");
        check (x"4", "count 4");
        check (x"5", "count 5");

        reset <= '1';                       -- reset in the middle of counting
        check (x"0", "reset in the middle");
        reset <= '0';
        check (x"1", "counting again after reset");

        for i in 2 to 15 loop               -- run up to 15
            wait until rising_edge(clk);
        end loop;
        wait for 10 ns;
        if pc /= x"F" then
            report "FAIL: PC should reach 15" severity error;
            errors := errors + 1;
        end if;
        check (x"0", "PC wraps from 15 to 0");
        check (x"1", "PC continues after wrap");

        if errors = 0 then
            report "PASS: program_counter works" severity note;
        else
            report "FAIL: " & integer'image(errors) & " check(s) failed" severity error;
        end if;

        sim_done <= '1';
        wait;
    end process;

end behavior;
