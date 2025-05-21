''
  *:not(window) {
    border-radius: 8px;
    transition: background 0.1s ease-in-out;
  }

  window#waybar {
    background: alpha(@base00, 0.5);
  }

  .modules-left {
    padding-left: 10px;
  }

  .modules-right {
    padding-right: 10px;
  }

  #workspaces button.active, .modules-right * .module:hover {
    background: alpha(@base00, 0.25);
  }

  #workspaces button.empty {
    opacity: 0.5;
  }

  #workspaces button.urgent label {
    color: @base09;
  }

  .modules-right * .module {
    padding-left: 10px;
    padding-right: 10px;
  }

  .modules-right * label, #workspaces button * label {
    text-shadow: 0px 2px 2px alpha(black, 0.5);
  }
''
