----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:01:52 09/19/2016 
-- Design Name: 
-- Module Name:    WREB_v3_daq_v1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use work.max_11046_top_package.all;
use work.dual_ads1118_top_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

-- LSST libraries and packages 
--use work.RcmSciPackage.RcmSci;

entity WREB_v3_daq_v1 is

  port (
    ------ Clock signals ------
    -- PGP serdes clk
    PgpRefClk_P : in std_logic;
    PgpRefClk_M : in std_logic;
    -- sys clock (this is a clk gnerate by a quartz on the board)
    --sysclk_p    : in std_logic;
    --sysclk_m    : in std_logic;

    ------ PGP signals ------
    PgpRx_p : in  std_logic;
    PgpRx_m : in  std_logic;
    PgpTx_p : out std_logic;
    PgpTx_m : out std_logic;

    ------ CCD 1 -----

    -- CCD ADC
    adc_data_ccd_1    : in  std_logic_vector(15 downto 0);
    adc_cnv_ccd_1     : out std_logic;
    adc_sck_ccd_1     : out std_logic;
    adc_buff_pd_ccd_1 : out std_logic;

    -- ASPIC signals
    ASPIC_r_up_ccd_1_p   : out std_logic;
    ASPIC_r_up_ccd_1_n   : out std_logic;
    ASPIC_r_down_ccd_1_p : out std_logic;
    ASPIC_r_down_ccd_1_n : out std_logic;
    ASPIC_clamp_ccd_1_p  : out std_logic;
    ASPIC_clamp_ccd_1_n  : out std_logic;
    ASPIC_reset_ccd_1_p  : out std_logic;
    ASPIC_reset_ccd_1_n  : out std_logic;

    -- CCD Clocks signals
    par_clk_ccd_1_p    : out std_logic_vector(3 downto 0);
    par_clk_ccd_1_n    : out std_logic_vector(3 downto 0);
    ser_clk_ccd_1_p    : out std_logic_vector(2 downto 0);
    ser_clk_ccd_1_n    : out std_logic_vector(2 downto 0);
    reset_gate_ccd_1_p : out std_logic;
    reset_gate_ccd_1_n : out std_logic;

    ---- ASPICs SPI link ---- 
    -- ASPIC control signals
    ASPIC_spi_mosi_ccd_1   : out std_logic;
    ASPIC_spi_sclk_ccd_1   : out std_logic;
    ASPIC_spi_miso_t_ccd_1 : in  std_logic;
    ASPIC_spi_miso_b_ccd_1 : in  std_logic;
    ASPIC_ss_t_ccd_1       : out std_logic;
    ASPIC_ss_b_ccd_1       : out std_logic;
    ASPIC_spi_reset_ccd_1  : out std_logic;
    ASPIC_nap_ccd_1        : out std_logic;

    backbias_clamp : out std_logic;
    backbias_ssbe  : out std_logic;

    -- CABAC pulse
    pulse_ccd_1_p : out std_logic;
    pulse_ccd_1_n : out std_logic;

    ------ REB V & I sensors ------  
    LTC2945_SCL : inout std_logic;
    LTC2945_SDA : inout std_logic;

    ------ Temperature ------
-- DREB PCB temperature
    DREB_temp_sda : inout std_logic;
    DREB_temp_scl : inout std_logic;

-- board temp ADC
    Temp_adc_scl_ccd_1 : inout std_logic;
    Temp_adc_sda_ccd_1 : inout std_logic;

-- CCD temperatures
    csb_24ADC  : out std_logic;
    sclk_24ADC : out std_logic;
    din_24ADC  : out std_logic;
    dout_24ADC : in  std_logic;


-- ASPICs temp and voltage ADC
    aspic_t_v_miso    : in  std_logic;
    aspic_t_v_mosi    : out std_logic;
    aspic_t_v_ss_ccd1 : out std_logic;
    aspic_t_v_sclk    : out std_logic;

    ------ DACs ------
-- cabac clock rails DAC
    ldac_RAILS      : out std_logic;
    din_RAILS       : out std_logic;
    sclk_RAILS      : out std_logic;
    sync_RAILS_dac0 : out std_logic;
    sync_RAILS_dac1 : out std_logic;

-- CCD BIAS
    ldac_C_BIAS : out std_logic;
    din_C_BIAS  : out std_logic;
    sync_C_BIAS : out std_logic;
    sclk_C_BIAS : out std_logic;

-- max 11056 slow adc
    ck_adc_EOC                 : in    std_logic;
    ccd1_adc_EOC               : in    std_logic;
    slow_adc_data_from_adc_dcr : inout std_logic_vector(3 downto 0);
    slow_adc_data_from_adc     : in    std_logic_vector(15 downto 4);
    ck_adc_CS                  : out   std_logic;
    ccd1_adc_CS                : out   std_logic;
    slow_adc_RD                : out   std_logic;
    slow_adc_WR                : out   std_logic;
    ck_adc_CONVST              : out   std_logic;
    ccd1_adc_CONVST            : out   std_logic;
    ck_adc_SHDN                : out   std_logic;
    ccd1_adc_SHDN              : out   std_logic;

    ------ MISC ------
-- Resistors
    r_add : in std_logic_vector(7 downto 0);

-- Test port
    TEST : out std_logic_vector(3 downto 0);

-- Test led
    TEST_LED : out std_logic_vector(2 downto 0);

-- Power ON reset
    Pwron_Rst_L : in std_logic;


-- CCD clocks enable
    ccd1_clk_en_out_p : out std_logic;
    ccd1_clk_en_out_n : out std_logic;

-- ASPIC reference power down
    ASPIC_ref_sd_ccd1 : out std_logic;
    ASPIC_5V_sd_ccd1  : out std_logic;


    -- GPIO
    gpio_0_p   : out std_logic;
    gpio_0_n   : out std_logic;
    gpio_0_dir : out std_logic;
    gpio_1_p   : out std_logic;
    gpio_1_n   : out std_logic;
    gpio_1_dir : out std_logic;

-- DREB serial number
    reb_sn_onewire : inout std_logic

    );

end WREB_v3_daq_v1;

architecture Behavioral of WREB_v3_daq_v1 is


  component LsstSci is
    port (
      -------------------------------------------------------------------------
      -- FPGA Interface
      -------------------------------------------------------------------------
      StableClk : in std_logic;
      StableRst : in std_logic;

      FpgaRstL : in std_logic;

      PgpRefClk : in  std_logic;
      PgpRxP    : in  std_logic;
      PgpRxM    : in  std_logic;
      PgpTxP    : out std_logic;
      PgpTxM    : out std_logic;

      -------------------------------------------------------------------------
      -- Clock/Reset Generator Interface
      -------------------------------------------------------------------------
      ClkOut : out std_logic;
      RstOut : out std_logic;
      ClkIn  : in  std_logic;
      RstIn  : in  std_logic;

      -------------------------------------------------------------------------
      -- SCI Register Encoder/Decoder Interface
      -------------------------------------------------------------------------
      RegAddr   : out std_logic_vector(23 downto 0);
      RegReq    : out std_logic;
      RegOp     : out std_logic;
      RegDataWr : out std_logic_vector(31 downto 0);
      RegWrEn   : out std_logic_vector(31 downto 0);
      RegAck    : in  std_logic;
      RegFail   : in  std_logic;
      RegDataRd : in  std_logic_vector(31 downto 0);

      -------------------------------------------------------------------------
      -- Data Encoder Interface
      -------------------------------------------------------------------------
      DataWrEn : in std_logic;
      DataSOT  : in std_logic;
      DataEOT  : in std_logic;
      DataIn   : in std_logic_vector(17 downto 0);

      -------------------------------------------------------------------------
      -- Notification Interface
      -------------------------------------------------------------------------
      NoticeEn : in std_logic;
      Notice   : in std_logic_vector(13 downto 0);

      -------------------------------------------------------------------------
      -- Synchronous Command Interface
      -------------------------------------------------------------------------
      SyncCmdEn : out std_logic;
      SyncCmd   : out std_logic_vector(7 downto 0);

      -------------------------------------------------------------------------
      -- Status Block Interface
      -------------------------------------------------------------------------
      StatusAddr : in  std_logic_vector(23 downto 0);
      StatusReg  : out std_logic_vector(31 downto 0);
      StatusRst  : in  std_logic;

      -------------------------------------------------------------------------
      -- Debug Interface
      -------------------------------------------------------------------------
      PgpLocLinkReadyOut : out std_logic;
      PgpRemLinkReadyOut : out std_logic;
      PgpRxPhyReadyOut   : out std_logic;
      PgpTxPhyReadyOut   : out std_logic);

  end component;




  component wreb_v3_cmd_interpeter
    port (
      reset : in std_logic;
      clk   : in std_logic;

-- signals from/to SCI
      regReq           : in  std_logic;  -- with this line the master start a read/write procedure (1 to start)
      regOp            : in  std_logic;  -- this line define if the procedure is read or write (1 to write)
      regAddr          : in  std_logic_vector(23 downto 0);  -- address bus
      statusReg        : in  std_logic_vector(31 downto 0);  -- status reg bus. The RCI handle this bus and this machine pass it to the sure if he wants to read it
      regWrEn          : in  std_logic_vector(31 downto 0);  -- write enable bus. This bus enables the data write bits
      regDataWr_masked : in  std_logic_vector(31 downto 0);  -- data write bus masked. Is the logical AND of data write bus and write enable bus
      regAck           : out std_logic;  -- acknowledge line to activate when the read/write procedure is completed
      regFail          : out std_logic;  -- line to activate when an error occurs during the read/write procedure
      regDataRd        : out std_logic_vector(31 downto 0);  -- data bus to RCI used to transfer read data
      StatusReset      : out std_logic;  -- status block reset

-- Base Register Set signals            
      busy_bus               : in std_logic_vector(31 downto 0);  -- busy bus is composed by the different register sets busy
      time_base_actual_value : in std_logic_vector(63 downto 0);  -- time base value 
      trig_tm_value_SB       : in std_logic_vector(63 downto 0);  -- Status Block trigger time 
      trig_tm_value_TB       : in std_logic_vector(63 downto 0);  -- Time Base trigger time
      trig_tm_value_seq      : in std_logic_vector(63 downto 0);  -- Sequencer Trigger time
      trig_tm_value_V_I      : in std_logic_vector(63 downto 0);  -- Voltage and current sens trigger time
      trig_tm_value_pcb_t    : in std_logic_vector(63 downto 0);  -- PCB temperature Trigger time
--          trig_tm_value_f_adc    : in std_logic_vector(63 downto 0);  -- fast ADC Trigger time

      trigger_ce_bus     : out std_logic_vector(31 downto 0);  -- bus to enable register sets trigger. To trigger a register set that stops itself use en AND val                                      
      trigger_val_bus    : out std_logic_vector(31 downto 0);  -- bus of register sets trigger values  
      load_time_base_lsw : out std_logic;  -- ce signal to load the time base lsw
      load_time_base_MSW : out std_logic;  -- ce signal to load the time base MSW
      cnt_preset         : out std_logic_vector(63 downto 0);  -- preset value for the time base counter

      Mgt_avcc_ok   : in std_logic;
      Mgt_accpll_ok : in std_logic;
      Mgt_avtt_ok   : in std_logic;
      V3_3v_ok      : in std_logic;
      Switch_addr   : in std_logic_vector(7 downto 0);

-- sync commands
      sync_cmd_delay_en   : out std_logic;  -- set the sync command0 delay
      sync_cmd_delay_read : in  std_logic_vector(7 downto 0);
      sync_cmd_mask_en    : out std_logic;
      sync_cmd_mask_read  : in  std_logic_vector(31 downto 0);


-- Image parameters
      image_size        : in  std_logic_vector(31 downto 0);  -- this register contains the image size
      image_patter_read : in  std_logic;  -- this register gives the state of image patter gen. 1 is ON
      ccd_sel_read      : in  std_logic_vector(2 downto 0);  -- this register contains the CCD to drive
      image_size_en     : out std_logic;  -- this line enables the register where the image size is written
      image_patter_en   : out std_logic;  -- this register enable the image patter gen. 1 is ON
      ccd_sel_en        : out std_logic;  -- register enable for CCD acquisition selector


-- Sequencer
      seq_time_mem_readbk      : in  std_logic_vector(15 downto 0);  -- time memory read bus
      seq_out_mem_readbk       : in  std_logic_vector(31 downto 0);  -- time memory read bus
      seq_prog_mem_readbk      : in  std_logic_vector(31 downto 0);  -- sequencer program memory read
      seq_time_mem_w_en        : out std_logic;  -- this signal enables the time memory write
      seq_out_mem_w_en         : out std_logic;  -- this signal enables the output memory write
      seq_prog_mem_w_en        : out std_logic;  -- this signal enables the program memory write
      seq_step                 : out std_logic;  -- this signal send the STEP to the sequencer. Valid on in infinite loop (the machine jump out from IL to next function)   
      seq_stop                 : out std_logic;  -- this signal send the STOP to the sequencer. Valid on in infinite loop (the machine jump out from IL to next function)
      enable_conv_shift_in     : in  std_logic;  -- this signal enable the adc_conv shifter (the adc_conv is shifted 1 clk every time is activated)
      enable_conv_shift        : out std_logic;  -- this signal enable the adc_conv shifter (the adc_conv is shifted 1 clk every time is activated)
      init_conv_shift          : out std_logic;  -- this signal initialize the adc_conv shifter (the adc_conv is shifted 1 clk every time is activated)
      start_add_prog_mem_en    : out std_logic;
      start_add_prog_mem_rbk   : in  std_logic_vector(9 downto 0);
      seq_ind_func_mem_we      : out std_logic;
      seq_ind_func_mem_rdbk    : in  std_logic_vector(3 downto 0);
      seq_ind_rep_mem_we       : out std_logic;
      seq_ind_rep_mem_rdbk     : in  std_logic_vector(23 downto 0);
      seq_ind_sub_add_mem_we   : out std_logic;
      seq_ind_sub_add_mem_rdbk : in  std_logic_vector(9 downto 0);
      seq_ind_sub_rep_mem_we   : out std_logic;
      seq_ind_sub_rep_mem_rdbk : in  std_logic_vector(15 downto 0);
      seq_op_code_error        : in  std_logic;
      seq_op_code_error_add    : in  std_logic_vector(9 downto 0);
      seq_op_code_error_reset  : out std_logic;

-- ASPIC

      aspic_config_r_ccd_1 : in  std_logic_vector(15 downto 0);
      aspic_config_r_ccd_2 : in  std_logic_vector(15 downto 0);
      aspic_config_r_ccd_3 : in  std_logic_vector(15 downto 0);
      aspic_op_end         : in  std_logic;
      aspic_start_trans    : out std_logic;
      aspic_start_reset    : out std_logic;
      aspic_nap_mode_en    : out std_logic;
      aspic_nap_ccd1_in    : in  std_logic;
--      aspic_nap_ccd2_in    : in  std_logic;


-- CCD clock rails DAC          
      clk_rail_load_start : out std_logic;
      clk_rail_ldac_start : out std_logic;

-- BIAS DAC (former CABAC bias DAC)               
      c_bias_load_start : out std_logic;
      c_bias_ldac_start : out std_logic;

-- DREB voltage and current sensors
      error_V_HTR_voltage   : in std_logic;
      V_HTR_voltage         : in std_logic_vector(15 downto 0);
      error_V_HTR_current   : in std_logic;
      V_HTR_current         : in std_logic_vector(15 downto 0);
      error_V_DREB_voltage  : in std_logic;
      V_DREB_voltage        : in std_logic_vector(15 downto 0);
      error_V_DREB_current  : in std_logic;
      V_DREB_current        : in std_logic_vector(15 downto 0);
      error_V_CLK_H_voltage : in std_logic;
      V_CLK_H_voltage       : in std_logic_vector(15 downto 0);
      error_V_CLK_H_current : in std_logic;
      V_CLK_H_current       : in std_logic_vector(15 downto 0);
      error_V_ANA_voltage   : in std_logic;
      V_ANA_voltage         : in std_logic_vector(15 downto 0);
      error_V_ANA_current   : in std_logic;
      V_ANA_current         : in std_logic_vector(15 downto 0);
      error_V_OD_voltage    : in std_logic;
      V_OD_voltage          : in std_logic_vector(15 downto 0);
      error_V_OD_current    : in std_logic;
      V_OD_current          : in std_logic_vector(15 downto 0);

-- DREB temperature
      T1_dreb       : in std_logic_vector(15 downto 0);
      T1_dreb_error : in std_logic;
      T2_dreb       : in std_logic_vector(15 downto 0);
      T2_dreb_error : in std_logic;

-- REB temperature gr1
      T1_reb_gr1       : in std_logic_vector(15 downto 0);
      T1_reb_gr1_error : in std_logic;
      T2_reb_gr1       : in std_logic_vector(15 downto 0);
      T2_reb_gr1_error : in std_logic;
      T3_reb_gr1       : in std_logic_vector(15 downto 0);
      T3_reb_gr1_error : in std_logic;
      T4_reb_gr1       : in std_logic_vector(15 downto 0);
      T4_reb_gr1_error : in std_logic;

-- REB temperature gr2
      T1_reb_gr2       : in std_logic_vector(15 downto 0);
      T1_reb_gr2_error : in std_logic;
      T2_reb_gr2       : in std_logic_vector(15 downto 0);
      T2_reb_gr2_error : in std_logic;
      T3_reb_gr2       : in std_logic_vector(15 downto 0);
      T3_reb_gr2_error : in std_logic;
      T4_reb_gr2       : in std_logic_vector(15 downto 0);
      T4_reb_gr2_error : in std_logic;

-- REB temperature gr3
      T1_reb_gr3       : in std_logic_vector(15 downto 0);
      T1_reb_gr3_error : in std_logic;

-- ASPIC temp and voltage monitor
      aspic_t_v_data    :     array432;
      aspic_t_v_busy    : in  std_logic;
      aspic_t_v_start_r : out std_logic;

-- CCD temperature
      ccd_temp_busy        : in  std_logic;
      ccd_temp             : in  std_logic_vector(23 downto 0);
      ccd_temp_start       : out std_logic;
      ccd_temp_start_reset : out std_logic;

-- slow ADCs
      slow_adc_busy        : in  std_logic;
      ck_adc_conv_res      : in  array816;
      ccd1_adc_conv_res    : in  array816;
      ccd2_adc_conv_res    : in  array816;
      slow_adc_start_read  : out std_logic;
      slow_adc_start_write : out std_logic;

-- DREB 1wire serial number
      dreb_onewire_reset : out std_logic;
      dreb_sn_crc_ok     : in  std_logic;
      dreb_sn_dev_error  : in  std_logic;
      dreb_sn            : in  std_logic_vector(47 downto 0);
      dreb_sn_timeout    : in  std_logic;

-- REB 1wire serial number
      reb_onewire_reset : out std_logic;
      reb_sn_crc_ok     : in  std_logic;
      reb_sn_dev_error  : in  std_logic;
      reb_sn            : in  std_logic_vector(47 downto 0);
      reb_sn_timeout    : in  std_logic;

-- CCD clock enable
      ccd1_clk_en_in : in  std_logic;
      ccd2_clk_en_in : in  std_logic;
      ccd_clk_en     : out std_logic;

-- ASPIC reference enable
      aspic_ref_en_in_ccd1 : in  std_logic;
      aspic_ref_en_in_ccd2 : in  std_logic;
      aspic_ref_en         : out std_logic;
-- ASPIC 5V enable
      aspic_5v_en_in_ccd1  : in  std_logic;
      aspic_5v_en_in_ccd2  : in  std_logic;
      aspic_5v_en          : out std_logic;

-- CABAC regulators enable
      CABAC_reg_in : in  std_logic_vector(4 downto 0);
      CABAC_reg_en : out std_logic;

-- back bias switch
      back_bias_sw_rb : in  std_logic;
      back_bias_cl_rb : in  std_logic;
      en_back_bias_sw : out std_logic;

-- multiboot
      start_multiboot : out std_logic

      );    
  end component;

  component sync_cmd_decoder_top
    port (
      pgp_clk            : in  std_logic;
      pgp_reset          : in  std_logic;
      clk                : in  std_logic;
      reset              : in  std_logic;
      sync_cmd_en        : in  std_logic;
      delay_en           : in  std_logic;
      sync_cmd_mask_en   : in  std_logic;
      delay_in           : in  std_logic_vector(7 downto 0);
      delay_read         : out std_logic_vector(7 downto 0);
      sync_cmd_mask      : in  std_logic_vector(31 downto 0);
      sync_cmd_mask_read : out std_logic_vector(31 downto 0);
      sync_cmd           : in  std_logic_vector(7 downto 0);
      sync_cmd_out       : out std_logic_vector(7 downto 0));
  end component;

  component base_reg_set_top is
    port (
      clk                : in  std_logic;
      reset              : in  std_logic;
      en_time_base_cnt   : in  std_logic;
      load_time_base_lsw : in  std_logic;
      load_time_base_MSW : in  std_logic;
      StatusReset        : in  std_logic;
      trigger_TB         : in  std_logic;
      trigger_seq        : in  std_logic;
      trigger_V_I_read   : in  std_logic;
      trigger_temp_pcb   : in  std_logic;
      trigger_fast_adc   : in  std_logic;
      cnt_preset         : in  std_logic_vector(63 downto 0);
      cnt_busy           : out std_logic;
      cnt_actual_value   : out std_logic_vector(63 downto 0);
      trig_tm_value_SB   : out std_logic_vector(63 downto 0);
      trig_tm_value_TB   : out std_logic_vector(63 downto 0);
      trig_tm_value_seq  : out std_logic_vector(63 downto 0);
      trig_tm_value_V_I  : out std_logic_vector(63 downto 0);
      trig_tm_value_pcb  : out std_logic_vector(63 downto 0);
      trig_tm_value_adc  : out std_logic_vector(63 downto 0)
      );
  end component;

  component sequencer_v3_top is
    port (
      reset                    : in  std_logic;  -- syncronus reset
      clk                      : in  std_logic;  -- clock
      start_sequence           : in  std_logic;
      program_mem_we           : in  std_logic;
      seq_mem_w_add            : in  std_logic_vector(9 downto 0);
      seq_mem_data_in          : in  std_logic_vector(31 downto 0);
      prog_mem_redbk           : out std_logic_vector(31 downto 0);
      program_mem_init_en      : in  std_logic;
      program_mem_init_add_rbk : out std_logic_vector(9 downto 0);
      ind_func_mem_we          : in  std_logic;
      ind_func_mem_redbk       : out std_logic_vector(3 downto 0);
      ind_rep_mem_we           : in  std_logic;
      ind_rep_mem_redbk        : out std_logic_vector(23 downto 0);
      ind_sub_add_mem_we       : in  std_logic;
      ind_sub_add_mem_redbk    : out std_logic_vector(9 downto 0);
      ind_sub_rep_mem_we       : in  std_logic;
      ind_sub_rep_mem_redbk    : out std_logic_vector(15 downto 0);
      time_mem_w_en            : in  std_logic;
      time_mem_readbk          : out std_logic_vector(15 downto 0);
      out_mem_w_en             : in  std_logic;
      out_mem_readbk           : out std_logic_vector(31 downto 0);
      stop_sequence            : in  std_logic;
      step_sequence            : in  std_logic;
      op_code_error_reset      : in  std_logic;
      op_code_error            : out std_logic;
      op_code_error_add        : out std_logic_vector(9 downto 0);
      sequencer_busy           : out std_logic;
      sequencer_out            : out std_logic_vector(31 downto 0);
      end_sequence             : out std_logic
      );
  end component;

  component sequencer_aligner_shifter_top is
    generic(start_adc_bit : natural := 12);
    port (
      clk           : in  std_logic;
      reset         : in  std_logic;
      shift_on_en   : in  std_logic;
      shift_on      : in  std_logic;
      init_shift    : in  std_logic;
      sequencer_in  : in  std_logic_vector(31 downto 0);
      shift_on_out  : out std_logic;
      sequencer_out : out std_logic_vector(31 downto 0)
      );
  end component;

  component ADC_data_handler_v4 is
    port (
      reset             : in  std_logic;
      clk               : in  std_logic;
      testmode_rst      : in  std_logic;
      testmode_col      : in  std_logic;
      start_of_img      : in  std_logic;  -- this signal is generated by the user (using the sequencer) and has to arrive before the first trigger
      end_of_img        : in  std_logic;  -- this signal is generated by the user (using the sequencer) and has to arrive after the last  ADC trasfer
      end_sequence      : in  std_logic;  -- this signal is the end of sequence generated by the sequencer and is used as a timeot to generate EOF.
      trigger           : in  std_logic;  -- this signal start the operations (ADC conv and send data to PGP)
      en_test_mode      : in  std_logic;  -- register enable for pattern test mode
      test_mode_in      : in  std_logic;  -- test mode in 
      en_load_ccd_sel   : in  std_logic;  -- register enable for CCD enable
      ccd_sel_in        : in  std_logic_vector(2 downto 0);  -- register to select which CCD acquire (1, 2 or 3) 
      ccd_sel_out       : out std_logic_vector(2 downto 0);  -- register to select which CCD acquire (1, 2 or 3) 
      SOT               : out std_logic;  -- Start of Image
      EOT               : out std_logic;  -- End of Image
      write_enable      : out std_logic;  -- signal to write the image in the PGP
      test_mode_enb_out : out std_logic;
      data_out          : out std_logic_vector(17 downto 0);  -- 18 bits ADC word 
      adc_data_ccd_1    : in  std_logic_vector(15 downto 0);  -- CCD ADC data 
      adc_cnv_ccd_1     : out std_logic;  -- ADC conv
      adc_sck_ccd_1     : out std_logic;  -- ADC serial clock
      adc_data_ccd_2    : in  std_logic_vector(15 downto 0);  -- CCD ADC data 
      adc_cnv_ccd_2     : out std_logic;  -- ADC conv
      adc_sck_ccd_2     : out std_logic;  -- ADC serial clock
      adc_data_ccd_3    : in  std_logic_vector(15 downto 0);  -- CCD ADC data 
      adc_cnv_ccd_3     : out std_logic;  -- ADC conv
      adc_sck_ccd_3     : out std_logic   -- ADC serial clock
      );
  end component;

  component aspic_3_spi_link_top_mux is
    port (
      clk                : in  std_logic;
      reset              : in  std_logic;
      start_link_trans   : in  std_logic;
      start_reset        : in  std_logic;
      miso_ccd1          : in  std_logic;
      miso_ccd2          : in  std_logic;
      miso_ccd3          : in  std_logic;
      word2send          : in  std_logic_vector(31 downto 0);
      aspic_mosi         : out std_logic;
      ss_t_ccd1          : out std_logic;
      ss_t_ccd2          : out std_logic;
      ss_t_ccd3          : out std_logic;
      ss_b_ccd1          : out std_logic;
      ss_b_ccd2          : out std_logic;
      ss_b_ccd3          : out std_logic;
      aspic_sclk         : out std_logic;
      aspic_n_reset      : out std_logic;
      busy               : out std_logic;
      d_slave_ready_ccd1 : out std_logic;
      d_slave_ready_ccd2 : out std_logic;
      d_slave_ready_ccd3 : out std_logic;
      d_from_slave_ccd1  : out std_logic_vector(15 downto 0);
      d_from_slave_ccd2  : out std_logic_vector(15 downto 0);
      d_from_slave_ccd3  : out std_logic_vector(15 downto 0)
      );
  end component;

  component ad53xx_DAC_top
    port (
      clk         : in  std_logic;
      reset       : in  std_logic;
      start_write : in  std_logic;
      start_ldac  : in  std_logic;
      d_to_slave  : in  std_logic_vector(15 downto 0);
      mosi        : out std_logic;
      ss          : out std_logic;
      sclk        : out std_logic;
      ldac        : out std_logic);
  end component;

  component dual_ad53xx_DAC_top is
    port (
      clk         : in  std_logic;
      reset       : in  std_logic;
      start_write : in  std_logic;
      start_ldac  : in  std_logic;
      d_to_slave  : in  std_logic_vector(16 downto 0);
      mosi        : out std_logic;
      ss_dac_0    : out std_logic;
      ss_dac_1    : out std_logic;
      sclk        : out std_logic;
      ldac        : out std_logic
      );
  end component;

  component ltc2945_multi_read_top_greb is
    port (
      clk                   : in    std_logic;
      reset                 : in    std_logic;
      start_procedure       : in    std_logic;
      busy                  : out   std_logic;
      error_V_HTR_voltage   : out   std_logic;
      V_HTR_voltage_out     : out   std_logic_vector(15 downto 0);
      error_V_HTR_current   : out   std_logic;
      V_HTR_current_out     : out   std_logic_vector(15 downto 0);
      error_V_DREB_voltage  : out   std_logic;
      V_DREB_voltage_out    : out   std_logic_vector(15 downto 0);
      error_V_DREB_current  : out   std_logic;
      V_DREB_current_out    : out   std_logic_vector(15 downto 0);
      error_V_CLK_H_voltage : out   std_logic;
      V_CLK_H_voltage_out   : out   std_logic_vector(15 downto 0);
      error_V_CLK_H_current : out   std_logic;
      V_CLK_H_current_out   : out   std_logic_vector(15 downto 0);
      error_V_OD_voltage    : out   std_logic;
      V_OD_voltage_out      : out   std_logic_vector(15 downto 0);
      error_V_OD_current    : out   std_logic;
      V_OD_current_out      : out   std_logic_vector(15 downto 0);
      error_V_ANA_voltage   : out   std_logic;
      V_ANA_voltage_out     : out   std_logic_vector(15 downto 0);
      error_V_ANA_current   : out   std_logic;
      V_ANA_current_out     : out   std_logic_vector(15 downto 0);
      sda                   : inout std_logic;  --serial data output of i2c bus
      scl                   : inout std_logic  --serial clock output of i2c bus
      );
  end component;

  component adt7420_temp_multiread_2_top is
    port (
      clk             : in    std_logic;
      reset           : in    std_logic;
      start_procedure : in    std_logic;
      busy            : out   std_logic;
      error_T1        : out   std_logic;
      T1_out          : out   std_logic_vector(15 downto 0);
      error_T2        : out   std_logic;
      T2_out          : out   std_logic_vector(15 downto 0);
      sda             : inout std_logic;  --serial data output of i2c bus
      scl             : inout std_logic   --serial clock output of i2c bus
      );
  end component;

  component adt7420_temp_multiread_4_top is
    port (
      clk             : in    std_logic;
      reset           : in    std_logic;
      start_procedure : in    std_logic;
      busy            : out   std_logic;
      error_T1        : out   std_logic;
      T1_out          : out   std_logic_vector(15 downto 0);
      error_T2        : out   std_logic;
      T2_out          : out   std_logic_vector(15 downto 0);
      error_T3        : out   std_logic;
      T3_out          : out   std_logic_vector(15 downto 0);
      error_T4        : out   std_logic;
      T4_out          : out   std_logic_vector(15 downto 0);
      sda             : inout std_logic;  --serial data output of i2c bus
      scl             : inout std_logic   --serial clock output of i2c bus 
      );
  end component;

  component generic_reg_ce_init is
    generic (width : integer);
    port (
      reset    : in  std_logic;         -- syncronus reset
      clk      : in  std_logic;         -- clock
      ce       : in  std_logic;         -- clock enable
      init     : in  std_logic;  -- signal to reset the reg (active high)
      data_in  : in  std_logic_vector(width downto 0);   -- data in
      data_out : out std_logic_vector(width downto 0));  -- data out
  end component;

  component ad7794_top is
    port (
      clk             : in  std_logic;
      reset           : in  std_logic;
      start           : in  std_logic;
      start_reset     : in  std_logic;
      read_write      : in  std_logic;
      ad7794_dout_rdy : in  std_logic;
      reg_add         : in  std_logic_vector(2 downto 0);
      d_to_slave      : in  std_logic_vector(15 downto 0);
      ad7794_din      : out std_logic;
      ad7794_cs       : out std_logic;
      ad7794_sclk     : out std_logic;
      busy            : out std_logic;
      d_from_slave    : out std_logic_vector(23 downto 0)
      );
  end component;

  component max_11046_multiple_top
    generic (
      num_adc_on_bus : integer := 3);   -- number of ADC on the same bus
    port (
      clk              : in  std_logic;
      reset            : in  std_logic;
      start_write      : in  std_logic;
      start_read       : in  std_logic;
      EOC_ck           : in  std_logic;
      EOC_ccd1         : in  std_logic;
      EOC_ccd2         : in  std_logic;
      data_to_adc      : in  std_logic_vector(5 downto 0);
      data_from_adc    : in  std_logic_vector(15 downto 0);
      link_busy        : out std_logic;
      CS_ck            : out std_logic;
      CS_ccd1          : out std_logic;
      CS_ccd2          : out std_logic;
      RD               : out std_logic;
      WR               : out std_logic;
      CONVST_ck        : out std_logic;
      CONVST_ccd1      : out std_logic;
      CONVST_ccd2      : out std_logic;
      SHDN_ck          : out std_logic;
      SHDN_ccd1        : out std_logic;
      SHDN_ccd2        : out std_logic;
      write_en         : out std_logic;
      data_to_adc_out  : out std_logic_vector(3 downto 0);
      cnv_results_ck   : out array816;
      cnv_results_ccd1 : out array816;
      cnv_results_ccd2 : out array816);
  end component;

  component dual_ads1118_top
    port (
      clk           : in  std_logic;
      reset         : in  std_logic;
      start_read    : in  std_logic;
      device_select : in  std_logic;
      miso          : in  std_logic;
      mosi          : out std_logic;
      ss_adc_1      : out std_logic;
      ss_adc_2      : out std_logic;
      sclk          : out std_logic;
      link_busy     : out std_logic;
      data_from_adc : out array432);
  end component;

  component onewire_iface
    generic (
      CheckCRC   : boolean;
      ADD_PULLUP : boolean;
      CLK_DIV    : integer range 0 to 12);
    port (
      sys_clk     : in    std_logic;    -- system clock (50Mhz)
      latch_reset : in    std_logic;
      sys_reset   : in    std_logic;    -- active high syn. reset 
      dq          : inout std_logic;    -- connect to the 1-wire bus
      dev_error   : out   std_logic;
      data        : out   std_logic_vector(7 downto 0);    -- data output
      data_valid  : out   std_logic;    -- data output valid (20us strobe)
      crc_ok      : out   std_logic;    -- crc ok signal (active high)
      timeout     : out   std_logic;    -- timeout signal ~10ms
      sn_data     : out   std_logic_vector(47 downto 0));  -- parallel out
  end component;

  component ff_ce is
    port (
      reset    : in  std_logic;         -- syncronus reset
      clk      : in  std_logic;         -- clock
      data_in  : in  std_logic;         -- data in
      ce       : in  std_logic;         -- clock enable
      data_out : out std_logic);        -- data out
  end component;

  component ff_ce_pres is
    port (
      preset   : in  std_logic;
      clk      : in  std_logic;
      data_in  : in  std_logic;
      ce       : in  std_logic;
      data_out : out std_logic
      ); 
  end component;

  component led_blink is
    port (
      clk_in  : in  std_logic;
      led_out : out std_logic);
  end component;

  component multiboot_fsm is
    port (
      TRIGGER : in std_logic;
      SYSCLK  : in std_logic
      );
  end component;

  component dcm_user_clk
    port
      (                                 -- Clock in ports
        CLK_IN1  : in  std_logic;
        -- Clock out ports
        CLK_OUT1 : out std_logic;
        CLK_OUT2 : out std_logic;

        -- Status and control signals
        LOCKED : out std_logic
        );
  end component;

-- Clocks
--      signal pgpRefClk                : std_logic;
  signal pgpRefClk       : std_logic;
  signal stable_clk      : std_logic;
  signal stable_reset    : std_logic;
  signal stable_clk_lock : std_logic;
  signal usrClk          : std_logic;
  signal clk_100_Mhz     : std_logic;
  signal clk_50_Mhz      : std_logic;

-- Reset
  signal n_rst      : std_logic;
  signal usrRst     : std_logic;
  --signal pgp_usr_rst : std_logic;
  signal sync_res   : std_logic;
  signal sync_res_1 : std_logic;
  signal sync_res_2 : std_logic;

-- SCI signals
  signal pgpLocLinkReady : std_logic;
  signal pgpRemLinkReady : std_logic;
  signal regReq          : std_logic;
  signal regOp           : std_logic;
  signal RegAddr         : std_logic_vector(23 downto 0);
  signal RegDataWr       : std_logic_vector(31 downto 0);
  signal regAck          : std_logic;
  signal regFail         : std_logic;
  signal RegDataRd       : std_logic_vector(31 downto 0);
  signal RegWrEn         : std_logic_vector(31 downto 0);
  signal dataWrEn        : std_logic;
  signal dataSOT         : std_logic;
  signal dataEOT         : std_logic;
  signal image_in        : std_logic_vector(17 downto 0);
  signal StatusAddr      : std_logic_vector(23 downto 0);
  signal StatusReg       : std_logic_vector(31 downto 0);
  signal StatusRst       : std_logic;

-- CMD interpreter signals
  signal regDataWr_masked   : std_logic_vector(31 downto 0);
  signal busy_bus           : std_logic_vector(31 downto 0);
  signal trigger_ce_bus     : std_logic_vector(31 downto 0);
  signal trigger_val_bus    : std_logic_vector(31 downto 0);
  signal load_time_base_lsw : std_logic;
  signal load_time_base_MSW : std_logic;
  signal cnt_preset         : std_logic_vector(63 downto 0);

  -- sync commands signals
  signal sync_cmd_en         : std_logic;
  signal sync_cmd_in         : std_logic_vector(7 downto 0);
  signal sync_cmd_out        : std_logic_vector(7 downto 0);
  signal sync_cmd_delay_en   : std_logic;
  signal sync_cmd_mask_en    : std_logic;
  signal sync_cmd_delay_read : std_logic_vector(7 downto 0);
  signal sync_cmd_mask_read  : std_logic_vector(31 downto 0);


  -- BRS signals
  signal time_base_actual_value : std_logic_vector(63 downto 0);
  signal trig_tm_value_SB       : std_logic_vector(63 downto 0);
  signal trig_tm_value_TB       : std_logic_vector(63 downto 0);
  signal trig_tm_value_seq      : std_logic_vector(63 downto 0);
  signal trig_tm_value_V_I      : std_logic_vector(63 downto 0);
  signal trig_tm_value_pcb_t    : std_logic_vector(63 downto 0);
--  signal trig_tm_value_fast_adc : std_logic_vector(63 downto 0);
  signal time_base_busy         : std_logic;

  -- sequencer signals
  signal sequencer_busy           : std_logic;
  signal seq_time_mem_readbk      : std_logic_vector(15 downto 0);
  signal seq_out_mem_readbk       : std_logic_vector(31 downto 0);
  signal seq_prog_mem_readbk      : std_logic_vector(31 downto 0);
  signal seq_time_mem_w_en        : std_logic;
  signal seq_out_mem_w_en         : std_logic;
  signal seq_prog_mem_w_en        : std_logic;
  signal seq_start                : std_logic;
  signal seq_step                 : std_logic;
  signal seq_stop                 : std_logic;
  signal sequencer_outputs        : std_logic_vector(31 downto 0);
  signal sequencer_outputs_int    : std_logic_vector(31 downto 0);
  signal enable_conv_shift        : std_logic;
  signal enable_conv_shift_out    : std_logic;
  signal init_conv_shift          : std_logic;
  signal end_sequence             : std_logic;
  signal start_add_prog_mem_en    : std_logic;
  signal start_add_prog_mem_rbk   : std_logic_vector(9 downto 0);
  signal seq_ind_func_mem_we      : std_logic;
  signal seq_ind_func_mem_rdbk    : std_logic_vector(3 downto 0);
  signal seq_ind_rep_mem_we       : std_logic;
  signal seq_ind_rep_mem_rdbk     : std_logic_vector(23 downto 0);
  signal seq_ind_sub_add_mem_we   : std_logic;
  signal seq_ind_sub_add_mem_rdbk : std_logic_vector(9 downto 0);
  signal seq_ind_sub_rep_mem_we   : std_logic;
  signal seq_ind_sub_rep_mem_rdbk : std_logic_vector(15 downto 0);
  signal seq_op_code_error        : std_logic;
  signal seq_op_code_error_reset  : std_logic;
  signal seq_op_code_error_add    : std_logic_vector(9 downto 0);

-- ASPIC config signals
  signal aspic_start_trans    : std_logic;
  signal aspic_start_reset    : std_logic;
  signal aspic_busy           : std_logic;
  signal aspic_config_r_ccd_1 : std_logic_vector (15 downto 0);
  signal aspic_config_r_ccd_2 : std_logic_vector (15 downto 0);
--      signal aspic_config_r_ccd_3     : std_logic_vector (15 downto 0);
  signal ASPIC_mosi_int       : std_logic;
  signal ASPIC_sclk_int       : std_logic;
  signal ASPIC_miso_ccd_1     : std_logic;
  signal aspic_miso_sel_ccd_1 : std_logic;
  signal ASPIC_miso_ccd_2     : std_logic;
  signal aspic_miso_sel_ccd_2 : std_logic;


  signal aspic_nap_mode_en    : std_logic;
  signal aspic_nap_mode_ccd_1 : std_logic;
  signal aspic_nap_mode_ccd_2 : std_logic;


-- ASPIC CCD 1
  signal ASPIC_r_up_ccd_1   : std_logic;
  signal ASPIC_r_down_ccd_1 : std_logic;
  signal ASPIC_clamp_ccd_1  : std_logic;
  signal ASPIC_reset_ccd_1  : std_logic;

-- CCD 1 signals
  signal par_clk_ccd_1    : std_logic_vector(3 downto 0);
  signal ser_clk_ccd_1    : std_logic_vector(2 downto 0);
  signal reset_gate_ccd_1 : std_logic;
--   signal adc_data_ccd_1                      : std_logic_vector(15 downto 0); 

  -- ASPIC CCD 2
  signal ASPIC_r_up_ccd_2   : std_logic;
  signal ASPIC_r_down_ccd_2 : std_logic;
  signal ASPIC_clamp_ccd_2  : std_logic;
  signal ASPIC_reset_ccd_2  : std_logic;

-- CCD 2 signals
  signal par_clk_ccd_2    : std_logic_vector(3 downto 0);
  signal ser_clk_ccd_2    : std_logic_vector(2 downto 0);
  signal reset_gate_ccd_2 : std_logic;

-- Image handler signals
  signal image_size        : std_logic_vector(31 downto 0);
  signal image_patter_read : std_logic;
  signal image_size_en     : std_logic;
  signal image_patter_en   : std_logic;
  signal ADC_trigger       : std_logic;
--      signal CCD_sel_en                               : std_logic;
  signal CCD_sel           : std_logic_vector(2 downto 0);
  signal start_of_img      : std_logic;
  signal end_of_img        : std_logic;
  signal pattern_reset     : std_logic;

-- CCD clock rails DAC                  
  signal clk_rail_load_start : std_logic;
  signal clk_rail_ldac_start : std_logic;


-- CABAC bias
  signal c_bias_load_start : std_logic;
  signal c_bias_ldac_start : std_logic;

-- ltc2945 V & I sensors read
  signal V_I_read_start        : std_logic;
  signal V_I_busy              : std_logic;
  signal error_V_HTR_voltage   : std_logic;
  signal V_HTR_voltage         : std_logic_vector(15 downto 0);
  signal error_V_HTR_current   : std_logic;
  signal V_HTR_current         : std_logic_vector(15 downto 0);
  signal error_V_DREB_voltage  : std_logic;
  signal V_DREB_voltage        : std_logic_vector(15 downto 0);
  signal error_V_DREB_current  : std_logic;
  signal V_DREB_current        : std_logic_vector(15 downto 0);
  signal error_V_CLK_H_voltage : std_logic;
  signal V_CLK_H_voltage       : std_logic_vector(15 downto 0);
  signal error_V_CLK_H_current : std_logic;
  signal V_CLK_H_current       : std_logic_vector(15 downto 0);
  signal error_V_OD_voltage    : std_logic;
  signal V_OD_voltage          : std_logic_vector(15 downto 0);
  signal error_V_OD_current    : std_logic;
  signal V_OD_current          : std_logic_vector(15 downto 0);
  signal error_V_ANA_voltage   : std_logic;
  signal V_ANA_voltage         : std_logic_vector(15 downto 0);
  signal error_V_ANA_current   : std_logic;
  signal V_ANA_current         : std_logic_vector(15 downto 0);


-- PCB temperature
  signal temp_read_start : std_logic;
  signal temp_busy       : std_logic;

-- DREB temperature
  signal DREB_temp_busy : std_logic;
  signal T1_dreb        : std_logic_vector(15 downto 0);
  signal T1_dreb_error  : std_logic;
  signal T2_dreb        : std_logic_vector(15 downto 0);
  signal T2_dreb_error  : std_logic;

--REB temperature gr1
  signal REB_temp_busy_gr1 : std_logic;
  signal T1_reb_gr1        : std_logic_vector(15 downto 0);
  signal T1_reb_gr1_error  : std_logic;
  signal T2_reb_gr1        : std_logic_vector(15 downto 0);
  signal T2_reb_gr1_error  : std_logic;
  signal T3_reb_gr1        : std_logic_vector(15 downto 0);
  signal T3_reb_gr1_error  : std_logic;
  signal T4_reb_gr1        : std_logic_vector(15 downto 0);
  signal T4_reb_gr1_error  : std_logic;

-- ASPIC temp and voltage monitor
  signal aspic_t_v_data    : array432;
  signal aspic_t_v_start_r : std_logic;
  signal aspic_t_v_busy    : std_logic;


-- CCD temperature 
  signal ccd_temp_busy        : std_logic;
  signal ccd_temp             : std_logic_vector(23 downto 0);
  signal ccd_temp_start       : std_logic;
  signal ccd_temp_start_reset : std_logic;

-- slow adc

  signal slow_adc_busy              : std_logic;
  signal ck_adc_conv_res            : array816;
  signal ccd1_adc_conv_res          : array816;
  signal ccd2_adc_conv_res          : array816 := (others => (others => '0'));
  signal slow_adc_start_read        : std_logic;
  signal slow_adc_start_write       : std_logic;
  signal slow_adc_write_en          : std_logic;
  signal slow_adc_data_to_adc_out   : std_logic_vector(3 downto 0);
  signal slow_adc_data_from_adc_int : std_logic_vector(15 downto 0);

-- REB 1wire serial number
  signal reb_onewire_reset      : std_logic;
  signal reb_onewire_reset_lock : std_logic;
  signal reb_sn_crc_ok          : std_logic;
  signal reb_sn_dev_error       : std_logic;
  signal reb_sn                 : std_logic_vector(47 downto 0);
  signal reb_sn_timeout         : std_logic;

-- CCD clock enable
  signal ccd1_clk_en_out_int : std_logic;
  signal ccd2_clk_en_out_int : std_logic;
  signal ccd_clk_en          : std_logic;

-- ASPIC reference enable
  signal aspic_ref_en_out_int_ccd1 : std_logic;
  signal aspic_ref_en_out_int_ccd2 : std_logic;
  signal aspic_ref_en              : std_logic;

  -- ASPIC 5V enable
  signal aspic_5v_en_out_int_ccd1 : std_logic;
  signal aspic_5v_en_out_int_ccd2 : std_logic;
  signal aspic_5v_en              : std_logic;

-- CABAC regulators enable
  signal CABAC_reg_in : std_logic_vector(4 downto 0);
  signal CABAC_reg_en : std_logic;

------ MISC ------
-- test led
  signal test_led_int : std_logic_vector(2 downto 0);
  signal dcm_locked   : std_logic;
  signal test_port    : std_logic_vector(3 downto 0);

-- CABAC_pulse
  signal cabac_pulse_ccd_1 : std_logic;
  signal cabac_pulse_ccd_2 : std_logic;

-- back bias switch signals
  signal en_back_bias_sw     : std_logic;
  signal back_bias_sw_int    : std_logic;
  signal back_bias_clamp_int : std_logic;

-- this line enables the output buffers 
  signal enable_io : std_logic;

  signal ASPIC_ss_t_ccd_1_int : std_logic;
  signal ASPIC_ss_b_ccd_1_int : std_logic;
  signal ASPIC_ss_t_ccd_2_int : std_logic;
  signal ASPIC_ss_b_ccd_2_int : std_logic;
  signal ASPIC_spi_reset      : std_logic;

  -- multiboot
  signal start_multiboot : std_logic;
  signal mb_en           : std_logic;
  signal mb_en_1         : std_logic;
  signal mb_en_2         : std_logic;

  signal LTC2945_SDA_int    : std_logic;
  signal LTC2945_SCL_int    : std_logic;
  signal test_i2c           : std_logic;
  signal reb_sn_onewire_int : std_logic;

  signal adc_cnv_ccd_1_int : std_logic;
  signal adc_sck_ccd_1_int : std_logic;

  signal ASPIC_spi_mosi_int : std_logic;
  signal ASPIC_spi_sclk_int : std_logic;

  signal gpio_0_int : std_logic;
  signal gpio_1_int : std_logic;

  signal aspic_t_v_mosi_int    : std_logic;
  signal aspic_t_v_ss_ccd1_int : std_logic;
  signal aspic_t_v_ss_ccd2_int : std_logic;
  signal aspic_t_v_sclk_int    : std_logic;

   constant TPD_C : time := 1 ns;
  

begin


  test_led_int(0) <= pgpLocLinkReady;
  test_led_int(1) <= pgpRemLinkReady;


  regDataWr_masked         <= regDataWr and regWrEn;
  StatusAddr(23 downto 10) <= (others => '0');
  StatusAddr(9 downto 0)   <= regAddr(9 downto 0);

  busy_bus <= x"000000" & "000" & temp_busy & V_I_busy & sequencer_busy & time_base_busy & '0';


-- trigger signals
  seq_start       <= (trigger_val_bus(2) and trigger_ce_bus(2)) or sync_cmd_out(0);
  V_I_read_start  <= trigger_val_bus(3) and trigger_ce_bus(3);
  temp_read_start <= trigger_val_bus(4) and trigger_ce_bus(4);
--  fast_adc_start  <= trigger_val_bus(5) and trigger_ce_bus(5);

-- temperature signals
  temp_busy <= DREB_temp_busy or REB_temp_busy_gr1;


  ASPIC_spi_mosi_ccd_1  <= ASPIC_mosi_int;
  ASPIC_spi_sclk_ccd_1  <= ASPIC_sclk_int;
  ASPIC_spi_reset_ccd_1 <= ASPIC_spi_reset;


  aspic_miso_sel_ccd_1 <= ASPIC_ss_t_ccd_1_int and (not ASPIC_ss_b_ccd_1_int);
  ASPIC_miso_ccd_1     <= ASPIC_spi_miso_t_ccd_1 when ASPIC_miso_sel_ccd_1 = '0' else ASPIC_spi_miso_b_ccd_1;

------------ Chips and video ADC NAP mode lines ------------ 

  ASPIC_nap_ccd_1   <= aspic_nap_mode_ccd_1;  -- nap mode activated =1
  adc_buff_pd_ccd_1 <= '1';


------------ Sequencer's signals assignment ------------
-- CCD 1
  ASPIC_r_up_ccd_1   <= CCD_sel(0) and (not sequencer_outputs(0));
  ASPIC_r_down_ccd_1 <= CCD_sel(0) and (not sequencer_outputs(1));
  ASPIC_reset_ccd_1  <= sequencer_outputs(2) and CCD_sel(0);
  ASPIC_clamp_ccd_1  <= sequencer_outputs(3) and CCD_sel(0);

  ser_clk_ccd_1(0) <= sequencer_outputs(4) and CCD_sel(0);
  ser_clk_ccd_1(1) <= sequencer_outputs(5) and CCD_sel(0);
  ser_clk_ccd_1(2) <= sequencer_outputs(6) and CCD_sel(0);
  reset_gate_ccd_1 <= sequencer_outputs(7) and CCD_sel(0);

  par_clk_ccd_1(0) <= sequencer_outputs(8) and CCD_sel(0);
  par_clk_ccd_1(1) <= sequencer_outputs(9) and CCD_sel(0);
  par_clk_ccd_1(2) <= sequencer_outputs(10) and CCD_sel(0);
  par_clk_ccd_1(3) <= sequencer_outputs(11) and CCD_sel(0);

  ADC_trigger       <= sequencer_outputs(12);
  start_of_img      <= sequencer_outputs(13);
  end_of_img        <= sequencer_outputs(14);
  cabac_pulse_ccd_1 <= sequencer_outputs(15);
  pattern_reset     <= sequencer_outputs(16);

  gpio_0_int <= sequencer_outputs(16);
  gpio_1_int <= sequencer_outputs(17);

------------ assignment for test ------------
--      test_port(10 downto 0)  <= sequencer_outputs(10 downto 0);
--      test_port(11)                           <= sequencer_outputs(12);
--      test_port(12)                           <= sequencer_outputs(16); 
  test_port(2) <= sequencer_outputs_int(12);


------------ misc ------------
  enable_io <= '0';                     -- 1 = disable 

  ASPIC_ss_t_ccd_1 <= ASPIC_ss_t_ccd_1_int;
  ASPIC_ss_b_ccd_1 <= ASPIC_ss_b_ccd_1_int;

  LTC2945_SDA    <= LTC2945_SDA_int;
  LTC2945_SCL    <= LTC2945_SCl_int;
--  LTC2945_SCl_int <= '1';
  reb_sn_onewire <= reb_sn_onewire_int;

  adc_cnv_ccd_1 <= adc_cnv_ccd_1_int;
  adc_sck_ccd_1 <= adc_sck_ccd_1_int;

  aspic_t_v_mosi    <= aspic_t_v_mosi_int;
  aspic_t_v_ss_ccd1 <= aspic_t_v_ss_ccd1_int;
  aspic_t_v_sclk    <= aspic_t_v_sclk_int;





  U_LocRefClkIbufds : IBUFDS_GTE2
    port map (
      I     => PgpRefClk_P,
      IB    => PgpRefClk_M,
      CEB   => '0',
      O     => PgpRefClk,
      ODIV2 => open);


  ClockManager_local_100MHz : entity work.ClockManager7
    generic map (
      TPD_G              => TPD_C,
      TYPE_G             => "MMCM",
      INPUT_BUFG_G       => true,
      FB_BUFG_G          => true,
      OUTPUT_BUFG_G      => false,
      RST_IN_POLARITY_G  => '1',
      NUM_CLOCKS_G       => 1,
      BANDWIDTH_G        => "OPTIMIZED",
      CLKIN_PERIOD_G     => 4.0,
      DIVCLK_DIVIDE_G    => 1,
      CLKFBOUT_MULT_F_G  => 4.000,
      CLKOUT0_DIVIDE_F_G => 10.000,
      CLKOUT0_RST_HOLD_G => 8)
    port map (
      clkIn     => PgpRefClk,
      rstIn     => '0',
      clkOut(0) => stable_clk,
      locked    => stable_clk_lock,
      rstOut(0) => open);


  LsstSci_0 : LsstSci
    port map (
      -------------------------------------------------------------------------
      -- FPGA Interface
      -------------------------------------------------------------------------


      StableClk => stable_clk,
      StableRst => '0',                 -- not used

      FpgaRstL => n_rst,

      PgpRefClk => PgpRefClk,


      PgpRxP => PgpRx_p,
      PgpRxM => PgpRx_m,
      PgpTxP => PgpTx_p,
      PgpTxM => PgpTx_m,
      -------------------------------------------------------------------------
      -- Clock/Reset Generator Interface
      -------------------------------------------------------------------------
      ClkOut => usrClk,
      RstOut => usrRst,
      ClkIn  => clk_100_Mhz,
      RstIn  => sync_res,

      -------------------------------------------------------------------------
      -- SCI Register Encoder/Decoder Interface
      -------------------------------------------------------------------------
      RegAddr   => RegAddr,
      RegReq    => regReq,
      RegOp     => regOp,
      RegDataWr => RegDataWr,
      RegWrEn   => RegWrEn,
      RegAck    => regAck,
      RegFail   => regFail,
      RegDataRd => RegDataRd,
      -------------------------------------------------------------------------
      -- Data Encoder Interface
      -------------------------------------------------------------------------
      DataWrEn  => dataWrEn,
      DataSOT   => dataSOT,
      DataEOT   => dataEOT,
      DataIn    => image_in,

      -------------------------------------------------------------------------
      -- Notification Interface
      -------------------------------------------------------------------------
      NoticeEn => '0',
      Notice   => (others => '0'),

      -------------------------------------------------------------------------
      -- Synchronous Command Interface
      -------------------------------------------------------------------------
      SyncCmdEn => sync_cmd_en,
      SyncCmd   => sync_cmd_in,

      -------------------------------------------------------------------------
      -- Status Block Interface
      -------------------------------------------------------------------------
      StatusAddr => StatusAddr,
      StatusReg  => StatusReg,
      StatusRst  => StatusRst,

      -------------------------------------------------------------------------
      -- Debug Interface
      -------------------------------------------------------------------------
      PgpLocLinkReadyOut => pgpLocLinkReady,
      PgpRemLinkReadyOut => pgpRemLinkReady,
      PgpRxPhyReadyOut   => open,
      PgpTxPhyReadyOut   => open
      );





















  --LsstSci_0 : LsstSci
  --   port map (
  --     -------------------------------------------------------------------------
  --     -- FPGA Interface
  --     -------------------------------------------------------------------------
  --     FpgaRstL => n_rst,

  --     PgpClkP => PgpRefClk_P,
  --     PgpClkM => PgpRefClk_M,
  --     PgpRxP  => PgpRx_p,
  --     PgpRxM  => PgpRx_m,
  --     PgpTxP  => PgpTx_p,
  --     PgpTxM  => PgpTx_m,
  --     -------------------------------------------------------------------------
  --     -- Clock/Reset Generator Interface
  --     -------------------------------------------------------------------------
  --     ClkOut  =>  pgp_usr_clk,
  --     RstOut  => pgp_usr_rst,
  --     ClkIn   => clk_100_Mhz,
  --     RstIn   => sync_res,
  --     -------------------------------------------------------------------------
  --     -- SCI Register Encoder/Decoder Interface
  --     -------------------------------------------------------------------------
  --     RegAddr   => RegAddr,
  --     RegReq    => regReq,
  --     RegOp     => regOp,
  --     RegDataWr => RegDataWr,
  --     RegWrEn   => RegWrEn,
  --     RegAck    => regAck,
  --     RegFail   => regFail,
  --     RegDataRd => RegDataRd,
  --     -------------------------------------------------------------------------
  --     -- Data Encoder Interface
  --     -------------------------------------------------------------------------
  --     DataWrEn  => dataWrEn,
  --     DataSOT   => dataSOT,
  --     DataEOT   => dataEOT,
  --     DataIn    => image_in,

  --     -------------------------------------------------------------------------
  --     -- Notification Interface
  --     -------------------------------------------------------------------------
  --     NoticeEn => '0',
  --     Notice   => (others => '0'),

  --     -------------------------------------------------------------------------
  --     -- Synchronous Command Interface
  --     -------------------------------------------------------------------------
  --     SyncCmdEn => open,
  --     SyncCmd   => open,

  --     -------------------------------------------------------------------------
  --     -- Status Block Interface
  --     -------------------------------------------------------------------------
  --     StatusAddr => StatusAddr,
  --     StatusReg  => StatusReg,
  --     StatusRst  => StatusRst,

  --     -------------------------------------------------------------------------
  --     -- Debug Interface
  --     -------------------------------------------------------------------------
  --     PgpLocLinkReadyOut => pgpLocLinkReady,
  --     PgpRemLinkReadyOut => pgpRemLinkReady
  --     );


  wreb_v3_cmd_interpeter_0 : wreb_v3_cmd_interpeter
    port map (
      reset                    => sync_res,
      clk                      => clk_100_MHz,
-- signals from/to SCI
      regReq                   => regReq,  -- with this line the master start a read/write procedure (1 to start)
      regOp                    => regOp,  -- this line define if the procedure is read or write (1 to write)
      regAddr                  => RegAddr,  -- address bus
      statusReg                => StatusReg,  -- status reg bus. The RCI handle this bus and this machine pass it to the sure if he wants to read it
      regWrEn                  => RegWrEn,  -- write enable bus. This bus enables the data write bits
      regDataWr_masked         => regDataWr_masked,  -- data write bus masked. Is the logical AND of data write bus and write enable bus
      regAck                   => regAck,  -- acknowledge line to activate when the read/write procedure is completed
      regFail                  => regFail,  -- line to activate when an error occurs during the read/write procedure
      regDataRd                => RegDataRd,  -- data bus to RCI used to transfer read data
      StatusReset              => StatusRst,  -- status block reset
-- Base Register Set signals            
      busy_bus                 => busy_bus,  -- busy bus is composed by the different register sets busy
      time_base_actual_value   => time_base_actual_value,  -- time base value 
      trig_tm_value_SB         => trig_tm_value_SB,  -- Status Block trigger time 
      trig_tm_value_TB         => trig_tm_value_TB,  -- Time Base trigger time
      trig_tm_value_seq        => trig_tm_value_seq,  -- Sequencer Trigger time
      trig_tm_value_V_I        => trig_tm_value_V_I,  -- Voltage and current sens trigger time
      trig_tm_value_pcb_t      => trig_tm_value_pcb_t,  -- PCB temperature Trigger time
--      trig_tm_value_f_adc      => trig_tm_value_fast_adc,  -- fast ADC Trigger time
      trigger_ce_bus           => trigger_ce_bus,  -- bus to enable register sets trigger. To trigger a register set that stops itself use en AND val                                      
      trigger_val_bus          => trigger_val_bus,  -- bus of register sets trigger values  
      load_time_base_lsw       => load_time_base_lsw,  -- ce signal to load the time base lsw
      load_time_base_MSW       => load_time_base_MSW,  -- ce signal to load the time base MSW
      cnt_preset               => cnt_preset,  -- preset value for the time base counter
      Mgt_avcc_ok              => '0',
      Mgt_accpll_ok            => '0',
      Mgt_avtt_ok              => '0',
      V3_3v_ok                 => '0',
      Switch_addr              => r_add,
-- sync commands
      sync_cmd_delay_en        => sync_cmd_delay_en,
      sync_cmd_delay_read      => sync_cmd_delay_read,
      sync_cmd_mask_en         => sync_cmd_mask_en,
      sync_cmd_mask_read       => sync_cmd_mask_read,
-- Image parameters
      image_size               => x"00000000",  -- this register contains the image size (no longer used)
      image_patter_read        => image_patter_read,  -- this register gives the state of image patter gen. 1 is ON
      ccd_sel_read             => CCD_sel,  -- this register contains the CCD to drive
      image_size_en            => open,  -- this line enables the register where the image size is written
      image_patter_en          => image_patter_en,  -- this register enable the image patter gen. 1 is ON
      ccd_sel_en               => open,  -- on GREB only first two stripes are active                                                  -- register enable for CCD acquisition selector 
-- Sequencer
      seq_time_mem_readbk      => seq_time_mem_readbk,  -- time memory read bus
      seq_out_mem_readbk       => seq_out_mem_readbk,  -- time memory read bus
      seq_prog_mem_readbk      => seq_prog_mem_readbk,  -- sequencer program memory read
      seq_time_mem_w_en        => seq_time_mem_w_en,  -- this signal enables the time memory write
      seq_out_mem_w_en         => seq_out_mem_w_en,  -- this signal enables the output memory write
      seq_prog_mem_w_en        => seq_prog_mem_w_en,  -- this signal enables the program memory write
      seq_step                 => seq_step,  -- this signal send the STEP to the sequencer. Valid on in infinite loop (the machine jump out from IL to next function)   
      seq_stop                 => seq_stop,  -- this signal send the STOP to the sequencer. Valid on in infinite loop (the machine jump out from IL to next function)
      enable_conv_shift_in     => enable_conv_shift_out,  -- this signal enable the adc_conv shifter (the adc_conv is shifted 1 clk every time is activated)
      enable_conv_shift        => enable_conv_shift,  -- this signal enable the adc_conv shifter (the adc_conv is shifted 1 clk every time is activated)
      init_conv_shift          => init_conv_shift,  -- this signal initialize the adc_conv shifter (the adc_conv is shifted 1 clk every time is activated)
      start_add_prog_mem_en    => start_add_prog_mem_en,
      start_add_prog_mem_rbk   => start_add_prog_mem_rbk,
      seq_ind_func_mem_we      => seq_ind_func_mem_we,
      seq_ind_func_mem_rdbk    => seq_ind_func_mem_rdbk,
      seq_ind_rep_mem_we       => seq_ind_rep_mem_we,
      seq_ind_rep_mem_rdbk     => seq_ind_rep_mem_rdbk,
      seq_ind_sub_add_mem_we   => seq_ind_sub_add_mem_we,
      seq_ind_sub_add_mem_rdbk => seq_ind_sub_add_mem_rdbk,
      seq_ind_sub_rep_mem_we   => seq_ind_sub_rep_mem_we,
      seq_ind_sub_rep_mem_rdbk => seq_ind_sub_rep_mem_rdbk,
      seq_op_code_error        => seq_op_code_error,
      seq_op_code_error_add    => seq_op_code_error_add,
      seq_op_code_error_reset  => seq_op_code_error_reset,

-- ASPIC
      aspic_config_r_ccd_1 => aspic_config_r_ccd_1,
      aspic_config_r_ccd_2 => x"0000",
      aspic_config_r_ccd_3 => x"0000",
      aspic_op_end         => aspic_busy,
      aspic_start_trans    => aspic_start_trans,
      aspic_start_reset    => aspic_start_reset,
      aspic_nap_mode_en    => aspic_nap_mode_en,
      aspic_nap_ccd1_in    => aspic_nap_mode_ccd_1,
--      aspic_nap_ccd2_in    => aspic_nap_mode_ccd_2,

-- CCD clock rails DAC          
      clk_rail_load_start => clk_rail_load_start,
      clk_rail_ldac_start => clk_rail_ldac_start,

--  BIAS DAC (former CABAC bias DAC)                
      c_bias_load_start     => c_bias_load_start,
      c_bias_ldac_start     => c_bias_ldac_start,
-- DREB voltage and current sensors
      error_V_HTR_voltage   => error_V_HTR_voltage,
      V_HTR_voltage         => V_HTR_voltage,
      error_V_HTR_current   => error_V_HTR_current,
      V_HTR_current         => V_HTR_current,
      error_V_DREB_voltage  => error_V_DREB_voltage,
      V_DREB_voltage        => V_DREB_voltage,
      error_V_DREB_current  => error_V_DREB_current,
      V_DREB_current        => V_DREB_current,
      error_V_CLK_H_voltage => error_V_CLK_H_voltage,
      V_CLK_H_voltage       => V_CLK_H_voltage,
      error_V_CLK_H_current => error_V_CLK_H_current,
      V_CLK_H_current       => V_CLK_H_current,
      error_V_OD_voltage    => error_V_OD_voltage,
      V_OD_voltage          => V_OD_voltage,
      error_V_OD_current    => error_V_OD_current,
      V_OD_current          => V_OD_current,
      error_V_ANA_voltage   => error_V_ANA_voltage,
      V_ANA_voltage         => V_ANA_voltage,
      error_V_ANA_current   => error_V_ANA_current,
      V_ANA_current         => V_ANA_current,

-- DREB temperature
      T1_dreb              => T1_dreb,
      T1_dreb_error        => T1_dreb_error,
      T2_dreb              => T2_dreb,
      T2_dreb_error        => T2_dreb_error,
-- REB temperature gr1
      T1_reb_gr1           => T1_reb_gr1,
      T1_reb_gr1_error     => T1_reb_gr1_error,
      T2_reb_gr1           => T2_reb_gr1,
      T2_reb_gr1_error     => T2_reb_gr1_error,
      T3_reb_gr1           => T3_reb_gr1,
      T3_reb_gr1_error     => T3_reb_gr1_error,
      T4_reb_gr1           => T4_reb_gr1,
      T4_reb_gr1_error     => T4_reb_gr1_error,
-- REB temperature gr2
      T1_reb_gr2           => x"0000",
      T1_reb_gr2_error     => '0',
      T2_reb_gr2           => x"0000",
      T2_reb_gr2_error     => '0',
      T3_reb_gr2           => x"0000",
      T3_reb_gr2_error     => '0',
      T4_reb_gr2           => x"0000",
      T4_reb_gr2_error     => '0',
-- REB temperature gr3
      T1_reb_gr3           => x"0000",
      T1_reb_gr3_error     => '0',
-- ASPIC temp and voltage monitor
      aspic_t_v_data       => aspic_t_v_data,
      aspic_t_v_busy       => aspic_t_v_busy,
      aspic_t_v_start_r    => aspic_t_v_start_r,
-- CCD temperature
      ccd_temp_busy        => ccd_temp_busy,
      ccd_temp             => ccd_temp,
      ccd_temp_start       => ccd_temp_start,
      ccd_temp_start_reset => ccd_temp_start_reset,

-- Bias slow ADC
      slow_adc_busy        => slow_adc_busy,
      ck_adc_conv_res      => ck_adc_conv_res,
      ccd1_adc_conv_res    => ccd1_adc_conv_res,
      ccd2_adc_conv_res    => ccd2_adc_conv_res,
      slow_adc_start_read  => slow_adc_start_read,
      slow_adc_start_write => slow_adc_start_write,

-- DREB 1wire serial number
      dreb_onewire_reset   => open,
      dreb_sn_crc_ok       => '0',
      dreb_sn_dev_error    => '0',
      dreb_sn              => x"000000000000",
      dreb_sn_timeout      => '0',
-- REB 1wire serial number
      reb_onewire_reset    => reb_onewire_reset,
      reb_sn_crc_ok        => reb_sn_crc_ok,
      reb_sn_dev_error     => reb_sn_dev_error,
      reb_sn               => reb_sn,
      reb_sn_timeout       => reb_sn_timeout,
-- CCD clock enable
      ccd1_clk_en_in       => ccd1_clk_en_out_int,
      ccd2_clk_en_in       => ccd2_clk_en_out_int,
      ccd_clk_en           => ccd_clk_en,
-- ASPIC reference enable
      aspic_ref_en_in_ccd1 => aspic_ref_en_out_int_ccd1,
      aspic_ref_en_in_ccd2 => aspic_ref_en_out_int_ccd2,
      aspic_ref_en         => aspic_ref_en,
-- ASPIC 5V enable
      aspic_5v_en_in_ccd1  => aspic_5v_en_out_int_ccd1,
      aspic_5v_en_in_ccd2  => aspic_5v_en_out_int_ccd2,
      aspic_5v_en          => aspic_5v_en,
-- CABAC regulators enable 
      CABAC_reg_in         => CABAC_reg_in,
      CABAC_reg_en         => CABAC_reg_en,
-- back bias switch
      back_bias_sw_rb      => back_bias_sw_int,
      back_bias_cl_rb      => back_bias_clamp_int,
      en_back_bias_sw      => en_back_bias_sw,
-- multiboot
      start_multiboot      => start_multiboot
      );

  sync_cmd_decoder_top_1 : sync_cmd_decoder_top
    port map (
      pgp_clk            => usrClk,
      pgp_reset          => usrRst,
      clk                => clk_100_Mhz,
      reset              => sync_res,
      sync_cmd_en        => sync_cmd_en,
      delay_en           => sync_cmd_delay_en,
      sync_cmd_mask_en   => sync_cmd_mask_en,
      delay_in           => regDataWr_masked(7 downto 0),
      delay_read         => sync_cmd_delay_read,
      sync_cmd_mask      => regDataWr_masked,
      sync_cmd_mask_read => sync_cmd_mask_read,
      sync_cmd           => sync_cmd_in,
      sync_cmd_out       => sync_cmd_out);

  base_reg_set : base_reg_set_top
    port map (
      clk                => clk_100_MHz,
      reset              => sync_res,
      en_time_base_cnt   => trigger_ce_bus(1),
      load_time_base_lsw => load_time_base_lsw,
      load_time_base_MSW => load_time_base_MSW,
      StatusReset        => StatusRst,
      trigger_TB         => trigger_val_bus(1),
      trigger_seq        => seq_start,
      trigger_V_I_read   => V_I_read_start,
      trigger_temp_pcb   => temp_read_start,
      trigger_fast_adc   => '0',
      cnt_preset         => cnt_preset,
      cnt_busy           => time_base_busy,
      cnt_actual_value   => time_base_actual_value,
      trig_tm_value_SB   => trig_tm_value_SB,
      trig_tm_value_TB   => trig_tm_value_TB,
      trig_tm_value_seq  => trig_tm_value_seq,
      trig_tm_value_V_I  => trig_tm_value_V_I,
      trig_tm_value_pcb  => trig_tm_value_pcb_t,
      trig_tm_value_adc  => open
      );

  sequencer_v3_0 : sequencer_v3_top
    port map (
      reset                    => sync_res,
      clk                      => clk_100_MHz,
      start_sequence           => seq_start,
      program_mem_we           => seq_prog_mem_w_en,
      seq_mem_w_add            => regAddr(9 downto 0),
      seq_mem_data_in          => regDataWr_masked,
      prog_mem_redbk           => seq_prog_mem_readbk,
      program_mem_init_en      => start_add_prog_mem_en,
      program_mem_init_add_rbk => start_add_prog_mem_rbk,
      ind_func_mem_we          => seq_ind_func_mem_we,
      ind_func_mem_redbk       => seq_ind_func_mem_rdbk,
      ind_rep_mem_we           => seq_ind_rep_mem_we,
      ind_rep_mem_redbk        => seq_ind_rep_mem_rdbk,
      ind_sub_add_mem_we       => seq_ind_sub_add_mem_we,
      ind_sub_add_mem_redbk    => seq_ind_sub_add_mem_rdbk,
      ind_sub_rep_mem_we       => seq_ind_sub_rep_mem_we,
      ind_sub_rep_mem_redbk    => seq_ind_sub_rep_mem_rdbk,
      time_mem_w_en            => seq_time_mem_w_en,
      time_mem_readbk          => seq_time_mem_readbk,
      out_mem_w_en             => seq_out_mem_w_en,
      out_mem_readbk           => seq_out_mem_readbk,
      stop_sequence            => seq_stop,
      step_sequence            => seq_step,
      op_code_error_reset      => seq_op_code_error_reset,
      op_code_error            => seq_op_code_error,
      op_code_error_add        => seq_op_code_error_add,
      sequencer_busy           => sequencer_busy,
      sequencer_out            => sequencer_outputs_int,
      end_sequence             => end_sequence
      );

  sequencer_aligner_shifter : sequencer_aligner_shifter_top
    generic map(start_adc_bit => 12)
    port map (
      clk           => clk_100_Mhz,
      reset         => sync_res,
      shift_on_en   => enable_conv_shift,
      shift_on      => regDataWr_masked(0),
      init_shift    => init_conv_shift,
      sequencer_in  => sequencer_outputs_int,
      shift_on_out  => enable_conv_shift_out,
      sequencer_out => sequencer_outputs
      );

  Image_data_handler_0 : ADC_data_handler_v4
    port map (
      reset             => sync_res,
      clk               => clk_100_Mhz,
      testmode_rst      => pattern_reset,
      testmode_col      => sequencer_outputs(8),
      start_of_img      => start_of_img,  -- this signal is generated by the user (using the sequencer) and has to arrive before the first trigger 
      end_of_img        => end_of_img,  -- this signal is generated by the user (using the sequencer) and has to arrive after the last  ADC trasfer 
      end_sequence      => end_sequence,  -- this signal is the end of sequence generated by the sequencer and is used as a timeot to generate EOF.
      trigger           => ADC_trigger,  -- this signal start the operations (ADC conv and send data to PGP)
      en_test_mode      => image_patter_en,  -- register enable for pattern test mode
      test_mode_in      => regDataWr_masked(0),  -- test mode in 
      en_load_ccd_sel   => '1',  -- for GREB only two stripes are active  register enable for CCD enable
      ccd_sel_in        => "001",    -- for WREB only first stripe is active 
      ccd_sel_out       => CCD_sel,  -- register to select which CCD to acquire (1, 2 or 3) 
      SOT               => dataSOT,     -- Start of Image
      EOT               => dataEOT,     -- End of Image
      write_enable      => dataWrEn,    -- signal to write the image in the PGP
      test_mode_enb_out => image_patter_read,
      data_out          => image_in,    -- 18 bits ADC word 
      adc_data_ccd_1    => adc_data_ccd_1,   -- CCD ADC data 
      adc_cnv_ccd_1     => adc_cnv_ccd_1_int,    -- ADC conv
      adc_sck_ccd_1     => adc_sck_ccd_1_int,    -- ADC serial clock
      adc_data_ccd_2    => x"0000",     -- CCD ADC data 
      adc_cnv_ccd_2     => open,        -- ADC conv
      adc_sck_ccd_2     => open,        -- ADC serial clock
      adc_data_ccd_3    => x"0000",  -- for GREB only first stripe is active                                 -- CCD ADC data 
      adc_cnv_ccd_3     => open,  -- for GREB only first stripe is active                         -- ADC conv
      adc_sck_ccd_3     => open  -- for GREB only first stripe is active                         -- ADC serial clock
      );

  aspic_3_spi_link_top_mux_0 : aspic_3_spi_link_top_mux
    port map (
      clk                => clk_100_Mhz,
      reset              => sync_res,
      start_link_trans   => aspic_start_trans,
      start_reset        => aspic_start_reset,
      miso_ccd1          => ASPIC_miso_ccd_1,
      miso_ccd2          => ASPIC_miso_ccd_2,
      miso_ccd3          => '0',
      word2send          => regDataWr_masked,
      aspic_mosi         => ASPIC_mosi_int,
      ss_t_ccd1          => ASPIC_ss_t_ccd_1_int,
      ss_t_ccd2          => ASPIC_ss_t_ccd_2_int,
      ss_t_ccd3          => open,
      ss_b_ccd1          => ASPIC_ss_b_ccd_1_int,
      ss_b_ccd2          => ASPIC_ss_b_ccd_2_int,
      ss_b_ccd3          => open,
      aspic_sclk         => ASPIC_sclk_int,
      aspic_n_reset      => ASPIC_spi_reset,
      busy               => aspic_busy,
      d_slave_ready_ccd1 => open,
      d_slave_ready_ccd2 => open,
      d_slave_ready_ccd3 => open,
      d_from_slave_ccd1  => aspic_config_r_ccd_1,
      d_from_slave_ccd2  => aspic_config_r_ccd_2,
      d_from_slave_ccd3  => open
      );

  aspic_nap_mode_ccd_1_ff : ff_ce
    port map (
      reset    => sync_res,
      clk      => clk_100_Mhz,
      data_in  => regDataWr_masked(0),
      ce       => aspic_nap_mode_en,
      data_out => aspic_nap_mode_ccd_1);

  aspic_nap_mode_ccd_2_ff : ff_ce
    port map (
      reset    => sync_res,
      clk      => clk_100_Mhz,
      data_in  => regDataWr_masked(1),
      ce       => aspic_nap_mode_en,
      data_out => aspic_nap_mode_ccd_2);  

  c_bias_DAC : ad53xx_DAC_top
    port map (
      clk         => clk_100_Mhz,
      reset       => sync_res,
      start_write => c_bias_load_start,
      start_ldac  => c_bias_ldac_start,
      d_to_slave  => regDataWr_masked(15 downto 0),
      mosi        => din_C_BIAS,
      ss          => sync_C_BIAS,
      sclk        => sclk_C_BIAS,
      ldac        => ldac_C_BIAS);

  clk_rails_DAC : dual_ad53xx_DAC_top
    port map (
      clk         => clk_100_Mhz,
      reset       => sync_res,
      start_write => clk_rail_load_start,
      start_ldac  => clk_rail_ldac_start,
      d_to_slave  => regDataWr_masked(16 downto 0),
      mosi        => din_RAILS,
      ss_dac_0    => sync_RAILS_dac0,
      ss_dac_1    => sync_RAILS_dac1,
      sclk        => sclk_RAILS,
      ldac        => ldac_RAILS
      );


  ltc2945_V_I_sens : ltc2945_multi_read_top_greb
    port map (
      clk                   => clk_100_Mhz,
      reset                 => sync_res,
      start_procedure       => V_I_read_start,
      busy                  => V_I_busy,
      error_V_HTR_voltage   => error_V_HTR_voltage,
      V_HTR_voltage_out     => V_HTR_voltage,
      error_V_HTR_current   => error_V_HTR_current,
      V_HTR_current_out     => V_HTR_current,
      error_V_DREB_voltage  => error_V_DREB_voltage,
      V_DREB_voltage_out    => V_DREB_voltage,
      error_V_DREB_current  => error_V_DREB_current,
      V_DREB_current_out    => V_DREB_current,
      error_V_CLK_H_voltage => error_V_CLK_H_voltage,
      V_CLK_H_voltage_out   => V_CLK_H_voltage,
      error_V_CLK_H_current => error_V_CLK_H_current,
      V_CLK_H_current_out   => V_CLK_H_current,
      error_V_OD_voltage    => error_V_OD_voltage,
      V_OD_voltage_out      => V_OD_voltage,
      error_V_OD_current    => error_V_OD_current,
      V_OD_current_out      => V_OD_current,
      error_V_ANA_voltage   => error_V_ANA_voltage,
      V_ANA_voltage_out     => V_ANA_voltage,
      error_V_ANA_current   => error_V_ANA_current,
      V_ANA_current_out     => V_ANA_current,
      sda                   => LTC2945_SDA_int,  --serial data output of i2c bus 
      scl                   => LTC2945_SCl_int  --serial clock output of i2c bus
      );

  DREB_temp_read : adt7420_temp_multiread_2_top
    port map (
      clk             => clk_100_Mhz,
      reset           => sync_res,
      start_procedure => temp_read_start,
      busy            => DREB_temp_busy,
      error_T1        => T1_dreb_error,
      T1_out          => T1_dreb,
      error_T2        => T2_dreb_error,
      T2_out          => T2_dreb,
      sda             => DREB_temp_sda,  --serial data output of i2c bus 
      scl             => DREB_temp_scl   --serial clock output of i2c bus
      );

  WREB_temp_rd_gr1 : adt7420_temp_multiread_4_top
    port map (
      clk             => clk_100_Mhz,
      reset           => sync_res,
      start_procedure => temp_read_start,
      busy            => REB_temp_busy_gr1,
      error_T1        => T1_reb_gr1_error,
      T1_out          => T1_reb_gr1,
      error_T2        => T2_reb_gr1_error,
      T2_out          => T2_reb_gr1,
      error_T3        => T3_reb_gr1_error,
      T3_out          => T3_reb_gr1,
      error_T4        => T4_reb_gr1_error,
      T4_out          => T4_reb_gr1,
      sda             => Temp_adc_sda_ccd_1,  --serial data output of i2c bus 
      scl             => Temp_adc_scl_ccd_1   --serial clock output of i2c bus
      );

  dual_ads1118_top_0 : dual_ads1118_top
    port map (
      clk           => clk_100_Mhz,
      reset         => sync_res,
      start_read    => aspic_t_v_start_r,
      device_select => '0',
      miso          => aspic_t_v_miso,
      mosi          => aspic_t_v_mosi_int,
      ss_adc_1      => aspic_t_v_ss_ccd1_int,
      ss_adc_2      => aspic_t_v_ss_ccd2_int,
      sclk          => aspic_t_v_sclk_int,
      link_busy     => aspic_t_v_busy,
      data_from_adc => aspic_t_v_data
      );


  ccd_temperature_sensor : ad7794_top
    port map (
      clk             => clk_100_Mhz,
      reset           => sync_res,
      start           => ccd_temp_start,
      start_reset     => ccd_temp_start_reset,
      read_write      => regDataWr_masked(19),
      ad7794_dout_rdy => dout_24ADC,
      reg_add         => regDataWr_masked(18 downto 16),
      d_to_slave      => regDataWr_masked(15 downto 0),
      ad7794_din      => din_24ADC,
      ad7794_cs       => csb_24ADC,
      ad7794_sclk     => sclk_24ADC,
      busy            => ccd_temp_busy,
      d_from_slave    => ccd_temp
      );

  max_11046_multiple_top_1 : max_11046_multiple_top
    generic map (
      num_adc_on_bus => 2)
    port map (
      clk              => clk_100_Mhz,
      reset            => sync_res,
      start_write      => slow_adc_start_write,
      start_read       => slow_adc_start_read,
      EOC_ck           => ck_adc_EOC,
      EOC_ccd1         => ccd1_adc_EOC,
      EOC_ccd2         => '0',
      data_to_adc      => regDataWr_masked(5 downto 0),
      data_from_adc    => slow_adc_data_from_adc_int,
      link_busy        => slow_adc_busy,
      CS_ck            => ck_adc_CS,
      CS_ccd1          => ccd1_adc_CS,
      CS_ccd2          => open,
      RD               => slow_adc_RD,
      WR               => slow_adc_WR,
      CONVST_ck        => ck_adc_CONVST,
      CONVST_ccd1      => ccd1_adc_CONVST,
      CONVST_ccd2      => open,
      SHDN_ck          => ck_adc_SHDN,
      SHDN_ccd1        => ccd1_adc_SHDN,
      SHDN_ccd2        => open,
      write_en         => slow_adc_write_en,
      data_to_adc_out  => slow_adc_data_to_adc_out,
      cnv_results_ck   => ck_adc_conv_res,
      cnv_results_ccd1 => ccd1_adc_conv_res,
      cnv_results_ccd2 => ccd2_adc_conv_res);

  ccd1_clk_enable_ff : ff_ce
    port map (
      reset    => sync_res,
      clk      => clk_100_Mhz,
      data_in  => regDataWr_masked(0),
      ce       => ccd_clk_en,
      data_out => ccd1_clk_en_out_int);

  ccd2_clk_enable_ff : ff_ce
    port map (
      reset    => sync_res,
      clk      => clk_100_Mhz,
      data_in  => regDataWr_masked(1),
      ce       => ccd_clk_en,
      data_out => ccd2_clk_en_out_int);

  ASPIC_ref_enable_ff_ccd1 : ff_ce
    port map (
      reset    => sync_res,
      clk      => clk_100_Mhz,
      data_in  => regDataWr_masked(0),
      ce       => aspic_ref_en,
      data_out => aspic_ref_en_out_int_ccd1);

  ASPIC_ref_sd_ccd1 <= aspic_ref_en_out_int_ccd1;

  --ASPIC_ref_enable_ff_ccd2 : ff_ce
  --  port map (
  --    reset    => sync_res,
  --    clk      => clk_100_Mhz,
  --    data_in  => regDataWr_masked(1),
  --    ce       => aspic_ref_en,
  --    data_out => aspic_ref_en_out_int_ccd2);

  --ASPIC_ref_sd_ccd2 <= aspic_ref_en_out_int_ccd2;

  ASPIC_5v_enable_ff_ccd1 : ff_ce_pres
    port map (
      preset   => sync_res,
      clk      => clk_100_Mhz,
      data_in  => regDataWr_masked(0),
      ce       => aspic_5v_en,
      data_out => aspic_5v_en_out_int_ccd1);

  ASPIC_5V_sd_ccd1 <= aspic_5v_en_out_int_ccd1;

  --ASPIC_5v_enable_ff_ccd2 : ff_ce_pres
  --  port map (
  --    preset   => sync_res,
  --    clk      => clk_100_Mhz,
  --    data_in  => regDataWr_masked(1),
  --    ce       => aspic_5v_en,
  --    data_out => aspic_5v_en_out_int_ccd2);

  --ASPIC_5V_sd_ccd2 <= aspic_5v_en_out_int_ccd2;

  led_blink_0 : led_blink
    port map (
      clk_in  => clk_100_Mhz,
      led_out => test_led_int(2));


  REB_1wire_sn : onewire_iface
    generic map (
      CheckCRC   => true,
      ADD_PULLUP => false,
      CLK_DIV    => 12)
    port map(
      sys_clk     => clk_100_Mhz,
      --    latch_reset => sync_res,
      latch_reset => reb_onewire_reset_lock,
      --    sys_reset   => reb_onewire_reset,
      sys_reset   => reb_onewire_reset_lock,
      crc_ok      => reb_sn_crc_ok,
      dev_error   => reb_sn_dev_error,
      data        => open,
      data_valid  => open,
      sn_data     => reb_sn,
      timeout     => reb_sn_timeout,
      dq          => reb_sn_onewire_int
      );
  reb_onewire_reset_lock <= not dcm_locked;

  back_bias_sw : ff_ce
    port map (
      reset    => sync_res,
      clk      => clk_100_Mhz,
      data_in  => regDataWr_masked(0),
      ce       => en_back_bias_sw,
      data_out => back_bias_sw_int); 

  back_bias_clamp_int <= not back_bias_sw_int;

  back_bias_reg : ff_ce
    port map (
      reset    => sync_res,
      clk      => clk_100_Mhz,
      data_in  => back_bias_sw_int,
      ce       => '1',
      data_out => backbias_ssbe); 

  back_bias_clamp_reg : ff_ce_pres
    port map (
      preset   => sync_res,
      clk      => clk_100_Mhz,
      data_in  => back_bias_clamp_int,
      ce       => '1',
      data_out => backbias_clamp);       


-- clock 
  

  multiboot_fsm_0 : multiboot_fsm
    port map (
      TRIGGER => mb_en_2,
      SYSCLK  => clk_50_Mhz
      );
--
  flop1_mb : FD port map (D => start_multiboot, C => clk_50_Mhz, Q => mb_en);
  flop2_mb : FD port map (D => mb_en, C => clk_50_Mhz, Q => mb_en_1);

  mb_en_2 <= mb_en or mb_en_1;


  dcm_user_clk_0 : dcm_user_clk
    port map
    (                                   -- Clock in ports
      CLK_IN1  => usrClk,
      -- Clock out ports
      CLK_OUT1 => clk_100_Mhz,
      CLK_OUT2 => clk_50_Mhz,
      -- Status and control signals
      LOCKED   => dcm_locked);

---- check master clk
--
--  ODDR_inst : ODDR generic map(DDR_CLK_EDGE => "OPPOSITE_EDGE",
--                               INIT         => '0',
--                               SRTYPE       => "SYNC") 
--    port map (
--      Q  => test_port(0),
--      C  => pgp_usr_clk,
--      CE => '1',
--      D1 => '1',
--      D2 => '0',
--      R  => '0',
--      S  => '0'
--      );
--
--sys_clk_in_buffer: IBUFGDS
--generic map (
--              DIFF_TERM               => TRUE,
--              IBUF_LOW_PWR    => FALSE,
--              IOSTANDARD              => "DEFAULT")
--port map (
--              I       => sysclk_p,
--              IB      => sysclk_m,
--              O       => clk_100_Mhz);


-- Resets
  -- Power on reset (goes to PGP part)
  Ureset : IBUF port map (O => n_rst, I => Pwron_Rst_L);

                                        -- sync reset for the user part (from PGP)
  flop1_res : FD port map (D => usrRst, C => clk_100_Mhz, Q => sync_res_1);
  flop2_res : FD port map (D => sync_res_1, C => clk_100_Mhz, Q => sync_res_2);
  flop3_res : FD port map (D => sync_res_2, C => clk_100_Mhz, Q => sync_res);

-- Clock conditioning
  -- PGP serdes clk
--      U_PgpRefClk : IBUFDS port map (I  => PgpRefClk_P,
--                                  IB => PgpRefClk_M,
--                                  O  => pgpRefClk);

------ MISC ------                                  
-- leds
  Utest_led0 : OBUF port map (O => TEST_LED(0), I => test_led_int(0));
  Utest_led1 : OBUF port map (O => TEST_LED(1), I => test_led_int(1));
  Utest_led2 : OBUF port map (O => TEST_LED(2), I => test_led_int(2));

-- CCD 1
  U_ASPIC_r_up_ccd_1 : OBUFTDS port map (I  => ASPIC_r_up_ccd_1,
                                         T  => enable_io,
                                         O  => ASPIC_r_up_ccd_1_p,
                                         OB => ASPIC_r_up_ccd_1_n);

  U_ASPIC_r_down_ccd_1 : OBUFTDS port map (I  => ASPIC_r_down_ccd_1,
                                           T  => enable_io,
                                           O  => ASPIC_r_down_ccd_1_p,
                                           OB => ASPIC_r_down_ccd_1_n);

  U_ASPIC_clamp_ccd_1 : OBUFTDS port map (I  => ASPIC_clamp_ccd_1,
                                          T  => enable_io,
                                          O  => ASPIC_clamp_ccd_1_p,
                                          OB => ASPIC_clamp_ccd_1_n);

  U_ASPIC_reset_ccd_1 : OBUFTDS port map (I  => ASPIC_reset_ccd_1,
                                          T  => enable_io,
                                          O  => ASPIC_reset_ccd_1_p,
                                          OB => ASPIC_reset_ccd_1_n);

  par_clk_ccd_1_generate :
  for I in 0 to 3 generate
    U_par_clk_ccd_1 : OBUFTDS
      port map (I  => par_clk_ccd_1(I),
                T  => enable_io,
                O  => par_clk_ccd_1_p(I),
                OB => par_clk_ccd_1_n(I));
  end generate;

  ser_clk_ccd_1_generate :
  for I in 0 to 2 generate
    U_ser_clk_ccd_1 : OBUFTDS
      port map (I  => ser_clk_ccd_1(I),
                T  => enable_io,
                O  => ser_clk_ccd_1_p(I),
                OB => ser_clk_ccd_1_n(I));
  end generate;

  U_reset_gate_ccd_1 : OBUFTDS port map (I  => reset_gate_ccd_1,
                                         T  => enable_io,
                                         O  => reset_gate_ccd_1_p,
                                         OB => reset_gate_ccd_1_n);

  U_pulse_t_ccd_1 : OBUFTDS port map (I  => cabac_pulse_ccd_1,
                                      T  => enable_io,
                                      O  => pulse_ccd_1_p,
                                      OB => pulse_ccd_1_n);


-- slow slow adc tri state buffer

  slow_adc_iobuf_generate :
  for i in 0 to 3 generate
    bs_IOBF : IOBUF
      port map (
        O  => slow_adc_data_from_adc_int(i),
        IO => slow_adc_data_from_adc_dcr(i),
        I  => slow_adc_data_to_adc_out(i),
        T  => slow_adc_write_en
        );
  end generate;

  slow_adc_data_from_adc_int(15 downto 4) <= slow_adc_data_from_adc;


  CCD1_clk_en_buffer : OBUFDS
    port map (I  => ccd1_clk_en_out_int,
              O  => ccd1_clk_en_out_p,
              OB => ccd1_clk_en_out_n);

  gpio_0_buffer : OBUFDS
    port map (I  => gpio_0_int,
              O  => gpio_0_p,
              OB => gpio_0_n);

  gpio_1_buffer : OBUFDS
    port map (I  => gpio_1_int,
              O  => gpio_1_p,
              OB => gpio_1_n);

  gpio_0_dir <= '0';                    -- must be 0 to work as receiver
  gpio_1_dir <= '0';                    -- must be 0 to work as receiver

-- test points
-- test port
  Utest0 : OBUF port map (O => TEST(0), I => test_port(0));
  Utest1 : OBUF port map (O => TEST(1), I => test_port(1));
  Utest2 : OBUF port map (O => TEST(2), I => test_port(2));
  Utest3 : OBUF port map (O => TEST(3), I => test_port(3));
  --Utest4  : OBUF port map (O => TEST(4), I => test_port(4));
  --Utest5  : OBUF port map (O => TEST(5), I => test_port(5));
  --Utest6  : OBUF port map (O => TEST(6), I => test_port(6));
  --Utest7  : OBUF port map (O => TEST(7), I => test_port(7));
  --Utest8  : OBUF port map (O => TEST(8), I => test_port(8));
  --Utest9  : OBUF port map (O => TEST(9), I => test_port(9));
  --Utest10 : OBUF port map (O => TEST(10), I => test_port(10));
  --Utest11 : OBUF port map (O => TEST(11), I => test_port(11));
  --Utest12 : OBUF port map (O => TEST(12), I => test_port(12));




  
end Behavioral;

