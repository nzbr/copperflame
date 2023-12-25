{ runCommand, ... }:
runCommand "perfect-dos-vga" { } ''
  install -m444 -D "${./.}/more-perfect-dos-vga.ttf" $out/share/fonts/truetype/more-perfect-dos-vga.ttf
  install -m444 -D "${./.}/less-perfect-dos-vga.ttf" $out/share/fonts/truetype/less-perfect-dos-vga.ttf
''
