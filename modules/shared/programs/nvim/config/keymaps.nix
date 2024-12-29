let
  defaultOpts = {
    silent = true;
    noremap = true;
  };

  mkMap = mode: key: action: {
    inherit mode key action;
    options = defaultOpts;
  };
in
[
  (mkMap "n" "<leader>d" "<cmd>Ex<CR>")

  # Copy to/Paste from system clipboard
  (mkMap [
    "n"
    "x"
  ] "sy" ''"+y'')
  (mkMap [
    "n"
    "x"
  ] "sp" ''"+p'')

  # Move lines
  (mkMap "v" "J" ":m '>+1<CR>gv=gv")
  (mkMap "v" "K" ":m '<-2<CR>gv=gv")

  # Append line below to current line and keep cursor in same place with J
  (mkMap "n" "J" "mzJ`z")

  # Jump up/down page and keep cursor in same place
  (mkMap "n" "<C-u>" "<C-u>zz")
  (mkMap "n" "<C-d>" "<C-d>zz")

  # Keep cursor centred when searching
  (mkMap "n" "n" "nzzzv")
  (mkMap "n" "N" "Nzzzv")

  # Replace the word I am currently on
  (mkMap "n" "<leader>e" ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

  # Make the current file executable
  (mkMap "n" "<leader>x" ":!chmod +x %<CR>")
]
