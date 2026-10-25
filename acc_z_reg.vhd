library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity acc_z_reg is
    Port ( clk     : in  STD_LOGIC;
           reset   : in  STD_LOGIC;
           acc_we  : in  STD_LOGIC;
           z_we    : in  STD_LOGIC;
           acc_in  : in  STD_LOGIC_VECTOR(7 downto 0);
           zero_in : in  STD_LOGIC;
           acc     : out STD_LOGIC_VECTOR(7 downto 0);
           z       : out STD_LOGIC);
end acc_z_reg;

architecture Behavioral of acc_z_reg is
    signal acc_r : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
    signal z_r   : STD_LOGIC := '1';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                acc_r <= "00000000";
                z_r   <= '1';
            else
                if acc_we = '1' then
                    acc_r <= acc_in;
                end if;
                if z_we = '1' then
                    z_r <= zero_in;
                end if;
            end if;
        end if;
    end process;

    acc <= acc_r;
    z   <= z_r;
end Behavioral;
