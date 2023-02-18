@ Kevin Cruse
@ 3/1/22
@ kc0145@uah.edu
@ CS413-01 Spring 2022

@ Use these commands to assemble, link, run and debug this program:
@ as CruseLab4.s -o CruseLab4.o
@ gcc CruseLab4.o -o CruseLab4 || gcc -g CruseLab4.s -o CruseLab4 for debugging
@ ./CruseLab4
@ gdb --args ./CruseLab4

.text
.global main
.global printf
.global scanf

main:
    ADR r0, start + 1
    BX r0
    .thumb

start:
    MOV     r7, #48                     @ r7 <- 48
    LDR     r0, =welcomeInputPrompt     @ r0 <- address of string
    BL      printf
    LDR     r0, =welcomeInputPrompt2    @ r0 <- address of string
    BL      printf
    LDR     r0, =charInputPattern       @ r0 <- address of pattern
    LDR     r1, =charInput              @ r1 <- address of chatInput
    BL      scanf
    LDR     r1, =charInput
    LDR     r1, [r1]                    @ r1 <- value of r1 in ascii
    CMP     r1, #84                     @ Compare r1 to 84 ascii
    BEQ     exit                        @ If equal to T, exit
    LDR     r1, =charInput              @ r1 <- address of charInput
    LDR     r1, [r1]                    @ r1 <- value of r1
    CMP     r1, #66                     @ Compare r1 to 66 in ascii
    BEQ     loop                        @ If equal to B, branch to loop


loop:
    LDR     r0, =sizeInputPrompt        @ r0 <- address of string
    BL      printf
    LDR     r0, =sizeInputPrompt2       @ r0 <- address of string
    BL      printf
    LDR     r0, =numInputPattern        @ r0 <- address of pattern
    LDR     r1, =intInput               @ r1 <- address of intInput
    BL      scanf
    LDR     r1, =intInput               @ r1 <- address of intInput
    LDR     r1, [r1]                    @ r1 <- value of r1
    CMP     r1, #0                      @ If user selects any letter, turn off machine
    BEQ     exit
    CMP     r1, #10                     @ If user selects cup size higher than 10, branch to error
    BGT     error
    LDR     r0, =successMessage         @ r0 <- address of string
    BL      printf
    LDR     r0, =welcomeInputPrompt     @ r0 <- address of string
    BL      printf
    LDR     r1, =intInput
    LDR     r1, [r1]                    @ r1 <- value of r1
    SUB     r7, r7, r1                  @ Subtract users chosen cup size from the water reservoir. Serves as the loop counter
    LDR     r0, =statusMessage          @ r0 <- address of string
    CMP     r7, #6                      @ Check if the reservoir greater than or equal to 6 oz, if so print statusMessage
    BL      printf
    LDR     r0, =insertCupMessage       @ r0 <- address of string
    BL      printf
    CMP     r7, #6                      @ If reservoir is greater than or equal to 6 oz, loop
    BGE     loop
    LDR     r0, =refillMessage          @ r0 <- address of string
    BL      printf
    CMP     r7, #6                      @ Check if reservoir is less than 6 oz, if yes exit
    BLT     exit

error:
    LDR     r0, =errorMessage           @ r0 <- adress of string
    BL      printf
    B       loop                        @ Branch to loop unconditionally

exit:
    MOV     r7, #0X01
    SVC     0

.data

.balign 4
welcomeInputPrompt: .asciz "Welcome to the Coffee Maker!\nInsert K-cup and press B to begin making coffee.\nPress T to turn off the machine.\n\n"
.balign 4
welcomeInputPrompt2: .asciz "Enter B to brew or T to turn off machine: "
.balign 4
sizeInputPrompt: .asciz "\nSelect the cup size\n\nEnter 6 for Small (6 oz)\nEnter 8 for Medium (8 oz)\nEnter 10 for Large (10 oz)\n\n"
.balign 4
sizeInputPrompt2: .asciz "Enter either 6, 8, or 10: "
.balign 4
successMessage: .asciz "Success! Enjoy your cup.\n\n"
.balign 4
statusMessage: .asciz "Ready to brew\n\n"
.balign 4
insertCupMessage: .asciz "Place a cup into the tray\n\n"
.balign 4
refillMessage: .asciz "Refill the reservoir\n"
.balign 4
errorMessage: .asciz "This brewer only supprorts 6, 8, or 10 oz cup sizes\n\n"
.balign 4
hiddenMessage: .asciz "Water remaining: %d\n"
.balign 4
numInputPattern: .asciz "%d"
.balign 4
charInputPattern: .asciz "%c"
.balign 4
charInput: .word 0
.balign 4
intInput: .word 0
