; Vernamova sifra na architekture DLX
; Matúš Vráblik xvrabl05

        .data 0x04          ; zacatek data segmentu v pameti
login:  .asciiz "xvrabl05"  ; <-- nahradte vasim loginem
cipher: .space 9 ; sem ukladejte sifrovane znaky (za posledni nezapomente dat 0)

        .align 2            ; dale zarovnavej na ctverice (2^2) bajtu
laddr:  .word login         ; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        ; 4B adresa sifrovaneho retezce (pro vypis)

        .text 0x40          ; adresa zacatku programu v pameti
        .global main        ; 
main:   ; sem doplnte reseni Vernamovy sifry dle specifikace v zadani
	;xvrabl05-r4-r13-r22-r28-r29-r0
	;"v"=118 "r"=114 =>(-96) "v"=22 -"r"=-18
	addi r28,r0,-18		;r28=--"r"
	addi r29,r0,40		;r28=40 -> difference between +"v" and -"r"
	addi r13,r0,0		;r13 = counter of output letters

next:	lb r4,login(r13)	;load byte from login

	addi r22,r0,97		;number detection
	sgt r22,r22,r4		;compare if less than 97 -> "a"
	bnez r22,end		;end if less than 97

	sub r29,r0,r29		;switch between 40 and -40
	sub r28,r28,r29		;switch between -"r" and +"v"
	add r4,r4,r28		;aplying vignere cipher

	sgti r22,r4,97		;check if in bottom letter bounds
	bnez r22,n_low		;jump n_low if in bot bounds 
	nop
	nop
	addi r4,r4,26		;else add 26 and return inbounds

n_low:	addi r22,r0,122		
	sgt r22,r22,r4		;check if in top letter bounds
	bnez r22,n_high		;jump n_high if in top bounds
	nop
	nop
	subi r4,r4,26		;else subtract 26 and return inbounds

n_high: sb cipher(r13),r4	;save byte to cipher[r13]
	addi r13,r13,1		;inc counter r13
	j next			;repeat
	nop
	nop
end:    sb cipher(r13),r0	;add 0 to the end of cipher as requested
	addi r14, r0, caddr ; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace