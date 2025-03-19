----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.02.2025 18:59:46
-- Design Name: 
-- Module Name: control_unit - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
  port (
    i_opcode   : in std_logic_vector (6 downto 0);
    o_ALUSrc   : out std_logic;
    o_MemtoReg : out std_logic;
    o_RegWrite : out std_logic;
    o_MemRead  : out std_logic;
    o_MemWrite : out std_logic;
    o_Branch   : out std_logic;
    o_ALUOp    : out std_logic_vector (1 downto 0));
end control_unit;

architecture Behavioral of control_unit is
begin
  process (i_opcode) begin
    case i_opcode is
        -- R
      when "0110011" =>
        o_ALUSrc   <= '0';
        o_MemtoReg <= '0';
        o_RegWrite <= '1';
        o_MemRead  <= '0';
        o_MemWrite <= '0';
        o_Branch   <= '0';
        o_ALUOp    <= "10";
        -- I
      when "0010011" =>
        o_ALUSrc   <= '1';
        o_MemtoReg <= '0';
        o_RegWrite <= '1';
        o_MemRead  <= '0';
        o_MemWrite <= '0';
        o_Branch   <= '0';
        o_ALUOp    <= "10";
        -- Lw
      when "0000011" =>
        o_ALUSrc   <= '1';
        o_MemtoReg <= '1';
        o_RegWrite <= '1';
        o_MemRead  <= '1';
        o_MemWrite <= '0';
        o_Branch   <= '0';
        o_ALUOp    <= "00";
        -- Sw
      when "0100011" =>
        o_ALUSrc   <= '1';
        o_MemtoReg <= '0';
        o_RegWrite <= '0';
        o_MemRead  <= '0';
        o_MemWrite <= '1';
        o_Branch   <= '0';
        o_ALUOp    <= "00";
        -- B
      when "1100011" =>
        o_ALUSrc   <= '0';
        o_MemtoReg <= '0';
        o_RegWrite <= '0';
        o_MemRead  <= '0';
        o_MemWrite <= '0';
        o_Branch   <= '1';
        o_ALUOp    <= "01";
      when others =>
        o_ALUSrc   <= '0';
        o_MemtoReg <= '0';
        o_RegWrite <= '0';
        o_MemRead  <= '0';
        o_MemWrite <= '0';
        o_Branch   <= '0';
        o_ALUOp    <= "00";
    end case;
  end process;
end Behavioral;
