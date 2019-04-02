/*
	Minimal PIO Drivers. 
	Based directly on IO assignment
*/

.syntax unified

.equ PMC,	0x400E0400 /* PMC Base Address */


/* PIOC Base Address */
.equ PIOC,			0x400E1200 

// offset for PIOC line
.equ PID13, 13	


.equ INPUT_DIR,  1 
.equ OUTPUT_DIR, 0
.equ LEVEL_HIGH, 1
.equ LEVEL_LOW,  0

/* 
	enable peripheral clock line to PIOC 
*/
.thumb_func
.global pioc_init
pioc_init:		
	ldr r0, =(PMC + 0x10)
	mov r1, #1
	lsl r1, r1, PID13
	str r1, [r0] /* PCER0.bit13 = 1 */

	bx lr


/* 
	Set PIO Line Direction
*/
.thumb_func
.global pioc_dir_set
pioc_dir_set:	
	cmp r0, OUTPUT_DIR
	bne else_d
	ldr r0, =(PIOC + 0x10) 
	b end_d
else_d:
	ldr r0, =(PIOC + 0x14) 
end_d:
	mov r2, #1
	lsl r2, r2, r1			
	str r2, [r0]	
enable_writing:
	ldr r0, =(PIOC + 0xA0) 
	mov r2, #1
	lsl r2, r2, r1
	str r2, [r0]	

	bx lr

/* 
	Set PIO Line Level  
*/
.thumb_func
.global pioc_level_set
pioc_level_set:
	cmp r0, LEVEL_HIGH
	bne else_l
	ldr r0, =(PIOC + 0x30) 
	b end_l
else_l:
	ldr r0, =(PIOC + 0x34) 
end_l:
	mov r2, #1
	lsl r2, r2, r1  
	str r2, [r0]	

	bx lr
.end


