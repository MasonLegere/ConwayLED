/*
	Minimal PIOA drivers:
	Based directly on IO assignment

*/

.syntax unified
.equ PMC,	0x400E0400 /* PMC Base Address */
.equ PCER0, 0x10	

// Base address of PIOA
.equ PIOA,          0x400E0E00 


// offset for PIOA line
.equ PID11, 11 

.equ INPUT_DIR,  1 
.equ OUTPUT_DIR, 0
.equ LEVEL_HIGH, 1
.equ LEVEL_LOW,  0

/* 
	enable peripheral clock line to PIOC 
*/
.thumb_func
.global pioa_init
pioa_init:		
	ldr r0, =(PMC + 0x10)
	mov r1, #1
	lsl r1, r1, PID11
	str r1, [r0]

	bx lr

/* 
	Set PIO Line Direction
*/
.thumb_func
.global pioa_dir_set
pioa_dir_set:	
	cmp r0, OUTPUT_DIR
	bne else_d
	ldr r0, =(PIOA + 0x10) 
	b end_d
else_d:
	ldr r0, =(PIOA + 0x14) 
end_d:
	mov r2, #1
	lsl r2, r2, r1			
	str r2, [r0]	
enable_writing:
	ldr r0, =(PIOA + 0xA0) 
	mov r2, #1
	lsl r2, r2, r1
	str r2, [r0]	

	bx lr

/* 
	Set PIO Line Level  
*/
.thumb_func
.global pioa_level_set
pioa_level_set:
	cmp r0, LEVEL_HIGH
	bne else_l
	ldr r0, =(PIOA + 0x30) 
	b end_l
else_l:
	ldr r0, =(PIOA + 0x34) 
end_l:
	mov r2, #1
	lsl r2, r2, r1  
	str r2, [r0]	

	bx lr
.end