-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use('wbthomason/packer.nvim')

    use("tpope/vim-commentary")
    use("airblade/vim-gitgutter")
    use("tpope/vim-surround")
    use({
        "jiangmiao/auto-pairs",
        AutoPairsMapSpace = 0
    })
    use({ "lukas-reineke/indent-blankline.nvim" })

    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    })

    use({
        "L3MON4D3/LuaSnip",
        -- install jsregexp (optional!:).
        run = "make install_jsregexp"
    })

    use({
        "neovim/nvim-lspconfig",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
        -- "zbirenbaum/copilot-cmp"
    })
    use({
        'hendrikpetertje/copilot-cmp', -- fork of ^ that fixes deprecation errors
        branch = 'fix-deprecated-errors'
    })

    use({
        "nvim-telescope/telescope.nvim",
        -- tag = "v0.2.1",
        -- branch = "0.1.x",
        tag = "*",
        requires = {
            "nvim-lua/plenary.nvim",
            "ANGkeith/telescope-terraform-doc.nvim"
        }
    })

    use("wakatime/vim-wakatime")
    use("b0o/schemastore.nvim")
    -- use("pearofducks/ansible-vim")
    use("mfussenegger/nvim-ansible")
    -- use("norcalli/nvim-colorizer.lua")
    use("NiklasV1/nvim-colorizer.lua") -- fork of ^ that fixes deprecated api usage
    use("f-person/git-blame.nvim")
    -- use("onsails/lspkind.nvim") -- syntax symbols.. need patched font
    use("folke/todo-comments.nvim")
    use("preservim/vim-pencil")
    -- use({"junegunn/goyo.vim"})
    -- use("folke/zen-mode.nvim")
    use("junegunn/limelight.vim")
    use("joerdav/templ.vim")
    use("windwp/nvim-ts-autotag")
    -- use("christoomey/vim-tmux-navigator")
    use("alexghergh/nvim-tmux-navigation")
    use("bullets-vim/bullets.vim")
    use("hedyhli/outline.nvim")
    use("nvim-treesitter/nvim-treesitter-context")
    use("clangd/clangd")
    use("gbprod/phpactor.nvim")

    use("junegunn/fzf")
    use("junegunn/fzf.vim")

    use("ThePrimeagen/vim-be-good")

    use({
        "rachartier/tiny-code-action.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        }
    })

    use({
        "prettier/vim-prettier",
        run = 'npm install',
        -- ft = { 'javascript', 'typescript', 'blade', 'css', 'html', 'edge' }
    })

    -- use("dense-analysis/ale") -- this caused duplicate diagnostic messages.. probably a way to disable it
    use("bufbuild/vim-buf")
    use("Afourcat/treesitter-terraform-doc.nvim")
    use("laytan/cloak.nvim")
    -- use({
    --     "olimorris/codecompanion.nvim",
    --     requires = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --     }
    -- })
    use({ "luckasRanarison/tailwind-tools.nvim" })
    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" }
    })

    use({
        "zbirenbaum/copilot.lua",
    })
end)
