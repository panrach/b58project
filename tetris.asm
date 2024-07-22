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
    	base_address: .word 0x10008000   # Base address for the display
    	light: .word 0x808080            # Light color
    	dark: .word 0xA9A9A9             # Dark color
    	row_size: .word 128              # Number of rows
   	col_size: .word 64               # Number of columns
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
.text
    .globl main

main:
    	# Load dimensions and base address
    	lw $t0, base_address            # t0 = base_address
    	lw $t1, dark                    # t1 = dark color
    	lw $t2, light                   # t2 = light color
    	lw $t3, row_size           	# t3 = display width in pixels
    	lw $t4, col_size         	# t4 = display height in pixels
    	li $t8, 4			# t8 = pixel size (4 bytes)

    	# Initialize row count
    	li $t5, 0                       # t5 = cur_row = 0

outer_loop:
    	# Initialize column index to 0
    	li $t6, 0                      # t6 = cur_col = 0

inner_loop:
	#calculate the address of the current pixel
	
	# base + ((row index * number of columns) + column index) * pixel size 
    	# row index * number of columns
    	mul $t7, $t5, $t4
    	#(row index * num columns) + column index
    	add $t7, $t7, $t6
    	# t7 * pixel size
    	mul $t7, $t7, $t8
    	# add offset to base
    	add $t7, $t7, $t0
    	
    	sw $t1, 0($t7)                # Store dark color
    	j next_pixel                  # Jump to next pixel

next_pixel:
    	# Move to the next pixel
    	# increment column index
    	addi $t6, $t6, 1
    	blt $t6, $t4, inner_loop
    	
    	# increment row
    	addi $t5, $t5, 1
    	blt $t5, $t3, outer_loop

    	# Exit the program
    	li $v0, 10                    # Exit system call
    	syscall
game_loop:
	# 1a. Check if key has been pressed
    	# 1b. Check which key has been pressed
    	# 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    b game_loop
