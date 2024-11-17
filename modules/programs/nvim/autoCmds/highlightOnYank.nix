{
  event = [ "TextYankPost" ];
  command = ''lua vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })'';
}
