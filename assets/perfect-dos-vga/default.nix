{ runCommand, ... }:
runCommand "perfect-dos-vga" {} ''
    install -m444 -D "${./.}/More Perfect DOS VGA.ttf" $out/share/fonts/truetype/more-perfect-dos-vga.ttf
    install -m444 -D "${./.}/Less Perfect DOS VGA.ttf" $out/share/fonts/truetype/less-perfect-dos-vga.ttf
''
