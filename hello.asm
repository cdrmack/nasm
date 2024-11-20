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
    mov     rax, msg            ; move the address of msg into rax
    call    strlen

    mov     rdx, rax            ; strlen leaves the result inside rax, we need it inside rdx for the syscall
    mov     rax, 4              ; write syscall
    mov     rdi, 1              ; file descriptor of standard output
    mov     rsi, msg            ; address of the message to write
    syscall

    call    exit

section .data
    msg     db  'hello, world!', 10, 0
