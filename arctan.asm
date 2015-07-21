.segment "ZEROPAGE" : zeropage
.importzp quadrant, x_delta, y_delta, half_value, region_number, small, large


.segment "util"
.export Arctan

quadrant_region_to_direction:
  .byte  9, 3,15,21
  .byte 10, 2,14,22
  .byte 11, 1,13,23
  .byte 12, 0,12, 0
  .byte  9, 3,15,21
  .byte  8, 4,16,20
  .byte  7, 5,17,19
  .byte  6, 6,18,18

;Arctan
; From a pair of X/Y deltas, and quadrant, calculate discrete direction
; between 0 and 23.
;  .reg:a @in  quadrant Number 0 to 3.
;  .reg:x @in  x_delta Delta for x direction.
;  .reg:y @in  y_delta Delta for y direction.
; Returns Y as the direction
.proc Arctan
  sta quadrant
  sty y_delta
  stx x_delta
  cpx y_delta
  bcs XGreaterOrEqualY

XLessY:
  lda #16
  sta region_number
  stx small
  sty large
  bne DetermineRegion

XGreaterOrEqualY:
  lda #0
  sta region_number
  stx large
  sty small

DetermineRegion:
  ; set A = small * 2.5
  lda small
  lsr a
  sta half_value
  lda small
  asl a
  bcs SmallerQuotient
  clc
  adc half_value
  bcs SmallerQuotient
  cmp large
  bcc LargerQuotient

; S * 2.5 > L
SmallerQuotient:
  ; set A = S * 1.25
  lsr half_value
  lda small
  clc
  adc half_value
  cmp large
  bcc Region1 ; if S * 1.25 < L then goto Region1 (L / S > 1.25)
  bcs Region0 ;                                   (L / S < 1.25)

; S * 2.5 < L
LargerQuotient:
  ; set A = S * 7.5
  lda small
  asl a
  asl a
  asl a
  bcs Region2
  sec
  sbc half_value
  cmp large
  bcc Region3 ; if S * 7.5 < L then goto Region3 (L / S > 7.5)
  jmp Region2 ;                                  (L / S < 7.5)

Region0:
  ; L / S < 1.25. d=3,9,15,21
  jmp LookupResult

Region1:
  ; 1.25 < L / S < 2.5. d=2,4,8,10,14,16,20,22
  lda region_number
  clc
  adc #4
  sta region_number
  bpl LookupResult

Region2:
  ; 2.5 < L / S < 7.5. d=1,5,7,11,13,17,19,23
  lda region_number
  clc
  adc #8
  sta region_number
  bpl LookupResult

Region3:
  ; 7.5 < L / S. d=0,6,12,18
  lda region_number
  clc
  adc #12
  sta region_number

LookupResult:
  lda quadrant
  clc
  adc region_number
  tax
  lda quadrant_region_to_direction,x
  tay

  rts
.endproc
