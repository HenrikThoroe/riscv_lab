----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2025 15:24:46
-- Design Name: 
-- Module Name: immediate_generation - Behavioral
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

entity immediate_generation is
  port (
    i_operation : in std_logic_vector (31 downto 0);
    o_immediate : out std_logic_vector (31 downto 0));
end immediate_generation;

architecture Behavioral of immediate_generation is
  -- type OP_TYPE is (R, I, S, B, U, J);

  -- signal s_type : OP_TYPE;
begin
  process (i_operation)
  begin
    -- case i_operation(6 downto 0) is
    --   when "0110011" => s_type <= R;
    --   when "0010011" => s_type <= I;
    --   when "0000011" => s_type <= I;
    --   when "0100011" => s_type <= S;
    --   when "1100011" => s_type <= B;
    --   when "1101111" => s_type <= J;
    --   when "1100111" => s_type <= I;
    --   when "0110111" => s_type <= U;
    --   when "0010111" => s_type <= U;
    --   when others    => s_type    <= I;
    -- end case;

    case i_operation(6 downto 0) is
      when "0110011"                       =>
        o_immediate <= (others       => '0');
      when "0010011" | "0000011" | "1100111"                    =>
        o_immediate <= (31 downto 11 => i_operation(31)) & i_operation(30 downto 20);
      when "0100011"                       =>
        o_immediate <= (31 downto 11 => i_operation(31)) &
          i_operation(30 downto 25) &
          i_operation(11 downto 7);
      when "1100011"                       =>
        o_immediate <= (31 downto 12 => i_operation(31)) &
          i_operation(7) &
          i_operation(30 downto 25) &
          i_operation(11 downto 8) &
          '0';
      when "0110111" | "0010111" =>
        o_immediate <= i_operation(31 downto 12) &
          (11 downto 0                 => '0');
      when "1101111"                       =>
        o_immediate <= (31 downto 20 => i_operation(31)) &
          i_operation(19 downto 12) &
          i_operation(20) &
          i_operation(30 downto 21) &
          '0';
      when others            =>
        o_immediate <= (others => '0');
    end case;
  end process;
end Behavioral;
