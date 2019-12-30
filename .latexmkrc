# -*- mode: perl -*-

# Use XeLaTeX to compile
$pdf_mode = 5;
$dvi_mode = $postscript_mode = 0;

$xelatex_default_switches = '-no-pdf -synctex=1';

$pdf_previewer = 'open -a Skim';
@generated_exts = (@generated_exts, 'synctex.gz');

$out_dir = 'build';
