library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity acc_z_reg_tb is
end acc_z_reg_tb;

architecture behavior of acc_z_reg_tb is

    component acc_z_reg
        Port ( clk     : in  STD_LOGIC;
               reset   : in  STD_LOGIC;
               acc_we  : in  STD_LOGIC;
               z_we    : in  STD_LOGIC;
               acc_in  : in  STD_LOGIC_VECTOR(7 downto 0);
               zero_in : in  STD_LOGIC;
               acc     : out STD_LOGIC_VECTOR(7 downto 0);
               z       : out STD_LOGIC);
    end component;

    signal clk      : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '1';
    signal acc_we   : STD_LOGIC := '0';
    signal z_we     : STD_LOGIC := '0';
    signal acc_in   : STD_LOGIC_VECTOR(7 downto 0) := x"00";
    signal zero_in  : STD_LOGIC := '0';
    signal acc      : STD_LOGIC_VECTOR(7 downto 0);
    signal z        : STD_LOGIC;
    signal sim_done : STD_LOGIC := '0';

    constant clk_period : time := 50 ns;

begin

    uut: acc_z_reg port map (clk => clk, reset => reset, acc_we => acc_we, z_we => z_we,
                             acc_in => acc_in, zero_in => zero_in, acc => acc, z => z);

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

        -- applies the inputs, waits for the next rising edge, then compares ACC and Z
        procedure step (rst     : STD_LOGIC;
                        a_we    : STD_LOGIC;
                        zw      : STD_LOGIC;
                        a_in    : STD_LOGIC_VECTOR(7 downto 0);
                        z_in    : STD_LOGIC;
                        exp_acc : STD_LOGIC_VECTOR(7 downto 0);
                        exp_z   : STD_LOGIC;
                        msg     : string) is
        begin
            reset <= rst;  acc_we <= a_we;  z_we <= zw;
            acc_in <= a_in;  zero_in <= z_in;
            wait until rising_edge(clk);
            wait for 10 ns;
            if not (acc = exp_acc and z = exp_z) then
                report "FAIL: " & msg severity error;
                errors := errors + 1;
            end if;
        end procedure;

    begin
        --    rst a_we z_we acc_in   zero_in  exp_acc exp_z
        step ('1', '0', '0', x"00",  '0',     x"00",  '1', "reset: ACC = 0 and Z = 1");
        step ('0', '1', '1', x"F3",  '0',     x"F3",  '0', "load 0xF3, Z = 0");
        step ('0', '0', '0', x"55",  '1',     x"F3",  '0', "no write enable: ACC and Z hold");
        step ('0', '1', '1', x"00",  '1',     x"00",  '1', "load 0x00, Z = 1");
        step ('0', '1', '1', x"40",  '0',     x"40",  '0', "load 0x40, Z = 0");
        step ('0', '1', '0', x"00",  '1',     x"00",  '0', "only ACC enabled: Z holds");
        step ('0', '0', '1', x"99",  '1',     x"00",  '1', "only Z enabled: ACC holds");
        step ('0', '1', '1', x"AA",  '0',     x"AA",  '0', "load 0xAA, Z = 0");
        step ('1', '1', '1', x"AA",  '0',     x"00",  '1', "reset has priority over write");

        if errors = 0 then
            report "PASS: acc_z_reg works" severity note;
        else
            report "FAIL: " & integer'image(errors) & " check(s) failed" severity error;
        end if;

        sim_done <= '1';
        wait;
    end process;

end behavior;
