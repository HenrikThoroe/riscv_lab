library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_wrapper is
  port (
    i_clk    : in std_logic;
    i_rstn : in std_logic;
    i_instruction   : in std_logic_vector(31 downto 0);

    i_wb_reg : in std_logic_vector(4 downto 0);
    i_wb_data : in std_logic_vector(31 downto 0);
    i_wb_enable : in std_logic;

    o_imm : out std_logic_vector(31 downto 0);
    o_rs1 : out std_logic_vector(31 downto 0);
    o_rs2 : out std_logic_vector(31 downto 0);
    o_func3 : out std_logic_vector(2 downto 0);
    o_func7 : out std_logic_vector(6 downto 0);
    o_opcode : out std_logic_vector(6 downto 0);
    o_wb_reg : out std_logic_vector(4 downto 0);
    o_wb_enable : out std_logic
  );
end top_wrapper;

architecture arch_imp of top_wrapper is
  component control_unit is
    port (
      i_opcode   : in std_logic_vector (6 downto 0);
      o_ALUSrc   : out std_logic;
      o_MemtoReg : out std_logic;
      o_RegWrite : out std_logic;
      o_MemRead  : out std_logic;
      o_MemWrite : out std_logic;
      o_Branch   : out std_logic;
      o_ALUOp    : out std_logic_vector (1 downto 0)
    );
  end component;

  component immediate_generation is
    port (
      i_operation : in std_logic_vector (31 downto 0);
      o_immediate : out std_logic_vector (31 downto 0)
    );
  end component;

  type registerFile is array(0 to 31) of std_logic_vector(31 downto 0);
  signal registers : registerFile := (others => (others => '0'));

  signal s_rd           : std_logic_vector (4 downto 0);
  
  signal s_out1         : std_logic_vector (31 downto 0);
  signal s_out2         : std_logic_vector (31 downto 0);
  signal s_immediate    : std_logic_vector (31 downto 0);

  signal s_RegWrite : std_logic;

  signal s_wb_enable : std_logic;
  signal s_imm_data : std_logic_vector (31 downto 0);

  signal s_func3 : std_logic_vector(2 downto 0);
  signal s_func7 : std_logic_vector(6 downto 0);
  signal s_opcode : std_logic_vector(6 downto 0);
begin

  control_unit_inst : control_unit
  port map
  (
    i_opcode   => i_instruction(6 downto 0),
    o_ALUSrc   => open,
    o_MemtoReg => open,
    o_RegWrite => s_RegWrite,
    o_MemRead  => open,
    o_MemWrite => open,
    o_Branch   => open,
    o_ALUOp    => open
  );

  immediate_generation_inst : immediate_generation
  port map
  (
    i_operation => i_instruction,
    o_immediate => s_immediate
  );

  o_rs1 <= s_out1;
  o_rs2 <= s_out2;
  o_imm <= s_imm_data;
  o_wb_reg <= s_rd;
  o_wb_enable <= s_wb_enable;
  o_func3 <= s_func3;
  o_func7 <= s_func7;
  o_opcode <= s_opcode;

  process (i_clk) begin
    if rising_edge(i_clk) then
      if (i_rstn = '0') then
        s_out1 <= (others => '0');
        s_out2 <= (others => '0');
        s_imm_data <= (others => '0');
        registers <= (others => (others => '0'));
        s_rd <= (others => '0');
        s_wb_enable <= '0';
        s_opcode <= (others => '0');
        s_func3 <= (others => '0');
        s_func7 <= (others => '0');
      else
        s_imm_data <= s_immediate;
        s_rd <= i_instruction(11 downto 7);
        s_wb_enable <= s_RegWrite;

        s_func3 <= i_instruction(14 downto 12);
        s_func7 <= i_instruction(31 downto 25);
        s_opcode <= i_instruction(6 downto 0);

        if (i_wb_enable = '1') then
          registers(to_integer(unsigned(i_wb_reg))) <= i_wb_data;

          if (i_wb_reg = i_instruction(19 downto 15)) then
            s_out1 <= i_wb_data;
          end if;

          if (i_wb_reg = i_instruction(24 downto 20)) then
            s_out2 <= i_wb_data;
          end if;
        else 
          s_out1 <= registers(to_integer(unsigned(i_instruction(19 downto 15))));
          s_out2 <= registers(to_integer(unsigned(i_instruction(24 downto 20))));
        end if;
      end if;
    end if;
  end process;
end arch_imp;
