##############################################################################
# Example: Displaying Pixels
#
# This file demonstrates how to draw pixels with different colours to the
# bitmap display.
##############################################################################

######################## Bitmap Display Configuration ########################
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
##############################################################################
.data
    	base_address: .word 0x10008000   # Base address for the display
    	light: .word 0x808080            # Light color
    	dark: .word 0xA9A9A9             # Dark color
    	row_size: .word 64               # Number of rows
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
    	lw $t3, row_size           	# t3 = display width in units
    	lw $t4, col_size         	# t4 = display height in units

    	# Initialize row count
    	li $t5, 0                       # t5 = cur_row = 0

draw_background:


outer_loop:
    	# Initialize column index to 0
    	li $t6, 0                      # t6 = cur_col = 0

inner_loop:
	#calculate the address of the current pixel
	li $t8, 4			# t8 = pixel size (4 bytes)
	# base + ((row index * number of columns) + column index) * pixel size 
    	# row index * number of columns
    	mul $t7, $t5, $t4
    	#(row index * num columns) + column index
    	add $t7, $t7, $t6
    	# t7 * pixel size
    	mul $t7, $t7, $t8
    	# add offset to base
    	add $t7, $t7, $t0
    	
    	# t5 cur row, t6 cur col
    	# t8 0 if even, 1 otherwise
    	add $t8, $t5, $t6
    	andi $t8, $t8, 1
    	
    	# else even, light
    	sw $t2, 0($t7)
    	j next_unit
    	
    	
    	
    	#sw $t1, 0($t7)                # Store dark color
    	#j next_unit                  # Jump to next pixel

next_unit:
    	# Move to the next unit
    	# increment column index
    	addi $t6, $t6, 1
    	# if the column index is less than the column size, then continue
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
