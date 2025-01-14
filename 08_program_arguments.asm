;;; Order of sections expected by the linker in FreeBSD:
;;;   .text: Executable code (first in memory).
;;; .rodata: Read-only data (constants).
;;;   .data: Initialized variables.
;;;    .bss: Uninitialized variables (zeroed by the OS).
;;;
;;; Syscall arguments in FreeBSD x86-64:
;;; rdi, rsi, rdx, r10, r8, r9
;;; Syscall number is placed in rax.

%include    'functions.asm'

section .text
global  _start

_start:
    ;; there might be some rsp alignment going on
    ;; argc migh be at [rsp] or [rsp+8]
    ;; I assume it was aligned if rsp stores 0 or a "big" number
    pop     rcx
    cmp     rcx, 0
    jz      aligned

    cmp     rcx, 10
    jg      aligned             ; if greater than 10 then I assume it's garbage

    jmp     nextarg

aligned:
    pop     rcx

nextarg:
    cmp     rcx, 0              ; check if we have 0 arguments
    jz      nomoreargs          ; finish if there are no more arguments

    pop     rax                 ; pop next argument
    push    rcx                 ; save just in case
    call    sprintlf            ; print argument with the line feed
    pop     rcx                 ; restore rcx
    dec     rcx                 ; decrease number of arguments
    jmp     nextarg             ; repeat

nomoreargs:
    call    exit
