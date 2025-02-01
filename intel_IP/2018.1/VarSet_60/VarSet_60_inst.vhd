	component VarSet_60 is
		port (
			address    : in  std_logic_vector(6 downto 0)  := (others => 'X'); -- address
			chipselect : in  std_logic                     := 'X';             -- chipselect
			rst_n      : in  std_logic                     := 'X';             -- beginbursttransfer
			write_n    : in  std_logic                     := 'X';             -- write_n
			writedata  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			o_reg59    : out std_logic_vector(31 downto 0);                    -- readdata
			i_var59    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writebyteenable_n
			clk        : in  std_logic                     := 'X'              -- clk
		);
	end component VarSet_60;

	u0 : component VarSet_60
		port map (
			address    => CONNECTED_TO_address,    -- avalon_slave_0.address
			chipselect => CONNECTED_TO_chipselect, --               .chipselect
			rst_n      => CONNECTED_TO_rst_n,      --               .beginbursttransfer
			write_n    => CONNECTED_TO_write_n,    --               .write_n
			writedata  => CONNECTED_TO_writedata,  --               .writedata
			o_reg59    => CONNECTED_TO_o_reg59,    --               .readdata
			i_var59    => CONNECTED_TO_i_var59,    --               .writebyteenable_n
			clk        => CONNECTED_TO_clk         --          clock.clk
		);

