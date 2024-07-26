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
# Do not hold keys 
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

# J block and all its rotations
J0_BLOCK: 
	.byte 0 0 1 0
	.byte 0 0 1 0
	.byte 0 1 1 0
	.byte 0 0 0 0
J1_BLOCK: 
	.byte 0 0 0 0
	.byte 0 1 0 0
	.byte 0 1 1 1
	.byte 0 0 0 0
J2_BLOCK: 
	.byte 0 0 0 0
	.byte 0 1 1 0
	.byte 0 1 0 0
	.byte 0 1 0 0
J3_BLOCK: 
	.byte 0 0 0 0
	.byte 1 1 1 0
	.byte 0 0 1 0
	.byte 0 0 0 0

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

.eqv MAX_TET_NUM 3
.eqv ADDR_DSPL_CONST 0x10008000
.eqv UNIT_SIZE 4	# Size of each unit in bytes

.eqv GRID_DARK 0xA9A9A9	# dark colour in grid
.eqv GRID_LIGHT 0x808080 	# light colour in grid 
.eqv BORDER_BLACK 0x000000	# black for border

.eqv ROW_SIZE 32	# number of rows (256/8)
.eqv COL_SIZE 16	# number of col (128/8)
.eqv GRID_ROW_SIZE 24  # number of rows in grid (row_size - borders)
.eqv GRID_COL_SIZE 14  # number of cols in grid (col_size - borders)

.eqv TOP_BORDER 6	# row index that top border ends
.eqv BOTTOM_BORDER 31	# row index that bottom border starts 
.eqv LEFT_BORDER 0	# col index that left border ends
.eqv RIGHT_BORDER 15	# col index that left border starts


# after reaching a score of score cap, move on to next level
.eqv LEVEL_1_CAP 1
.eqv LEVEL_2_CAP 2

.eqv LEVEL_1_GRAVITY 250  # how many milliseconds should pass before moving 1 block down
.eqv LEVEL_2_GRAVITY 150 
.eqv LEVEL_3_GRAVITY 50

# what number each tet is assoicated with (used for picking random piece)
# also used for colouring
.eqv J_NUM 1
.eqv L_NUM 2
# colours for blocks
.eqv L_COLOUR 0xe69138
.eqv J_COLOUR 0xffd1f5 

.eqv SCORE_COLOUR 0xFFFFFF 

##############################################################################
# Mutable Data
##############################################################################

# to store playing field
# 0 if unoccupied
# number reping colour is occupied
playing_field: .byte 0:512

##############################################################################
# Code
##############################################################################
.text
    .globl main

main:  	
	# intialize score to 0 abd milliseconds passed
	li $s3, 0
	li $s4, 0
	
	# initialize level to 1
	li $s5, 1
	li $s6, LEVEL_1_GRAVITY
	
	jal draw_background
	
	# the tet I am generating
	# would be randomized in final
	# generate random number 1-7 in $t1
	# use generated tet number to figure out block
	
	generate_new_tet:
	
	# set up starting row and col
	# s registers for draw, a registers for collision detection
	li $s0, 0 # row to where tet starts off
	li $s1, 5 # col to where tet starts off
	move $a2, $s0 # row to where tet starts off
	move $a3, $s1 # col to where tet starts off
	
	# generate random num and store into t1
	# not yet, will do after implementing full set
	li $v0, 42
	li $a0, 0
	li $a1, MAX_TET_NUM
	syscall

	move $t1, $a0 # store the random number in t1
	addi $t1, $t1, 1
	
	# figure out which tet to generate based on random number
	beq $t1, J_NUM, generate_J # if t0 == 0, generate J block
	beq $t1, L_NUM, generate_L # if t1 == 1, generate L block

	# load appropiate tet address into s2 for collision detection 
	generate_J:
		la $s2, J0_BLOCK
		move $a1, $s2
		j check_spawn_collision

	# load appropiate tet address into s2 for collision detection 
	generate_L:
		la $s2, L0_BLOCK
		move $a1, $s2
		j check_spawn_collision

	
game_loop:
	# s0 -- row in grid (starts from 0) where top left corner of tet is
	# s1 -- col in grid (starts from 0) where top left corner of tet is
	# s2 -- tet we are drawing
	# s3 -- number of increments of .001 second that have passed; used for gravity
		# if level_#_gravity (constant) of .01 seconds have passed then reset s3 to 0
		# and tet move 1 down  
	# s4 -- score (number of lines cleared)
	# s5 -- current level
	# s6 -- gravity constant based on level 
	
	# 1a. Check if key has been pressed
		# check even 5 milliseconds/0.005 sec if its has been pressed
		# after checking 200 times, temp_drop (do this before checking for keyboard input)
		# if yes, then check what key
	
	# Sleep
	li $v0, 32
	li $a0, 5 # Wait one second (1000 milliseconds)
	syscall
	
	# increment counters for how many milliseconds have passed, s3
	addi $s3, $s3, 1
	
	# if level number of milliseconds (1000 milli sec = 1 sec), apply gravity
	#	reset s3 to 0 and move down
	# otherwise, check for a key pressed
	bge $s3, $s6, gravity
	j check_keypressed
	
	# reset s3 to 0 and move down
	gravity: 
		li $s3, 0
		b temp_drop
	
	
	check_keypressed: 
	lw $t0, ADDR_KBRD
	lw $t1,  0($t0) # load the value from the keyboard register
	
	
	
	bne $t1, 1, game_loop # no key has been pressed, go back 
		
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
		move $a1, $s2		   # store the address to the tet block
		move $a2, $s0		   # row stays the same. store potential row in a2
		move $a3, $s1		   # Store original column index. store potential col in  a3
		addi $a3, $a3, 1	   # Increment column index
		j check_collision
		
	temp_move_left:
		li $a0, 0x61		   # store the key pressed
		move $a1, $s2		   # store the address to the tet block
		move $a2, $s0		   # row stays the same
		move $a3, $s1		   # Store original column index
		addi $a3, $a3, -1	   # Decrement column index
		j check_collision
	
	temp_rotate:
		li $a0, 0x77		   # store the key pressed
		move $a2, $s0		   # store original row index
		move $a3, $s1		   # Store original column index

		# FOR J BLOCK
		la $t2, J0_BLOCK  # Load address of J0_BLOCK into $t2
		la $t3, J1_BLOCK  # Load address of J1_BLOCK into $t3
		la $t4, J2_BLOCK  # Load address of J2_BLOCK into $t4
		la $t5, J3_BLOCK  # Load address of J3_BLOCK into $t5
	
		# check the block type
		beq $s2, $t2, set_J1 # If $s2 == J0_BLOCK, branch to set_J1
		beq $s2, $t3, set_J2 # If $s2 == J1_BLOCK, branch to set_J2
		beq $s2, $t4, set_J3 # If $s2 == J2_BLOCK, branch to set_J3
		beq $s2, $t5, set_J0 # If $s2 == J3_BLOCK, branch to set_J0
		j L_block_check

		set_J0:
			la $a1, J0_BLOCK
			j check_collision

		set_J1:
			la $a1, J1_BLOCK
			j check_collision

		set_J2:
			la $a1, J2_BLOCK
			j check_collision

		set_J3:
			la $a1, J3_BLOCK
			j check_collision
		
		L_block_check:
		# FOR L BLOCK
		la $t2, L0_BLOCK  # Load address of L0_BLOCK into $t2
		la $t3, L1_BLOCK  # Load address of L1_BLOCK into $t3
		la $t4, L2_BLOCK  # Load address of L2_BLOCK into $t4
		la $t5, L3_BLOCK  # Load address of L3_BLOCK into $t5
	
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
		move $a1, $s2		   # store the address to the tet block
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
    				
    				# TO DO
    				# this is for checking playing field collision
    				# calc offset based on these block_row and block_col 
    				#	similar to calc in draw_tet but do *1 instead of *4 in this case
    				# checks byte at playing field + this offset != 0 then collision, 
    				#	if key pressed is a or d or w then this is a horizonal collision, return 2
    				#	otherwise vertical collision, return 1
    				# otherwise no collision, move on to next block 
    				
	
	# t3 = current block address
	move $t3, $a1
	# t4 = row index for row_loop/row offset (i.e. what row index within tet)
	# t5 = col index for col_loop/col offset
	# t6 = offset for playing field + playing field address
	# t8 = row of current block
	# t9 = col of current block
	# t7 = cur block in tet which is 1 or 0 (located at cur block address)
	
	# initialize row index
	li $t4, -1 # -1 bc it gets incremented to 0 in the row_loop 
	
	# initialize collision to 0 (no collision)
	li $v0, 0

	collision_row_loop:
		# initialize col index to 0
		li $t5, -1 # negative bc it get incremented to 0 in the col_loop
		
		# increment row counter
		addi $t4, $t4, 1
		
		# if (row >= 4, exit) and go to draw)
		bge $t4, 4, update_location
		
		collision_col_loop:
			#increment col offset/counter
			addi $t5, $t5, 1
			
			# if (col >=4, move to next row)
			bge $t5, 4, collision_row_loop
			
			# accessing value of current block
			lb $t7, 0($t3)
			
			# move on to address of next block
			addi $t3, $t3, 1
			
			# block value is empty, move on to next block
			beq $t7, 0, collision_col_loop
			
			# calculate row where cur block would be
			# block_row = row_index + row_in_grid (given by argument)
			add $t8, $t4, $a2
			
			# calculate column where cur block would be
			# block_col = col_index + col_in_grid
			add $t9, $t5, $a3
			
			# check for collision with walls
			# add TOP_BORDER + 1 to block_row to get overall row in entire screen
			# if it is greater than BOTTOM_BORDER, return 1
			addi $t1, $t8, TOP_BORDER
			addi $t1, $t1, 1
			bge $t1, BOTTOM_BORDER, vertical_collide
			# add LEFT_BORDER + 1 to block_col to get overall col in entire screen
			# if it is less than LEFT_BORDER or greater than RIGHT_BORDER,
			addi $t1, $t9, LEFT_BORDER
			addi $t1, $t1, 1
			ble $t1, LEFT_BORDER, collide
			bge $t1, RIGHT_BORDER, collide
			
			# check for collison with playing field
			# calc offset based on these block_row and block_col 
			# add to playing_field address
			# base + ((row index * number of columns) + column index) * 1 
			mul $t6, $t8, GRID_COL_SIZE
			add $t6, $t6, $t9
			la $t0, playing_field
			add $t6, $t6, $t0
			
			# check value in playing field to see if occupied or not
			lb $t1, 0($t6)
			# if value is not 0, i.e. occupied, collision
			bne $t1, 0, collide
			# otherwise, no collision move on to next block
			j collision_col_loop
			
			collide:
				li $v0, 1 # store 1, assume vertical collision
				# check if a or d or w was pressed to mean horizontal collision
				beq $a0, 0x64, horizontal_collide  # d is pressed
				beq $a0, 0x61, horizontal_collide  # a is pressed
				beq $a0, 0x77, horizontal_collide  # w is pressed
				j update_location
				
				horizontal_collide:
					li $v0, 2
					j update_location
			
			vertical_collide:
				li $v0, 1
				j update_location
				
			
	# 2b. Update locations (cur_tet_row, cur_tet_col)
		# takes in key pressed, output of collision check
		# if collision returned 0, then move based on key pressed, 
		#        i.e. update row s0 and col s1 or tet s2 to be sent to draw functions later
		# if returned 2, branch back to game_loop, no need to redraw
		# TO DO
		# if returned 1, cur block in cur position to playing field bc it has been set, 
		#        maybe functon for add position to playing field 
		#        generate new piece to put in s2
	
	update_location: 
		# check output of collision detection
		# if horizontal collision, don't move so go back to start of game loop
		beq $v0, 2, game_loop
		# deal with vertical collision later, so for now dont move
		beq $v0, 1, add_to_playing_field
		# otherwise, no collision, update locations for real
		move $s0, $a2
		move $s1, $a3
		move $s2, $a1
	
	draw: 
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
	
		# here we also need to draw playing field
		# make this a func prolly that doesnt need args, it use uses the save value for tet (kinda like global var)
		# and the playing field and the display address
		# inside draw_playing field is where we get rid of lines and increment the score (s4)
		#	will deal with getting rid of lines and score later
		#	might just loop through every row to see if any all non-zero rows and shifting if require
		#	before proceeding to second loop that does the printing

		# loop through playing field row by row
		# 	to do so would have a row = 0 to grid_row_size - 1, col = 0 to grid_col_size - 1 loop
		# 	per row, check value at each block
		# 		would do this by calculating address in playing field based on row and col
		#		then accessing byte at each block
		#	if value is 0, move on to next block (unoccupied so dont draw anything)
		# 	if occupied, continue
		#	determine what colour based on value in there
		#	calculate the unit in the display that would need to colour
		#		calculate row_in_overall = row_in_grid + TOP_BORDER + 1 
		#		and col_in_overall = col_in_grid + LEFT_BORDER + 1 
		#		use those in display_base + ((row index * number of columns) + column index) * unit_size
		# 	store colour at that unit ( the address u just calculated)
		# use the constants I create at the top for all these things

		draw_playing_field:
		
		# loop through playing field row by row
		# t0 = current block address in display
		# t1 = current row index
		# t2 = current column index
		# t3 = address of playing field
		# t4 = value at current block
		# t5 = row to color in overall display
		# t6 = column to color in overall display
		# t7 = address of unit in display
		# t8 = temp register for color

		# initialize current row index to -1 (we increment in in the loop)
		li $t1, -1

		draw_playing_field_row_loop:
			# loop through the playing field row by row
			# initialize current column index to -1 (-1 because we increment it in the loop)
			li $t2, -1 
			# increment row counter
			addi $t1, $t1, 1

			# if row >= GRID_ROW_SIZE, exit
			bge $t1, GRID_ROW_SIZE, game_loop

			# increment column counter
			draw_playing_field_col_loop:
				# increment column counter
				addi $t2, $t2, 1

				# if col >= GRID_COL_SIZE, move to next row
				bge $t2, GRID_COL_SIZE, draw_playing_field_row_loop

				# check the value at each block
				# calculate the address of the current block in the playing field
				# base + ((row index * number of columns) + column index) * 1
				# t0 contains the address of the current block in the playing field
				mul $t0, $t1, GRID_COL_SIZE # row index * number of columns
				add $t0, $t0, $t2 # (row index * number of columns) + column index
				la $t9, playing_field
                		add $t0, $t0, $t9 # add offset to base

				# check the value at the current block
				lb $t4, 0($t0)

				# if the value is 0, move on to the next block
				beq $t4, 0, draw_playing_field_col_loop

				# calculate the unit in the display that would need to be coloured
				# calculate the row in the overall display
				# row_in_overall = row_in_grid + TOP_BORDER + 1
				addi $t5, $t1, TOP_BORDER # row_in_grid + TOP_BORDER
				addi $t5, $t5, 1 # row_in_grid + TOP_BORDER + 1

				# calculate the column in the overall display
				# col_in_overall = col_in_grid + LEFT_BORDER + 1
				addi $t6, $t2, LEFT_BORDER # col_in_grid + LEFT_BORDER
				addi $t6, $t6, 1 # col_in_grid + LEFT_BORDER + 1

				# calculate the address of the unit in the display
				# base + ((row index * number of columns) + column index) * unit size
				mul $t7, $t5, COL_SIZE # row index * number of columns
				add $t7, $t7, $t6 # (row index * number of columns) + column index
				mul $t7, $t7, UNIT_SIZE # (row index * number of columns + column index) * unit size
				addi $t7, $t7, ADDR_DSPL_CONST # add offset to base

				# store the colour at that unit
				# t4 tells us the color of the block

				# if the value is 0, store the J block colour
				beq $t4, J_NUM, store_J_color 
				# if the value is 1, store the L block colour
				beq $t4, L_NUM, store_L_color

				store_J_color:
					li $t8, J_COLOUR # store orange into t8
					j store_color
				
				store_L_color:
					li $t8, L_COLOUR # store orange into t8
					j store_color

				# store the colour at that unit
				# t4 contains the value at the current block. it is a color. store it into the address of unit in display
				store_color:
				sw $t8, 0($t7)
				
				j draw_playing_field_col_loop
	
	#5. Go back to 1
	b game_loop	


EXIT: 
	# Exit the program
    	li $v0, 10
    	syscall

		# when vertical collision happens we need:
		#	1. the current tet in the original position (use s registers for positon) to be 
		#	   added to the playing field
		#	2. a new tet to be generated (j generate_new_tet)
		# 	3. playing field drawing will happen when we call draw later, not here 
		
		# pseudocode for 1. add_to_playing_field
		# takes in tet (s2), row (s0), col (s1) 
		# gets tet num based on tet to put into playing field 
		# loop through each block in tet, same as row_offset col_offset loop in check collision
		# access value in current block 
		#	(how? move $t1, $s2, increment t1 in every loop, load byte from t1 to see value)
		#	if 0, move on to next block
		# 	if 1, continue 
		# calc cur block row = row (s0) + row_offset, cur block col = col (s0) + col_offset
		# using block_row and block_col, calulate corresponding address in playing_field
		# 	base + ((row index * number of columns) + column index) * 1
		# 	see line 354 for example
		# set value at that playing field address to the tet num (the value is 1 byte, not a 4 byte word, use sb)
		# done 
							
		# otherwise, if no collision
		# update the rows, columns, etc. according to movement 
		
add_to_playing_field:
	# takes in tet (s2), row (s0), col (s1) 
	# t0 = the tet num
	# t1 = row index for row_loop
	# t2 = col index for col_loop
	# t3 = current block address
	# t4  = cur block in tet which is 1 or 0 (located at cur block address)
	# t5 = block_row = row_in_block + row_in_grid
	# t6 = block_col = col_in_block + col_in_grid
	# t7 = location on playing field
	# t8 = temporary register to store the address of the block

	# initialize row index for add_playing_field_row__loop
	li $t1, -1

	# move the address of the tet to $t3
	move $t3, $s2

	# gets tet num based on tet to put into playing field
	# FOR J BLOCK
	# store J_BLOCK address in $t8
	la $t8, J0_BLOCK
	# check if we have a J block
	beq $s2, $t8, set_J
	# store J1_BLOCK address in $t8
	la $t8, J1_BLOCK
	# check if we have a J block
	beq $s2, $t8, set_J
	# store J2_BLOCK address in $t8
	la $t8, J2_BLOCK
	# check if we have a J block
	beq $s2, $t8, set_J
	# store J3_BLOCK address in $t8
	la $t8, J3_BLOCK
	# check if we have a J block
	beq $s2, $t8, set_J
	
	# FOR L BLOCK 
	# store L0_BLOCK address in $t8
	la $t8, L0_BLOCK
	# check if s2 == t8
	beq $s2, $t8, set_L
	# store L1_BLOCK address in $t8
	la $t8, L1_BLOCK
	# check if s2 == t8
	beq $s2, $t8, set_L
	# store L2_BLOCK address in $t8
	la $t8, L2_BLOCK
	# check if s2 == t8
	beq $s2, $t8, set_L
	# store L3_BLOCK address in $t8
	la $t8, L3_BLOCK
	# check if s3 == t8
	beq $s2, $t8, set_L

	set_J:
		li $t0, J_NUM
		j add_playing_field_row_loop

	set_L:
		li $t0, L_NUM
		j add_playing_field_row_loop
	

	add_playing_field_row_loop:
		# initialize col index
		li $t2, -1
		# increment row counter
		addi $t1, $t1, 1

		# if (row >= 4, exit)
		bge $t1, 4, clear_row
		
		add_playing_field_col_loop:
			# incerement col counter
			addi $t2, $t2, 1

			# if (col >= 4, move to next row)
			bge $t2, 4, add_playing_field_row_loop

			# access the value of the current block
			lb $t4, 0($t3)

			# move on to the address of the next block
			addi $t3, $t3, 1

			# block value is empty: no need to add to playing field, continue
			beq $t4, 0, add_playing_field_col_loop

			# otherwise, calculate the row where the current block would be
			# block_row = row_index + row_in_grid
			add $t5, $t1, $s0
			# calculate the column where the current block would be
			# block_col = col_index + col_in_grid
			add $t6, $t2, $s1

			# calculate the location on the playing field
			# base + ((row index * number of columns) + column index) * 1
			mul $t7, $t5, GRID_COL_SIZE # (row index * number of columns)
			add $t7, $t7, $t6 # (row index * number of columns) + column_index
			la $t9, playing_field
            		add $t7, $t7, $t9 # add offset to base

			sb $t0, 0($t7) # set the value at the playing field address to the tet num
			
			j add_playing_field_col_loop

clear_row:
	# t0: row index for row_loop
	# t1: col index for col_loop
	# t2: counter for clear_row_loop
	# t3: the address of the current block in the playing field
	# t4: the value at the current block
	# t5: shifted_address (for shift_loop)
	# t6: shift_into_address (for shift_loop)
	# t7: COL_SIZE - 1 (can overwrite later if needed)
	# t8: playing field address (can overwrite later if needed)

	# jump to draw_tet when we jump out of row loop
	# 	int row = row_size;

	# store the address of the playing field in $t8
	la $t8, playing_field

	# initialize row index to row_size
	li $t0, GRID_ROW_SIZE

	# loop through the rows
	# row row row your boat, gently down the stream!
	# merrily merrily merrily merrily, life is but a dream!
	clear_row_row_loop: 		# while (row >= 0)
		li $t1, -1 				# initialize col index to -1
		addi $t0, $t0, -1 		# decrement row counter
		blt $t0, 0, generate_new_tet 	# if row < 0, exit

		clear_row_col_loop:
			# increment col counter
			addi $t1, $t1, 1
			bge $t1, GRID_COL_SIZE, clear_row_row_loop

			# calculate the address of the current block in the playing field
			# base + ((row index * number of columns) + column index) * 1
			mul $t3, $t0, GRID_COL_SIZE # row index * number of columns
			add $t3, $t3, $t1 # (row index * number of columns) + column index
			add $t3, $t3, $t8 # add offset to base

			# check the value at the current block
			# if the value is 0, move on to the next row
			lb $t4, 0($t3)
			beq $t4, 0, clear_row_row_loop

			# check if we are at the end of a row
			li $t7, GRID_COL_SIZE
			addi $t7, $t7, -1
			# not at end of row, jump back to col loop to check next block in row
			bne $t1, $t7, clear_row_col_loop
			
			# increment score
			# at this point also check if we have reached the level cap
			# if yes, go to next level
			# change level saved value and level gravity saved value
			addi $s4, $s4, 1
			bge $s4, LEVEL_2_CAP, set_level_3
			bge $s4, LEVEL_1_CAP, set_level_2
			b shift_setup
			
			set_level_3:
				li $s5, 3 # set level to 3
				li $s6, LEVEL_3_GRAVITY # set gravity to level 3
				b shift_setup
			
			set_level_2: 
				li $s5, 2 # set level to 2
				li $s6, LEVEL_2_GRAVITY # set gravity to level 2
				b shift_setup
			

			# if (col == col_size - 1), continue. otherwise jump
			# we have a full row that we need to clear 

			shift_setup:
			
			# shifted_address (t5) = curaddress - col_size
			sub $t5, $t3, GRID_COL_SIZE
			# shift_into_address (t6) = curaddress
			move $t6, $t3

			# while (shifted_address >= playing_field)
			shift_loop:
				# if shifted_address >= playing_field
				# make a label called add 0 and then from there jump back to the row loop
				blt $t5, $t8 zero_out_top_row

				# copy the block at shifted_address to shift_into_address
				lb $t9, 0($t5)
				sb $t9, 0($t6)

				# decrement shifted_address and shift_into_address by 1
				addi $t5, $t5, -1
				addi $t6, $t6, -1
				j shift_loop

			zero_out_top_row:
				# t7: make_zero_address = playing_field
				la $t7, playing_field
				# t8: playing_field address + col_size 
				la $t8, playing_field
				addi $t8, $t8, GRID_COL_SIZE

				# while (make_zero_address < playing_field + col_size)
				zero_out_top_row_loop:
					
					bge $t7, $t8, zero_out_done

					# make the block at make_zero_address 0
					sb $zero, 0($t7)
					
					# increment make_zero_address
					addi $t7, $t7, 1

					j zero_out_top_row_loop
			
				zero_out_done:
					# increment row counter
					addi $t0, $t0, 1
		j clear_row_row_loop
			
	# while (row >= 0) {
	#     # 0 if we encounter a 0 which means the row is not full
	#     # 1 so, we have only encountered non-zeros

	#     row--;

	#     int col = -1

	#     while (col < col_size) {
	#         col++;
	#         # calc cur address to check if the block is full
	#         int curaddress = playing_field + (row * col_size + col);
	#         if (playing_field[row][col] == 0) {
	#             j row_loop
	#         }
	#         if (col == col_size -1) {
	#             # there been all non-zeroes so far
	#             # we have a full row
	#             # we need to remove the row

				
	#             int shifted_address = curaddress - col_size; 
	#             int shift_into_address = curaddress;
	#             while (shifted_address >= playing_field) {
	#                 # copy the block at shifted_address to shift_into_address
	#                 # decrement shifted_address and shift_into_address by 1
	#                 shifted_address--;
	#                 shift_into_address--;
	#             }

	#             # we need to fill the top row with zeros
	#             int make_zero_address = playing_field;
	#             while (make_zero_address < playing_field + col_size) {
	#                 # make the block at make_zero_address 0
	#                 make_zero_address++;
	#             }

	#             row++;
	#         }
	#     }
	# }

		

	
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
		# base + ((row index * number of columns) + column index) * unit size 
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

check_spawn_collision:
    	# a0 -- what key is pressed
    	# a1 -- cur tet (the constant that means the address) 
    	# 	for every function except for rotate just grab the value in the stored register
    	# a2 -- row index in grid that the top left block of the tet is located at
    	# a3 -- col index in grid that the top left block of the tet is located at
    	# if no collision, update locations
    	# if collision, exit (game over)
    				
	
	# t3 = current block address
	move $t3, $a1
	# t4 = row index for row_loop/row offset (i.e. what row index within tet)
	# t5 = col index for col_loop/col offset
	# t6 = offset for playing field + playing field address
	# t8 = row of current block
	# t9 = col of current block
	# t7 = cur block in tet which is 1 or 0 (located at cur block address)
	
	# initialize row index
	li $t4, -1 # -1 bc it gets incremented to 0 in the row_loop 
	
	# initialize collision to 0 (no collision)
	li $v0, 0

	spawn_collision_row_loop:
		# initialize col index to 0
		li $t5, -1 # negative bc it get incremented to 0 in the col_loop
		
		# increment row counter
		addi $t4, $t4, 1
		
		# if (row >= 4, exit) and go to draw, no collision
		bge $t4, 4, update_location
		
		spawn_collision_col_loop:
			#increment col offset/counter
			addi $t5, $t5, 1
			
			# if (col >=4, move to next row)
			bge $t5, 4, spawn_collision_row_loop
			
			# accessing value of current block
			lb $t7, 0($t3)
			
			# move on to address of next block
			addi $t3, $t3, 1
			
			# block value is empty, move on to next block
			beq $t7, 0, spawn_collision_col_loop
			
			# calculate row where cur block would be
			# block_row = row_index + row_in_grid (given by argument)
			add $t8, $t4, $a2
			
			# calculate column where cur block would be
			# block_col = col_index + col_in_grid
			add $t9, $t5, $a3
			
			# check for collision with walls
			# add TOP_BORDER + 1 to block_row to get overall row in entire screen
			# if it is greater than BOTTOM_BORDER, return 1
			addi $t1, $t8, TOP_BORDER
			addi $t1, $t1, 1
			bge $t1, BOTTOM_BORDER, EXIT
			# add LEFT_BORDER + 1 to block_col to get overall col in entire screen
			# if it is less than LEFT_BORDER or greater than RIGHT_BORDER,
			addi $t1, $t9, LEFT_BORDER
			addi $t1, $t1, 1
			ble $t1, LEFT_BORDER, EXIT
			bge $t1, RIGHT_BORDER, EXIT
			
			# check for collison with playing field
			# calc offset based on these block_row and block_col 
			# add to playing_field address
			# base + ((row index * number of columns) + column index) * 1 
			mul $t6, $t8, GRID_COL_SIZE
			add $t6, $t6, $t9
			la $t0, playing_field
			add $t6, $t6, $t0
			
			# check value in playing field to see if occupied or not
			lb $t1, 0($t6)
			# if value is not 0, i.e. occupied, collision
			bne $t1, 0, EXIT
			# otherwise, no collision move on to next block
			j spawn_collision_col_loop
    
            
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
	# t7 = temp register for the blocks
	
	# if (tet == any variation of J block, t6 = J_COLOUR)
	la $t7, J0_BLOCK
	beq $t3, $t7, set_J_COLOR
	
	la $t7, J1_BLOCK
	beq $t3, $t7, set_J_COLOR
	
	la $t7, J2_BLOCK
	beq $t3, $t7, set_J_COLOR
	
	la $t7, J3_BLOCK
	beq $t3, $t7, set_J_COLOR
	
	la $t7, L0_BLOCK
	beq $t3, $t7, set_L_COLOR
	
	la $t7, L1_BLOCK
	beq $t3, $t7, set_L_COLOR
	
	la $t7, L2_BLOCK
	beq $t3, $t7, set_L_COLOR
	
	la $t7, L3_BLOCK
	beq $t3, $t7, set_L_COLOR

	# t7 = byte located at current block address (i.e. 0 or 1)
	# t8 = start row + row_offset
	# t9 = start col + col_offset
	
	set_J_COLOR:
		li $t6, J_COLOUR
		j setup_draw_tet

	set_L_COLOR:
		li $t6, L_COLOUR
		j setup_draw_tet
	
	setup_draw_tet:
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
