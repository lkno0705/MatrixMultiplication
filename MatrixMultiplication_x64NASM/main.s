; libcall, 64 bit. V1.03
NULL              EQU 0                   ; Constants
STD_OUTPUT_HANDLE EQU -11
CARRIAGE_RETURN   EQU 0Dh
LINE_FEED         EQU 0Ah
N                 EQU 1440

extern GetStdHandle                       ; Import external symbols
extern WriteFile                          ; Windows API functions, not decorated
extern ExitProcess
extern QueryPerformanceFrequency
extern QueryPerformanceCounter

extern itoa
extern malloc
extern matmul
extern matmulWrapper
extern parMatmul

global Start                              ; Export symbols. The entry point

section .data                             ; Initialized data segment
 maxDigits      equ 22                    ; no 64 bit integer will have more than 22 digits
 dataSize       equ maxDigits + 4 + maxDigits + 4

section .bss                              ; Uninitialized data segment
alignb 8
 StandardHandle resq 1
 Written        resq 1
 output         resb dataSize
 c              resq 1 ; ptr to c
 b              resq 1 ; ptr to b
 a              resq 1 ; ptr to a
 frequency      resq 1
 startTime      resq 1
 endTime        resq 1
 callStruct     resb 36
 outputPtr      resq 1

section .text                             ; Code segment

Start:
 sub    rsp, 8                             ; Align the stack to a multiple of 16 bytes
 mov    qword [outputPtr], output

 mov    rcx, N*N*4
 call   malloc
 mov    qword [c], rax
 mov    rcx, N*N*4
 call   malloc
 mov    qword [a], rax
 mov    rcx, N*N*4
 call   malloc
 mov    qword [b], rax
 
 sub    rsp, 32
 mov    rcx, frequency
 call   QueryPerformanceFrequency
 mov    rcx, startTime
 call   QueryPerformanceCounter
 add    rsp, 32

 mov    rcx, [c]
 mov    rdx, [b]
 mov    r8, [a]
 mov    r9, N
 call   matmul

 sub    rsp, 32
 mov    rcx, endTime
 call   QueryPerformanceCounter
 add    rsp, 32

 mov    rax, [REL endTime]
 mov    rdx, [REL startTime]
 sub    rax, rdx; rax = ticks taken
 mov    rdx, 1000
 mul    rdx
 div    qword [frequency]

 mov    rcx, rax
 mov    rdx, [outputPtr]
 call   itoa
 mov    rdx, [outputPtr]
 add    rdx, rax
 mov    byte [rdx], 'm'
 inc    rdx
 mov    byte [rdx], 's'
 inc    rdx
 mov    byte [rdx], CARRIAGE_RETURN
 inc    rdx
 mov    byte [rdx], LINE_FEED
 inc    rdx
 mov    qword [outputPtr], rdx

 mov    rcx, startTime
 call   QueryPerformanceCounter
 add    rsp, 32

 mov    rcx, [c]
 mov    rdx, [b]
 mov    r8, [a]
 mov    r9, N
 call   parMatmul

 sub    rsp, 32
 mov    rcx, endTime
 call   QueryPerformanceCounter
 add    rsp, 32

 mov    rax, [REL endTime]
 mov    rdx, [REL startTime]
 sub    rax, rdx; rax = ticks taken
 mov    rdx, 1000
 mul    rdx
 div    qword [frequency]

 mov    rcx, rax
 mov    rdx, qword [outputPtr]
 call   itoa
 mov    rdx, qword [outputPtr]
 add    rdx, rax
 mov    byte [rdx], 'm'
 inc    rdx
 mov    byte [rdx], 's'
 inc    rdx
 mov    byte [rdx], CARRIAGE_RETURN
 inc    rdx
 mov    byte [rdx], LINE_FEED
 inc    rdx
 
 sub    rsp, 32                           ; 32 bytes of shadow space
 mov    ecx, STD_OUTPUT_HANDLE
 call   GetStdHandle
 mov    qword [REL StandardHandle], rax
 add    rsp, 32                           ; Remove the 32 bytes

 sub    rsp, 32 + 8 + 8                   ; Shadow space + 5th parameter + align stack
                                          ; to a multiple of 16 bytes
 mov    rcx, qword [REL StandardHandle]   ; 1st parameter
 lea    rdx, [REL output]                 ; 2nd parameter
 mov    r8, dataSize                      ; 3rd parameter
 lea    r9, [REL Written]                 ; 4th parameter
 mov    qword [rsp + 4 * 8], NULL         ; 5th parameter
 call   WriteFile                         ; Output can be redirect to a file using >
 add    rsp, 48                           ; Remove the 48 bytes

 xor    ecx, ecx
 call   ExitProcess