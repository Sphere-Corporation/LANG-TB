; ETA-3400 Tiny BASIC ROM.
;
; Generated by disassembling ROM image using the f9dasm program.
; Adapted to the crasm assembler. I have confirmed that it produces
; the same binary output as the Heathkit ROMs.
;
; Tiny BASIC was implemented as a (target dependent) virtual machine
; running a (portable) interpreted language. The disassembled source
; code here does not reflect this and is not particularly meaningful
; (e.g. many of the instructions are actually data). Apparently the
; original source for the 6800 version of Tiny BASIC has been
; lost. Some of the source has been reverse engineered using the
; source code for the 6502 version of Tiny BASIC.
;
; See:
;   http://www.ittybittycomputers.com/IttyBitty/TinyBasic
;   https://github.com/Arakula/f9dasm
;   https://github.com/colinbourassa/crasm
;
; Jeff Tranter <tranter@pobox.com>

; LOCATION   SIGNIFICANCE
; 0000-000F  Not used by Tiny BASIC.
; 0010-001F  Temporaries.
; 0020-0021  Lowest address of user program space.
; 0022-0023  Highest address of user program space.
; 0024-0025  Program end + stack reserve.
; 0026-0027  Top of GOSUB stack.
; 0028-002F  Interpreter parameters.
; 0030-007F  Input line buffer and Computation stack.
; 0080-0081  Random Number generator workspace.
; 0082-00B5  Variables A,B,...Z.
; 00B6-00C7  Interpreter temporaries.
; 0100-0FFF  Tiny BASIC user program space.

; 1C00       Cold start entry point.
; 1C03       Warm start entry point.
; 1C06       Character input routine.
; 1C09       Character output routine.
; 1C0C       Break test.
; 1C0F       Backspace code.
; 1C10       Line cancel code.
; 1C11       Pad character.
; 1C12       Tape mode enable flag. (HEX 80 = enabled)
; 1C13       Spare stack size.
; 1C14       Subroutine (PEEK) to read one byte from RAM to B and A.
;            (address in X)
; 1C18       Subroutine (POKE) to store A and B into RAM at address X.

        .CR 6800               ; LOAD MC6800 CROSS OVERLAY
        .TF tb.exe,BIN         ; OUTPUT FILE IN BINARY FORMAT
        .OR $0200              ; START OF ASSEMBLY ADDRESS
        .LI OFF                ; SWITCH OFF ASSEMBLY LISTING (EXCEPT ERRORS)
        .SF SYMBOLS.SYM        ; CREATE SYMBOL FILE


;****************************************************
;* Used Labels                                      *
;****************************************************

M0020   .EQU     $0020
M0021   .EQU     $0021
M0022   .EQU     $0022
M0024   .EQU     $0024
M0025   .EQU     $0025
M0026   .EQU     $0026
M0027   .EQU     $0027
M0028   .EQU     $0028
M0029   .EQU     $0029
M002A   .EQU     $002A
M002B   .EQU     $002B
M002C   .EQU     $002C
M002D   .EQU     $002D
M002E   .EQU     $002E
M002F   .EQU     $002F
M0030   .EQU     $0030
M0080   .EQU     $0080
M0099   .EQU     $0099
M00B6   .EQU     $00B6
M00B7   .EQU     $00B7
M00B8   .EQU     $00B8
M00B9   .EQU     $00B9
M00BA   .EQU     $00BA
M00BC   .EQU     $00BC
M00BD   .EQU     $00BD
M00BE   .EQU     $00BE
M00BF   .EQU     $00BF
M00C0   .EQU     $00C0
M00C1   .EQU     $00C1
M00C2   .EQU     $00C2
M00C3   .EQU     $00C3
M00C4   .EQU     $00C4
M0100   .EQU     $0100
MAIN    .EQU     $1400
OUTIS   .EQU     $1618
M1CFF   .EQU     $1CFF
SNDCHR  .EQU     $1865
RCCHR   .EQU     $18E1
FTOP    .EQU     $1A80
BREAK   .EQU     $1B1F
L1B2D   .EQU     $1B2D
L1B38   .EQU     $1B38

;****************************************************
;* Program Code / Data Areas                        *
;****************************************************

        * =     $1C00

CV      JMP     COLD_S          ; Cold start vector
WV      JMP     WARM_S          ; Warm start vector
L1C06   JMP     RCCHR           ; Input routine address
L1C09   JMP     SNDCHR          ; Output routine address
L1C0C   JMP     BREAK           ; Begin break routine

;
; Some codes
;
BSC     .DB     $08             ; Backspace code
LSC     .DB     $15             ; Line cancel code
PCC     .DB     $83             ; Pad character
TMC     .DB     $80             ; Tape mode control
M1C13   .DB     $20             ; Spare Stack size.
;
; Code fragment for 'PEEK' and 'POKE'
;
PEEK    LDAA    0,X
        CLRB
M1C17   RTS

POKE    STAA    0,X
        RTS
;
; The following table contains the addresses for the ML handlers for the IL opcodes.
;
SRVT    .DW      IL_BBR                ; ($40-$5F) Backward Branch Relative
        .DW      IL_FBR                ; ($60-$7F) Forward Branch Relative
        .DW      IL__BC                ; ($80-$9F) String Match Branch
        .DW      IL__BV                ; ($A0-$BF) Branch if not Variable
        .DW      IL__BN                ; ($C0-$DF) Branch if not a Number
        .DW      IL__BE                ; ($E0-$FF) Branch if not End of line
        .DW      IL__NO                ; ($08) No Operation
        .DW      IL__LB                ; ($09) Push Literal Byte onto Stack
        .DW      IL__LN                ; ($0A) Push Literal Number
        .DW      IL__DS                ; ($0B) Duplicate Top two bytes on Stack
        .DW      IL__SP                ; ($0C) Stack Pop
;       .DW       IL__NO               ; ($0D) (Reserved)
        .DW      L1CA9
;       .DW       IL__NO               ; ($0E) (Reserved)
        .DW      L1C77
;       .DW       IL__NO               ; ($0F) (Reserved)
        .DW      L1C80
;       .DW       IL__SB               ; ($10) Save Basic Pointer
        .DW      L1FAB
;       .DW       IL__RB               ; ($11) Restore Basic Pointer
        .DW      L1FB0
;       .DW       IL__FV               ; ($12) Fetch Variable
        .DW      L1F00
;       .DW       IL__SV               ; ($13) Store Variable
        .DW      L1F10
;       .DW       IL__GS               ; ($14) Save GOSUB line
        .DW      L1FCE
;       .DW       IL__RS               ; ($15) Restore saved line
        .DW      L1F99
;       .DW       IL__GO               ; ($16) GOTO
        .DW      L1F8E
;       .DW       IL__NE               ; ($17) Negate
        .DW      L1EC2
;       .DW       IL__AD               ; ($18) Add
        .DW      L1ECF
;       .DW       IL__SU               ; ($19) Subtract
        .DW      L1ECD
;       .DW       IL__MP               ; ($1A) Multiply
        .DW      L1EE5
;       .DW       IL__DV               ; ($1B) Divide
        .DW      L1E6B
;       .DW       IL__CP               ; ($1C) Compare
        .DW      L1F23
;       .DW       IL__NX               ; ($1D) Next BASIC statement
        .DW      L1F49
;       .DW       IL__NO               ; ($1E) (Reserved)
        .DW      IL__NO
;       .DW       IL__LS               ; ($1F) List the program
        .DW      L20D7
;       .DW       IL__PN               ; ($20) Print Number
        .DW      L2045
;       .DW       IL__PQ               ; ($21) Print BASIC string
        .DW      L20BA
;       .DW       IL__PT               ; ($22) Print Tab
        .DW      L20C2
;       .DW       IL__NL               ; ($23) New Line
        .DW      Z2128
;       .DW       IL__PC               ; ($24) Print Literal String
        .DW      Z20AD
;       .DW       IL__NO               ; ($25) (Reserved)
        .DW      L20CB
;       .DW       IL__NO               ; ($26) (Reserved)
        .DW      MAIN
;       .DW       IL__GL               ; ($27) Get input Line
        .DW      L2159
;       .DW       ILRES1               ; ($28) (Seems to be reserved - No IL opcode calls this)
        .DW      L1B2D
;       .DW       ILRES2               ; ($29) (Seems to be reserved - No IL opcode calls this)
        .DW      L1B38
;       .DW       IL__IL               ; ($2A) Insert BASIC Line
        .DW      L21B1
;       .DW       IL__MT               ; ($2B) Mark the BASIC program space Empty
        .DW      L1D12
;       .DW       IL__XQ               ; ($2C) Execute
        .DW      L1F7E
;       .DW       WARM_S               ; ($2D) Stop (Warm Start)
        .DW      WARM_S
;       .DW       IL__US               ; ($2E) Machine Language Subroutine Call
        .DW      L1CB9
;       .DW       IL__RT               ; ($2F) IL subroutine return
        .DW      L1FA6

;
; Begin Cold Start
;
; Load start of free ram ($0200) into locations $20 and $21
; and initialize the address for end of free ram ($22 & $23)
;

L1C77   BSR     IL__SP
        STAA    M00BC
        STAB    M00BD
        JMP     L1FD7
L1C80   JSR     L1FFC
        LDAA    M00BC
        LDAB    M00BD
        BRA     L1C8D
IL__DS  BSR     IL__SP
        BSR     L1C8D
L1C8D   LDX     M00C2
        DEX
        STAB    0,X
        BRA     L1C96
L1C94   LDX     M00C2
L1C96   DEX
        STAA    0,X
        STX     M00C2
        PSHA
        LDAA    M00C1
        CMPA    M00C3
        PULA
        BCS     IL__NO
L1CA3   JMP     L1D5C
IL__SP  BSR     L1CA9
        TBA
L1CA9   LDAB    #1
L1CAB   ADDB    M00C3
        CMPB    #$80
        BHI     L1CA3
        LDX     M00C2
        INC     M00C3
        LDAB    0,X
        RTS
L1CB9   BSR     L1CC0
        BSR     L1C94
        TBA
        BRA     L1C94
L1CC0   LDAA    #6
        TAB
        ADDA    M00C3
        CMPA    #$80
        BHI     L1CA3
        LDX     M00C2
        STAA    M00C3
L1CCD   LDAA    $05,X
        PSHA
        DEX
        DECB
        BNE     L1CCD
        TPA
        PSHA
        RTI
IL__LB  BSR     L1CF5
        BRA     L1C94
IL__LN  BSR     L1CF5
        PSHA
        BSR     L1CF5
        TAB
        PULA
        BRA     L1C8D
L1CE4   ADDA    M00C3
        STAA    M00BD
        CLR     M00BC
        BSR     L1CA9
        LDX     M00BC
        LDAA    0,X
        STAB    0,X
        BRA     L1C94
L1CF5   LDX     M002A
        LDAA    0,X
        INX
        STX     M002A
IL__NO  TSTA
        RTS
M1CFE   .DW      ILTBL
COLD_S  LDX     #M0100
        STX     M0020
        JSR     FTOP
        STX     M0022
        JSR     OUTIS
        ;ASC     "HTB1\0"
L1D12   LDAA    M0020
        LDAB    M0021
L1D16   ADDB    M1C13
        ADCA    #0
        STAA    M0024
        STAB    M0025
        LDX     M0020
        CLR     0,X
        CLR     $01,X
WARM_S  LDS     M0022
L1D27   JSR     L212C
L1D2A   LDX     M1CFE
        STX     M002A
        LDX     #M0080
        STX     M00C2
        LDX     #M0030
        STX     M00C0
L1D39   STS     M0026
L1D3B   BSR     L1CF5
        BSR     L1D46
        BRA     L1D3B
        CPX     #M0099
        BRA     L1D39
L1D46   LDX     #M1C17
        STX     M00BC
        CMPA    #$30
        BCC     L1DA5
        CMPA    #8
        BCS     L1CE4
        ASLA
        STAA    M00BD
        LDX     M00BC
        LDX     $17,X
        JMP     0,X
L1D5C   JSR     L212C
        LDAA    #$21
        STAA    M00C1
        JSR     L1C09
        LDAA    #$80
        STAA    M00C3
        LDAB    M002B
        LDAA    M002A
        SUBB    M1CFF
        SBCA    M1CFE
        JSR     Z2042
        LDAA    M00C0
        BEQ     L1D8A
        LDX     #M1D93
        STX     M002A
        JSR     Z20AD
        LDAA    M0028
        LDAB    M0029
        JSR     Z2042
L1D8A   LDAA    #7
        JSR     L1C09
        LDS     M0026
        BRA     L1D27
M1D93   BRA     L1DD5+1
        LSRB
        BRA     L1D16+2
IL_BBR  DEC     M00BC
IL_FBR  TST     M00BC
        BEQ     L1D5C
L1DA0   LDX     M00BC
        STX     M002A
        RTS
L1DA5   CMPA    #$40
        BCC     L1DCC
        PSHA
        JSR     L1CF5
        ADDA    M1CFF
        STAA    M00BD
        PULA
        TAB
        ANDA    #7
        ADCA    M1CFE
        STAA    M00BC
        ANDB    #8
        BNE     L1DA0
        LDX     M002A
        STAA    M002A
        LDAB    M00BD
        STAB    M002B
        STX     M00BC
        JMP     L1FD7
L1DCC   TAB
        LSRA
        LSRA
        LSRA
        LSRA
        ANDA    #$0E
        STAA    M00BD
L1DD5   LDX     M00BC
        LDX     $17,X
        CLRA
        CMPB    #$60
        ANDB    #$1F
        BCC     L1DE2
        ORAB    #$E0
L1DE2   BEQ     L1DEA
        ADDB    M002B
        STAB    M00BD
        ADCA    M002A
L1DEA   STAA    M00BC
        JMP     0,X
IL__BC  LDX     M002C
        STX     M00B8
L1DF2   BSR     L1E2A
        BSR     L1E20
        TAB
        JSR     L1CF5
        BPL     L1DFE
        ORAB    #$80
L1DFE   CBA
        BNE     L1E05
        TSTA
        BPL     L1DF2
        RTS
L1E05   LDX     M00B8
        STX     M002C
L1E09   BRA     IL_FBR
IL__BE  BSR     L1E2A
        CMPA    #$0D
        BNE     L1E09
        RTS
IL__BV  BSR     L1E2A
        CMPA    #$5A
        BGT     L1E09
        CMPA    #$41
        BLT     L1E09
        ASLA
        JSR     L1C94
L1E20   LDX     M002C
        LDAA    0,X
        INX
        STX     M002C
        CMPA    #$0D
        RTS
L1E2A   BSR     L1E20
        CMPA    #$20
        BEQ     L1E2A
        DEX
        STX     M002C
        CMPA    #$30
        CLC
        BLT     L1E3A
        CMPA    #$3A
L1E3A   RTS
IL__BN  BSR     L1E2A
        BCC     L1E09
        LDX     #0
        STX     M00BC
L1E44   BSR     L1E20
        PSHA
        LDAA    M00BC
        LDAB    M00BD
        ASLB
        ROLA
        ASLB
        ROLA
        ADDB    M00BD
        ADCA    M00BC
        ASLB
        ROLA
        STAB    M00BD
        PULB
        ANDB    #$0F
        ADDB    M00BD
        ADCA    #0
        STAA    M00BC
        STAB    M00BD
        BSR     L1E2A
        BCS     L1E44
        LDAA    M00BC
        JMP     L1C8D
L1E6B   BSR     L1EE0
        LDAA    $02,X
        ASRA
        ROLA
        SBCA    $02,X
        STAA    M00BC
        STAA    M00BD
        TAB
        ADDB    $03,X
        STAB    $03,X
        TAB
        ADCB    $02,X
        STAB    $02,X
        EORA    0,X
        STAA    M00BE
        BPL     L1E89
        BSR     L1EC4
L1E89   LDAB    #$11
        LDAA    0,X
        ORAA    $01,X
        BNE     L1E94
        JMP     L1D5C
L1E94   LDAA    M00BD
        SUBA    $01,X
        PSHA
        LDAA    M00BC
        SBCA    0,X
        PSHA
        EORA    M00BC
        BMI     L1EAB
        PULA
        STAA    M00BC
        PULA
        STAA    M00BD
        SEC
        BRA     L1EAE
L1EAB   PULA
        PULA
        CLC
L1EAE   ROL     $03,X
        ROL     $02,X
        ROL     M00BD
        ROL     M00BC
        DECB
        BNE     L1E94
        BSR     L1EDD
        TST     M00BE
        BPL     L1ECC
L1EC2   LDX     M00C2
L1EC4   NEG     $01,X
        BNE     L1ECA
        DEC     0,X
L1ECA   COM     0,X
L1ECC   RTS
L1ECD   BSR     L1EC2
L1ECF   BSR     L1EE0
        LDAB    $03,X
        ADDB    $01,X
        LDAA    $02,X
        ADCA    0,X
L1ED9   STAA    $02,X
        STAB    $03,X
L1EDD   JMP     L1CA9
L1EE0   LDAB    #4
L1EE2   JMP     L1CAB
L1EE5   BSR     L1EE0
        LDAA    #$10
        STAA    M00BC
        CLRA
        CLRB
L1EED   ASLB
        ROLA
        ASL     $01,X
        ROL     0,X
        BCC     L1EF9
        ADDB    $03,X
        ADCA    $02,X
L1EF9   DEC     M00BC
        BNE     L1EED
        BRA     L1ED9
L1F00   BSR     L1EDD
        STAB    M00BD
        CLR     M00BC
        LDX     M00BC
        LDAA    0,X
        LDAB    $01,X
        JMP     L1C8D
L1F10   LDAB    #3
        BSR     L1EE2
        LDAB    $01,X
        CLR     $01,X
        LDAA    0,X
        LDX     $01,X
        STAA    0,X
        STAB    $01,X
L1F20   JMP     IL__SP
L1F23   BSR     L1F20
        PSHB
        LDAB    #3
        BSR     L1EE2
        INC     M00C3
        INC     M00C3
        PULB
        SUBB    $02,X
        SBCA    $01,X
        BGT     L1F42
        BLT     L1F3E
        TSTB
        BEQ     L1F40
        BRA     L1F42
L1F3E   ASR     0,X
L1F40   ASR     0,X
L1F42   ASR     0,X
        BCC     L1F61
        JMP     L1CF5
L1F49   LDAA    M00C0
        BEQ     L1F6A
L1F4D   JSR     L1E20
        BNE     L1F4D
        BSR     L1F71
        BEQ     L1F67
L1F56   BSR     L1F8A
        JSR     L1C0C
        BCS     L1F62
        LDX     M00C4
        STX     M002A
L1F61   RTS
L1F62   LDX     M1CFE
        STX     M002A
L1F67   JMP     L1D5C
L1F6A   LDS     M0026
        STAA    M00BF
        JMP     L1D2A
L1F71   JSR     L1E20
        STAA    M0028
        JSR     L1E20
        STAA    M0029
        LDX     M0028
        RTS
L1F7E   LDX     M0020
        STX     M002C
        BSR     L1F71
        BEQ     L1F67
        LDX     M002A
        STX     M00C4
L1F8A   TPA
        STAA    M00C0
        RTS
L1F8E   JSR     Z201A
        BEQ     L1F56
L1F93   LDX     M00BC
        STX     M0028
        BRA     L1F67
L1F99   BSR     L1FFC
        TSX
        INC     $01,X
        INC     $01,X
        JSR     Z2025
        BNE     L1F93
        RTS
L1FA6   BSR     L1FFC
        STX     M002A
        RTS
L1FAB   LDX     #M002C
        BRA     L1FB3
L1FB0   LDX     #M002E
L1FB3   LDAA    $01,X
        CMPA    #$80
        BCC     L1FC1
        LDAA    0,X
        BNE     L1FC1
        LDX     M002C
        BRA     MDB
L1FC1   LDX     M002C
        LDAA    M002E
        STAA    M002C
        LDAA    M002F
        STAA    M002D
MDB     STX     M002E
        RTS
L1FCE   TSX
        INC     $01,X
        INC     $01,X
        LDX     M0028
        STX     M00BC
L1FD7   DES
        DES
        TSX
        LDAA    $02,X
        STAA    0,X
        LDAA    $03,X
        STAA    $01,X
        LDAA    M00BC
        STAA    $02,X
        LDAA    M00BD
        STAA    $03,X
        LDX     #M0024
        STS     M00BC
        LDAA    $01,X
        SUBA    M00BD
        LDAA    0,X
        SBCA    M00BC
        BCS     Z2019
L1FF9   JMP     L1D5C
L1FFC   TSX
        INX
        INX
        INX
        CPX     M0022
        BEQ     L1FF9
        LDX     $01,X
        STX     M00BC
        TSX
        PSHB
        LDAB    #4
Z200C   LDAA    $03,X
        STAA    $05,X
        DEX
        DECB
        BNE     Z200C
        PULB
        INS
        INS
        LDX     M00BC
Z2019   RTS
Z201A   JSR     IL__SP
        STAB    M00BD
        STAA    M00BC
        ORAA    M00BD
        BEQ     L1FF9
Z2025   LDX     M0020
        STX     M002C
Z2029   JSR     L1F71
        BEQ     Z203F
        LDAB    M0029
        LDAA    M0028
        SUBB    M00BD
        SBCA    M00BC
        BCC     Z203F
Z2038   JSR     L1E20
        BNE     Z2038
        BRA     Z2029
Z203F   CPX     M00BC
        RTS
Z2042   JSR     L1C8D
L2045   LDX     M00C2
        TST     0,X
        BPL     Z2052
        JSR     L1EC2
        LDAA    #$2D
        BSR     Z2098
Z2052   CLRA
        PSHA
        LDAB    #$0F
        LDAA    #$1A
        PSHA
        PSHB
        PSHA
        PSHB
        JSR     IL__SP
        TSX
Z2060   INC     0,X
        SUBB    #$10
        SBCA    #$27
        BCC     Z2060
Z2068   DEC     $01,X
        ADDB    #$E8
        ADCA    #3
        BCC     Z2068
Z2070   INC     $02,X
        SUBB    #$64
        SBCA    #0
        BCC     Z2070
Z2078   DEC     $03,X
        ADDB    #$0A
        BCC     Z2078
        CLR     M00BE
Z2081   PULA
        TSTA
        BEQ     Z2089
        BSR     Z208A
        BRA     Z2081
Z2089   TBA
Z208A   CMPA    #$10
        BNE     Z2093
        TST     M00BE
        BEQ     Z20AA
Z2093   INC     M00BE
        ORAA    #$30
Z2098   INC     M00BF
        BMI     Z20A7
        STX     M00BA
        PSHB
        JSR     L1C09
        PULB
        LDX     M00BA
        RTS
Z20A7   DEC     M00BF
Z20AA   RTS
Z20AB   BSR     Z2098
Z20AD   JSR     L1CF5
        BPL     Z20AB
        BRA     Z2098
Z20B4   CMPA    #$22
        BEQ     Z20AA
        BSR     Z2098
L20BA   JSR     L1E20
        BNE     Z20B4
        JMP     L1D5C
L20C2   LDAB    M00BF
        BMI     Z20AA
        ORAB    #$F8
        NEGB
        BRA     Z20CE
L20CB   JSR     IL__SP
Z20CE   DECB
        BLT     Z20AA
        LDAA    #$20
        BSR     Z2098
        BRA     Z20CE
L20D7   LDX     M002C
        STX     M00B8
        LDX     M0020
        STX     M002C
        LDX     M0024
        BSR     Z210F
        BEQ     Z20E7
        BSR     Z210F
Z20E7   LDAA    M002C
        LDAB    M002D
        SUBB    M00B7
        SBCA    M00B6
        BCC     Z2123
        JSR     L1F71
        BEQ     Z2123
        LDAA    M0028
        LDAB    M0029
        JSR     Z2042
        LDAA    #$20
Z20FF   BSR     Z214C
        JSR     L1C0C
        BCS     Z2123
        JSR     L1E20
        BNE     Z20FF
        BSR     Z2128
        BRA     Z20E7
Z210F   INX
        STX     M00B6
        LDX     M00C2
        CPX     #M0080
        BEQ     Z2122
        JSR     Z201A
Z211C   LDX     M002C
        DEX
        DEX
        STX     M002C
Z2122   RTS
Z2123   LDX     M00B8
        STX     M002C
        RTS
Z2128   LDAA    M00BF
        BMI     Z2122
L212C   LDAA    #$0D
        BSR     Z2149
        LDAB    PCC
        ASLB
        BEQ     Z213E
Z2136   PSHB
        BSR     Z2142
        PULB
        DECB
        DECB
        BNE     Z2136
Z213E   LDAA    #$0A
        BSR     Z214C
Z2142   CLRA
        TST     PCC
        BPL     Z2149
        COMA
Z2149   CLR     M00BF
Z214C   JMP     Z2098
Z214F   LDAA    TMC
        BRA     Z2155
Z2154   CLRA
Z2155   STAA    M00BF
        BRA     Z2163
L2159   LDX     #M0030
        STX     M002C
        STX     M00BC
        JSR     L1C8D
Z2163   EORA    M0080
        STAA    M0080
        JSR     L1C06
        ANDA    #$7F
        BEQ     Z2163
        CMPA    #$7F
        BEQ     Z2163
        CMPA    #$0A
        BEQ     Z214F
        CMPA    #$13
        BEQ     Z2154
        LDX     M00BC
        CMPA    LSC
        BEQ     Z218B
        CMPA    BSC
        BNE     Z2192
        CPX     #M0030
        BNE     Z21A0
Z218B   LDX     M002C
        LDAA    #$0D
        CLR     M00BF
Z2192   CPX     M00C2
        BNE     Z219C
        LDAA    #7
        BSR     Z214C
        BRA     Z2163
Z219C   STAA    0,X
        INX
        INX
Z21A0   DEX
        STX     M00BC
        CMPA    #$0D
        BNE     Z2163
        JSR     Z2128
        LDAA    M00BD
        STAA    M00C1
        JMP     IL__SP
L21B1   JSR     L1FC1
        JSR     Z201A
        TPA
        JSR     Z211C
        STX     M00B8
        LDX     M00BC
        STX     M00B6
        CLRB
        TAP
        BNE     Z21D0
        JSR     L1F71
        LDAB    #$FE
Z21CA   DECB
        JSR     L1E20
        BNE     Z21CA
Z21D0   LDX     #0
        STX     M0028
        JSR     L1FC1
        LDAA    #$0D
        LDX     M002C
        CMPA    0,X
        BEQ     Z21EC
        ADDB    #3
Z21E2   INCB
        INX
        CMPA    0,X
        BNE     Z21E2
        LDX     M00B6
        STX     M0028
Z21EC   LDX     M00B8
        STX     M00BC
        TSTB
        BEQ     Z2248
        BPL     Z2218
        LDAA    M002F
        ABA
        STAA    M00B9
        LDAA    M002E
        ADCA    #$FF
        STAA    M00B8
Z2200   LDX     M002E
        LDAB    0,X
        CPX     M0024
        BEQ     Z2244
        CPX     M0026
        BEQ     Z2244
        INX
        STX     M002E
        LDX     M00B8
        STAB    0,X
        INX
        STX     M00B8
        BRA     Z2200
Z2218   ADDB    M0025
        STAB    M002F
        LDAA    #0
        ADCA    M0024
        STAA    M002E
        SUBB    M0027
        SBCA    M0026
        BCS     Z222E
        DEC     M002B
        JMP     L1D5C
Z222E   LDX     M002E
        STX     M00B8
Z2232   LDX     M0024
        LDAA    0,X
        DEX
        STX     M0024
        LDX     M002E
        STAA    0,X
        DEX
        STX     M002E
        CPX     M00BC
        BNE     Z2232
Z2244   LDX     M00B8
        STX     M0024
Z2248   LDX     M0028
        BEQ     Z2265
        LDX     M00BC
        LDAA    M0028
        LDAB    M0029
        STAA    0,X
        INX
        STAB    0,X
Z2257   INX
        STX     M00BC
        JSR     L1E20
        LDX     M00BC
        STAA    0,X
        CMPA    #$0D
        BNE     Z2257
Z2265   LDS     M0026
        JMP     L1D2A

;
; TBIL program table
;
ILTBL   .DB     $24, $3A, $91, $27, $10, $E1, $59, $C5, $2A, $56, $10, $11, $2C, $8B, $4C
        .DB     $45, $D4, $A0, $80, $BD, $30, $BC, $E0, $13, $1D, $94, $47, $CF, $88, $54
        .DB     $CF, $30, $BC, $E0, $10, $11, $16, $80, $53, $55, $C2, $30, $BC, $E0, $14
        .DB     $16, $90, $50, $D2, $83, $49, $4E, $D4, $E5, $71, $88, $BB, $E1, $1D, $8F
        .DB     $A2, $21, $58, $6F, $83, $AC, $22, $55, $83, $BA, $24, $93, $E0, $23, $1D
        .DB     $30, $BC, $20, $48, $91, $49, $C6, $30, $BC, $31, $34, $30, $BC, $84, $54
        .DB     $48, $45, $CE, $1C, $1D, $38, $0D, $9A, $49, $4E, $50, $55, $D4, $A0, $10
        .DB     $E7, $24, $3F, $20, $91, $27, $E1, $59, $81, $AC, $30, $BC, $13, $11, $82
        .DB     $AC, $4D, $E0, $1D, $89, $52, $45, $54, $55, $52, $CE, $E0, $15, $1D, $85
        .DB     $45, $4E, $C4, $E0, $2D, $98, $4C, $49, $53, $D4, $EC, $24, $00, $00, $00
        .DB     $00, $0A, $80, $1F, $24, $93, $23, $1D, $30, $BC, $E1, $50, $80, $AC, $59
        .DB     $85, $52, $55, $CE, $38, $0A, $86, $43, $4C, $45, $41, $D2, $2B, $84, $52
        .DB     $45, $CD, $1D, $39, $57, $00, $00, $00, $85, $AD, $30, $D3, $17, $64, $81
        .DB     $AB, $30, $D3, $85, $AB, $30, $D3, $18, $5A, $85, $AD, $30, $D3, $19, $54
        .DB     $2F, $30, $E2, $85, $AA, $30, $E2, $1A, $5A, $85, $AF, $30, $E2, $1B, $54
        .DB     $2F, $97, $52, $4E, $C4, $0A, $80, $80, $12, $0A, $09, $29, $1A, $0A, $1A
        .DB     $85, $18, $13, $09, $80, $12, $0B, $31, $30, $61, $73, $0B, $02, $04, $02
        .DB     $03, $05, $03, $1B, $1A, $19, $0B, $09, $06, $0A, $00, $00, $1C, $17, $2F
        .DB     $8F, $55, $53, $D2, $80, $A8, $30, $BC, $31, $2A, $31, $2A, $80, $A9, $2E
        .DB     $2F, $A2, $12, $2F, $C1, $2F, $80, $A8, $30, $BC, $80, $A9, $2F, $83, $AC
        .DB     $38, $BC, $0B, $2F, $80, $A8, $52, $2F, $84, $BD, $09, $02, $2F, $8E, $BC
        .DB     $84, $BD, $09, $03, $2F, $84, $BE, $09, $05, $2F, $09, $01, $2F, $80, $BE
        .DB     $84, $BD, $09, $06, $2F, $84, $BC, $09, $05, $2F, $09, $04, $2F, $84, $42
        .DB     $59, $C5, $26, $86, $4C, $4F, $41, $C4, $28, $1D, $86, $53, $41, $56, $C5
        .DB     $29, $1D, $A0, $80, $BD, $38, $14

; Fill rest of ROM with FFs.

;        DS      $2400-*,$FF

       .END
