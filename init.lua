-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Options
vim.opt.sw = 2
vim.opt.ts = 2
vim.opt.et = true

vim.cmd("filetype plugin indent on")

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hidden = true
vim.opt.mouse = "a"
vim.opt.splitbelow = true

vim.opt.undodir = vim.fn.expand("~/.config/nvim/undodir")
vim.opt.undofile = true

-- security
vim.opt.modeline = false
vim.opt.modelines = 0

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.backupcopy = "yes"

vim.opt.updatetime = 300
vim.opt.shortmess:append("c")

vim.opt.termguicolors = true
vim.opt.background = "dark"

if vim.fn.executable("rg") == 1 then
	vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --follow"
end

vim.env.FZF_DEFAULT_COMMAND = "rg --files --follow"

-- Python provider venv for Neovim remote plugins like molten-nvim
local nvim_python_venv = vim.fn.expand("~/.venvs/neovim")
local nvim_python = nvim_python_venv .. "/bin/python"

local function ensure_nvim_python_venv()
	if vim.fn.executable(nvim_python) == 1 then
		vim.g.python3_host_prog = nvim_python
		return
	end

	local python3 = vim.fn.exepath("python3")

	if python3 == "" then
		vim.notify("python3 not found; cannot create Neovim Python provider venv", vim.log.levels.ERROR)
		return
	end

	vim.notify("Creating Neovim Python provider venv at " .. nvim_python_venv, vim.log.levels.INFO)

	vim.fn.system({
		python3,
		"-m",
		"venv",
		nvim_python_venv,
	})

	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to create Neovim Python provider venv", vim.log.levels.ERROR)
		return
	end

	vim.fn.system({
		nvim_python,
		"-m",
		"pip",
		"install",
		"--upgrade",
		"pip",
	})

	vim.fn.system({
		nvim_python,
		"-m",
		"pip",
		"install",
		"pynvim",
		"jupyter_client",
		"cairosvg",
		"plotly",
		"kaleido",
		"pnglatex",
		"pyperclip",
	})

	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to install Neovim Python provider packages", vim.log.levels.ERROR)
		return
	end

	vim.g.python3_host_prog = nvim_python

	vim.notify("Neovim Python provider venv ready. Restart nvim, then run :UpdateRemotePlugins", vim.log.levels.INFO)
end

ensure_nvim_python_venv()

-- Plugins
require("lazy").setup({
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		cmd = "FzfLua",
		opts = {
			ui_select = true,
			winopts = {
				height = 0.85,
				width = 0.85,
				preview = {
					layout = "flex",
				},
			},
			grep = {
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --follow --glob '!.git' --glob '!.venv' --glob '!node_modules'",
			},
			files = {
				fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude .venv --exclude node_modules",
			},
		},
	},

	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		opts = {
			keymap = {
				preset = "default",
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 300,
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
	},

	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		opts = {},
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"pyright",
				"ruff",
			},
			automatic_enable = false,
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
		config = function()
			local fzf = require("fzf-lua")

			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			vim.lsp.config("pyright", {
				settings = {
					pyright = {
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
			})

			vim.lsp.config("ruff", {
				init_options = {
					settings = {},
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local bufnr = args.buf
					local opts = { buffer = bufnr, silent = true }

					if client and client.name == "ruff" then
						client.server_capabilities.hoverProvider = false
					end

					vim.keymap.set("n", "gd", fzf.lsp_definitions, opts)
					vim.keymap.set("n", "gy", fzf.lsp_typedefs, opts)
					vim.keymap.set("n", "gi", fzf.lsp_implementations, opts)
					vim.keymap.set("n", "gr", fzf.lsp_references, opts)

					vim.keymap.set("n", "<leader>ca", fzf.lsp_code_actions, opts)
					vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

					vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)
					vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)

					vim.keymap.set("n", "K", function()
						if vim.tbl_contains({ "vim", "help" }, vim.bo.filetype) then
							vim.cmd("h " .. vim.fn.expand("<cword>"))
						else
							vim.lsp.buf.hover()
						end
					end, opts)

					if client and client.server_capabilities.documentHighlightProvider then
						local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })

						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							group = group,
							buffer = bufnr,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							group = group,
							buffer = bufnr,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			vim.diagnostic.config({
				virtual_text = true,
				severity_sort = true,
				float = {
					border = "rounded",
					source = true,
				},
				signs = true,
				underline = true,
			})

			vim.lsp.enable({
				"pyright",
				"ruff",
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "VeryLazy" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				javascriptreact = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier" },
			},
			format_on_save = function(bufnr)
				local disabled_filetypes = {}

				if disabled_filetypes[vim.bo[bufnr].filetype] then
					return nil
				end

				return {
					timeout_ms = 1000,
					lsp_format = "fallback",
				}
			end,
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local parsers = {
				"bash",
				"css",
				"go",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"rust",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			}

			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					if lang and vim.treesitter.language.add(lang) then
						vim.treesitter.start(args.buf, lang)
					end
				end,
			})
		end,
	},

	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gc", mode = { "n", "v" } },
			{ "gcc", mode = "n" },
		},
		opts = {},
	},

	{
		"tpope/vim-surround",
		event = "VeryLazy",
	},

	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufNewFile" },
	},

	{
		"HakonHarnes/img-clip.nvim",
		ft = "markdown",
		opts = {
			default = {
				dir_path = ".",
			},
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			options = {
				theme = "auto",
				globalstatus = true,
			},
		},
	},

	{
		"benlubas/molten-nvim",
		-- version = "^1.0.0",
		build = ":UpdateRemotePlugins",
		init = function()
			vim.g.molten_image_provider = "image.nvim"

			-- Important: stop output windows from appearing/disappearing while navigating.
			vim.g.molten_auto_open_output = false

			-- Keep text output visible without opening the floating output window.
			vim.g.molten_virt_text_output = true
			vim.g.molten_virt_lines_off_by_1 = true
			vim.g.molten_wrap_output = true
		end,
	},

	{
		"3rd/image.nvim",
		opts = {
			backend = "kitty",
			integrations = {
				markdown = {
					enabled = true,
				},
			},
			max_width = 100,
			max_height = 20,
			max_height_window_percentage = 50,
			max_width_window_percentage = 80,
			window_overlap_clear_enabled = true,
		},
	},

	{
		"GCBallesteros/NotebookNavigator.nvim",
		dependencies = {
			"echasnovski/mini.comment",
			"benlubas/molten-nvim",
		},
		event = "VeryLazy",
		opts = {
			activate_hydra_keys = nil,
		},
		keys = {
			{
				"]h",
				function()
					require("notebook-navigator").move_cell("d")
				end,
				desc = "Next notebook cell",
			},
			{
				"[h",
				function()
					require("notebook-navigator").move_cell("u")
				end,
				desc = "Previous notebook cell",
			},
			{
				"<leader>x",
				function()
					require("notebook-navigator").run_cell()
				end,
				desc = "Run notebook cell",
			},
			{
				"<leader>X",
				function()
					require("notebook-navigator").run_and_move()
				end,
				desc = "Run notebook cell and move",
			},
		},
	},

	{
		"mhartington/oceanic-next",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.oceanic_next_terminal_bold = 1
			vim.g.oceanic_next_terminal_italic = 1
			vim.cmd.colorscheme("OceanicNext")
		end,
	},

	{
		"NLKNguyen/papercolor-theme",
		lazy = true,
	},
}, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})

-- Keybindings
local map = vim.keymap.set

map("n", "<leader>r", function()
	require("fzf-lua").grep_project()
end, { silent = true })

map("n", "<leader>f", function()
	require("fzf-lua").files()
end, { silent = true })

map("n", "<leader>w", "<cmd>w<cr>", { silent = true })
map("n", "<leader>e", ":e ", { silent = false })
map("n", "<leader>n", "<cmd>bn<cr>", { silent = true })
map("n", "<leader>p", "<cmd>bp<cr>", { silent = true })

-- Molten
map("n", "<leader>mi", "<cmd>MoltenInit<cr>", { silent = true })
map("n", "<leader>mo", "<cmd>noautocmd MoltenEnterOutput<cr>", { silent = true })
map("n", "<leader>mh", "<cmd>MoltenHideOutput<cr>", { silent = true })
map("n", "<leader>md", "<cmd>MoltenDelete<cr>", { silent = true })
map("n", "<leader>mr", "<cmd>MoltenRestart<cr>", { silent = true })
map("n", "<leader>mc", "<cmd>MoltenDelete!<cr>", { silent = true })

-- Autocmds
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(args)
		vim.keymap.set("n", "<leader>mp", function()
			vim.cmd("PasteImage")
		end, { buffer = args.buf, silent = true })
	end,
})
