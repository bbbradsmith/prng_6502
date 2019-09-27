;
; Common code for RNG tests
; http://rainwarrior.ca
;

.zeropage
seed: .res 4 ; seed can be 2-4 bytes
_seed = seed ; C alias
.exportzp seed
.exportzp _seed

; C variables for testing
_i: .res 4
_j: .res 4
_k: .res 4
_l: .res 4
_p: .res 1
_q: .res 1
_r: .res 1
_s: .res 1
.exportzp _i
.exportzp _j
.exportzp _k
.exportzp _l
.exportzp _p
.exportzp _q
.exportzp _r
.exportzp _s
