" Vim script for formatting Chinese GuideXML
" Last Change:  2007 Jul 27 
" Maintainer:   Zhang Le <r0bertz@gentoo.org>
" License:      GPLv3

" TODO: 
" 	handle nested <li><ul><li> tags
"
" Usage:
" 	vim -S format.vim foo.xml

set nows 	"nowrapspan
set tw=4096 	"set textwidth to a large number

let mylist=[ "abstract", "p", "note", "impo", "warn", "ti", "li" ]

for item in mylist
	call cursor(1, 1) 			"rewind to the beginning
	let pattern = '^<' . item . '>$'	"form a pattern
	let @a = 'j/<\/' . item . '>

	while search(pattern, 'c') > 0 
		normal @a
	endwhile

	"<ti> and <li> tags not in the beginning of a line
	"need special treatment
	if item == "ti" || item == "li"
		call cursor(1, 1)
		let pattern = '[^^]<' . item . '>$'
		let @b = 'j/<\/' . item . '>
		while search(pattern, 'c') > 0
			normal @b
		endwhile
	endif
endfor

exe "wq!"