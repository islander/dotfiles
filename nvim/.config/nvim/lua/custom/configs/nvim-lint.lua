local lint = require('lint')

lint.linters_by_ft = {
  go = {'golangcilint'}
}

require("lint").try_lint()
