-------------------------------------------------------------------------------
-- Title      : 1GbE/10GbE/40GbE Ethernet MAC
-------------------------------------------------------------------------------
-- File       : EthMacRxPause.vhd
-- Author     : Ryan Herbst <rherbst@slac.stanford.edu>
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2015-09-21
-- Last update: 2016-09-14
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-- Generic pause frame receiver for Ethernet MACs. Pause frames are dropped
-- from the incoming data stream.
-------------------------------------------------------------------------------
-- This file is part of 'SLAC Ethernet Library'.
-- It is subject to the license terms in the LICENSE.txt file found in the 
-- top-level directory of this distribution and at: 
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
-- No part of 'SLAC Ethernet Library', including this file, 
-- may be copied, modified, propagated, or distributed except according to 
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.AxiStreamPkg.all;
use work.StdRtlPkg.all;
use work.EthMacPkg.all;

entity EthMacRxPause is
   generic (
      TPD_G      : time                  := 1 ns;
      PAUSE_EN_G : boolean               := true;
      VLAN_EN_G  : boolean               := false;
      VLAN_CNT_G : positive range 1 to 8 := 1);          
   port (
      -- Clock and Reset
      ethClk       : in  sl;
      ethRst       : in  sl;
      -- Incoming data from MAC
      sAxisMaster  : in  AxiStreamMasterType;
      -- Outgoing data 
      mAxisMaster  : out AxiStreamMasterType;
      mAxisMasters : out AxiStreamMasterArray(VLAN_CNT_G-1 downto 0);
      -- Pause Values
      rxPauseReq   : out sl;
      rxPauseValue : out slv(15 downto 0));
end EthMacRxPause;

architecture rtl of EthMacRxPause is

   type StateType is (
      IDLE_S,
      PAUSE_S,
      DUMP_S,
      PASS_S);

   type RegType is record
      pauseEn      : sl;
      pauseValue   : slv(15 downto 0);
      mAxisMaster  : AxiStreamMasterType;
      mAxisMasters : AxiStreamMasterArray(VLAN_CNT_G-1 downto 0);
      state        : StateType;
   end record RegType;

   constant REG_INIT_C : RegType := (
      pauseEn      => '0',
      pauseValue   => (others => '0'),
      mAxisMaster  => AXI_STREAM_MASTER_INIT_C,
      mAxisMasters => (others => AXI_STREAM_MASTER_INIT_C),
      state        => IDLE_S);

   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;

   -- attribute dont_touch      : string;
   -- attribute dont_touch of r : signal is "true";   

begin

   U_RxPauseGen : if (PAUSE_EN_G = true) generate

      comb : process (ethRst, r, sAxisMaster) is
         variable v : RegType;
         variable i : natural;
      begin
         -- Latch the current value
         v := r;

         -- Reset flags
         v.pauseEn            := '0';
         v.mAxisMaster.tValid := '0';
         for i in (VLAN_CNT_G-1) downto 0 loop
            v.mAxisMasters(i).tValid := '0';
         end loop;

         -- State Machine
         case r.state is
            ----------------------------------------------------------------------
            when IDLE_S =>
               -- Check for data
               if (sAxisMaster.tValid = '1') then
                  -- Check for pause frame
                  if (sAxisMaster.tData(47 downto 0) = x"010000c28001") and  -- DST MAC (Pause MAC Address)
                     (sAxisMaster.tData(127 downto 112) = x"01000888") then  -- Mac Type, Mac OpCode
                     -- Check for no EOF
                     if (sAxisMaster.tLast = '0') then
                        -- Next State
                        v.state := PAUSE_S;
                     end if;
                  else
                     -- Move the data
                     v.mAxisMaster := sAxisMaster;
                     -- Check for no EOF
                     if (sAxisMaster.tLast = '0') then
                        -- Next State
                        v.state := PASS_S;
                     end if;
                  end if;
               end if;
            ----------------------------------------------------------------------
            when PAUSE_S =>
               ----------------------------------------------------------------------------------------------------------
               -- Refer to https://www.safaribooksonline.com/library/view/ethernet-the-definitive/1565926609/ch04s02.html
               ----------------------------------------------------------------------------------------------------------            
               -- Check for data
               if (sAxisMaster.tValid = '1') then
                  -- Latch the pause data
                  v.pauseValue(7 downto 0)  := sAxisMaster.tData(15 downto 8);
                  v.pauseValue(15 downto 8) := sAxisMaster.tData(7 downto 0);
                  -- Check for a EOF
                  if (sAxisMaster.tLast = '1') then
                     -- Set the pause
                     v.pauseEn := not axiStreamGetUserBit(EMAC_AXIS_CONFIG_C, sAxisMaster, EMAC_EOFE_BIT_C);
                     -- Next State
                     v.state   := IDLE_S;
                  else
                     -- Next State
                     v.state := DUMP_S;
                  end if;
               end if;
            ----------------------------------------------------------------------
            when DUMP_S =>
               -- Check for a valid EOF
               if (sAxisMaster.tValid = '1') and (sAxisMaster.tLast = '1') then
                  -- Set the pause
                  v.pauseEn := not axiStreamGetUserBit(EMAC_AXIS_CONFIG_C, sAxisMaster, EMAC_EOFE_BIT_C);
                  -- Next State
                  v.state   := IDLE_S;
               end if;
            ----------------------------------------------------------------------
            when PASS_S =>
               -- Move the data
               v.mAxisMaster := sAxisMaster;
               -- Check for a valid EOF
               if (sAxisMaster.tValid = '1') and (sAxisMaster.tLast = '1') then
                  -- Next State
                  v.state := IDLE_S;
               end if;
         ----------------------------------------------------------------------
         end case;

         -- Reset
         if ethRst = '1' then
            v := REG_INIT_C;
         end if;

         -- Register the variable for next clock cycle
         rin <= v;

         -- Outputs
         mAxisMaster  <= r.mAxisMaster;
         mAxisMasters <= r.mAxisMasters;
         rxPauseReq   <= r.pauseEn;
         rxPauseValue <= r.pauseValue;

      end process;

      seq : process (ethClk) is
      begin
         if rising_edge(ethClk) then
            r <= rin after TPD_G;
         end if;
      end process seq;
      
   end generate;

   U_BypRxPause : if (PAUSE_EN_G = false) generate
      mAxisMaster  <= sAxisMaster;
      mAxisMasters <= (others => AXI_STREAM_MASTER_INIT_C);
      rxPauseReq   <= '0';
      rxPauseValue <= (others => '0');
   end generate;
   
end rtl;
