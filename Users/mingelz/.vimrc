" Vimrc
" mingelz <mingelz@gmail.com>
" 2016-07-21 21:42:47

" == 此 vimrc 仅适用于 VIM 7.0 以上版本 == {{{
if v:version < 700
  echoerr 'This vimrc requires Vim 7 or later.'
  quit
endif
" == }}}

" == 变量 == {{{
let RTHOME=split(&runtimepath, ',')[0]    "先取到 RUNTIMEPATH 路径，.vim 或 vimfiles，接下来会用到
" == }}}

" == 基础 == {{{
set modeline    "开启模式行
set modelines=2    "模式行有效范围为文件最前两行或最后两行
set nocompatible    "关闭针对 Vi 的兼容模式
source $VIMRUNTIME/vimrc_example.vim    "Vim 格式化脚本
if has("win32")
  source $VIMRUNTIME/mswin.vim    "设置快捷键为 Windows 方式
  behave mswin    "设置快捷键为 Windows 方式
endif
"指定 viminfo 的位置，使用 set viminfo 的方式只能跟字符串，为了合适变量，需要用 let &viminfo
if has('nvim')
  " neovim 的 viminfo 格式不与 vim 兼容
  let &viminfo .= ',n' . RTHOME . '/nviminfo'
else
  let &viminfo .= ',n' . RTHOME . '/viminfo'
endif
" == }}}

" == 编码 == {{{
set encoding=utf-8    "Vim 内部使用的字符编码方式，包括 buffer(缓冲区)、菜单文本、消息文本等
set fileencoding=utf-8    "Vim 中当前编辑的文件的字符编码方式，Vim 保存文件时也会将文件保存为这种字符编码方式 (不管是否新文件都如此)，打开新文件时此值可能会被修改，请看 fileencodings 项
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1    "Vim 自动探测 fileencoding 的顺序列表，启动时会按照它所列出的字符编码方式逐一探测即将打开的文件的字符编码方式，并且将 fileencoding 设置为最终探测到的字符编码方式。因此最好将 Unicode 编码方式放到这个列表的最前面，将拉丁语系编码方式 latin1 放到最后面
source $VIMRUNTIME/delmenu.vim    "处理菜单编码
source $VIMRUNTIME/menu.vim    "处理菜单编码
if has("win32")
  language messages zh_CN.utf-8    "处理 console 输出编码
endif
set fileformats=unix,dos,mac    "默认使用 UNIX 文件格式及换行符 (使用 :set fileformat=unix 可以将文件格式转为 UNIX) [ff=fileformat, ffs=fileformats]
set ambiwidth=double    "设置宽度不明的文字 (如中文破折号) 为双宽度文本
set nobomb    "不设置 Unicode BOM
" == }}}

" == 字体 == {{{
" 推荐 http://input.fontbureau.com/ 系列的字体
if has("win32")    "GVim on Windows
  set guifont=Yahei\ Mono:h11:cGB2312    "Yahei Mono 下载地址：http://url.cn/LXjV5U (字体作者博客已无法访问：http://blog.humou.net/?p=898)
  "set guifontwide=Yahei\ Mono:h11:cGB2312
elseif has("mac")    "Vim on Mac, or MacVim
  set guifont=Monaco:h18    "设置界面字体:大小:编码
  set guifontwide=Heiti\ SC:h18    "像汉字属于宽字体，一个字占两个字符
elseif has("unix")    "Linux, 主要是 Ubuntu
  set guifont=Inconsolata\ Medium\ 11
  set guifontwide=WenQuanYi\ Micro\ Hei\ Mono\ Medium\ 10
endif
" == }}}

" == 界面 == {{{
set number    "显示行号 (不显示行号为 nonumber) [nu=number]
set ruler    "显示标尺 (状态栏，不显示标尺为 noruler)
set wrap    "自动换行 (不自动换行为 nowrap)
set scrolloff=2    "上下滚动时，总是预留 X 行，而不是光标到最顶或最底后才滚动
if has("gui_running")    "当在 GUI 运行时
  set guioptions=eg    "定义 GUI 界面元素 (b:底部滚动条总是存在; e:标签栏; g:不可用的菜单项变灰; t:菜单栏可撕下; T:工具栏; m:菜单栏; r:右侧滚动条总是存在; R:如有垂直分割的窗口则右侧滚动条总是存在; l左侧滚动条总是存在; L如有垂直分割的窗口则左侧滚动条总是存在) [go=guioptions]
  set mousehide    "输入时隐藏光标
  "set cursorline    "高亮当前行
  "set cursorcolumn    "高亮当前列
  "hi cursorline guibg=#333333    "当前行背景色
  "hi cursorcolumn guibg=#333333    "当前列背景色
  colo desert
  if has("win32")
    au GUIEnter * simalt ~x    "界面最大化
    "winpos 1 1    "窗口起始位置，当双屏幕时，可以让 Vim 默认在某个屏幕打开
  elseif has("mac")
    set antialias    "抗锯齿渲染
    set transparency=10    "半透明，取值0-100，0为不透明，100为全透明
  endif
else
  colo koehler
endif
" == }}}

" == 标签栏 & 命令行 & 状态栏 == {{{
set showtabline=2    "显示tab标签 (0:从不显示; 1:至少2个tab才显示; 2:总是显示)
"set laststatus=2    "显示状态栏 (0:从不显示; 1:至少2个tab才显示; 2:总是显示)
"set tabline=%N\)\ %t\ %M    "自定义 terminal 下的标签内容 (%N:标签序号; %t:文件名; %M:是否被修改) [gtl=guitablable]
set wildmenu    "使用增强模式的命令行补全
set showcmd    "在状态栏显示目前所执行的指令，未完成的指令片断也显示
"set statusline=\ [File]\ %F%m%r%h%y[%{&fileformat},%{&fileencoding}]\ %w\ \ [PWD]\ %r%{GetPWD()}%h\ %=\ [Line]%l/%L\ %=\[%P]    "自定义状态栏内容 [stl=statusline]
" == }}}

" == 按键 == {{{
set backspace=indent,eol,start    "定义 <backspace> 键可以删除缩进、行尾和行首
set whichwrap=b,s,h,l,<,>,[,]    "定义行间切换时某些键的作用 (b:Normal 模式下在行首按 <backspace> 键可以返回上一行尾; s:Normal 模式下在行尾按 <space> 键可以到下一行首; h:Normal 模式下在行首按 h 键可以返回上一行尾; l:Normal 模式下在行尾按 l 键可以到下一行首; <:Normal 模式下在行首按左箭头可以返回上一行尾; >:Normal 模式下在行尾按右箭头可以到下一行首; [:Insert 模式下在行首按左箭头可以返回上一行尾; ]:Insert 模式下在行尾按右箭头可以到下一行首)
set virtualedit=block    "列编辑模式可以选择空白位置[ve=virtualedit]
" == }}}

" == 输入法 == {{{
if has("gui_running") && has("mac")
  " 解决 MacVim 下的输入法切换问题
  set iminsert=0
  set imsearch=0
  set imdisable    "[imd=imdisabled, noimd=imdisabled]
  au InsertEnter * set noimd
  au InsertLeave * set imd
  au FocusGained * set imd
endif
" == }}}

" == 缩进 & tab == {{{
set autoindent    "自动缩进 (继承前一行的缩进) [ai=autoindent]
set smartindent    "使用智能缩进 [si=smartindent]
set cindent    "使用 C 语言风格的缩进 [ci=cindent]
set cinoptions=l1C3j1J1    "自定义 C 语言风格缩进 [cino=cinoptions]
set list    "显示缩进参考线及行尾标记 (行尾使用$符)，使用 vim-indent-guides 插件时不再需要配置这一项
set listchars=tab:>-,trail:-    "定义tab以 >--- 显示，行尾空格使用 - 显示 (需要先设置 set list) [lcs=listchars]
set expandtab    "使用空格代替 tab (使用空格代替tab: expandtab，不使用空格代替tab: noexpandtab) [et=expandtab, noet=noexpandtab]
set tabstop=2    "tab 宽度 (页面中已有的 tab) [ts=tabstop]
set softtabstop=2    "按 <tab> 或 <backspace> 时，对应的 tab 宽度 [sts=softtabstop]
set shiftwidth=2    "使用自动缩进时的 tab 宽度 [sw=shiftwidth]
":%retab!    "强制按照上边对tab的定义格式化当前文件的缩进，为保证不改变输入，应在确定有问题时再手动使用
" == }}}

" == 折叠 == {{{
set foldenable    "开启代码折叠
set foldmethod=syntax    "折叠 (indent:按缩进折叠，syntax:按语法折叠，expr:按表达式折叠，diff:对没有更改的文本进行折叠，marker:按文中的标志折叠，manual:手动折叠) [fdm=foldmethod]
"set textwidth=80    "页面最宽文本的边界
set formatoptions+=rmM    "设置文本排版处理方式 (t:根据 textwidth 自动折行; c:在程序源代码注释中自动折行; r:在程序源代码注释中插入回车时自动插入合适的注释起始字符; q:允许使用gq命令对注释格式化; n:针对编号列表空白决定下一行缩进; 2:使用一段的第二行缩进; l:当前行长度超过 textwidth 时不自动重新格式化，m:在多字节字符处可以折行 (针对中文很有效); M:拼接行时如果为多字节则不插入空格) ，另可参考 textwidth
" == }}}

" == 搜索 == {{{
set hlsearch    "高亮显示搜索的内容 [hls=hlsearch]
set noincsearch    "搜索时不高亮所有关键字 [is=incsearch, nois=noincsearch]
set ignorecase    "搜索时忽略大小写，想让下一条生效，这一条必须启用
set smartcase    "搜索时如果输入的是全小写，则此次搜索大小写不敏感；如果搜索字符中含大写，则此次搜索大小写敏感，此时会覆盖上一条的设置 [scs=smartcase]
" == }}}

" == 语法 == {{{
syntax on    "开启语法高亮支持
"au BufRead,BufNewFile *.less set filetype=css    " .less 使用 css 语法规则
au BufRead,BufNewFile *.we set filetype=html
" == }}}

" == 备份 == {{{
set nobackup    "关闭备份。备份文件是 Vim 每隔一段时间自动保存的文件，备份文件不会被删除，如果需要在结束编辑时删除备份文件，使用 set writebackup  (见下一个设置项)
set nowritebackup    "关闭备份。此命令只会在编辑时创建备份文件，当关闭 Vim 时也会将备份文件删除 [nowb=nowritebackup]
"set noswapfile    "关闭交换文件。Vim 会在打开文件的同时，在同目录下 (如需要自定义目录请看下一项) 创建一个交换文件(.swp)，在 Vim 意外关闭的时候，可以通过交换文件恢复之前的操作。非常不建议关闭！
if has("persistent_undo")    "持久化撤销，该功能从 7.3 版本开始支持
  set undofile    "开启持久化撤销 [udf=undofile]
  "持久化撤销的路径默认为"."，保存的文件名后缀为 .un~ [udir=undodir]，个人习惯放到 RUNTIMEPATH 目录
  "因为调用了变量，所以使用 `let &undodir` 而不是 `set undodir`
  "并记得在 RTHOME 下建一个 undo 目录
  let &undodir = RTHOME . '/undo/'
endif
" == }}}

" == 其他 == {{{
set autochdir    "自动将目录切换到当前文件所在位置 (此定义在 GVim 和 MacVim中可能会有系统兼容问题)
set hidden    "只要 Vim 窗口还在，通过 q 关闭的文件存在于 buffer 中，而不是真正的关闭 (可通过 bd 命令彻底关闭) ，带来的好处是在切换 buffer 时不会丢失操作记录
set keywordprg=    "K 命令总是使用 :help 查找关键字 (在Linux中默认是 man -s) [kp=keywordprg]
"set clipboard=unnamed    "默认使用系统剪切板，这会导致 Vim 自己的各个寄存器不可用
" == }}}

" == 功能 & 函数 == {{{
" -- Window GVIM 自带的diff函数 --------------------{{{--
if has("win32")
  set diffexpr=MyDiff()
  function! MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = ''
    if $VIMRUNTIME =~ ' '
      if &sh =~ '\<cmd'
        let cmd = '""' . $VIMRUNTIME . '\diff"'
        let eq = '"'
      else
        let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
      endif
    else
      let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
  endfunction
endif
" -------------------------------------------}}}--

" -- 自动补全括号和引号 ---------------------{{{--
function! ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
    return "\<Right>"
  else
    return a:char
  endif
endfunction

inoremap ( ()<Left>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { {}<Left>
inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ []<Left>
inoremap ] <c-r>=ClosePair(']')<CR>
" -------------------------------------------}}}--

" -- 上下移动一行文本 -----------------------{{{--
" 在正常和插入模式下，按 `control + k` 和 `control + j` 将当前行上移或下移
nmap <C-j> mz:m+<cr>`z
nmap <C-k> mz:m-2<cr>`z
vmap <C-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <C-k> :m'<-2<cr>`>my`<mzgv`yo`z
" -------------------------------------------}}}--

" -- 在回绕行内移动光标 ---------------------{{{--
" MacVim 在正常模式下，按 `command + k` 和 `command + j` 在回绕行内移动光标
if has("gui_macvim")
  nmap <D-j> gj
  nmap <D-k> gk
  nmap <D-h> gh
  nmap <D-l> gl
endif
" -------------------------------------------}}}--

" -- 插入当前时间 ---------------------------{{{--
function! GetDateTimeInfo(type)
  if a:type == 'date'
    return strftime('%Y-%m-%d')    " 2014-08-29
  elseif a:type == 'time'
    return strftime('%H:%M:%S')    " 21:30:18
  elseif a:type == 'full'
    "return strftime('%Y-%m-%d %A %H:%M:%S')    " 2012-04-11 星期三 21:30:11
    return strftime('%Y-%m-%d %H:%M:%S')    " 2012-04-11 21:30:18
  endif
endfunction

" control + d(ate) 插入当前日期
imap <C-d> <C-r>=GetDateTimeInfo('date')<CR>
" control + t(ime) 插入当前时间
imap <C-t> <C-r>=GetDateTimeInfo('time')<CR>
" control + f(ull) 插入当前日期+时间
imap <C-f> <C-r>=GetDateTimeInfo('full')<CR>
" -------------------------------------------}}}--

" -- 定制 * # 支持可视化的选中搜索 ----------{{{--
vnoremap * y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
vnoremap # y?<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
" -------------------------------------------}}}--

" -- MacVim + MacOSX 10.7+ 原生全屏幕功能 ----{{{--
if has("gui_macvim")    "Mac GUI
  function! MacVimFullScreen()
    if &fullscreen
      set nofullscreen    " [nofu=nofuscreen]
    else
      set fullscreen    " [fu=fuscreen]
    endif
  endfunction

  " 按 <leader>ff 切换全屏状态，<leader> 默认是 \
  nmap <leader>ff :call MacVimFullScreen()<CR>
endif
" -------------------------------------------}}}--

" -- 快捷修改缩进默认值 ----{{{--
function! TabStopSwitcher(num)
  let &l:ts=a:num
  let &l:sts=a:num
  let &l:sw=a:num
endfunction
nmap <leader>t2 :call TabStopSwitcher(2)<CR>
nmap <leader>t4 :call TabStopSwitcher(4)<CR>
" -------------------------------------------}}}--

" -- 给标签设置序号，方便 {Num}gt 切换 ----{{{--
" 此配置在打开 Vim 时不会触发，所以写在函数里
function! SetGuiTabLabel()
  set guitablabel=%N\)\ %t\ %M    "自定义标签内容 [gtl=guitablable]
endfunction
nmap <leader>tn :call SetGuiTabLabel()<CR>
" -------------------------------------------}}}--

" -- 当需要 sudo 时，可以使用 :w!! ----{{{--
cmap w!! w !sudo tee % >/dev/null
" -------------------------------------------}}}--
" == }}}

" == 插件 == {{{
" -- vundle ---------------------------------{{{--
" https://github.com/VundleVim/Vundle.vim/
filetype off    "执行vundle前必须先关闭插件支持
set rtp+=~/.vim/bundle/Vundle.vim    "添加 vundle runtime path 并启动 vundle
call vundle#begin()    "必须将安装插件的命令放在 vundle#begin 和 vundle#end 之间
" 格式为 `Plugin 'github-username/repo-name'`
Plugin 'VundleVim/Vundle.vim'    "让 vundle 管理插件版本, 必须
Plugin 'scrooloose/nerdtree'    "文件管理器
Plugin 'scrooloose/nerdcommenter'    "通过 [count]<leader>ci 切换注释（cn添加，cu取消，cc不考虑缩进切换，c<space>考虑缩进切换），更多快捷键详看帮助
" Plugin 'scrooloose/syntastic'    "语法检查，scrooloose 太 TMD 高产了
Plugin 'jistr/vim-nerdtree-tabs'    "给 NERDTree 添加自动开启
Plugin 'ctrlpvim/ctrlp.vim'    "Ctrl+p 快速打开文件
Plugin 'terryma/vim-multiple-cursors'    "多光标支持，快捷键 <control-n>
Plugin 'godlygeek/tabular'    "强大的自动对齐能力
Plugin 'airblade/vim-gitgutter'    "添加一个 git 状态槽
Plugin 'tpope/vim-fugitive'    "提供 vim 环境下的 git 命令支持
" Plugin 'mattn/emmet-vim'    "原来的 ZenCoding
" Plugin 'othree/yajs.vim'    "更好的 Javascript 语法高亮，性能不太好，默认关掉了
Plugin 'cakebaker/scss-syntax.vim'    "Sass 语法高亮
" Plugin 'digitaltoad/vim-jade'    "Jade 语法高亮
Plugin 'altercation/vim-colors-solarized'    "漂亮的主题
" Plugin 'tomasr/molokai'    "又一个漂亮的主题
" Plugin 'vim-airline/vim-airline'    "powerline 的 vim 版本
" Plugin 'vim-airline/vim-airline-themes'
Plugin 'lilydjwg/colorizer'    "修改 CSS 颜色值的背景色为对应颜色
" Plugin 'luochen1990/rainbow'    "彩虹括号
" Plugin 'jiangmiao/simple-javascript-indenter'    "更好的 Javascript 缩进
Plugin 'nathanaelkane/vim-indent-guides'    "更漂亮的缩进
" Plugin 'Yggdroot/indentLine'    "又一个漂亮的缩进
" Plugin 'ntpeters/vim-better-whitespace'    "显示行尾无用空白字符
Plugin 'yianwillis/vimcdoc'    "vim中文文档
" Plugin 'wakatime/vim-wakatime'    "统计写码时间 https://wakatime.com
Plugin 'editorconfig/editorconfig-vim'    "Editor Config
call vundle#end()

filetype plugin indent on    "重新开启插件支持
source $VIMRUNTIME/macros/matchit.vim    "启用 vim 自带的 matchit 插件，扩展 % 键的功能，可以在成对的匹配开始与结束位置跳转。例如左右括号、HTML 的 Tags 等
" -------------------------------------------}}}--

" -- 插件设置，仅开启对应插件后有效 ---------{{{--
" NERDCommenter
let g:NERDSpaceDelims = 1    "NERDCommenter: 注释时在后边加空格
let g:NERDDefaultAlign = 'left'    "注释插入到代码行最开始

" syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_javascript_checkers = ['eslint']

" vim-nerdtree-tabs
let NERDTreeShowHidden=1
" let g:nerdtree_tabs_open_on_console_startup=1    " 从 terminal 启动时，是否要开启 nerdtree
map <leader>n <plug>NERDTreeTabsToggle<CR>

" ctrlp
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$|\v[\/](node_modules|dist)$',
  \ 'file': '\v\.(exe|so|dll|DS_Store)|\vThumbs\.db$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" emmet
" let g:user_emmet_expandabbr_key = '<c-e>'    "emmet 默认的快捷键是 <c-y>,

" vim-airline
" let g:airline_powerline_fonts = 1    "airline 使用 powerline 字体

" rainbow
" let g:rainbow_active = 1    "彩虹括号默认打开

" vim-indent-guides
" set nolist    "当开启这款插件时，就不需要再显示 list 了
let g:indent_guides_enable_on_vim_startup = 1    "自动打开缩进线
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']    "在哪些场景下关闭缩进线
let g:indent_guides_tab_guides = 1    "是否针对 Tab 缩进显示缩进线
let g:indent_guides_space_guides = 1    "是否针对 Space 缩进显示缩进线

" vim-colors-solarized
if has("gui_running")
  silent! colo solarized    "只在 GUI 下尝试使用 solarized 主题
endif
" -------------------------------------------}}}--
" == }}}

" == 技巧 == {{{
" 1. 大部分命令可以使用 :set xxx? 查看当前值 (即 xxx 的设置加?号)
" 2. 可以使用 :verbose map key 查看对应按键的绑定状态 (如 :verbose imap <C-r> 查看 ctrl-r 的绑定状态)
" 3. 可以使用 :echo $xxx (如:echo $VIMRUNTIME 或 :echo $VIM) 查看相关环境变量
" == }}}

" == 参考 & 引用 == {{{
" # ref:
"   + http://vimcdoc.sourceforge.net/
"   + http://blah.blogsome.com/category/vim/
"   + https://github.com/feelinglucky/vimrc
"   + https://github.com/hotoo/vimrc
"   + http://lilydjwg.is-programmer.com/2014/4/16/what-does-sublime-text-do-better-than-vim.44942.html
"   + http://t.qq.com/p/t/56342018278957
"   + http://zhihu.com
"   + http://v2ex.com
" == }}}

" XXX: 最后一行为 模式行，请勿修改，可参考 modelines
" vim:set et ts=2 sts=2 sw=2 fdm=marker:
