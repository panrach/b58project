#####################################################################
# CSCB58 Summer 2024 Assembly Final Project - UTSC
# Student1: Janani Gurram, 1009109778, gurramja, j.gurram@utoronto.ca
# Student2: Rachel Pan, 1009041145, panrach1, r.pan@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 
# - Unit height in pixels: 8
# - Display width in pixels:  128
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1
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

##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

# to store playing field
# 0 if unoccupied
# number reping colour is occupied
playing_field: .byte 0:512

# L block and all its rotations
L0_BLOCK: 
	.byte 0 1 0 0
	.byte 0 1 0 0
	.byte 0 1 1 0
	.byte 0 0 0 0
L1_BLOCK: 
	.byte 0 0 0 0
	.byte 0 1 1 1
	.byte 0 1 0 0
	.byte 0 0 0 0
L2_BLOCK: 
	.byte 0 0 0 0
	.byte 0 1 1 0
	.byte 0 0 1 0
	.byte 0 0 1 0
L3_BLOCK: 
	.byte 0 0 0 0
	.byte 0 0 1 0
	.byte 1 1 1 0
	.byte 0 0 0 0

.eqv ADDR_DSPL_CONST 0x10008000
.eqv UNIT_SIZE 4	# Size of each unit in bytes

.eqv GRID_DARK 0xA9A9A9	# dark colour in grid
.eqv GRID_LIGHT 0x808080 	# light colour in grid 
.eqv BORDER_BLACK 0x000000	# black for border

.eqv ROW_SIZE 32	# Number of rows (256/8)
.eqv COL_SIZE 16	# Number of col (128/8)
.eqv GRID_ROW_SIZE 24  # Number of rows in grid (row_size - borders)
.eqv GRID_COL_SIZE 14  # Number of cols in grid (col_size - borders)

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
	
	# the block I am generating
	# would be randomized in final
	la $s2, L0_BLOCK
	
	# set up starting row and col
	li $s0, 0 # row to where tet starts off
	li $s1, 5 # col to where tet starts off
	
	# set up to call draw_tet
	# move up a word to give space for the block address
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	
	# make room for row
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	# make room for column
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	jal draw_tet
	
	# Sleep
	li $v0, 32
	li $a0, 500 # Wait one second (1000 milliseconds)
	syscall
	
	
	
game_loop:
	# s0 -- row in grid (starts from 0) where top left corner of tet is
	# s1 -- col in grid (starts from 0) where top left corner of tet is
	# s2 -- tet we are drawing
	
	
	# 1a. Check if key has been pressed
		# continuely check if its has been pressed
		# if yes, then check what key
    	# 1b. Check which key has been pressed
    		# if invalid, go back to checking for press, branch back
    		# if valid key, update s0 (row), s1 (col) of current tet appropiately based on key
    		# if valid key is w for rotate, rotation function to change value of what we are tet we are drawing (s2)
    	
    	# currently increment row to move down
    	# you would do different things to row and col based on what key was pressed
	addi $s0, $s0, 1
	
    	# 2a. Check for collisions
    		# collision takes in what key has been pressed + shape + cur row in grid and cur col in grid 
    		# for every block in shape (loop similar to draw tet), 
    			# if 0 move on
    			# if 1 calc where it will move which is row_in_block + row_in_grid, col_in_block + col_in_grid
    				# calc offset based on these new row and new col (*1 instead of 4 in this case)
    				# checks byte at playing field + this offset = 1 then collision
    				# if key pressed is a or d then this is a horizonal collision, return 2
    				# otherwise vertical collision, return 1
    		
	# 2b. Update locations (cur tet row, cur tet col)
		# takes in key pressed, output of collision check
		# if collision returned 0, then move based on key pressed, i.e. update row and col to be sent to draw functions
		# if returned 2, don't move 
		# if returned 1, cur block in cur position to playing field, generate new piece to put in s2
	
	# 3. Draw the screen
	jal draw_background
	
	# set up to call draw_tet
	# move up a word to give space for the block address
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	
	# make room for row
	addi $sp, $sp, -4
	#li $t0, 10
	sw $s0, 0($sp)
	
	# make room for column
	addi $sp, $sp, -4
	#li $t1, 5
	sw $s1, 0($sp)
	
	jal draw_tet
	
	# if end of screen, end
	bge $s0, 20, EXIT
	
	# 4. Sleep
	li $v0, 32
	li $a0, 500 # Wait one second (1000 milliseconds)
	syscall
	
	
	#5. Go back to 1
	b game_loop	

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
    
draw_tet:
	lw $t0, ADDR_DSPL
	
	# pop column index in grid, put it in t1
	# add left_border + 1 to it so it is cur column on entire display
	# not just relative to grid 
	lw $t1, 0($sp)
	addi $t1, $t1, LEFT_BORDER
	addi $t1, $t1, 1
	addi $sp, $sp, 4
	
	# pop row in grid, put it in t2
	# add top_border + 1 to it so it is row column on entire display
	# not just relative to grid 
	lw $t2, 0($sp)
	addi $t2, $t2, TOP_BORDER
	addi $t2, $t2, 1
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
    
    
