vim.g.mapleader = " "
vim.g.localmapleader = " "
local map = vim.keymap.set

local opts = function(desc)
    return {
        silent = true,
        nowait = true,
        desc = desc
    }
end

map("n", "<Space>", "<Nop>", opts("SpaceBard do nothing!"))

map("n", "<leader>pv", vim.cmd.Ex, opts("Back to dir list."))
map("n", "<leader>bp", vim.cmd.bp, opts("Prev Buffer."))
map("n", "<leader>bn", vim.cmd.bn, opts("Next Buffer."))
map("n", "<leader>bd", vim.cmd.bd, opts("Delete Opening buffer."))
map("n", "Y", [[yg_]], opts("Yank to eol"))

map("n", "<C-d>", "<C-d>zz", opts("Scroll up and center current line."))
map("n", "<C-u>", "<C-u>zz", opts("Scroll down and center current line."))
map("n", "n", "nzzzv", opts("Next search result and center current result."))
map("n", "N", "Nzzzv", opts("Prev search result and center current result."))
map("n", "<leader>y", [["+y]], opts("yank select to clipboard."))
map("v", "<leader>Y", '"+Y', opts("yank line to clipboard"))
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts("subsitute word under cursor"))
map("n", "<leader>;", ":", opts("Enter cmd mode."))
map("n", "<leader>q", ":q!", opts("Force exit nvim"))
map("n", "<leader>w", ":w", opts("Write current file"))
map("n", "<leader>x", ":x", opts("Write & Exit"))
map({ "n", "v" }, "<leader>d", [["_d]], opts("Void delete"))
map("n", "<leader>vcf", function() vim.cmd.edit("~/.config/nvim/") end, opts("Open nvim config dir"))
map("n", "<leader>ex", ":!chmod u+x %<cr>", opts("chmod +x. to current file."))
map("i", "<C-c>", "<C-[>", opts("<ESC> to normal mode."))
map("v", "J", ":m '>+1<CR>gv=gv", opts("Move select line up"))
map("v", "K", ":m '<-2<CR>gv=gv", opts("Move select line up"))
map("x", "<leader>p", [["_dP]], opts("Void current word and paste current register"))

map("n", "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })
map("n", "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })
