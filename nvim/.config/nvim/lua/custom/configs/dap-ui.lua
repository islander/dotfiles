-- local dap, dapui =require("dap"),require("dapui")

local dap_present, dap = pcall(require, "dap")
if not dap_present then
  return
end

local dapui_present, dapui = pcall(require, "dapui")
if not dapui_present then
  return
end


dapui.setup()

dap.listeners.after.event_initialized["dapui_config"]=function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"]=function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"]=function()
  dapui.close()
end
