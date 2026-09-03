-- Plugin manager: lazy.nvim

--------------------------------------------------------------------------------
-- Leader (must be set before lazy.nvim loads)
--------------------------------------------------------------------------------
vim.g.mapleader = ","
vim.g.maplocalleader = ","

--------------------------------------------------------------------------------
-- Plugin-related globals (set before plugins load)
--------------------------------------------------------------------------------
-- vim-session
vim.g.session_autosave = "no"
vim.g.session_autoload = "no"

-- tagbar
vim.g.tagbar_left = 1
-- vim.g.tagbar_width = 90

-- vim-floaterm
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.9
vim.g.floaterm_wintype = "split"
vim.g.floaterm_title = "$1/$2" -- title shown in the floating window border

--------------------------------------------------------------------------------
-- lazy.nvim bootstrap
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
require("lazy").setup({
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    { "dense-analysis/ale" },
    { "scrooloose/nerdtree" },

    { "xolox/vim-session", dependencies = { "xolox/vim-misc" } },

    -- To Use: :TagbarToggle
    { "preservim/tagbar" },

    -- coc.nvim
    -- pip install --user cmake-language-server
    -- :CocInstall coc-pyright
    -- :CocInstall coc-clangd
    { "neoclide/coc.nvim", branch = "release" },

    { "voldikss/vim-floaterm" },

    -- Themes
    { "altercation/vim-colors-solarized" },
    { "jnurmine/Zenburn" },
    { "twerth/ir_black" },
    { "morhetz/gruvbox" },
    { "rakr/vim-one" },
    { "folke/tokyonight.nvim" },
}, {
    -- keep default lazy.nvim behavior; use :Lazy to manage plugins
})

--------------------------------------------------------------------------------
-- General Things
--------------------------------------------------------------------------------
vim.opt.showcmd = true
-- Highlight current line
vim.opt.cursorline = true
-- vim.opt.cursorcolumn = true
vim.cmd("syntax on")
-- Default mouse state.
vim.opt.mouse = ""
-- Tab settings
vim.opt.expandtab = true
vim.opt.ruler = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
-- Search
vim.opt.incsearch = true -- search as characters are entered
vim.opt.showmatch = true -- highlight matching
vim.opt.hlsearch = true  -- highlight matches
vim.opt.wrapscan = true  -- turn on search wrap
vim.opt.laststatus = 2
vim.opt.textwidth = 80
-- No visual bell
vim.opt.visualbell = true
vim.opt.belloff = "all"

vim.opt.tabpagemax = 100
-- Spelling
vim.opt.spelllang = "en"
-- Make file open auto-complete friendlier
vim.opt.wildmenu = true
vim.opt.wildmode = { "list:longest" }

-- Toggle mouse support with Leader+m
local function toggle_mouse()
    if vim.o.mouse == "a" then
        vim.opt.mouse = ""
    else
        vim.opt.mouse = "a"
    end
end
vim.keymap.set("n", "<Leader>m", toggle_mouse, { silent = true })

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------
require("tokyonight").setup({
    on_highlights = function(highlights, colors)
        -- 1. Active Tab Text (Foreground) and Background
        highlights.TabLineSel = {
            fg = colors.orange,
            bg = colors.bg_statusline,
            bold = true,
        }
        -- 2. Inactive Tab Text (Foreground) and Background
        highlights.TabLine = {
            fg = colors.cyan,
            bg = colors.bg_dark,
        }
        -- 3. The empty space fill of the tab bar
        highlights.TabLineFill = {
            bg = colors.bg_dark
        }
    end,
})

vim.cmd[[colorscheme tokyonight-night]]

--------------------------------------------------------------------------------
-- lualine
--------------------------------------------------------------------------------
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
                'WinEnter',
                'BufEnter',
                'BufWritePost',
                'SessionLoadPost',
                'FileChangedShellPost',
                'VimResized',
                'Filetype',
                'CursorMoved',
                'CursorMovedI',
                'ModeChanged',
            },
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

--------------------------------------------------------------------------------
-- Coc
--------------------------------------------------------------------------------
vim.g.coc_global_extensions = {
    'coc-pyright',
    'coc-rust-analyzer',
    'coc-go',
    'coc-clangd'
}

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 2

-- Show coc.nvim status, including extension installation progress
vim.opt.statusline:prepend('%{coc#status()}')

local keyset = vim.keymap.set
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Trigger completion with Tab and navigate the completion menu
local opts = {
    silent = true,
    noremap = true,
    expr = true,
    replace_keycodes = false
}
keyset('i', '<TAB>', 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
vim.keymap.set('i', '<CR>', [[coc#pum#visible() ? coc#pum#confirm() : "\<CR>"]], { expr = true, silent = true })

-- Diagnostics and code navigation
keyset('n', '[g',         '<Plug>(coc-diagnostic-prev)', { silent = true })
keyset('n', ']g',         '<Plug>(coc-diagnostic-next)', { silent = true })
keyset('n', 'gd',         '<Plug>(coc-definition)', { silent = true })
keyset('n', 'gy',         '<Plug>(coc-type-definition)', { silent = true })
keyset('n', 'gi',         '<Plug>(coc-implementation)', { silent = true })
keyset('n', 'gr',         '<Plug>(coc-references)', { silent = true })
keyset('n', '<leader>rn', '<Plug>(coc-rename)', { silent = true })
keyset('n', '<leader>qf', '<Plug>(coc-fix-current)', {silent = true})

--------------------------------------------------------------------------------
-- VIM-Session
--------------------------------------------------------------------------------
-- :SaveSession <name>
-- :OpenSession
-- (session_autosave / session_autoload globals set near the top)

--------------------------------------------------------------------------------
-- Tex Things
--------------------------------------------------------------------------------
-- Default to tex flavor by default
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.tex",
    callback = function()
        vim.bo.filetype = "tex"
    end,
})

--------------------------------------------------------------------------------
-- Python Things
--------------------------------------------------------------------------------
-- stop terrible default indentation of '#'s in python
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*.py",
    callback = function()
        vim.keymap.set("i", "#", "X<c-h>#", { buffer = true })
    end,
})

--------------------------------------------------------------------------------
-- TagBar Things
--------------------------------------------------------------------------------
-- (tagbar_left / tagbar_width globals set near the top)

--------------------------------------------------------------------------------
-- Floatterm settings
--------------------------------------------------------------------------------
vim.keymap.set("n", "<Leader>t", ":FloatermToggle term1<CR>", { silent = true })
vim.keymap.set("t", "<Leader>t", "<C-\\><C-n>:FloatermToggle term1<CR>", { silent = true })

vim.keymap.set("n", "<Leader>c", ":FloatermToggle term2<CR>", { silent = true })
vim.keymap.set("t", "<Leader>c", "<C-\\><C-n>:FloatermToggle term2<CR>", { silent = true })

-- To scroll: <C-\><C-n>

--------------------------------------------------------------------------------
-- Notes
--------------------------------------------------------------------------------
-- :term in nvim, not :sh
-- setf - set filetype
-- folding - zf unfolding - zfa
-- :%!xxd to switch into hex mode.
-- :%!xxd -r to exit from hex mode.
-- :set spell - z= for suggestions
-- :Autoformat (uses astyle -- vim-autoformat)
-- ciDELIM to update text between DELIM pair (e.g., (), [])
-- cit update text between tags (e.g., <div>)

--------------------------------------------------------------------------------
-- cscope stuff
--------------------------------------------------------------------------------
-- update cscope db:
-- o :!cscope -Rb
-- o :cs reset

--------------------------------------------------------------------------------
-- make buffer
--------------------------------------------------------------------------------
-- :make
-- :copen
