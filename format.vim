set nows
set tw=4096

let mylist=[ "abstract", "p", "note", "impo", "warn" ]

for item in mylist
	call cursor(1, 1)
	let ptn = '<' . item . '>'
	while search(ptn) > 0
		let @a = 'j/<\/' . item . '>gqn'
		normal @a
	endwhile
endfor

exe "wq"
