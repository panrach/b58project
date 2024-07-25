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

	
game_loop:
	# s0 -- row in grid (starts from 0) where top left corner of tet is
	# s1 -- col in grid (starts from 0) where top left corner of tet is
	# s2 -- tet we are drawing
	# s3 -- number of increments of .01 second that have passed; used for gravity
		# if level_#_gravity (constant) of .01 seconds have passed then reset s3 to 0
		# and tet move 1 down  
	
	# 1a. Check if key has been pressed
		# check even 10 milliseconds/0.01 sec if its has been pressed
		# if yes, then check what key
	
	# Sleep
	li $v0, 32
	li $a0, 10 # Wait one second (1000 milliseconds)
	syscall
	
	
	
	lw $t0, ADDR_KBRD
	lw $t1,  0($t0) # load the value from the keyboard register
	
	# s3 incremented
	# if s3 is == level_3_gravity then temp_drop
	
	bne $t1, 1, game_loop # no key has been pressed, go back 
		
	# TODO
    	# 1b. Check which key has been pressed
    		# if invalid, go back to checking for pressed, branch back
    		# if valid key, continue
    		# calc row, col, and tet in temps based on key pressed; temps will be used by collision dectection
    			# if key is w for rotate, rotation function to change value of what we are tet we are drawing,
    			#     other parameters sent to stack stay the same
    			# if key is a, s, d, put new row and new col based on movement in temp and push them to the 
    			#     stack, others stay the same
    	
    	keypress_happened:
		lw $t0, ADDR_KBRD # load the address of the keyboard
		lw $t2, 4($t0) # load the value of the key
		
		# TO DO
		# these fcn should set up the arguments for collision dectection based on new position 
		# must use adjust temps according to temp assignments
		beq $t2, 0x64, temp_move_right  # d is pressed
		beq $t2, 0x61, temp_move_left  # a is pressed
		beq $t2, 0x77, temp_rotate  # w is pressed
		beq $t2, 0x73, temp_drop  # s is pressed
		beq $t2, 0x71, EXIT  # q is pressed, quit
		
		j game_loop # invalid key
		
	temp_move_right:
		li $a0, 0x64		   # store the key pressed
		la $a1, ($s2)		   # store the address to the tet block
		move $a2, $s0		   # row stays the same. store potential row in a2
		move $a3, $s1		   # Store original column index. store potential col in  a3
		addi $a3, $a3, 1	   # Increment column index
		j check_collision
		
	temp_move_left:
		li $a0, 0x61		   # store the key pressed
		la $a1, ($s2)		   # store the address to the tet block
		move $a2, $s0		   # row stays the same
		move $a3, $s1		   # Store original column index
		addi $a3, $a3, -1	   # Decrement column index
		j check_collision
	
	temp_rotate:
		li $a0, 0x77		   # store the key pressed
		move $a2, $s0		   # store original row index
		move $a3, $s1		# Store original column index
		la $t2, L0_BLOCK  # Load address of L0_BLOCK into $t1
		la $t3, L1_BLOCK  # Load address of L1_BLOCK into $t2
		la $t4, L2_BLOCK  # Load address of L2_BLOCK into $t3
		la $t5, L3_BLOCK  # Load address of L3_BLOCK into $t4
	
		# check the block type
		beq $s2, $t2, set_L1 # If $s2 == L0_BLOCK, branch to set_L1
		beq $s2, $t3, set_L2 # If $s2 == L1_BLOCK, branch to set_L2
		beq $s2, $t4, set_L3 # If $s2 == L2_BLOCK, branch to set_L3
		beq $s2, $t5, set_L0 # If $s2 == L3_BLOCK, branch to set_L1

		set_L0:
			la $a1, L0_BLOCK
			j check_collision

		set_L1:
			la $a1, L1_BLOCK
			j check_collision

		set_L2:
			la $a1, L2_BLOCK
			j check_collision

		set_L3:
			la $a1, L3_BLOCK
			j check_collision

	temp_drop:
		li $a0, 0x73		   # store the key pressed
		la $a1, ($s2)		   # store the address to the tet block
		move $a2, $s0		   # store original row index
		addi $a2, $a2, 1	# Increment row index
		move $a3, $s1		# Store original column index
    	
	check_collision:
    	# a0 -- what key is pressed
    	# a1 -- cur tet (the constant that means the address) 
    	# 	for every function except for rotate just grab the value in the stored register
    	# a2 -- row index in grid that the top left block of the tet is located at
    	# a3 -- col index in grid that the top left block of the tet is located at
    	# v0 -- return
    	#		0 if no collision
    	#		1 if vertical collision
    	#		2 if horizonal collsion
    	
    	# TO DO
    	# 2a. Check for collisions in this new position
    		# collision takes in what key was pressed + tet + row in grid + col in grid 
    		# for every block in tet (loop similar to draw tet), 
    			# if 0 move on to next block
    			# if 1 calc where that block is on the grid which is block_row = row_in_block + row_in_grid, block_col = col_in_block + col_in_grid
    				# check for collision with border 
    				# collison if any of the following
    				# 	block_row >= BOTTOM_BORDER
    				#	block_col <= LEFT_BORDER
    				#	block_col <= RIGHT_BORDER 
    				# if collision and key pressed is 'a' or 'd', return 2 for horizontal collision
    				# otherwise, return 1 (maybe do in opposite order, set to 1 default for collision, branch and set to 2 if horizontal)
    				
    				# don't do playing field check yet
    				# this is for checking playing field collision
    				# calc offset based on these new row and new col (*1 instead of 4 in this case)
    				# checks byte at playing field + this offset != 0 then collision, otherwise no collision return 0 
    				# if key pressed is a or d then this is a horizonal collision, return 2
    				# otherwise vertical collision, return 1
	
	# t3 = current block address
	# t4 = row index for row_loop/row offset (i.e. what row index within tet)
	# t5 = col index for col_loop/ col offset
	# t6 = row/col of current block
	# t7 = cur block in tet which is 1 or 0 (located at cur block address)
	
	# initialize row index
	li $t4, -1
	
	# initialize collision to 0 (no collision)
	li $v0, 0

	collision_row_loop:
		# initialize col index to 0
		li $t5, 0
		
		# increment row counter
		addi $t4, $t4, 1
		
		# if (row >= 4, exit) and go to draw)
		bge $t4, 4, draw
		
		collision_col_loop:
			# if (col >=4, move to next row)
			bge $t5, 4, collision_row_loop
			
			# accessing current block in block_array
			lb $t7, 0($t3)
			
			# move on to address of next block in block_array
			addi, $t3, $t3, 1
			
			#increment col offset/counter
			addi $t5, $t5, 1
			
			# block value is empty, move on to next block
			beq $t7, 0, collision_col_loop
			
			# calculate row where cur block would be
			# block_row = row_index + row_in_grid (given by argument)
			add $t6, $t4, $a2
			# if it is greater than BOTTOM_BORDER, return 1
			bge $t6, BOTTOM_BORDER, vertical_collide
			
			# calculate column where cur block would be
			# block_col = col_index + col_in_grid
			add $t6, $t5, $a3
			# if it is less than LEFT_BORDER or greater than RIGHT_BORDER,
			ble $t6, LEFT_BORDER, collide
			bge $t6, RIGHT_BORDER, collide
			j collision_col_loop
			
			collide:
				li, $v0, 1 # store 1, assume vertical collision
				# check if a or d was pressed to mean horizontal collision
				beq $a0, 0x64, horizonal_collide  # d is pressed
				beq $a0, 0x61, horizonal_collide  # a is pressed
				j draw
				
				horizonal_collide:
					li $v0, 2
					j draw
			
			vertical_collide:
				li $v0, 1
				
			
	# TO DO: case collision detection returns 0 (i.e. t4 is 0), update stuff for real,use move_right, etc. 
	# also do case returns 2, branch back to game_loop, no need to redraw
	# case where it return 1 is impossible for rignt now, dont do it
	# 2b. Update locations (cur_tet_row, cur_tet_col)
		# takes in key pressed, output of collision check
		# if collision returned 0, then move based on key pressed, 
		#        i.e. update row s0 and col s1 or tet s2 to be sent to draw functions later
		# if returned 2, don't move, s0 s1 s2 stay the same
		# if returned 1, cur block in cur position to playing field bc it has been set, 
		#        maybe functon for add position to playing field 
		#        generate new piece to put in s2
	
	draw: 
		# check output of collision detection
		# if horizontal collision, don't move so go back to start of game loop
		beq $v0, 2, game_loop
		
		# deal with vertical collision later
		
		# otherwise, if no collision
		# update the rows, columns, etc. according to movement 
		move $s0, $a2
		move $s1, $a3
		la $s2, ($a1)

		# 3. Draw the screen
		jal draw_background
	
		# set up to call draw_tet
		# move up a word to give space for the tet address
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
	
		# later, draw playing field
	
	
	#5. Go back to 1
	b game_loop	

EXIT: 
	# Exit the program
    	li $v0, 10
    	syscall


	
	j game_loop
	
move_right: # not really useful as a fcn bc we only use it once, pre-collison detec we need to put in temps
	addi $s1, $s1, 1           # Increment column index
	j draw
	
move_left:
	addi $s1, $s1, -1           # Decrement column index
	j draw

actual_rotate:
	la $t1, L0_BLOCK  # Load address of L0_BLOCK into $t1
	la $t2, L1_BLOCK  # Load address of L1_BLOCK into $t2
	la $t3, L2_BLOCK  # Load address of L2_BLOCK into $t3
	la $t4, L3_BLOCK  # Load address of L3_BLOCK into $t4
	
	# check the block type
	beq $s2, $t1, set_L1 # If $s2 == L0_BLOCK, branch to set_L1
	beq $s2, $t2, set_L2 # If $s2 == L1_BLOCK, branch to set_L2
	beq $s2, $t3, set_L3 # If $s2 == L2_BLOCK, branch to set_L3
	beq $s2, $t4, set_L0 # If $s2 == L3_BLOCK, branch to set_L1

actual_drop:
	addi $s0, $s0, 1           # Increment row index
	j draw
	

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
	
	# pop tet address, put it in t3
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	
	# t0 = current display address 
	# t1 = start column index
	# t2 = start row index
	# t3 = current block address (i.e. address of block in tet we are drawing)
	# t4 = row index for row_loop/row offset
	# t5 = col index for col_loop/ col offset
	# t6 = color (would pop from stack later)
	li $t6, ORANGE
	# t7 = byte located at current block address (i.e. 0 or 1)
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
			
			# accessing current block in block_array/tet
			lb $t7, 0($t3)
			
			# move on to address of next block in block_array/t4et
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
