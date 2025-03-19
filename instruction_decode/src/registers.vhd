----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2025 14:44:06
-- Design Name: 
-- Module Name: registers - Behavioral
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

entity registers is
  port (
    i_clk   : in std_logic;
    i_rst   : in std_logic;
    i_rs1   : in std_logic_vector (4 downto 0);
    i_rs2   : in std_logic_vector (4 downto 0);
    i_rd    : in std_logic_vector (4 downto 0);
    i_input : in std_logic_vector (31 downto 0);
    i_write : in std_logic;
    o_out1  : out std_logic_vector (31 downto 0);
    o_out2  : out std_logic_vector (31 downto 0));
end registers;

architecture Behavioral of registers is
  type registerFile is array(0 to 31) of std_logic_vector(31 downto 0);
  signal registers : registerFile := (others => (others => '0'));
  signal s_out1 : std_logic_vector(31 downto 0) := (others => '0');
  signal s_out2 : std_logic_vector(31 downto 0) := (others => '0');
begin

  o_out1 <= s_out1;
  o_out2 <= s_out2;

  -- o_out1 <= registers(to_integer(unsigned(i_rs1)));
  -- o_out1 <= registers(to_integer(unsigned(i_rs2)));

  process (i_rs1, i_rs2) begin
    s_out1 <= registers(to_integer(unsigned(i_rs1)));
    s_out2 <= registers(to_integer(unsigned(i_rs2)));
  end process;

  process (i_input, i_write, i_rd) begin
    if (i_write = '1') then 
        registers(to_integer(unsigned(i_rd))) <= i_input;
      end if;
  end process;

  -- process (i_clk) begin
  --   if rising_edge(i_clk) then
  --     s_out1 <= registers(to_integer(unsigned(i_rs1)));
  --     s_out2 <= registers(to_integer(unsigned(i_rs2)));

  --     if (i_write = '1') then   
  --       registers(to_integer(unsigned(i_rd))) <= i_input;
  --     end if;
      -- if i_rst = '0' then 
      --   registers <= (others => (others => '0'));
      -- else 
      --   if (i_write = '1') then 
      --     registers(to_integer(unsigned(i_rd))) <= i_input;
      --   end if;
      -- end if;

        -- for i in 0 to 31 loop
        --   if (i_write = '1') and (i_rd = std_logic_vector(to_unsigned(i, 5))) then
        --     registers(i) <= i_input;
        --   else 
        --     registers(i) <= registers(i);
        --   end if;
        -- end loop;
      -- end if;

      
      
      -- if (i_write = '1') then 
      --   registers(to_integer(unsigned(i_rd))) <= i_input;
      -- end if;


      -- if (i_write = '1') and (i_rd = i_rs1) then
      --   o_out1 <= i_input;
      -- else
      --   o_out1 <= registers(to_integer(unsigned(i_rs1)));
      -- end if;

      -- if (i_write = '1') and (i_rd = i_rs2) then
      --   o_out2 <= i_input;
      -- else
      --   o_out2 <= registers(to_integer(unsigned(i_rs2)));
      -- end if;
    -- end if;
  -- end process;

end Behavioral;
