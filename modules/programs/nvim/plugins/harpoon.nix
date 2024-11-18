{
  programs.nixvim.plugins.harpoon = {
    enable = true;
    keymaps = {
      addFile = "<leader>a";
      toggleQuickMenu = "<C-y>";
      navFile = {
        "1" = "<C-h>";
        "2" = "<C-j>";
        "3" = "<C-k>";
        "4" = "<C-l>";
      };
    };
  };
}
