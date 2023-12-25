# Typst Tree-Sitter Mode

Tree Sitter support for Typst. Minimum Emacs version requirement: 29.  

![Static Badge](https://img.shields.io/badge/Made_with-Emacs-purple)

[Project Page](https://sr.ht/~meow_king/typst-mode)  
[Home Page for this Package](https://git.sr.ht/~meow_king/typst-ts-mode)  
[Send a Patch](https://lists.sr.ht/~meow_king/typst-ts-mode-dev)  
[Discussion](https://lists.sr.ht/~meow_king/typst-ts-mode-discussion): Questions and Feedback  
[Tickets](https://todo.sr.ht/~meow_king/typst-ts-mode): issues, feature requests, etc.  
[Public Inbox](https://lists.sr.ht/~meow_king/public-inbox): General Consults

## Requirement

1. Emacs >= 29

2. Latest [Typst](https://github.com/typst/typst).  
`typst 0.10.0 (70ca0d25)`

3. Tree Sitter parser for Typst: https://github.com/uben0/tree-sitter-typst  
commit: `c0765e3`

Note this tree sitter parser is included in [tree sitter modules](https://github.com/casouri/tree-sitter-module), so you can use the build script 
in it to get this parser.  
You can also use the following script to build the parser too, which is extracted 
from `tree sitter modules`.  
<details>
  <summary>Click me</summary>
  
*Note*, you should change the extension of `libtree-sitter-typst.so` from `so` to `dylib`(Darwin) or 
`dll`(Windows) to match your system specification.

```shell
git clone --depth=1 --single-branch -b master git@github.com:uben0/tree-sitter-typst.git

cd tree-sitter-typst/src
cc -fPIC -c -I. parser.c

# Compile scanner.c.
if test -f scanner.c
then
    cc -fPIC -c -I. scanner.c
fi

# Compile scanner.cc.
if test -f scanner.cc
then
    c++ -fPIC -I. -c scanner.cc
fi

# Link.
if test -f scanner.cc
then
    c++ -fPIC -shared *.o -o "libtree-sitter-typst.so"
else
    cc -fPIC -shared *.o -o "libtree-sitter-typst.so"
fi
```

</details>


After building, you can see that there is a file called `typst-sitter-typst.so`(`.so` may also be `.dylib` or `.dll` too). Then move this file to the tree sitter parser directory ( Evaluate expression `(info "(elisp) Language Grammar")` in Emacs to read the info manual of tree sitter language grammar. The infomation of where the tree sitter parsers should be put locates in the first few paragraph of this manual). After that, you can install this package. 

## Installation

For reference, this is my configuration.
``` emacs-lisp
(use-package typst-ts-mode
  :elpaca (:type git :host sourcehut :repo "meow_king/typst-ts-mode")
  :custom
  (typst-ts-mode-watch-options "--open"))
```

## Keys

`C-c C-c c` : `typst-ts-mode-compile-and-preview`  
`C-c C-c C` : `typst-ts-mode-compile`  
`C-c C-c w` : `typst-ts-mode-watch-toggle`  
`C-c C-c p` : `typst-ts-mode-preview`  
`M-<left>`  : `typst-ts-mode-heading-decrease`  
`M-<right>` : `typst-ts-mode-heading-increase`  
`M-<up>`    : `typst-ts-mode-heading-up`  
`M-<down>`  : `typst-ts-mode-heading-down`  

*NOTE*: `outline-minor-mode` is enabled by `typst-ts-mode`, so you can use comamnd 
defined by `outline-minor-mode` such as `outline-cycle`.

## Customization Options

`customize` -> `typst-ts`

For some options you may find useful:
1. `typst-ts-mode-indent-offset`
2. `typst-ts-mode-executable-location`
3. `typst-ts-mode-watch-options`. Set this to `--open` so typst will open the compiled
file for you.
4. `typst-ts-mode-compile-options`. Note that setting `--open` has no use for this
customization variable. You can execute the shell command 
`typst compile <file> --open && sleep 1` to view what is happening. 
5. `typst-ts-mode-display-watch-process-bufer-automatically`. This is set to `t` by
default, so the `typst watch` process buffer appear when an error occurs, and disappear
when there is no error. You may find sometimes there is only one error at a time, and it is
because Typst itself do this style. You may find `auto-save-visited-mode`,
[auto-save](https://github.com/manateelazycat/auto-save) or 
[super-save](https://github.com/bbatsov/super-save) useful (or annoying).
6. `typst-ts-markup-header-same-height` and `typst-ts-markup-header-scale` to control header height. 
7. `typst-ts-mode-before-compile-hook` and `typst-ts-mode-after-compile-hook`

### Consult Imenu Integration
If you use `consult-iemnu`
command [consult](https://github.com/minad/consult), you way want this setting.
``` emacs-lisp
(setq
 consult-imenu-config
 (append consult-imenu-config
         '((typst-ts-mode :topLevel "Headings" :types
                          ((?h "Headings" typst-ts-markup-header-face)
                           (?f "Functions" font-lock-function-name-face))))))
```

## Co-Maintainer

[Huan Nguyen](https://sr.ht/~huan)

## Do you want to develop a new Tree Sitter Major Mode?

Here are some resources:
- [Let’s Write a Tree-Sitter Major Mode - Matering Emacs](https://www.masteringemacs.org/article/lets-write-a-treesitter-major-mode)
- [ts-query-highlight](https://sr.ht/~meow_king/ts-query-highlight/)  
  I wrote this package to highlight tree sitter queries. I use this package to help
developing `typst-ts-mode`.
- [combobulate](https://github.com/mickeynp/combobulate)
