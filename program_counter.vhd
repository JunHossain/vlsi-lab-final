library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_counter is
    Port ( clk   : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           pc    : out STD_LOGIC_VECTOR(3 downto 0));
end program_counter;

architecture Behavioral of program_counter is
    signal count : UNSIGNED(3 downto 0) := "0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                count <= "0000";
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    pc <= STD_LOGIC_VECTOR(count);
end Behavioral;
