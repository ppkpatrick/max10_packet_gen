	component fyp_max10_tse_sys is
		port (
			clk_sys_125_clk                             : in  std_logic                     := 'X';             -- clk
			eth_tse_0_mac_mdio_connection_mdc           : out std_logic;                                        -- mdc
			eth_tse_0_mac_mdio_connection_mdio_in       : in  std_logic                     := 'X';             -- mdio_in
			eth_tse_0_mac_mdio_connection_mdio_out      : out std_logic;                                        -- mdio_out
			eth_tse_0_mac_mdio_connection_mdio_oen      : out std_logic;                                        -- mdio_oen
			eth_tse_0_mac_misc_connection_xon_gen       : in  std_logic                     := 'X';             -- xon_gen
			eth_tse_0_mac_misc_connection_xoff_gen      : in  std_logic                     := 'X';             -- xoff_gen
			eth_tse_0_mac_misc_connection_magic_wakeup  : out std_logic;                                        -- magic_wakeup
			eth_tse_0_mac_misc_connection_magic_sleep_n : in  std_logic                     := 'X';             -- magic_sleep_n
			eth_tse_0_mac_misc_connection_ff_tx_crc_fwd : in  std_logic                     := 'X';             -- ff_tx_crc_fwd
			eth_tse_0_mac_misc_connection_ff_tx_septy   : out std_logic;                                        -- ff_tx_septy
			eth_tse_0_mac_misc_connection_tx_ff_uflow   : out std_logic;                                        -- tx_ff_uflow
			eth_tse_0_mac_misc_connection_ff_tx_a_full  : out std_logic;                                        -- ff_tx_a_full
			eth_tse_0_mac_misc_connection_ff_tx_a_empty : out std_logic;                                        -- ff_tx_a_empty
			eth_tse_0_mac_misc_connection_rx_err_stat   : out std_logic_vector(17 downto 0);                    -- rx_err_stat
			eth_tse_0_mac_misc_connection_rx_frm_type   : out std_logic_vector(3 downto 0);                     -- rx_frm_type
			eth_tse_0_mac_misc_connection_ff_rx_dsav    : out std_logic;                                        -- ff_rx_dsav
			eth_tse_0_mac_misc_connection_ff_rx_a_full  : out std_logic;                                        -- ff_rx_a_full
			eth_tse_0_mac_misc_connection_ff_rx_a_empty : out std_logic;                                        -- ff_rx_a_empty
			eth_tse_0_mac_rgmii_connection_rgmii_in     : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- rgmii_in
			eth_tse_0_mac_rgmii_connection_rgmii_out    : out std_logic_vector(3 downto 0);                     -- rgmii_out
			eth_tse_0_mac_rgmii_connection_rx_control   : in  std_logic                     := 'X';             -- rx_control
			eth_tse_0_mac_rgmii_connection_tx_control   : out std_logic;                                        -- tx_control
			eth_tse_0_mac_status_connection_set_10      : in  std_logic                     := 'X';             -- set_10
			eth_tse_0_mac_status_connection_set_1000    : in  std_logic                     := 'X';             -- set_1000
			eth_tse_0_mac_status_connection_eth_mode    : out std_logic;                                        -- eth_mode
			eth_tse_0_mac_status_connection_ena_10      : out std_logic;                                        -- ena_10
			eth_tse_0_pcs_mac_rx_clock_connection_clk   : in  std_logic                     := 'X';             -- clk
			eth_tse_0_pcs_mac_tx_clock_connection_clk   : in  std_logic                     := 'X';             -- clk
			eth_tse_0_receive_data                      : out std_logic_vector(31 downto 0);                    -- data
			eth_tse_0_receive_endofpacket               : out std_logic;                                        -- endofpacket
			eth_tse_0_receive_error                     : out std_logic_vector(5 downto 0);                     -- error
			eth_tse_0_receive_empty                     : out std_logic_vector(1 downto 0);                     -- empty
			eth_tse_0_receive_ready                     : in  std_logic                     := 'X';             -- ready
			eth_tse_0_receive_startofpacket             : out std_logic;                                        -- startofpacket
			eth_tse_0_receive_valid                     : out std_logic;                                        -- valid
			eth_tse_0_receive_clock_connection_clk      : in  std_logic                     := 'X';             -- clk
			eth_tse_0_transmit_data                     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- data
			eth_tse_0_transmit_endofpacket              : in  std_logic                     := 'X';             -- endofpacket
			eth_tse_0_transmit_error                    : in  std_logic                     := 'X';             -- error
			eth_tse_0_transmit_empty                    : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- empty
			eth_tse_0_transmit_ready                    : out std_logic;                                        -- ready
			eth_tse_0_transmit_startofpacket            : in  std_logic                     := 'X';             -- startofpacket
			eth_tse_0_transmit_valid                    : in  std_logic                     := 'X';             -- valid
			eth_tse_0_transmit_clock_connection_clk     : in  std_logic                     := 'X';             -- clk
			reset_sys_125_reset_n                       : in  std_logic                     := 'X'              -- reset_n
		);
	end component fyp_max10_tse_sys;

	u0 : component fyp_max10_tse_sys
		port map (
			clk_sys_125_clk                             => CONNECTED_TO_clk_sys_125_clk,                             --                           clk_sys_125.clk
			eth_tse_0_mac_mdio_connection_mdc           => CONNECTED_TO_eth_tse_0_mac_mdio_connection_mdc,           --         eth_tse_0_mac_mdio_connection.mdc
			eth_tse_0_mac_mdio_connection_mdio_in       => CONNECTED_TO_eth_tse_0_mac_mdio_connection_mdio_in,       --                                      .mdio_in
			eth_tse_0_mac_mdio_connection_mdio_out      => CONNECTED_TO_eth_tse_0_mac_mdio_connection_mdio_out,      --                                      .mdio_out
			eth_tse_0_mac_mdio_connection_mdio_oen      => CONNECTED_TO_eth_tse_0_mac_mdio_connection_mdio_oen,      --                                      .mdio_oen
			eth_tse_0_mac_misc_connection_xon_gen       => CONNECTED_TO_eth_tse_0_mac_misc_connection_xon_gen,       --         eth_tse_0_mac_misc_connection.xon_gen
			eth_tse_0_mac_misc_connection_xoff_gen      => CONNECTED_TO_eth_tse_0_mac_misc_connection_xoff_gen,      --                                      .xoff_gen
			eth_tse_0_mac_misc_connection_magic_wakeup  => CONNECTED_TO_eth_tse_0_mac_misc_connection_magic_wakeup,  --                                      .magic_wakeup
			eth_tse_0_mac_misc_connection_magic_sleep_n => CONNECTED_TO_eth_tse_0_mac_misc_connection_magic_sleep_n, --                                      .magic_sleep_n
			eth_tse_0_mac_misc_connection_ff_tx_crc_fwd => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_tx_crc_fwd, --                                      .ff_tx_crc_fwd
			eth_tse_0_mac_misc_connection_ff_tx_septy   => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_tx_septy,   --                                      .ff_tx_septy
			eth_tse_0_mac_misc_connection_tx_ff_uflow   => CONNECTED_TO_eth_tse_0_mac_misc_connection_tx_ff_uflow,   --                                      .tx_ff_uflow
			eth_tse_0_mac_misc_connection_ff_tx_a_full  => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_tx_a_full,  --                                      .ff_tx_a_full
			eth_tse_0_mac_misc_connection_ff_tx_a_empty => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_tx_a_empty, --                                      .ff_tx_a_empty
			eth_tse_0_mac_misc_connection_rx_err_stat   => CONNECTED_TO_eth_tse_0_mac_misc_connection_rx_err_stat,   --                                      .rx_err_stat
			eth_tse_0_mac_misc_connection_rx_frm_type   => CONNECTED_TO_eth_tse_0_mac_misc_connection_rx_frm_type,   --                                      .rx_frm_type
			eth_tse_0_mac_misc_connection_ff_rx_dsav    => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_rx_dsav,    --                                      .ff_rx_dsav
			eth_tse_0_mac_misc_connection_ff_rx_a_full  => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_rx_a_full,  --                                      .ff_rx_a_full
			eth_tse_0_mac_misc_connection_ff_rx_a_empty => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_rx_a_empty, --                                      .ff_rx_a_empty
			eth_tse_0_mac_rgmii_connection_rgmii_in     => CONNECTED_TO_eth_tse_0_mac_rgmii_connection_rgmii_in,     --        eth_tse_0_mac_rgmii_connection.rgmii_in
			eth_tse_0_mac_rgmii_connection_rgmii_out    => CONNECTED_TO_eth_tse_0_mac_rgmii_connection_rgmii_out,    --                                      .rgmii_out
			eth_tse_0_mac_rgmii_connection_rx_control   => CONNECTED_TO_eth_tse_0_mac_rgmii_connection_rx_control,   --                                      .rx_control
			eth_tse_0_mac_rgmii_connection_tx_control   => CONNECTED_TO_eth_tse_0_mac_rgmii_connection_tx_control,   --                                      .tx_control
			eth_tse_0_mac_status_connection_set_10      => CONNECTED_TO_eth_tse_0_mac_status_connection_set_10,      --       eth_tse_0_mac_status_connection.set_10
			eth_tse_0_mac_status_connection_set_1000    => CONNECTED_TO_eth_tse_0_mac_status_connection_set_1000,    --                                      .set_1000
			eth_tse_0_mac_status_connection_eth_mode    => CONNECTED_TO_eth_tse_0_mac_status_connection_eth_mode,    --                                      .eth_mode
			eth_tse_0_mac_status_connection_ena_10      => CONNECTED_TO_eth_tse_0_mac_status_connection_ena_10,      --                                      .ena_10
			eth_tse_0_pcs_mac_rx_clock_connection_clk   => CONNECTED_TO_eth_tse_0_pcs_mac_rx_clock_connection_clk,   -- eth_tse_0_pcs_mac_rx_clock_connection.clk
			eth_tse_0_pcs_mac_tx_clock_connection_clk   => CONNECTED_TO_eth_tse_0_pcs_mac_tx_clock_connection_clk,   -- eth_tse_0_pcs_mac_tx_clock_connection.clk
			eth_tse_0_receive_data                      => CONNECTED_TO_eth_tse_0_receive_data,                      --                     eth_tse_0_receive.data
			eth_tse_0_receive_endofpacket               => CONNECTED_TO_eth_tse_0_receive_endofpacket,               --                                      .endofpacket
			eth_tse_0_receive_error                     => CONNECTED_TO_eth_tse_0_receive_error,                     --                                      .error
			eth_tse_0_receive_empty                     => CONNECTED_TO_eth_tse_0_receive_empty,                     --                                      .empty
			eth_tse_0_receive_ready                     => CONNECTED_TO_eth_tse_0_receive_ready,                     --                                      .ready
			eth_tse_0_receive_startofpacket             => CONNECTED_TO_eth_tse_0_receive_startofpacket,             --                                      .startofpacket
			eth_tse_0_receive_valid                     => CONNECTED_TO_eth_tse_0_receive_valid,                     --                                      .valid
			eth_tse_0_receive_clock_connection_clk      => CONNECTED_TO_eth_tse_0_receive_clock_connection_clk,      --    eth_tse_0_receive_clock_connection.clk
			eth_tse_0_transmit_data                     => CONNECTED_TO_eth_tse_0_transmit_data,                     --                    eth_tse_0_transmit.data
			eth_tse_0_transmit_endofpacket              => CONNECTED_TO_eth_tse_0_transmit_endofpacket,              --                                      .endofpacket
			eth_tse_0_transmit_error                    => CONNECTED_TO_eth_tse_0_transmit_error,                    --                                      .error
			eth_tse_0_transmit_empty                    => CONNECTED_TO_eth_tse_0_transmit_empty,                    --                                      .empty
			eth_tse_0_transmit_ready                    => CONNECTED_TO_eth_tse_0_transmit_ready,                    --                                      .ready
			eth_tse_0_transmit_startofpacket            => CONNECTED_TO_eth_tse_0_transmit_startofpacket,            --                                      .startofpacket
			eth_tse_0_transmit_valid                    => CONNECTED_TO_eth_tse_0_transmit_valid,                    --                                      .valid
			eth_tse_0_transmit_clock_connection_clk     => CONNECTED_TO_eth_tse_0_transmit_clock_connection_clk,     --   eth_tse_0_transmit_clock_connection.clk
			reset_sys_125_reset_n                       => CONNECTED_TO_reset_sys_125_reset_n                        --                         reset_sys_125.reset_n
		);

