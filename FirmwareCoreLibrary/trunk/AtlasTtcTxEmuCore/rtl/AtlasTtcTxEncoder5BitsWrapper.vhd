-------------------------------------------------------------------------------
-- Title      : 
-------------------------------------------------------------------------------
-- File       : AtlasTtcTxEncoder5BitsWrapper.vhd
-- Author     : Larry Ruckman  <ruckman@slac.stanford.edu>
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2014-06-05
-- Last update: 2014-06-05
-- Platform   : Vivado 2014.1
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.StdRtlPkg.all;

entity AtlasTtcTxEncoder5BitsWrapper is
   generic (
      TPD_G : time := 1 ns);      
   port (
      dataIn   : in  slv(7 downto 0);
      dataOut  : out slv(7 downto 0);
      checkOut : out slv(4 downto 0));
end AtlasTtcTxEncoder5BitsWrapper;

architecture rtl of AtlasTtcTxEncoder5BitsWrapper is

   component AtlasTtcTxEncoder5Bits
      port (
         ecc_data_in     : in  slv(7 downto 0);
         ecc_data_out    : out slv(7 downto 0);
         ecc_chkbits_out : out slv(4 downto 0));
   end component;

   attribute SYN_BLACK_BOX                               : boolean;
   attribute SYN_BLACK_BOX of AtlasTtcTxEncoder5Bits     : component is true;
   
   attribute BLACK_BOX_PAD_PIN                           : string;
   attribute BLACK_BOX_PAD_PIN of AtlasTtcTxEncoder5Bits : component is "ecc_data_in[7:0],ecc_data_out[7:0],ecc_chkbits_out[4:0]";

   signal dataOutReversed    : slv(7 downto 0);
   signal checkOutReversed : slv(4 downto 0);
   
begin
   
   dataOut  <= bitReverse(dataOutReversed);
   checkOut <= bitReverse(checkOutReversed);

   AtlasTtcTxEncoder5Bits_Inst : AtlasTtcTxEncoder5Bits
      port map (
         ecc_data_in     => bitReverse(dataIn),
         ecc_data_out    => dataOutReversed,
         ecc_chkbits_out => checkOutReversed);

end rtl;