.syntax unified 

/*
	- Easy to deal with repetitions here than to have to apply pin numbers
		manually in the code. 
	{r2} is the argument used for setting pin high or low. 
	Logic is inverted: 
		r2 = 0 => level_set_high
		r2 = 1 => level_set_low

*/


// RED
// Top 16 rows
.thumb_func 
.global set_r0
set_r0: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #17
	bl pioa_level_set 
	pop {r0,r1,pc}

// GREEN
// Top 16 rows
.thumb_func 
.global set_g0
set_g0: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #24
	bl pioa_level_set 
	pop {r0,r1,pc}

// BLUE
// Top 16 rows
.thumb_func 
.global set_b0
set_b0: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #23
	bl pioa_level_set 
	pop {r0,r1,pc}

// RED 
// Bottom 16 rows
.thumb_func 
.global set_r1
set_r1: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #1
	bl pioa_level_set 
	pop {r0,r1,pc}

// GREEN 
// Bottom 16 rows
.thumb_func 
.global set_g1
set_g1: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #3
	bl pioa_level_set 
	pop {r0,r1,pc}

// BLUE 
// Bottom 16 rows
.thumb_func 
.global set_b1
set_b1: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #21
	bl pioa_level_set 
	pop {r0,r1,pc}

/*
	Rows are given by [a3,a2,a1,a0] specifying 16 rows, where the colours 
	specify between the top and bottom half of the matrix
*/
.thumb_func 
.global set_a0
set_a0: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #25
	bl pioc_level_set 
	pop {r0,r1,pc}

.thumb_func 
.global set_a1
set_a1: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #24
	bl pioc_level_set 
	pop {r0,r1,pc}

.thumb_func 
.global set_a2
set_a2: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #19
	bl pioc_level_set 
	pop {r0,r1,pc}


.thumb_func 
.global set_a3
set_a3: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #26
	bl pioc_level_set 
	pop {r0,r1,pc}

// Clock edge used to shift colour into column 
.thumb_func 
.global set_clk
set_clk: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #29
	bl pioc_level_set 
	pop {r0,r1,pc}

// Latches new row into the shifter 
.thumb_func 
.global set_stb
set_stb: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #21
	bl pioc_level_set 
	pop {r0,r1,pc}

// Shifters new row after increment
.thumb_func 
.global set_oe
set_oe: 
	push {r0,r1,lr}
	mov r0, r2
	mov r1, #20
	bl pioc_level_set 
	pop {r0,r1,pc}
