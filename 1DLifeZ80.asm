; ============================================================
; 1D Life
; Tatung Einstein - Z80 assembly
;
; Origin: 0100H
; Display width: 39 characters
; Generations: 26
;
; Einstein character output:
; RST 8 / DEFB 158
; ============================================================

        ORG     0100H

START:
        CALL    INIT_RNG
        LD HL, START_MESSAGE_TEXT
        
START_MESSAGE:                
        LD A, (HL)
        CP 0
        JR Z,END_OF_MESSAGE
        CALL PRINT_CHAR
        INC HL
        JR START_MESSAGE

 END_OF_MESSAGE:
        RST     08H             ; Call MS to read key
        DEFB    156            	; ZINC (0x9D) - Wait for key press & return ASCII in A   
        CALL 	NEW_LINE
        
MAIN_LOOP:
	LD      B,39		;used by DJNZ 
	LD      HL,DATA_X+38
	
SEED_DATA:
	CALL GET_RANDOM
	CP 128
	JR C,SET_STAR	
	LD A,' '
	JP STORE_VALUE
	
SET_STAR:
	LD A,'*'
	
STORE_VALUE:
	CALL PRINT_CHAR
	LD (HL),A		;store A in DATA_X (pointed to by HL)
	DEC HL
	DJNZ SEED_DATA
	
;GEN_COUNT holds the current generation number from 26 down to 0
;B holds the current cell we are looking at
;IX is pointer to DATA_X position
;IY is pointer to DATA_Y position	

	;set values for 26 loops	
	LD A,26
	LD (GEN_COUNT), A	

GENERATION_LOOP:
	;step through each cell and check for neighbours
	LD IX,DATA_X+37
	LD IY,DATA_Y+37
	LD B,35		;only got from 37 down to 3
	
CELL:
	LD C, 0
	LD A,(IX+2)
	CP '*'
	JR NZ,I_PLUS_ONE;NZ for not zero, so not a star so don't increase the C value
	INC C		;increase number of live neighbours
	
I_PLUS_ONE:
	LD A,(IX+1)
	CP '*'
	JR NZ,I_MINUS_ONE;NZ for not zero
	INC C		;increase number of live neighbours
	
I_MINUS_ONE:
	LD A,(IX-1)
	CP '*'
	JR NZ,I_MINUS_TWO;NZ for not zero
	INC C		;increase score	
		
I_MINUS_TWO:
	LD A,(IX-2)
	CP '*'
	JR NZ,CURRENT_CELL;NZ for not zero
	INC C		;increase number of live neighbours

CURRENT_CELL:
	LD A,(IX+0)
	CP '*'
	JR Z,CURRENTLY_STAR	;Z for zero so is a match so don't increment C
	
CURRENTLY_BLANK:
	;spawn new life if 2 or 3 neighbours
	LD A,C
	CP 2
	JP Z,SET_Y_STAR
	CP 3
	JP Z,SET_Y_STAR	
	JP SET_Y_BLANK
	
CURRENTLY_STAR:
	;spawn new life if 2 or 4 neighbours
	LD A,C
	CP 2
	JP Z,SET_Y_STAR
	CP 4
	JP Z,SET_Y_STAR
	
SET_Y_BLANK:
	LD A,' '
	JP STORE_LIFE_VALUE
	
SET_Y_STAR:	
	LD A,'*'
	
STORE_LIFE_VALUE:
	;place value in DATA_Y
	LD (IY+0), A
	DEC IX
	DEC IY
	DJNZ CELL	;repeat for rest of cells
	
	;prep the next section
	;load DATA into registers to allow easy access to data 
	LD HL,DATA_Y
        LD DE,DATA_X
	LD BC,39	;set number of characters to print
	CALL NEW_LINE	
	
DRAW_GENERATION:
	;draw the 40 characters and move Y to X
        LD      A,(HL)
        LD      (DE),A
        CALL    PRINT_CHAR
        INC     HL
        INC     DE
        DEC     BC
        LD      A,B
        OR      C
        JR      NZ,DRAW_GENERATION	

END_OF_GENERATION_LOOP:
	LD A, (GEN_COUNT)
	DEC A
	LD (GEN_COUNT), A
	JR NZ, GENERATION_LOOP
	LD A,13
	CALL PRINT_CHAR
	JP      MAIN_LOOP

; ============================================================
; Write character to screen, store and retrieve all registers
; ============================================================

PRINT_CHAR:
        PUSH    AF
        PUSH    BC
        PUSH    DE
        PUSH    HL
        PUSH    IX
        PUSH    IY
        RST     8
        DEFB    158
        POP     IY
        POP     IX
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        RET

; ============================================================
; New line, chr 13 plus chr 10
; ============================================================

NEW_LINE:
        LD      A,13
        CALL    PRINT_CHAR
        LD      A,10
        CALL    PRINT_CHAR
        RET

; ============================================================
; RANDOM NUMBER GENERATOR
; ============================================================

INIT_RNG:
        LD      A,R
        OR      A
        JR      NZ,STORE_SEED
        LD      A,055H

STORE_SEED:
        LD      (SEED),A
        RET

GET_RANDOM:
        LD      A,(SEED)
        SRL     A
        JR      NC,NO_TAP
        XOR     0B8H

NO_TAP:
        LD      (SEED),A
        RET        
        
; ============================================================
; DATA
; ============================================================

SEED:
        DEFB    055H

GEN_COUNT:
        DEFB    0

DATA_X:
        DEFS    40,32	;40 space characters

DATA_Y:
        DEFS    40,32	;40 space characters
        
START_MESSAGE_TEXT:
	DEFB '--- Press Any Key To Start ---',0
	
        END
