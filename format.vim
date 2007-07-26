set nows
set tw=4096

let mylist=[ "abstract", "p", "note", "impo", "warn", "ti", "li" ]

for item in mylist
	call cursor(1, 1)
	let ptn = '^<' . item . '>$'
	let @a = 'j/<\/' . item . '>gqn'
	while search(ptn) > 0
		normal @a
	endwhile
	if item == "ti" || item == "li"
		call cursor(1, 1)
		let ptn = '[^^]<' . item . '>$'
		let @a = 'j/<\/' . item . '>gqnnik<<i  '
		while search(ptn) > 0
			normal @a
		endwhile
	endif
endfor

exe "wq!"
