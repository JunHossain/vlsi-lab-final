library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_top is
    Port ( clk   : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           q     : out STD_LOGIC_VECTOR(7 downto 0);
           z     : out STD_LOGIC;
           pc    : out STD_LOGIC_VECTOR(3 downto 0));
end cpu_top;

architecture Structural of cpu_top is

    component program_counter
        Port ( clk   : in  STD_LOGIC;
               reset : in  STD_LOGIC;
               pc    : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

    component program_rom
        Port ( addr  : in  STD_LOGIC_VECTOR(3 downto 0);
               instr : out STD_LOGIC_VECTOR(11 downto 0));
    end component;

    component control_unit
        Port ( opcode  : in  STD_LOGIC_VECTOR(3 downto 0);
               alu_sel : out STD_LOGIC_VECTOR(2 downto 0);
               acc_we  : out STD_LOGIC;
               z_we    : out STD_LOGIC);
    end component;

    component alu_8bit
        Port ( acc     : in  STD_LOGIC_VECTOR(7 downto 0);
               operand : in  STD_LOGIC_VECTOR(7 downto 0);
               alu_sel : in  STD_LOGIC_VECTOR(2 downto 0);
               result  : out STD_LOGIC_VECTOR(7 downto 0);
               zero    : out STD_LOGIC);
    end component;

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

    signal pc_s    : STD_LOGIC_VECTOR(3 downto 0);
    signal instr   : STD_LOGIC_VECTOR(11 downto 0);
    signal alu_sel : STD_LOGIC_VECTOR(2 downto 0);
    signal acc_we  : STD_LOGIC;
    signal z_we    : STD_LOGIC;
    signal result  : STD_LOGIC_VECTOR(7 downto 0);
    signal zero    : STD_LOGIC;
    signal acc_s   : STD_LOGIC_VECTOR(7 downto 0);

begin

    u_pc:   program_counter port map (clk => clk, reset => reset, pc => pc_s);

    u_rom:  program_rom     port map (addr => pc_s, instr => instr);

    u_ctrl: control_unit    port map (opcode  => instr(11 downto 8),
                                      alu_sel => alu_sel,
                                      acc_we  => acc_we,
                                      z_we    => z_we);

    u_alu:  alu_8bit        port map (acc     => acc_s,
                                      operand => instr(7 downto 0),
                                      alu_sel => alu_sel,
                                      result  => result,
                                      zero    => zero);

    u_reg:  acc_z_reg       port map (clk     => clk,
                                      reset   => reset,
                                      acc_we  => acc_we,
                                      z_we    => z_we,
                                      acc_in  => result,
                                      zero_in => zero,
                                      acc     => acc_s,
                                      z       => z);

    q  <= acc_s;
    pc <= pc_s;

end Structural;
