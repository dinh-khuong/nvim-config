-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	"NMAC427/guess-indent.nvim",
	commit = "b8ae749fce17aa4c267eec80a6984130b94f80b2",
	optional = true,
	config = function()
		require('guess-indent')
	end
}
