-- Auto-start SourceKit for Swift buffers (macOS-friendly)
local group = vim.api.nvim_create_augroup('swift_lsp', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = 'swift',
  callback = function(args)
    -- don't start twice
    for _, c in ipairs(vim.lsp.get_clients { bufnr = args.buf }) do
      if c.name == 'sourcekit' or c.name == 'sourcekit-lsp' then
        return
      end
    end

    local fname = vim.api.nvim_buf_get_name(args.buf)
    local start = vim.fs.dirname(fname)
    local root_file = vim.fs.find({ 'Package.swift', '.git', '*.xcodeproj', '*.xcworkspace' }, { upward = true, path = start })[1]
    local root = root_file and vim.fs.dirname(root_file) or vim.fn.getcwd()

    -- macOS: use xcrun so you always get the right toolchain
    local cmd = { 'xcrun', 'sourcekit-lsp' }
    -- If you KNOW `sourcekit-lsp` is on PATH directly, you could use { "sourcekit-lsp" } instead.

    local client_id = vim.lsp.start {
      name = 'sourcekit',
      cmd = cmd,
      root_dir = root,
    }
    if client_id then
      vim.lsp.buf_attach_client(args.buf, client_id)
    end
  end,
})
