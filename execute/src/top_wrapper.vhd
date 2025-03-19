----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2025 15:04:14
-- Design Name: 
-- Module Name: top_wrapper - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_wrapper is
  port (
    i_rs1     : in std_logic_vector (31 downto 0);
    i_rs2     : in std_logic_vector (31 downto 0);
    i_imm     : in std_logic_vector (31 downto 0);
    i_opcode  : in std_logic_vector (6 downto 0);
    i_func3   : in std_logic_vector (2 downto 0);
    i_func7   : in std_logic_vector (6 downto 0);
    i_pc      : in std_logic_vector (15 downto 0);
    o_jmp_adr : out std_logic_vector (15 downto 0);
    o_jmp     : out std_logic;
    o_res     : out std_logic_vector (31 downto 0);
    o_MemWrite : out std_logic;
    o_MemRead : out std_logic
  );
end top_wrapper;

architecture Behavioral of top_wrapper is

  component alu is
    port (
      i_cont : in std_logic_vector (3 downto 0);
      i_a    : in std_logic_vector (31 downto 0);
      i_b    : in std_logic_vector (31 downto 0);
      o_res  : out std_logic_vector (31 downto 0)
    );
  end component;

  component alu_control is
    port (
      i_op   : in std_logic_vector (1 downto 0);
      i_func : in std_logic_vector (4 downto 0);
      o_cont : out std_logic_vector (3 downto 0)
    );
  end component;

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

  function eq_zero(a : std_logic_vector(31 downto 0)) return std_logic is
  begin
    if a = (31 downto 0 => '0') then
      return '1';
    else
      return '0';
    end if;
  end function;

  signal s_alu_control : std_logic_vector (3 downto 0);
  signal s_alu_op      : std_logic_vector (1 downto 0);
  signal s_branch      : std_logic;
  signal s_alu_src     : std_logic;
  signal s_res         : std_logic_vector (31 downto 0);
  signal s_b           : std_logic_vector (31 downto 0);
  signal s_func        : std_logic_vector (4 downto 0);

begin

  o_jmp_adr <= std_logic_vector(unsigned(i_pc) + shift_left(unsigned(i_imm(15 downto 0)), 2));
  o_jmp     <= s_branch and eq_zero(s_res);
  o_res     <= s_res;
  s_func    <= i_func3 & i_func7(6 downto 5); -- 0

  alu_inst : alu
  port map
  (
    i_cont => s_alu_control,
    i_a    => i_rs1,
    i_b    => s_b,
    o_res  => s_res
  );

  control_unit_inst : control_unit
  port map
  (
    i_opcode   => i_opcode, 
    o_ALUSrc   => s_alu_src, -- 1
    o_MemtoReg => open,
    o_RegWrite => open,
    o_MemRead  => o_MemRead,
    o_MemWrite => o_MemWrite,
    o_Branch   => s_branch,
    o_ALUOp    => s_alu_op -- 10
  );

  alu_control_inst : alu_control
  port map
  (
    i_op   => s_alu_op,
    i_func => s_func,
    o_cont => s_alu_control
  );

  process (s_alu_src) is -- , i_rs2, i_imm
  begin
    if s_alu_src = '1' then
      s_b <= i_imm;
    else
      s_b <= i_rs2;
    end if;
  end process;

end Behavioral;
