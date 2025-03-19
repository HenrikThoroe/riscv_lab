----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.02.2025 18:29:42
-- Design Name: 
-- Module Name: alu_control - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu_control is
    Port ( i_op : in STD_LOGIC_VECTOR (1 downto 0);
           i_func : in STD_LOGIC_VECTOR (4 downto 0);
           o_cont : out STD_LOGIC_VECTOR (3 downto 0));
end alu_control;

architecture Behavioral of alu_control is
begin
    process (i_op, i_func) begin
        case i_op is
            when "10" =>
                case i_func is
                    when "00000" =>
                        -- add
                        o_cont <= "0000";
                    when "00001" =>
                        -- sub
                        o_cont <= "0001";
                    when "10000" =>
                        -- xor
                        o_cont <= "0110";
                    when "11000" =>
                        -- or
                        o_cont <= "0101";
                    when "11100" =>
                        -- and
                        o_cont <= "0100";
                    when "00100" =>
                        -- sll
                        o_cont <= "1000";
                    when "10100" =>
                        -- srl
                        o_cont <= "1010";
                    when "10101" =>
                        -- sra
                        o_cont <= "1011";
                    when "01000" =>
                        -- slt
                        o_cont <= "1100";
                    when others =>
                        o_cont <= "0000";
                end case;
            when "01" =>
                -- sub
                o_cont <= "0001";
            when "00" =>
                -- add
                o_cont <= "0000";
            when others =>
        end case;
    end process;
end Behavioral;
