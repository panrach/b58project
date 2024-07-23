#####################################################################
# CSCB58 Summer 2024 Assembly Final Project - UTSC
# Student1: Name, Student Number, UTorID, official email
# Student2: Name, Student Number, UTorID, official email
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed) 
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels:  64( update this as needed)
# - Display height in pixels: 64 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved features have been implemented?
# (See the assignment handout for the list of features)
# Easy Features:
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# ... (add more if necessary)
# Hard Features:
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# ... (add more if necessary)
# How to play:
# (Include any instructions)
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################
# hi janani
##############################################################################

.data
	L0_BLOCK: 
		.byte 0 1 0 0
		.byte 0 1 0 0
		.byte 0 1 1 0
		.byte 0 0 0 0
	L1_block: 
		.byte 0 0 0 0
		.byte 0 1 1 1
		.byte 0 1 0 0
		.byte 0 0 0 0
	L2_block: 
		.byte 0 0 0 0
		.byte 0 1 1 0
		.byte 0 0 1 0
		.byte 0 0 1 0
	L3_block: 
		.byte 0 0 0 0
		.byte 0 0 1 0
		.byte 1 1 1 0
		.byte 0 0 0 0

##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000


.eqv ADDR_DSPL_CONST 0x10008000
.eqv UNIT_SIZE 4	# Size of each unit in bytes

.eqv GRID_DARK 0xA9A9A9	# dark colour in grid
.eqv GRID_LIGHT 0x808080 	# light colour in grid 
.eqv BORDER_BLACK 0x000000	# black for border

.eqv ROW_SIZE 32	# Number of units per row (128/8)
.eqv COL_SIZE 16	# Number of units per col (256/8)

.eqv TOP_BORDER 6	# row index that top border ends
.eqv BOTTOM_BORDER 31	# row index that bottom border starts 
.eqv LEFT_BORDER 0	# col index that left border ends
.eqv RIGHT_BORDER 15	# col index that left border starts

.eqv ORANGE 0xe69138

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
.text
    .globl main

main:  	
	jal draw_background
	
	# set up to call draw_tet
	# move up a word to give space for the block address
	addi $sp, $sp, -4
	la $t3, L0_BLOCK
	sw $t3, 0($sp)
	
	# make room for row
	addi $sp, $sp, -4
	li $t0, 8
	sw $t0, 0($sp)
	
	# make room for column
	addi $sp, $sp, -4
	li $t1, 4
	sw $t1, 0($sp)
	
	jal draw_tet
	
	

EXIT: 
	# Exit the program
    	li $v0, 10
    	syscall

draw_background:
    	# initialize cur row index to 0
    	li $t5, 0	# t5 = cur_row = 0
    	# initialize cur column index to 0
    	li $t6, 0	# t6 = cur_col = 0
    	

	bg_loop:
		# initalize values for calculating address of current unit
		lw $t0, ADDR_DSPL               # t0 = base display address
		li $t3, ROW_SIZE                # t3 = display width in units
		li $t4, COL_SIZE                # t4 = display height in units
	
		# calculate the address of the current unit in t7
		li $t8, UNIT_SIZE			# t8 = unit size (4 bytes)
		# base + ((row index * number of columns) + column index) * pixel size 
    		# row index * number of columns
    		mul $t7, $t5, $t4
    		# (row index * num columns) + column index
    		add $t7, $t7, $t6
    		# t7 * pixel size
    		mul $t7, $t7, $t8
    		# add offset to base
    		add $t7, $t7, $t0
    	
    		# t5 cur row, t6 cur col
    	
    		# black if part of border, i.e.
    			# cur row <= TOP_BORDER
    			# cur row >= BOTTOM_BORDER
    			# cur col <= LEFT_BORDER
    			# cur col >= RIGHT_BORDER
    		ble $t5, TOP_BORDER, black_if
    		bge $t5, BOTTOM_BORDER, black_if
    		ble $t6, LEFT_BORDER black_if
    		bge $t6, RIGHT_BORDER, black_if
    	
    		# if not part of border, it is part of the grid
    		# if cur row and col are same parity, dark unit
    		# i.e. cur row + cur col = odd number
    		# if dif parity, dark unit
    		add $t8, $t5, $t6
    		andi $t8, $t8, 1
    		beq $t8, 1, dark_if
    	
    		# else even, light
    		li $t2, GRID_LIGHT	# t2 = light color
    		sw $t2, 0($t7)		# make unit light colour
    		j next_unit
    	
		dark_if:
    			li $t1, GRID_DARK	# t1 = dark color
    			sw $t1, 0($t7)		# make unit dark colour
    			j next_unit
    	
    		black_if:
    			li $t1, BORDER_BLACK	# t1 = dark color
    			sw $t1, 0($t7)		# make unit dark colour
    			j next_unit
    	
	next_unit:
    		# move to the next unit
    		# increment column index
    		addi $t6, $t6, 1
    		# if the column index is less than the column size, then continue
    		blt $t6, $t4, bg_loop
    	
    		# increment row
    		addi $t5, $t5, 1
    		li $t6, 0                      # t6 = cur_col = 0

    		blt $t5, $t3, bg_loop
    	
    	jr $ra
    	
	
#game_loop:
	# 1a. Check if key has been pressed
    	# 1b. Check which key has been pressed
    	# 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep
	
	# set up to call draw_tet
	# move up a word to give space for the block address
	#addi $sp, $sp, -4
	#lw $sp, L0_BLOCK
	
	# make room for row
	#addi $sp, $sp, -4
	#li $sp, 8
	
	# make room for column
	#addi $sp, $sp, -4
	#li $sp, 4
	
	#jal draw_tet
	

    #5. Go back to 1
    #b game_loop
    
draw_tet:
	lw $t0, ADDR_DSPL
	
	# pop column, put it in t1
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	
	# pop row, put it in t2
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	
	# pop block address, put it in t3
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	
	# t0 = current display address 
	# t1 = start column index
	# t2 = start row index
	# t3 = current block address
	# t4 = row index for row_loop/row offset
	# t5 = col index for col_loop/ col offset
	# t6 = color (would pop from stack later)
	li $t6, ORANGE
	# t7 = block_array[block_counter]
	# t8 = start row + row_offset
	# t9 = start col + col_offset
	
	# calculate the address
	
	# initialize row counter
	li $t4, -1

	row_loop:
		# initialize col counter to 0
		li $t5, 0
		
		# increment row counter
		addi $t4, $t4, 1
		
		# if (row >= 4, exit)
		bge $t4, 4, exit_draw_tet
		col_loop:
			# if (col >=4, move to next row)
			bge $t5, 4, row_loop
			
			# current row
			add $t8, $t4, $t2
			# current col
			add $t9, $t5, $t1
			
			# calculating current display address
			# calculating offset
			mul $t0, $t8, COL_SIZE
			add $t0, $t0, $t9
			mul $t0, $t0, UNIT_SIZE
			# add to base display address
			addi $t0, $t0, ADDR_DSPL_CONST 
			
			# accessing current block in block_array
			lb $t7, 0($t3)
			
			# move on to address of next block in block_array
			addi, $t3, $t3, 1
			#increment col offset/counter
			addi $t5, $t5, 1
			
			# check this block should be coloured 
			beq $t7, 1, color
			j col_loop
			
			color:
				sw $t6, 0($t0)
				j col_loop
			
			
	
	
	exit_draw_tet:
		jr $ra
    
    
