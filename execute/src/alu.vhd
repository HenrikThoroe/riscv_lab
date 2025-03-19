----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.02.2025 18:23:41
-- Design Name: 
-- Module Name: alu - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( i_cont : in STD_LOGIC_VECTOR (3 downto 0);
           i_a : in STD_LOGIC_VECTOR (31 downto 0);
           i_b : in STD_LOGIC_VECTOR (31 downto 0);
           o_res : out STD_LOGIC_VECTOR (31 downto 0));
end alu;

architecture Behavioral of alu is
begin
    process (i_cont, i_a, i_b) 
        variable shift_amt : integer range 0 to 31;
    begin
        shift_amt := to_integer(unsigned(i_b(4 downto 0)));
        case (i_cont) is
            when "0000" => o_res <= std_logic_vector(signed(i_a) + signed(i_b));  -- add
            when "0001" => o_res <= std_logic_vector(signed(i_a) - signed(i_b));  -- sub
            when "0100" => o_res <= i_a and i_b;  -- and
            when "0101" => o_res <= i_a or i_b;   -- or
            when "0110" => o_res <= i_a xor i_b;  -- xor
            when "1000" => o_res <= to_stdlogicvector(to_bitvector(i_a) sll shift_amt);  -- sll
            when "1010" => o_res <= to_stdlogicvector(to_bitvector(i_a) srl shift_amt); -- srl
            when "1011" => o_res <= to_stdlogicvector(to_bitvector(i_a) sra shift_amt);    -- sra
            when "1100" => -- slt
                if signed(i_a) < signed(i_b) then 
                    o_res <= (31 downto 1 => '0') & '1';  
                else
                    o_res <= (others => '0');
                end if;
            when others =>
                o_res <= (others => '0');
        end case;
    end process;

end Behavioral;
