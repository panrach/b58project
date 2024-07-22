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
    	lw $t3, row_size          # t3 = display width in pixels
    	lw $t4, col_size         # t4 = display height in pixels

    	# Initialize row count
    	li $t5, 0                       # t5 = cur_row = 0

outer_loop:
    	# Calculate row start address
    	mul $t6, $t5, $t3              # t6 = cur_row * display_width ( the current number of pixels from start to current row)
    	sll $t6, $t6, 2                # t6 = cur_row * display_width * 4 (byte offset)
    	add $t6, $t6, $t0              # t6 = base_address + offset

    	# Initialize column index to 0
    	li $t7, 0                      # t7 = cur_col = 0

inner_loop:
    	# Determine color for the current position
    	# row and col same parity: dark, different parity: light
	# t8 = cur_row % 2 (0 if even, 1 if odd)
    	# t9 = cur_col % 2 (0 if even, 1 if odd)
    	# result = (cur_row % 2) XOR (cur_col % 2)
    	beq $t8, $zero, use_dark     # If result is 0, use dark color
    	sw $t2, 0($t6)                # Store light color
    	j next_pixel                  # Jump to next pixel

use_dark:
   	sw $t1, 0($t6)                # Store dark color

next_pixel:
    	# Move to the next pixel
    	addi $t6, $t6, 4              # Move to the next pixel (4 bytes)
    	addi $t7, $t7, 1              # Increment column index
    	blt $t7, $t3, inner_loop      # Continue with the next column if cur_col < display_width

    	# Move to the next row
    	addi $t5, $t5, 1              # Increment row index
    	blt $t5, $t4, outer_loop      # Continue with the next row if cur_row < display_height

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
