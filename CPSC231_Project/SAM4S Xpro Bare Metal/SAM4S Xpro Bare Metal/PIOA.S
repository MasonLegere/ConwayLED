/*
	Minimal PIO Drivers. 
	Allows to configure and set/clear IO lines.
	Limitations: Can only set IO lines from PIOC
*/

.syntax unified
/* PMC see pg 520 documentation */
.equ PMC,	0x400E0400 /* PMC Base Address */
.equ PCER0, 0x10	/* Peripheral Clock Enable Register 0*/

/* PIOC see pg 575 documentation */
.equ PIOA,          0x400E0E00 /*PIOA base arr*/
.equ OER_OFFSET,	0x10	/* Output Enable Register */
.equ ODR_OFFSET,	0x14	/* Output Disable Register */
.equ SODR_OFFSET,	0x30	/* Set Output Data Register */
.equ CODR_OFFSET,	0x34	/* Clear Output Data Register */
.equ OWER_OFFSET,	0xA0	/* Output Write Enable Register*/

/* PIOC PID pg. 48*/
.equ PID13, 13	
.equ PID11, 11 // for PIOA

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
	ldr r0, =(PMC + PCER0)
	mov r1, #1
	lsl r1, r1, PID11
	str r1, [r0] /* PCER0.bit13 = 1 */

	bx lr

/* 
	Set PIO Line Direction  
	r0 = direction (1=input, 0=output)
	r1 = IO line (PC1 = 1, PC2 = 2, so forth)
*/
.thumb_func
.global pioa_dir_set
pioa_dir_set:	
	cmp r0, OUTPUT_DIR
	bne else_d
	ldr r0, =(PIOA + OER_OFFSET) 
	b end_d
else_d:
	ldr r0, =(PIOA + ODR_OFFSET) 
end_d:
	mov r2, #1
	lsl r2, r2, r1			
	str r2, [r0]	/* OxR.bitx = 1 */
enable_writing:
	ldr r0, =(PIOA + OWER_OFFSET) 
	mov r2, #1
	lsl r2, r2, r1
	str r2, [r0]	/* OWER.bitx = 1 */

	bx lr

/* 
	Set PIO Line Level  
	r0 = level (1=high, 0=low)
	r1 = IO line (PC1 = 1, PC2 = 2, so forth)
*/
.thumb_func
.global pioa_level_set
pioa_level_set:
	cmp r0, LEVEL_HIGH
	bne else_l
	ldr r0, =(PIOA + SODR_OFFSET) 
	b end_l
else_l:
	ldr r0, =(PIOA + CODR_OFFSET) 
end_l:
	mov r2, #1
	lsl r2, r2, r1  
	str r2, [r0]	/* xODR.bitx = 1 */

	bx lr
.end