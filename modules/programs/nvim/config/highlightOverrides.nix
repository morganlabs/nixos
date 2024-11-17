let
  leftColumn = {
    bg = "none";
    ctermbg = "none";
    bold = true;
  };
in
{
  LineNr = leftColumn;
  LineNrAbove = leftColumn;
  LineNrBelow = leftColumn;
  SignColumn = leftColumn;
  # Normal.bg = "none";
  # NormalFloat.bg = "none";

  # LineNr = { bg = "none", bold = true },
  # LineNrAbove = { bg = "none", bold = true },
  # LineNrBelow = { bg = "none", bold = true },
  # NonText = { bg = "none", ctermbg = "none" },
  # Normal = { bg = "none", ctermbg = "none" },
  # NormalFloat = { bg = "none" },
  # SignColumn = { bg = "none", ctermbg = "none" },
}
