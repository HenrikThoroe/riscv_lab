library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_wrapper is
  generic (
    -- Users to add parameters here

    -- User parameters ends
    -- Do not modify the parameters beyond this line
    -- Parameters of Axi Slave Bus Interface Operand
    C_Operand_TDATA_WIDTH : integer := 32;

    -- Parameters of Axi Slave Bus Interface Data
    C_Data_TDATA_WIDTH : integer := 32;

    -- Parameters of Axi Master Bus Interface Out
    C_Out_TDATA_WIDTH : integer := 96;
    C_Out_START_COUNT : integer := 32
  );
  port (
    -- Users to add ports here

    -- User ports ends
    -- Do not modify the ports beyond this line
    -- Ports of Axi Slave Bus Interface Operand
    operand_aclk    : in std_logic;
    operand_aresetn : in std_logic;
    operand_tready  : out std_logic;
    operand_tdata   : in std_logic_vector(31 downto 0);
    -- operand_tstrb   : in std_logic_vector((C_Operand_TDATA_WIDTH/8) - 1 downto 0);
    -- operand_tlast   : in std_logic;
    operand_tvalid : in std_logic;

    -- Ports of Axi Slave Bus Interface Data
    data_aclk    : in std_logic;
    data_aresetn : in std_logic;
    data_tready  : out std_logic;
    data_tdata   : in std_logic_vector(C_Data_TDATA_WIDTH - 1 downto 0);
    -- data_tstrb   : in std_logic_vector((C_Data_TDATA_WIDTH/8) - 1 downto 0);
    -- data_tlast   : in std_logic;
    data_tvalid : in std_logic;

    -- Ports of Axi Master Bus Interface Out
    -- out_aclk    : in std_logic;
    -- out_aresetn : in std_logic;
    -- out_tvalid  : out std_logic;
    -- out_tdata   : out std_logic_vector(C_Out_TDATA_WIDTH - 1 downto 0);

    o_imm : out std_logic_vector(31 downto 0);
    o_rs1 : out std_logic_vector(31 downto 0);
    o_rs2 : out std_logic_vector(31 downto 0);

    o_func3 : out std_logic_vector(2 downto 0);
    o_func7 : out std_logic_vector(6 downto 0);
    o_opcode : out std_logic_vector(6 downto 0);

    o_wb_reg : out std_logic_vector(4 downto 0);
    o_wb_enable : out std_logic;
    i_wb_reg : in std_logic_vector(4 downto 0);
    i_wb_data : in std_logic_vector(31 downto 0);
    i_wb_write : in std_logic

    -- out_tstrb   : out std_logic_vector((C_Out_TDATA_WIDTH/8) - 1 downto 0);
    -- out_tlast   : out std_logic;
    -- out_tready : in std_logic
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

  -- component registers is
  --   port (
  --     i_clk : in std_logic;
  --     i_rst   : in std_logic;
  --     i_rs1   : in std_logic_vector (4 downto 0);
  --     i_rs2   : in std_logic_vector (4 downto 0);
  --     i_rd    : in std_logic_vector (4 downto 0);
  --     i_input : in std_logic_vector (31 downto 0);
  --     i_write : in std_logic;
  --     o_out1  : out std_logic_vector (31 downto 0);
  --     o_out2  : out std_logic_vector (31 downto 0)
  --   );
  -- end component;

  component immediate_generation is
    port (
      i_operation : in std_logic_vector (31 downto 0);
      o_immediate : out std_logic_vector (31 downto 0)
    );
  end component;

  type registerFile is array(0 to 31) of std_logic_vector(31 downto 0);
  signal registers : registerFile := (others => (others => '0'));
  -- signal s_out1 : std_logic_vector(31 downto 0) := (others => '0');
  -- signal s_out2 : std_logic_vector(31 downto 0) := (others => '0');

  signal s_rs1          : std_logic_vector (4 downto 0);
  signal s_rs2          : std_logic_vector (4 downto 0);
  signal s_rd           : std_logic_vector (4 downto 0);
  -- signal s_opcode       : std_logic_vector(6 downto 0);
  
  signal s_out1         : std_logic_vector (31 downto 0);
  signal s_out2         : std_logic_vector (31 downto 0);
  signal s_immediate    : std_logic_vector (31 downto 0);

  signal s_is_waiting : std_logic;
  signal s_write_data : std_logic_vector(31 downto 0);
  signal s_write        : std_logic;
  signal s_should_write : std_logic;
  signal s_write_reg    : std_logic_vector (4 downto 0);

  signal s_regwrite : std_logic;
  signal s_rs1_data : std_logic_vector (31 downto 0);
  signal s_rs2_data : std_logic_vector (31 downto 0);
  signal s_imm_data : std_logic_vector (31 downto 0);

  signal s_func3 : std_logic_vector(2 downto 0);
  signal s_func7 : std_logic_vector(6 downto 0);
  signal s_opcode : std_logic_vector(6 downto 0);
begin

  -- reg : registers
  -- port map
  -- (
  --   i_clk => operand_aclk,
  --   i_rst   => operand_aresetn,
  --   i_rs1   => operand_tdata(19 downto 15),
  --   i_rs2   => operand_tdata(24 downto 20),
  --   i_rd    => i_wb_reg,--operand_tdata(11 downto 7),
  --   i_input => i_wb_data,
  --   i_write => i_wb_write,
  --   o_out1  => s_out1,
  --   o_out2  => s_out2
  -- );

  control_unit_inst : control_unit
  port map
  (
    i_opcode   => operand_tdata(6 downto 0),
    o_ALUSrc   => open,
    o_MemtoReg => open,
    o_RegWrite => s_should_write,
    o_MemRead  => open,
    o_MemWrite => open,
    o_Branch   => open,
    o_ALUOp    => open
  );

  immediate_generation_inst : immediate_generation
  port map
  (
    i_operation => operand_tdata,
    o_immediate => s_immediate
  );

  -- o_rs1 <= s_out1;
  -- o_rs2 <= s_out2;
  -- o_imm <= s_immediate;

  o_rs1 <= s_rs1_data;
  o_rs2 <= s_rs2_data;
  o_imm <= s_imm_data;
  o_wb_reg <= s_rd;
  o_wb_enable <= s_regwrite;
  o_func3 <= s_func3;
  o_func7 <= s_func7;
  o_opcode <= s_opcode;


  -- process (s_should_write, operand_tdata) begin
  --   if s_should_write = '1' then
  --     -- s_write_data <= data_tdata;
  --     s_write <= '1';
  --     s_write_reg <= operand_tdata(11 downto 7);
  --   else
  --     -- s_write_data <= (others => '0');
  --     s_write <= '0';
  --     s_write_reg <= (others => '0');
  --   end if;
  -- end process;

  process (operand_aclk) begin

    if rising_edge(operand_aclk) then

      if (operand_aresetn = '0') then
        s_rs1_data <= (others => '0');
        s_rs2_data <= (others => '0');
        s_imm_data <= (others => '0');
        registers <= (others => (others => '0'));
        s_rd <= (others => '0');
        s_regwrite <= '0';
        s_opcode <= (others => '0');
        s_func3 <= (others => '0');
        s_func7 <= (others => '0');
      else
        -- s_rs1_data <= s_out1;
        -- s_rs2_data <= s_out2;
        s_imm_data <= s_immediate;
        s_rd <= operand_tdata(11 downto 7);
        s_regwrite <= s_should_write;

        s_func3 <= operand_tdata(14 downto 12);
        s_func7 <= operand_tdata(31 downto 25);
        s_opcode <= operand_tdata(6 downto 0);

        if (i_wb_write = '1') then
          registers(to_integer(unsigned(i_wb_reg))) <= i_wb_data;

          if (i_wb_reg = operand_tdata(19 downto 15)) then
            s_rs1_data <= i_wb_data;
          end if;

          if (i_wb_reg = operand_tdata(24 downto 20)) then
            s_rs2_data <= i_wb_data;
          end if;
        else 
          s_rs1_data <= registers(to_integer(unsigned(operand_tdata(19 downto 15))));
          s_rs2_data <= registers(to_integer(unsigned(operand_tdata(24 downto 20))));
        end if;
      end if;
    end if;

    -- if falling_edge(operand_aclk) then
    --   if s_should_write = '1' then
    --     -- s_write_data <= data_tdata;
    --     s_write <= '1';
    --     s_write_reg <= operand_tdata(11 downto 7);
    --   else
    --     -- s_write_data <= (others => '0');
    --     s_write <= '0';
    --     s_write_reg <= (others => '0');
    --   end if;
    -- end if;
    
    -- if rising_edge(operand_aclk) then
      -- o_imm <= s_immediate;
      -- o_rs1 <= s_out1;
      -- o_rs2 <= s_out2;
      -- s_imm_data <= s_immediate;
      -- s_write_data <= data_tdata;

      -- if (s_write_reg = operand_tdata(19 downto 15)) and (s_write = '1') then
      --   s_rs1_data <= data_tdata;
      -- else
      --   s_rs1_data <= s_out1;
      -- end if;

      -- if (s_write_reg = operand_tdata(24 downto 20)) and (s_write = '1') then
      --   s_rs2_data <= data_tdata;
      -- else
      --   s_rs2_data <= s_out2;
      -- end if;

      -- if s_should_write = '1' then
      --   s_is_waiting <= '1';
      --   s_rd <= operand_tdata(11 downto 7);
      -- else
      --   s_is_waiting <= '0';
      --   s_rd <= (others => '0');
      -- end if;

      -- s_write <= '1';
      -- s_write_reg <= operand_tdata(11 downto 7);

      
      
      -- s_rd <= operand_tdata(11 downto 7);
      -- s_write_reg <= s_rd;

      -- if s_rd = operand_tdata(19 downto 15) then 
      --   o_rs1 <= data_tdata;
      -- else
      --   o_rs1 <= s_out1;
      -- end if;

      -- if s_rd = operand_tdata(24 downto 20) then 
      --   o_rs2 <= data_tdata;
      -- else
      --   o_rs2 <= s_out1;
      -- end if;

      -- if s_should_write = '1' then
      --   s_write <= '1';
      -- else 
      --   s_write <= '0';
      -- end if;
    -- end if;
  end process;

  -- out_tdata  <= s_out1 & s_out2 & s_immediate;
  -- out_tvalid <= operand_tvalid and out_tready;

  -- process (operand_aclk) begin
  --   if rising_edge(operand_aclk) then
  --     if s_is_waiting = '1' then
  --       operand_tready <= '0';
  --       data_tready    <= '1';
  --       if data_tvalid = '1' then
  --         s_write      <= '1';
  --         s_is_waiting <= '0';
  --       end if;
  --     else
  --       operand_tready <= '1';
  --       data_tready    <= '0';
  --       s_write        <= '0';
  --       if s_should_write = '1' then
  --         s_is_waiting   <= '1';
  --         operand_tready <= '0';
  --       end if;
  --     end if;
  --   end if;
  -- end process;
end arch_imp;
