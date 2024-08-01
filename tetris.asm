#####################################################################
# CSCB58 Summer 2024 Assembly Final Project - UTSC
# Student1: Janani Gurram, 1009109778, gurramja, j.gurram@utoronto.ca
# Student2: Rachel Pan, 1009041145, panrach1, r.pan@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 16 
# - Unit height in pixels: 16
# - Display width in pixels:  256
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1
# - Milestone 2
# - Milestone 3
# - Milestone 4
# - Milestone 5
#
# Which approved features have been implemented?
# (See the assignment handout for the list of features)
# Easy Features:
# 1. Feature 1: Gravity
# 2. Feature 2: Increasing gravity
# 3. Feature 6: Levels with harder features (gravity increases)
# 4. Feature 11: All tetrominoes have a different color
# 5. Feature 14: Save feature
# Hard Features:
# 1. Feature 1: Tracking score and display in pixels
# 2. Feature 2: Implement the full set of tetrominoes 
# How to play:
# Do not hold keys 
# Score on the screen is displayed in hex
# Press C to hold the block

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
	
# S block and all its rotations
S0_BLOCK: 
	.byte 0 1 1 0
	.byte 1 1 0 0
	.byte 0 0 0 0
	.byte 0 0 0 0
S1_BLOCK: 
	.byte 0 1 0 0
	.byte 0 1 1 0
	.byte 0 0 1 0
	.byte 0 0 0 0
S2_BLOCK: 
	.byte 0 0 0 0
	.byte 0 1 1 0
	.byte 1 1 0 0
	.byte 0 0 0 0
S3_BLOCK: 
	.byte 1 0 0 0
	.byte 1 1 0 0
	.byte 0 1 0 0
	.byte 0 0 0 0
	
# I block and all its rotations
I0_BLOCK: 
	.byte 0 0 0 0
	.byte 1 1 1 1
	.byte 0 0 0 0
	.byte 0 0 0 0
I1_BLOCK: 
	.byte 0 0 1 0
	.byte 0 0 1 0
	.byte 0 0 1 0
	.byte 0 0 1 0
I2_BLOCK: 
	.byte 0 0 0 0
	.byte 0 0 0 0
	.byte 1 1 1 1
	.byte 0 0 0 0
I3_BLOCK: 
	.byte 0 1 0 0
	.byte 0 1 0 0
	.byte 0 1 0 0
	.byte 0 1 0 0

# Z block and all its rotations
Z0_BLOCK: 
	.byte 1 1 0 0
	.byte 0 1 1 0
	.byte 0 0 0 0
	.byte 0 0 0 0
Z1_BLOCK:
	.byte 0 0 1 0
	.byte 0 1 1 0
	.byte 0 1 0 0
	.byte 0 0 0 0
Z2_BLOCK:
	.byte 0 0 0 0
	.byte 1 1 0 0
	.byte 0 1 1 0
	.byte 0 0 0 0
Z3_BLOCK:
	.byte 0 0 1 0
	.byte 0 1 1 0
	.byte 0 1 0 0
	.byte 0 0 0 0
	
# O block and all its rotations
O0_BLOCK: 
	.byte 0 0 0 0
	.byte 0 1 1 0
	.byte 0 1 1 0
	.byte 0 0 0 0
	
# T block and all its rotations
T0_BLOCK: 
	.byte 0 0 0 0
	.byte 1 1 1 0
	.byte 0 1 0 0
	.byte 0 0 0 0
T1_BLOCK:
	.byte 0 1 0 0
	.byte 1 1 0 0
	.byte 0 1 0 0
	.byte 0 0 0 0
T2_BLOCK:
	.byte 0 1 0 0
	.byte 1 1 1 0
	.byte 0 0 0 0
	.byte 0 0 0 0
T3_BLOCK:
	.byte 0 1 0 0
	.byte 0 1 1 0
	.byte 0 1 0 0
	.byte 0 0 0 0

.eqv MAX_TET_NUM 7
sixteens_digit_0: .word 24 25 26 40 42 56 58 72 74 88 89 90 -1
sixteens_digit_1: .word 26 42 58 74 90 -1
sixteens_digit_2: .word 24 25 26 42 58 57 56 72 88 89 90 -1
sixteens_digit_3: .word 24 25 26 42 59 57 56 74 90 89 88 -1
sixteens_digit_4: .word 24 40 56 57 58 26 42 74 90 -1
sixteens_digit_5: .word 26 25 24 40 56 57 58 74 90 89 88 -1
sixteens_digit_6: .word 26 25 24 40 56 72 88 89 90 74 58 57 -1
sixteens_digit_7: .word 24 25 26 42 58 74 90 -1
sixteens_digit_8: .word 24 25 26 40 42 56 57 58 72 74 88 89 90 -1
sixteens_digit_9: .word 24 25 26 40 56 57 42 58 74 90 89 88 -1
sixteens_digit_a: .word 24 25 26 40 42 56 57 58 72 74 88 90 -1
sixteens_digit_b: .word 24 40 56 57 58 72 74 88 89 90 -1
sixteens_digit_c: .word 24 25 26 49 56 72 88 89 90 -1
sixteens_digit_d: .word 26 42 56 57 58 72 74 88 89 90 -1
sixteens_digit_e: .word 24 25 26 40 56 57 58 72 88 89 90 -1
sixteens_digit_f: .word 24 25 26 40 56 57 58 72 88 -1


ones_digit_0: .word 28 29 30 44 46 60 62 76 78 92 93 94 -1
ones_digit_1: .word 30 46 62 78 94 -1
ones_digit_2: .word 28 29 30 46 60 61 62 76 92 93 94 -1
ones_digit_3: .word 28 29 30 46 60 61 62 78 92 93 94 -1
ones_digit_4: .word 28 30 44 46 60 61 62 78 94 -1
ones_digit_5: .word 28 29 30 44 60 61 62 78 92 93 94 -1
ones_digit_6: .word 28 29 30 44 60 61 62 76 78 92 93 94 -1
ones_digit_7: .word 28 29 30 46 62 78 94 -1
ones_digit_8: .word 28 29 30 44 46 60 61 62 76 78 92 93 94 -1
ones_digit_9: .word 28 29 30 44 46 60 61 62 78 92 93 94 -1
ones_digit_a: .word 28 29 30 44 46 60 61 62 76 78 92 94 -1
ones_digit_b: .word 28 44 60 61 62 76 78 92 93 94 -1
ones_digit_c: .word 28 29 30 44 60 76 92 93 94 -1
ones_digit_d: .word 30 46 60 61 62 76 78 92 93 94 -1
ones_digit_e: .word 28 29 30 44 60 61 62 76 92 93 94 -1
ones_digit_f: .word 28 29 30 44 60 61 62 76 92 -1


.eqv HOLD_BUTTON 0x63
.eqv ADDR_DSPL_CONST 0x10008000
.eqv UNIT_SIZE 4	# Size of each unit in bytes

.eqv GRID_DARK 0x0	# dark colour in grid
.eqv GRID_LIGHT 0x1c1c1c	# light colour in grid 
.eqv BORDER_BLACK 0x444444	# black for border

.eqv ROW_SIZE 32	# number of rows (256/8)
.eqv COL_SIZE 16	# number of col (128/8)
.eqv GRID_ROW_SIZE 24  # number of rows in grid (row_size - borders)
.eqv GRID_COL_SIZE 14  # number of cols in grid (col_size - borders)

.eqv TOP_BORDER 6	# row index that top border ends
.eqv BOTTOM_BORDER 31	# row index that bottom border starts 
.eqv LEFT_BORDER 0	# col index that left border ends
.eqv RIGHT_BORDER 15	# col index that left border starts


LEVEL_1_DISPLAY: .word  86 -1
LEVEL_2_DISPLAY: .word  54 86 -1
LEVEL_3_DISPLAY: .word  22 54 86 -1

# after reaching a score of score cap, move on to next level
.eqv LEVEL_1_CAP 16
.eqv LEVEL_2_CAP 32

.eqv LEVEL_1_GRAVITY 700  # how many milliseconds should pass before moving 1 block down
.eqv LEVEL_2_GRAVITY 450 
.eqv LEVEL_3_GRAVITY 150

# what number each tet is assoicated with (used for picking random piece)
# also used for colouring
.eqv J_NUM 1
.eqv L_NUM 2
.eqv S_NUM 3
.eqv I_NUM 4
.eqv Z_NUM 5
.eqv O_NUM 6
.eqv T_NUM 7

# colours for blocks
.eqv L_COLOUR 0xe69138
.eqv S_COLOUR 0xfe481c
.eqv I_COLOUR 0x84e7ee
.eqv Z_COLOUR 0x0db23a
.eqv O_COLOUR 0xfffa5c
.eqv T_COLOUR 0x9400ab
.eqv J_COLOUR 0xE04DCC

.eqv SCORE_COLOUR 0xAAAAAA

.eqv START_TET_ROW 0
.eqv START_TET_COL 5

##############################################################################
# Mutable Data
##############################################################################

# to store playing field
# 0 if unoccupied
# number reping colour is occupied
playing_field: .byte 0:512
frame_buffer: .word 0:512

##############################################################################
# Code
##############################################################################
.text
    .globl main

main:  	
	# intialize score to 0 abd milliseconds passed
	li $s3, 0
	li $s4, 0
	la $s7, 0
	
	# initialize level to 1
	li $s6, LEVEL_1_GRAVITY
	
	jal draw_background
	
	# the tet I am generating
	# would be randomized in final
	# generate random number 1-7 in $t1
	# use generated tet number to figure out block
	
	generate_new_tet:
	# set up starting row and col
	# s registers for draw, a registers for collision detection
	li $s0, START_TET_ROW # row to where tet starts off
	li $s1, START_TET_COL # col to where tet starts off
	move $a2, $s0 # row to where tet starts off
	move $a3, $s1 # col to where tet starts off
	
	# reset swapped to 0
	li $s5, 0
	
	# generate random num and store into t1
	# not yet, will do after implementing full set
	li $v0, 42
	li $a0, 0
	li $a1, MAX_TET_NUM
	syscall

	move $t1, $a0 # store the random number in t1
	addi $t1, $t1, 1 # add 1 to include the upper bound
	
	# figure out which tet to generate based on random number
	beq $t1, J_NUM, generate_J # if t0 == 1, generate J block
	beq $t1, L_NUM, generate_L # if t1 == 2, generate L block
	beq $t1, S_NUM, generate_S # if t1 == 3, generate S block
	beq $t1, I_NUM, generate_I # if t1 == 4, generate I block
	beq $t1, Z_NUM, generate_Z # if t1 == 5, generate Z block
	beq $t1, O_NUM, generate_O # if t1 == 6, generate O block
	beq $t1, T_NUM, generate_T # if t1 == 7, generate T block

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
		
	# load appropiate tet address into s2 for collision detection 
	generate_S:
		la $s2, S0_BLOCK
		move $a1, $s2
		j check_spawn_collision	
		
	# load appropiate tet address into s2 for collision detection 
	generate_I:
		la $s2, I0_BLOCK
		move $a1, $s2
		j check_spawn_collision

	# load appropiate tet address into s2 for collision detection 
	generate_Z:
		la $s2, Z0_BLOCK
		move $a1, $s2
		j check_spawn_collision

	# load appropiate tet address into s2 for collision detection 
	generate_O:
		la $s2, O0_BLOCK
		move $a1, $s2
		j check_spawn_collision

	# load appropiate tet address into s2 for collision detection 
	generate_T:
		la $s2, T0_BLOCK
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
	# s5 -- whether we have already swapped out held and cur yet (0 if we havent, 1 if we have)
	#	used to determine if we have do another hold 
	# s6 -- gravity constant based on level, use gravity to determine level
	# s7 -- tet we are hold, 0 if  no hold
	
	# 1a. Check if key has been pressed
		# check even 5 milliseconds/0.005 sec if its has been pressed
		# after checking 200 times, temp_drop (do this before checking for keyboard input)
		# if yes, then check what key
	
	# Sleep
	li $v0, 32
	li $a0, 1 # Wait one second (1000 milliseconds)
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
		beq $t2, HOLD_BUTTON, hold
		
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
		beq $s2, $t5, set_L0 # If $s2 == L3_BLOCK, branch to set_L0
		j S_block_check

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
			
		S_block_check:
		# FOR S BLOCK
		la $t2, S0_BLOCK  # Load address of S0_BLOCK into $t2
		la $t3, S1_BLOCK  # Load address of S1_BLOCK into $t3
		la $t4, S2_BLOCK  # Load address of S2_BLOCK into $t4
		la $t5, S3_BLOCK  # Load address of S3_BLOCK into $t5
	
		# check the block type
		beq $s2, $t2, set_S1 # If $s2 == S0_BLOCK, branch to set_S1
		beq $s2, $t3, set_S2 # If $s2 == S1_BLOCK, branch to set_S2
		beq $s2, $t4, set_S3 # If $s2 == S2_BLOCK, branch to set_S3
		beq $s2, $t5, set_S0 # If $s2 == S3_BLOCK, branch to set_S0
		j I_block_check

		set_S0:
			la $a1, S0_BLOCK
			j check_collision

		set_S1:
			la $a1, S1_BLOCK
			j check_collision

		set_S2:
			la $a1, S2_BLOCK
			j check_collision

		set_S3:
			la $a1, S3_BLOCK
			j check_collision

		I_block_check:
		# FOR I BLOCK
		la $t2, I0_BLOCK  # Load address of I0_BLOCK into $t2
		la $t3, I1_BLOCK  # Load address of I1_BLOCK into $t3
		la $t4, I2_BLOCK  # Load address of I2_BLOCK into $t4
		la $t5, I3_BLOCK  # Load address of I3_BLOCK into $t5
	
		# check the block type
		beq $s2, $t2, set_I1 # If $s2 == I0_BLOCK, branch to set_I1
		beq $s2, $t3, set_I2 # If $s2 == I1_BLOCK, branch to set_I2
		beq $s2, $t4, set_I3 # If $s2 == I2_BLOCK, branch to set_I3
		beq $s2, $t5, set_I0 # If $s2 == I3_BLOCK, branch to set_I0
		j Z_block_check

		set_I0:
			la $a1, I0_BLOCK
			j check_collision

		set_I1:
			la $a1, I1_BLOCK
			j check_collision

		set_I2:
			la $a1, I2_BLOCK
			j check_collision

		set_I3:
			la $a1, I3_BLOCK
			j check_collision

		Z_block_check:
		# FOR Z BLOCK
		la $t2, Z0_BLOCK  # Load address of Z0_BLOCK into $t2
		la $t3, Z1_BLOCK  # Load address of Z1_BLOCK into $t3
		la $t4, Z2_BLOCK  # Load address of Z2_BLOCK into $t4
		la $t5, Z3_BLOCK  # Load address of Z3_BLOCK into $t5
	
		# check the block type
		beq $s2, $t2, set_Z1 # If $s2 == Z0_BLOCK, branch to set_Z1
		beq $s2, $t3, set_Z2 # If $s2 == Z1_BLOCK, branch to set_Z2
		beq $s2, $t4, set_Z3 # If $s2 == Z2_BLOCK, branch to set_Z3
		beq $s2, $t5, set_Z0 # If $s2 == Z3_BLOCK, branch to set_Z0
		j O_block_check

		set_Z0:
			la $a1, Z0_BLOCK
			j check_collision

		set_Z1:
			la $a1, Z1_BLOCK
			j check_collision

		set_Z2:
			la $a1, Z2_BLOCK
			j check_collision

		set_Z3:
			la $a1, Z3_BLOCK
			j check_collision
			
		O_block_check:
		# FOR Z BLOCK
		la $t2, O0_BLOCK  # Load address of Z0_BLOCK into $t2
	
		# check the block type
		beq $s2, $t2, set_O0 # If $s2 == Z0_BLOCK, branch to set_Z1
		j T_block_check
		
		set_O0:
			la $a1, O0_BLOCK
			j check_collision
			
		T_block_check:
		# FOR T BLOCK
		la $t2, T0_BLOCK  # Load address of T0_BLOCK into $t2
		la $t3, T1_BLOCK  # Load address of T1_BLOCK into $t3
		la $t4, T2_BLOCK  # Load address of T2_BLOCK into $t4
		la $t5, T3_BLOCK  # Load address of T3_BLOCK into $t5
	
		# check the block type
		beq $s2, $t2, set_T1 # If $s2 == T0_BLOCK, branch to set_T1
		beq $s2, $t3, set_T2 # If $s2 == T1_BLOCK, branch to set_T2
		beq $s2, $t4, set_T3 # If $s2 == T2_BLOCK, branch to set_T3
		beq $s2, $t5, set_T0 # If $s2 == I3_BLOCK, branch to set_T0

		set_T0:
			la $a1, T0_BLOCK
			j check_collision

		set_T1:
			la $a1, T1_BLOCK
			j check_collision

		set_T2:
			la $a1, T2_BLOCK
			j check_collision

		set_T3:
			la $a1, T3_BLOCK
			j check_collision
	
	hold:
		# if held tet s7 is 0, put current in tet s2 into s7
		# then call generate_tet
		beq $s7, 0, if_nothing_held
		
		# if we have have already swaped and can't do another one yet
		beq $s5, 1, game_loop
		
		# now we will swap so make swapped 1
		li $s5, 1
		
		# if held tet s7 if non-zero, swap held tet (S7) and cur tet (s2)
		move $t5, $s2
		move $s2, $s7
		move $s7, $t5
		
		# set up arg for check_collision
		li $a0, HOLD_BUTTON
		move $a1, $s2 
		li $a2, START_TET_ROW 
		li $a3, START_TET_COL
		j check_collision
		
		if_nothing_held:
			move $s7, $s2
			j generate_new_tet

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
		

		jal draw_playing_field
		
		
		# figure out what level to draw based on gravity value and draw level
		beq $s6, LEVEL_1_GRAVITY, setup_level_1
		beq $s6, LEVEL_2_GRAVITY, setup_level_2
		beq $s6, LEVEL_3_GRAVITY, setup_level_3
		
		setup_level_1:
			la $a0, LEVEL_1_DISPLAY
			j draw_level
		setup_level_2:
			la $a0, LEVEL_2_DISPLAY
			j draw_level
		setup_level_3:
			la $a0, LEVEL_3_DISPLAY
			j draw_level
			
		draw_level:
			jal draw_digit
		
		# set up arg for draw score
		# draw 16s digit, just picked on but later you would do based on acc score
		# get 16s digit and put into a0 as arg for 
		move $t0, $s4
		srl $t0, $t0, 4 #to get 16s digit, logical shift right 4 bits
    		# Mask the least significant 4 bits to get the digit in the 16s place
   		andi $t0, $t0, 0xF    # Mask the least significant 4 bits (0xF = 1111 in binary)
		
		# if t0 == 0, then draw 16s digit 0
		beq $t0, 0, draw_0_sixteens
		
		# if t0 == 1, then draw 16s digit 1
		beq $t0, 1, draw_1_sixteens

		# if t0 == 2, then draw 16s digit 2
		beq $t0, 2, draw_2_sixteens
	
		# if t0 == 3, then draw 16s digit 3
		beq $t0, 3, draw_3_sixteens

		# if t0 == 4, then draw 16s digit 4
		beq $t0, 4, draw_4_sixteens

		# if t0 == 5, then draw 16s digit 5
		beq $t0, 5, draw_5_sixteens

		# if t0 == 6, then draw 16s digit 6
		beq $t0, 6, draw_6_sixteens

		# if t0 == 7, then draw 16s digit 7
		beq $t0, 7, draw_7_sixteens

		# if t0 == 8, then draw 16s digit 8
		beq $t0, 8, draw_8_sixteens

		# if t0 == 9, then draw 16s digit 9
		beq $t0, 9, draw_9_sixteens

		# if t0 == a, then draw 16s digit a
		beq $t0, 0xa, draw_a_sixteens

		# if t0 == b, then draw 16s digit b
		beq $t0, 0xb, draw_b_sixteens

		# if t0 == c, then draw 16s digit c
		beq $t0, 0xc, draw_c_sixteens

		# if t0 == d, then draw 16s digit d
		beq $t0, 0xd, draw_d_sixteens

		# if t0 == e, then draw 16s digit e
		beq $t0, 0xe, draw_e_sixteens

		# if t0 == f, then draw 16s digit f
		beq $t0, 0xf, draw_f_sixteens

		draw_0_sixteens:
			la $a0, sixteens_digit_0
			j draw_sixteens
			
		draw_1_sixteens:
			la $a0, sixteens_digit_1
			j draw_sixteens

		draw_2_sixteens:
			la $a0, sixteens_digit_2
			j draw_sixteens
		
		draw_3_sixteens:
			la $a0, sixteens_digit_3
			j draw_sixteens

		draw_4_sixteens:
			la $a0, sixteens_digit_4
			j draw_sixteens
		
		draw_5_sixteens:
			la $a0, sixteens_digit_5
			j draw_sixteens
		
		draw_6_sixteens:
			la $a0, sixteens_digit_6
			j draw_sixteens
		
		draw_7_sixteens:
			la $a0, sixteens_digit_7
			j draw_sixteens
		
		draw_8_sixteens:
			la $a0, sixteens_digit_8
			j draw_sixteens
		
		draw_9_sixteens:
			la $a0, sixteens_digit_9
			j draw_sixteens

		draw_a_sixteens:
			la $a0, sixteens_digit_a
			j draw_sixteens
		
		draw_b_sixteens:
			la $a0, sixteens_digit_b
			j draw_sixteens
		
		draw_c_sixteens:
			la $a0, sixteens_digit_c
			j draw_sixteens
		
		draw_d_sixteens:
			la $a0, sixteens_digit_d
			j draw_sixteens
		
		draw_e_sixteens:
			la $a0, sixteens_digit_e
			j draw_sixteens
		
		draw_f_sixteens:
			la $a0, sixteens_digit_f
			j draw_sixteens
		
		draw_sixteens:
			jal draw_digit
		
				
		# based on number in t0, load approiate label address into a0 
		# if t0 = 0xa then sixteen_digit_a loaded into a0
		# 16 if statements
		
		# jal draw_digit
		
		# draw 1s digit
		# get 1s digit
	
		# to get 1s digit, logical shift left 2 bytes
                # then logical shift right 2 bytes
               	move $t0, $s4
               	andi $t0, $t0, 0xF
               	#sll $t0, $t0, 2
               	#srl $t0, $t0, 2
               	
        # if statements
		# if t0 == 0, then draw 16s digit 0
		beq $t0, $zero, draw_0_ones
		beq $t0, 1, draw_1_ones
		beq $t0, 2, draw_2_ones
		beq $t0, 3, draw_3_ones
		beq $t0, 4, draw_4_ones
		beq $t0, 5, draw_5_ones
		beq $t0, 6, draw_6_ones
		beq $t0, 7, draw_7_ones
		beq $t0, 8, draw_8_ones
		beq $t0, 9, draw_9_ones
		beq $t0, 0xa, draw_a_ones
		beq $t0, 0xb, draw_b_ones
		beq $t0, 0xc, draw_c_ones
		beq $t0, 0xd, draw_d_ones
		beq $t0, 0xe, draw_e_ones
		beq $t0, 0xf, draw_f_ones
		
		draw_0_ones:
			la $a0, ones_digit_0
			j draw_ones
		draw_1_ones:
			la $a0, ones_digit_1
			j draw_ones
		draw_2_ones:
			la $a0, ones_digit_2
			j draw_ones
		draw_3_ones:
			la $a0, ones_digit_3
			j draw_ones
		draw_4_ones:
			la $a0, ones_digit_4
			j draw_ones
		draw_5_ones:
			la $a0, ones_digit_5
			j draw_ones
		draw_6_ones:
			la $a0, ones_digit_6
			j draw_ones
		draw_7_ones:
			la $a0, ones_digit_7
			j draw_ones
		draw_8_ones:
			la $a0, ones_digit_8
			j draw_ones
		draw_9_ones:
			la $a0, ones_digit_9
			j draw_ones
		draw_a_ones:
			la $a0, ones_digit_a
			j draw_ones
		draw_b_ones:
			la $a0, ones_digit_b
			j draw_ones
		draw_c_ones:
			la $a0, ones_digit_c
			j draw_ones
		draw_d_ones:
			la $a0, ones_digit_d
			j draw_ones
		draw_e_ones:
			la $a0, ones_digit_e
			j draw_ones
		draw_f_ones:
			la $a0, ones_digit_f
			j draw_ones
			
		draw_ones:
			jal draw_digit
               	
		# draw held tet
		jal draw_held_tet
		jal copy_frame_buffer_to_display
	
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
			bge $t1, GRID_ROW_SIZE, exit_draw_playing_field

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
				sll $t7, $t7, 2
				#mul $t7, $t7, UNIT_SIZE # (row index * number of columns + column index) * unit size
				la $t9, frame_buffer
				add $t7, $t7, $t9 # add offset to base

				# store the colour at that unit
				# t4 tells us the color of the block

				# if the value is 0, store the J block colour
				beq $t4, J_NUM, store_J_color 
				# if the value is 1, store the L block colour
				beq $t4, L_NUM, store_L_color
				# if the value is 2, store S_block colour
				beq $t4, S_NUM, store_S_color
				# if the value is 3, store I_block colour
				beq $t4, I_NUM, store_I_color
				# if the value is 4, store Z_block colour
				beq $t4, Z_NUM, store_Z_color
				# if the value is 5, store O_block colour
				beq $t4, O_NUM, store_O_color
				# if the value is 6, store T_block colour
				beq $t4, T_NUM, store_T_color

				store_J_color:
					li $t8, J_COLOUR # store colour into t8
					j store_color
				
				store_L_color:
					li $t8, L_COLOUR # store colour into t8
					j store_color
					
				store_S_color:
					li $t8, S_COLOUR # store colour into t8
					j store_color
					
				store_I_color:
					li $t8, I_COLOUR # store colour into t8
					j store_color

				store_Z_color:
					li $t8, Z_COLOUR # store colour into t8
					j store_color
					
				store_O_color:
					li $t8, O_COLOUR # store colour into t8
					j store_color

				store_T_color:
					li $t8, T_COLOUR # store colour into t8
					j store_color
					
				# store the colour at that unit
				# t4 contains the value at the current block. it is a color. store it into the address of unit in display
				store_color:
				sw $t8, 0($t7)
				
				j draw_playing_field_col_loop
exit_draw_playing_field:
	jr $ra


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
	
	# store S_BLOCK address in $t8 and check if we have a S block
	la $t8, S0_BLOCK
	beq $s2, $t8, set_S
	
	la $t8, S1_BLOCK
	beq $s2, $t8, set_S
	
	la $t8, S2_BLOCK
	beq $s2, $t8, set_S
	
	la $t8, S3_BLOCK
	beq $s2, $t8, set_S

	# store I_BLOCK address in $t8 and check if we have a I block
	la $t8, I0_BLOCK
	beq $s2, $t8, set_I
	
	la $t8, I1_BLOCK
	beq $s2, $t8, set_I
	
	la $t8, I2_BLOCK
	beq $s2, $t8, set_I
	
	la $t8, I3_BLOCK
	beq $s2, $t8, set_I

	# store Z_BLOCK address in $t8 and check if we have a Z block
	la $t8, Z0_BLOCK
	beq $s2, $t8, set_Z
	
	la $t8, Z1_BLOCK
	beq $s2, $t8, set_Z
	
	la $t8, Z2_BLOCK
	beq $s2, $t8, set_Z
	
	la $t8, Z3_BLOCK
	beq $s2, $t8, set_Z

	# store O_BLOCK address in $t8 and check if we have a O block
	la $t8, O0_BLOCK
	beq $s2, $t8, set_O
	
	# store T_BLOCK address in $t8 and check if we have a T block
	la $t8, T0_BLOCK
	beq $s2, $t8, set_T
	
	la $t8, T1_BLOCK
	beq $s2, $t8, set_T
	
	la $t8, T2_BLOCK
	beq $s2, $t8, set_T
	
	la $t8, T3_BLOCK
	beq $s2, $t8, set_T

	set_J:
		li $t0, J_NUM
		j add_playing_field_row_loop
	set_L:
		li $t0, L_NUM
		j add_playing_field_row_loop
	set_S:
		li $t0, S_NUM
		j add_playing_field_row_loop
	set_I:
		li $t0, I_NUM
		j add_playing_field_row_loop
	set_Z:
		li $t0, Z_NUM
		j add_playing_field_row_loop
		
	set_O:
		li $t0, O_NUM
		j add_playing_field_row_loop

	set_T:
		li $t0, T_NUM
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
				li $s6, LEVEL_3_GRAVITY # set gravity to level 3
				b shift_setup
			
			set_level_2: 
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
		la $t0, frame_buffer              # t0 = base display address
		li $t3, ROW_SIZE                # t3 = display width in units
		li $t4, COL_SIZE                # t4 = display height in units
	
		# calculate the address of the current unit in t7
		#li $t8, UNIT_SIZE			# t8 = unit size (4 bytes)
		# base + ((row index * number of columns) + column index) * unit size 
    		# row index * number of columns
    		mul $t7, $t5, $t4
    		# (row index * num columns) + column index
    		add $t7, $t7, $t6
    		# t7 * unit size
    		sll $t7, $t7, 2
    		#mul $t7, $t7, UNIT_SIZE
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
	la $t0, frame_buffer
	
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
	
	# for L block
	la $t7, L0_BLOCK
	beq $t3, $t7, set_L_COLOR
	
	la $t7, L1_BLOCK
	beq $t3, $t7, set_L_COLOR
	
	la $t7, L2_BLOCK
	beq $t3, $t7, set_L_COLOR
	
	la $t7, L3_BLOCK
	beq $t3, $t7, set_L_COLOR

	# for S block
	la $t7, S0_BLOCK
	beq $t3, $t7, set_S_COLOR

	la $t7, S1_BLOCK
	beq $t3, $t7, set_S_COLOR
	
	la $t7, S2_BLOCK
	beq $t3, $t7, set_S_COLOR
	
	la $t7, S3_BLOCK
	beq $t3, $t7, set_S_COLOR
	
	# for I block
	la $t7, I0_BLOCK
	beq $t3, $t7, set_I_COLOR
	
	la $t7, I1_BLOCK
	beq $t3, $t7, set_I_COLOR
	
	la $t7, I2_BLOCK
	beq $t3, $t7, set_I_COLOR
	
	la $t7, I3_BLOCK
	beq $t3, $t7, set_I_COLOR

	# for Z block
	la $t7, Z0_BLOCK
	beq $t3, $t7, set_Z_COLOR
	
	la $t7, Z1_BLOCK
	beq $t3, $t7, set_Z_COLOR
	
	la $t7, Z2_BLOCK
	beq $t3, $t7, set_Z_COLOR
	
	la $t7, Z3_BLOCK
	beq $t3, $t7, set_Z_COLOR
	
	# for O block
	la $t7, O0_BLOCK
	beq $t3, $t7, set_O_COLOR

	# for T block
	la $t7, T0_BLOCK
	beq $t3, $t7, set_T_COLOR
	
	la $t7, T1_BLOCK
	beq $t3, $t7, set_T_COLOR
	
	la $t7, T2_BLOCK
	beq $t3, $t7, set_T_COLOR
	
	la $t7, T3_BLOCK
	beq $t3, $t7, set_T_COLOR

	# t7 = byte located at current block address (i.e. 0 or 1)
	# t8 = start row + row_offset
	# t9 = start col + col_offset
	
	set_J_COLOR:
		li $t6, J_COLOUR
		j setup_draw_tet

	set_L_COLOR:
		li $t6, L_COLOUR
		j setup_draw_tet
		
	set_S_COLOR:
		li $t6, S_COLOUR
		j setup_draw_tet

	set_I_COLOR:
		li $t6, I_COLOUR
		j setup_draw_tet

	set_Z_COLOR:
		li $t6, Z_COLOUR
		j setup_draw_tet
		
	set_O_COLOR:
		li $t6, O_COLOUR
		j setup_draw_tet
		
	set_T_COLOR:
		li $t6, T_COLOUR
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
			sll $t0, $t0, 2
			#mul $t0, $t0, UNIT_SIZE
			# add to base display address
			la $t8, frame_buffer
			add $t0, $t0, $t8
			
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
		
draw_digit:
# a0 -- array of grid num to colour
# t0 -- score colour
# t1 -- address to check cur grid num
# t2 -- address in display to colour

li $t0, SCORE_COLOUR
# a0 is the digit's blocks as an array
move $t1, $a0 # address of offset to print into, increments by 4 to jump to each word

draw_digit_loop:
    # get grid num to print at found in arg array 
    lw $t2, 0($t1)

    # if arg number is -1, array is done so we are done printing this number
    beq $t2, -1, exit_draw_digit

    # otherwise, calc offset from display address
    # i.e. grid_num (t2) * 4 + display_address
    sll $t2, $t2, 2
    la $t3, frame_buffer
    add $t2, $t2, $t3
    
    # colour it in the display
    sw $t0, 0($t2)

    # move to next word in array by incrementing t1 by 4 
    addi $t1, $t1, 4
    
    j draw_digit_loop

exit_draw_digit:
	jr $ra

draw_held_tet:
	# held text is empty, i.e. 0
	beq $s7, 0, exit_draw_held_tet
	
	# call draw tet but place in hold area
	# set up to call draw_tet
	# move up a word to give space for the tet address
	addi $sp, $sp, -4
	sw $s7, 0($sp)
	
	# make room for row
	addi $sp, $sp, -4
	li $t0, -6
	sw $t0, 0($sp)
	
	# make room for column
	addi $sp, $sp, -4
	li $t1, 0
	sw $t1, 0($sp)
	
	j draw_tet # no jal bc i dont want ra to be updated
	
exit_draw_held_tet:
	jr $ra


copy_frame_buffer_to_display:
    la $t0, frame_buffer
    lw $t1, ADDR_DSPL
    li $t2, 0
    li $t3, 512  # size of frame buffer, used to check if finished copying

copy_loop:
    bge $t2, $t3, end_copy
    # copy word from frame buffer to display
    lw $t4, 0($t0)
    sw $t4, 0($t1)
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    addi $t2, $t2, 1
    j copy_loop

end_copy:
    jr $ra
