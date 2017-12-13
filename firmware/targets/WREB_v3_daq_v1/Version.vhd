-------------------------------------------------------------------------------
-- Title         : Version File
-- Project       : 
-------------------------------------------------------------------------------
-- File          : 
-- Author        : 
-- Created       : 
-------------------------------------------------------------------------------
-- Description:
-- Version Constant Module.
-------------------------------------------------------------------------------
-- Copyright (c) 2010 by SLAC National Accelerator Laboratory. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

package Version is
-------------------------------------------------------------------------------
-- Version History
-------------------------------------------------------------------------------
  -- 00000000 Compiling WREB_v3 for DAQ v1

  constant FPGA_VERSION_C : std_logic_vector(31 downto 0) := x"10333001"; -- MAKE_VERSION

constant BUILD_STAMP_C : string := "WREB_v3_daq_v1: Vivado v2015.3 (x86_64) Built Tue Oct 24 16:08:58 PDT 2017 by srusso";

end Version;

-------------------------------------------------------------------------------
-- Revision History:
-- 
-------------------------------------------------------------------------------
