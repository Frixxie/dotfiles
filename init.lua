require("paq") {
  "savq/paq",
  "vim-airline/vim-airline",
  "vim-airline/vim-airline-themes",
  "windwp/nvim-autopairs",
  "joshdick/onedark.vim",
  "godlygeek/tabular",
  "majutsushi/tagbar",
  "mbbill/undotree",
  "tpope/vim-commentary",
  "rust-lang/rust.vim",
  "fatih/vim-go",
  "simrat39/rust-tools.nvim",
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",
  "mhartington/formatter.nvim", -- formatter
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  "mfussenegger/nvim-dap",
  "github/copilot.vim",
}

vim.opt.undodir = vim.fn.stdpath("config") .. "/undodir"
vim.opt.undofile = true

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.rnu = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.list = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.inccommand = "split"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.mouse = "a"

vim.g.airline_theme = "onedark"
vim.g.latex_to_unicode_tab = "off"

vim.api.nvim_set_keymap("n", "<silent><CR>", ":nohlsearch<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>r<space>", "mm:%s/[\t ]*$//g<CR>:noh<CR>'mzz", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>t", ":TagbarToggle<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>n", ":noh<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>w", ":w!<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-p>", ":Telescope find_files<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>u", ":UndotreeToggle<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>b", ":Telescope buffers<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "ff", ":Format<cr>", { noremap = true })

-- For copy paste
vim.api.nvim_set_keymap("v", "<C-c>", '"+ygv', { noremap = true })
-- to escape the terminal
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Put your favorite colorscheme here
vim.cmd([[colorscheme onedark]])

vim.cmd("au TextYankPost * lua vim.highlight.on_yank {on_visual = true}") -- disabled in visual mode

-- vim.cmd([[let g:neoformat_c_clangformat = {'exe'  : 'clang-format', 'args' : ["--style='{IndentWidth: 4}'"],}]])
-- vim.cmd([[let g:neoformat_cpp_clangformat = {'exe'  : 'clang-format', 'args' : ["--style='{IndentWidth: 4}'"],}]])

local nvim_lsp = require("lspconfig")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local servers = { "pyright", "rust_analyzer", "clangd", "julials", "texlab", "csharp-ls", "gopls", "hls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  })
end

vim.cmd([[imap <silent><script><expr> <C-l> copilot#Accept("\<CR>")]])
vim.cmd([[let g:copilot_no_tab_map = v:true]])

-- vim.lsp.diagnostic.show_line_diagnostics()
vim.diagnostic.show()

--nvim cmp config start
-- Setup nvim-cmp.
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

      -- For `luasnip` user.
      -- require('luasnip').lsp_expand(args.body)

      -- For `ultisnips` user.
      -- vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },

    -- For vsnip user.
    { name = "vsnip" },

    -- For luasnip user.
    -- { name = 'luasnip' },

    -- For ultisnips user.
    -- { name = 'ultisnips' },

    { name = "buffer" },
  },
})
--end

-- nvim auto-pairs setup
require("nvim-autopairs").setup({})
-- nvim auto-pairs setup end

-- nvim tresitter setup
require("nvim-treesitter.configs").setup({
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {}, -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

-- telescope setup
require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    use_less = true,
    path_display = {},
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
  },
})

-- Spelling stuffies
vim.api.nvim_set_keymap("n", "<leader>9", "<cmd> lua require('spell').NoSp()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>0", "<cmd> lua require('spell').EnSp()<cr>", { noremap = true })

vim.cmd([[au BufRead,BufNewFile *.h setfiletype c]])

--Formatter
local latexindent = function()
  return {
    exe = "latexindent",
    args = {},
    stdin = true,
  }
end

local hindent = function()
  return {
    exe = "hindent",
    args = {},
    stdin = true,
  }
end

-- Formatting
local astyle_format = function()
  return {
    exe = "astyle",
    args = {},
    stdin = true,
  }
end

require("formatter").setup({
  logging = false,
  filetype = {
    rust = {
      function()
        return {
          exe = "rustfmt",
          args = { "--emit=stdout", "--edition=2018" },
          stdin = true,
        }
      end,
    },
    python = {
      function()
        return {
          exe = "autopep8",
          args = { "-" },
          stdin = true,
        }
      end,
    },
    c = {
      astyle_format,
    },
    cpp = {
      astyle_format,
    },
    latex = {
      latexindent,
    },
    tex = {
      latexindent,
    },
    haskell = {
        hindent,
    },
    lua = {
      -- Stylua
      function()
        return {
          exe = "stylua",
          args = { "--indent-width", 2, "--indent-type", "Spaces" },
          stdin = false,
        }
      end,
    },
    go = {
      -- gofmt
      function()
        return {
          exe = "gofmt",
          args = { "" },
          stdin = true,
        }
      end,
    },
  },
})

require("rust-tools").setup({})
