local M = {}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO)
end

local function git(args)
  local output = vim.fn.system({ 'git', unpack(args) })
  local ok = vim.v.shell_error == 0
  return ok, output
end

local function git_lines(args)
  local lines = vim.fn.systemlist({ 'git', unpack(args) })
  local ok = vim.v.shell_error == 0
  return ok, lines
end

local function has_staged_changes()
  git({ 'diff', '--cached', '--quiet', '--exit-code' })
  return vim.v.shell_error ~= 0
end

local function has_any_changes()
  local ok, lines = git_lines({ 'status', '--porcelain' })
  if not ok then
    return false
  end
  return #lines > 0
end

local function last_real_commit()
  local ok, lines = git_lines({ 'log', '--format=%H', '--invert-grep', '--grep=^wip:', '-n', '1' })
  if not ok or #lines == 0 or lines[1] == '' then
    return nil
  end
  return lines[1]
end

local function next_wip_number()
  local base = last_real_commit()
  local args = { 'log', '--first-parent', '--format=%s', '--grep=^wip:' }
  if base then
    table.insert(args, 3, base .. '..HEAD')
  end

  local ok, lines = git_lines(args)
  if not ok then
    return 1
  end
  return #lines + 1
end

function M.wip_commit()
  local default_message = string.format('wip: %d', next_wip_number())
  local message = vim.fn.input('WIP message: ', default_message)
  if message == '' then
    notify('WIP commit cancelled', vim.log.levels.WARN)
    return
  end

  if not has_staged_changes() then
    if not has_any_changes() then
      notify('No changes to commit', vim.log.levels.WARN)
      return
    end

    local ok_add = git({ 'add', '-A' })
    if not ok_add then
      notify('git add -A failed', vim.log.levels.ERROR)
      return
    end
  end

  local ok_commit, output = git({ 'commit', '-m', message, '--no-verify' })
  if not ok_commit then
    notify(output, vim.log.levels.ERROR)
    return
  end

  notify('WIP commit created')
end

function M.wip_finalize()
  local base = last_real_commit()
  if not base then
    notify('No real commit found before wip commits', vim.log.levels.WARN)
    return
  end

  local ok_reset, output = git({ 'reset', '--soft', base })
  if not ok_reset then
    notify(output, vim.log.levels.ERROR)
    return
  end

  vim.cmd('Neogit commit')
end

function M.wip_diff()
  local base = last_real_commit()
  if not base then
    notify('No real commit found before wip commits', vim.log.levels.WARN)
    return
  end

  vim.cmd('DiffviewOpen ' .. base .. '..HEAD')
end

vim.keymap.set('n', '<leader>gw', M.wip_commit, { desc = 'Git WIP commit' })
vim.keymap.set('n', '<leader>gF', M.wip_finalize, { desc = 'Git WIP finalize' })
vim.keymap.set('n', '<leader>gD', M.wip_diff, { desc = 'Git WIP diff' })

vim.api.nvim_create_user_command('WipFinalize', M.wip_finalize, { desc = 'Finalize wip commits' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'NeogitStatus',
  callback = function()
    vim.keymap.set('n', 'F', M.wip_finalize, { buffer = true, desc = 'Finalize wip commits' })
    vim.keymap.set('n', 'W', M.wip_commit, { buffer = true, desc = 'Wip commit' })
  end,
})

return M
