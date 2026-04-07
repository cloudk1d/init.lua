local specs = {
    "https://github.com/tpope/vim-commentary",
    "https://github.com/airblade/vim-gitgutter",
    "https://github.com/tpope/vim-surround",
    "https://github.com/jiangmiao/auto-pairs",
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-buffer",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/hrsh7th/cmp-cmdline",
    "https://github.com/saadparwaiz1/cmp_luasnip",
    "https://github.com/hrsh7th/cmp-vsnip",
    "https://github.com/hrsh7th/vim-vsnip",
    { src = "https://github.com/hendrikpetertje/copilot-cmp", version = "fix-deprecated-errors" },
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/ANGkeith/telescope-terraform-doc.nvim",
    "https://github.com/wakatime/vim-wakatime",
    "https://github.com/b0o/schemastore.nvim",
    "https://github.com/mfussenegger/nvim-ansible",
    "https://github.com/NiklasV1/nvim-colorizer.lua",
    "https://github.com/f-person/git-blame.nvim",
    "https://github.com/folke/todo-comments.nvim",
    "https://github.com/preservim/vim-pencil",
    "https://github.com/junegunn/limelight.vim",
    "https://github.com/joerdav/templ.vim",
    "https://github.com/windwp/nvim-ts-autotag",
    "https://github.com/alexghergh/nvim-tmux-navigation",
    "https://github.com/bullets-vim/bullets.vim",
    "https://github.com/hedyhli/outline.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    "https://github.com/clangd/clangd",
    "https://github.com/gbprod/phpactor.nvim",
    "https://github.com/junegunn/fzf",
    "https://github.com/junegunn/fzf.vim",
    "https://github.com/ThePrimeagen/vim-be-good",
    "https://github.com/rachartier/tiny-code-action.nvim",
    "https://github.com/prettier/vim-prettier",
    "https://github.com/bufbuild/vim-buf",
    "https://github.com/Afourcat/treesitter-terraform-doc.nvim",
    "https://github.com/laytan/cloak.nvim",
    "https://github.com/luckasRanarison/tailwind-tools.nvim",
    "https://github.com/iamcco/markdown-preview.nvim",
    "https://github.com/zbirenbaum/copilot.lua",
}

local function run_post_install_hooks(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= "install" and kind ~= "update" then
        return
    end

    if name == "LuaSnip" then
        vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path })
        return
    end

    if name == "markdown-preview.nvim" then
        vim.system({ "npm", "install" }, { cwd = ev.data.path .. "/app" })
        return
    end

    if name == "vim-prettier" then
        vim.system({ "npm", "install" }, { cwd = ev.data.path })
        return
    end

    if name == "nvim-treesitter" then
        if not ev.data.active then
            vim.cmd.packadd("nvim-treesitter")
        end
        pcall(vim.cmd, "TSUpdate")
    end
end

vim.api.nvim_create_autocmd("PackChanged", { callback = run_post_install_hooks })

vim.pack.add(specs, { confirm = false, load = true })
