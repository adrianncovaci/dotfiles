local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
	{
		"windwp/nvim-ts-autotag",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"html",
			"svelte",
			"vue",
			"xml",
		},
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	--
	-- install dap
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"tpope/vim-fugitive",
		},
		config = function()
			require("dapui").setup()
			local dap, dapui = require("dap"), require("dapui")

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
			vim.keymap.set("n", "<leader>dc", dap.continue, {})
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {})
		end,
	},

	{
		"saecki/crates.nvim",
		ft = { "toml" },
		config = function(_, opts)
			local crates = require("crates")
			crates.setup(opts)
			require("cmp").setup.buffer({
				sources = { { name = "crates" } },
			})
			crates.show()
			require("core.utils").load_mappings("crates")
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		ft = { "rust" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
			"akinsho/toggleterm.nvim",
		},
		config = function()
			local on_attach = require("plugins.configs.lspconfig").on_attach
			local capabilities = require("plugins.configs.lspconfig").capabilities

			vim.g.rustaceanvim = {
				tools = {
					executor = "toggleterm",
					hover_actions = {
						auto_focus = true,
					},
					inlay_hints = {
						auto = true,
					},
				},
				server = {
					on_attach = on_attach,
					capabilities = capabilities,
					default_settings = {
						["rust-analyzer"] = {
							assist = {
								importMergeBehavior = "last",
								importPrefix = "by_self",
							},
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
								runBuildScripts = true,
							},
							checkOnSave = {
								command = "clippy",
								allFeatures = true,
								enable = true,
							},
							procMacro = {
								enable = true,
								ignored = {
									leptos_macro = {
										"server",
									},
								},
							},
							inlayHints = {
								lifetimeElisionHints = {
									enable = true,
									useParameterNames = true,
								},
							},
							diagnostics = {
								enable = true,
								experimental = {
									enable = true,
								},
							},
						},
					},
				},
			}

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = false,
			})
		end,
	},
	{
		"github/copilot.vim",
		lazy = false,
		config = function()
			-- Mapping tab is already used by NvChad
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = "\t"
			-- The mapping is set to other key, see custom/lua/mappings
			-- or run <leader>ch to see copilot mapping section
		end,
	},
	-- Override plugin definition options
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	{
		"stevearc/conform.nvim",
		--  for users those who want auto-save conform + lazyloading!
		-- event = "BufWritePre"
		config = function()
			require("custom.configs.conform")
		end,
	},
	{ "nvim-neotest/nvim-nio" },
	{
		"vuciv/golf",
		lazy = false,
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>fx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>fX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>fL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>fQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		"olimorris/codecompanion.nvim",
		opts = {},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = false,
		config = function()
			require("codecompanion").setup({
				strategies = {
					chat = {
						adapter = "anthropic",
					},
					inline = {
						adapter = "anthropic",
					},
				},
			})
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
	},
	{
		"mozanunal/sllm.nvim",
		dependencies = {
			"echasnovski/mini.notify",
			"echasnovski/mini.pick",
		},
		config = function()
			require("sllm").setup({
				llm_cmd = "llm",
				default_model = "openrouter/anthropic/claude-sonnet-4",
				show_usage = true, -- append usage stats to responses
				on_start_new_chat = true, -- start fresh chat on setup
				reset_ctx_each_prompt = true, -- clear file context each ask
				window_type = "vertical", -- Default. Options: "vertical", "horizontal", "float"
				-- function for item selection (like vim.ui.select)
				pick_func = require("mini.pick").ui_select,
				-- function for notifications (like vim.notify)
				notify_func = require("mini.notify").make_notify(),
				-- function for inputs (like vim.ui.input)
				input_func = vim.ui.input,
				-- See the "Customizing Keymaps" section for more details
				keymaps = {
					-- Disable a default keymap
					add_url_to_ctx = false,
					-- Other keymaps will use their default values
				},
			})
		end,
		lazy = false,
	},

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}

return plugins
