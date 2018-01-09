-------------------------------------------------------------------------------
-- Title         : AXI Lite Empty End Point
-- File          : AxiLiteEmpty.vhd
-------------------------------------------------------------------------------
-- Description:
-- Empty slave endpoint for AXI Lite bus.
-- Absorbs writes and returns zeros on reads.
-------------------------------------------------------------------------------
-- This file is part of 'SLAC Firmware Standard Library'.
-- It is subject to the license terms in the LICENSE.txt file found in the 
-- top-level directory of this distribution and at: 
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
-- No part of 'SLAC Firmware Standard Library', including this file, 
-- may be copied, modified, propagated, or distributed except according to 
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;

entity AxiLiteEmpty is
   generic (
      TPD_G           : time                  := 1 ns;
      AXI_RESP_G      : slv(1 downto 0)       := AXI_RESP_OK_C);
   port (
      -- AXI-Lite Bus
      axiClk         : in  sl;
      axiClkRst      : in  sl;
      axiReadMaster  : in  AxiLiteReadMasterType  := AXI_LITE_READ_MASTER_INIT_C;
      axiReadSlave   : out AxiLiteReadSlaveType;
      axiWriteMaster : in  AxiLiteWriteMasterType := AXI_LITE_WRITE_MASTER_INIT_C;
      axiWriteSlave  : out AxiLiteWriteSlaveType);
end AxiLiteEmpty;

architecture rtl of AxiLiteEmpty is

   type RegType is record
      axiReadSlave  : AxiLiteReadSlaveType;
      axiWriteSlave : AxiLiteWriteSlaveType;
   end record RegType;

   constant REG_INIT_C : RegType := (
      axiReadSlave  => AXI_LITE_READ_SLAVE_INIT_C,
      axiWriteSlave => AXI_LITE_WRITE_SLAVE_INIT_C);

   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;

begin

   comb : process (axiClkRst, axiReadMaster, axiWriteMaster, r, readRegister) is
      variable v      : RegType;
      variable regCon : AxiLiteEndPointType;
   begin
      -- Latch the current value
      v := r;

      -- Determine the transaction type
      axiSlaveWaitTxn(regCon, axiWriteMaster, axiReadMaster, v.axiWriteSlave, v.axiReadSlave);

      -- Closeout the transaction
      axiSlaveDefault(regCon, v.axiWriteSlave, v.axiReadSlave, AXI_RESP_G);

      -- Synchronous Reset
      if (axiClkRst = '1') then
         v := REG_INIT_C;
      end if;

      -- Register the variable for next clock cycle
      rin <= v;

      -- Outputs
      axiReadSlave  <= r.axiReadSlave;
      axiWriteSlave <= r.axiWriteSlave;

   end process comb;

   seq : process (axiClk) is
   begin
      if (rising_edge(axiClk)) then
         r <= rin after TPD_G;
      end if;
   end process seq;

end architecture rtl;
