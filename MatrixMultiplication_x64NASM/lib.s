DIVISOR_10_SCALED EQU 0xCCCC_CCCC_CCCC_CCCD
NULL EQU 0
INFINITE EQU 0xffffffff
TRUE    EQU 1

extern GetProcessHeap
extern HeapAlloc
extern GetSystemInfo
extern CreateThread
extern WaitForMultipleObjects
extern SetThreadIdealProcessor

global itoa
global matmul
global matmulWrapper

section .data
section .bss
alignb 8
 ProcessorCount resd 1
 SystemInfo     resb 48
 HandlePtr      resq 1
 ParamsPtr      resq 1
section .text                             ; Code segment
itoa:                                     ; expects input number in rcx and output address in rdx, puts output length in rax
 mov    r10, rdx
 mov    r9, DIVISOR_10_SCALED
 xor    r11, r11                          ; clear
 mov    rax, rcx
itoaDivision:                             ; first integer divide number by 10 through the algorithm explained at https://en.wikipedia.org/wiki/Division_algorithm#Division_by_a_constant
 mul    r9
 sar    rdx, 3                            ; only need to look at rdx as is shifted righted by 67 bits
                                          ; compute modulo to get the last digit
 lea    rax, [rdx + 4*rdx]                ; multiply 10*int(x/10)
 add    rax, rax
 sub    rcx, rax
                                          ; convert to ASCII and push on stack+housekeeping
 or     rcx, '0'                           ; convert to ASCII
 push   rcx
 inc    r11                               ; make one longer
 mov    rcx, rdx                           ; prepare for next iteration
 mov    rax, rcx                          ; prepare for next iteration
 cmp    rcx, 0                            ; if the remaining digits are 0 we are finished
 jne    itoaDivision
 mov    rax, r11                          ; put length into output
itoaEnd:
 pop    rcx
 mov    byte [r10], cl
 inc    r10
 dec    r11
 jnz    itoaEnd

 ret
malloc:; rcx = number of bytes to write, returns eax = pointer to buffer
 push   r14
 mov    r14, rcx
 sub    rsp, 32; shadow space
 call   GetProcessHeap
 ; ProcessHeap Handle in rax
 
 ; shadow space is already allocated
 mov    rcx, rax; 1st parameter hHeap
 mov    rdx, 4; 2nd parameter dwFlags
 mov    r8, r14; 3rd parameter dwBytes
 call   HeapAlloc
 add    rsp, 32; remove shadow space

 pop r14
 ; return pointer is already in rax, as HeapAlloc returns just that
 ret

parMatmul:; only for square matrices, rcx = pointer to c, rdx = pointer to b, r8 = pointer to a, r9 = n, no return
 push   r15
 push   r14
 push   r13
 push   r12
 push   rsi
 push   rdi

 mov   r15, rcx ; r15 = cptr
 mov   r14, rdx ; r14 = bptr
 mov   r13, r8  ; r13 = aptr
 mov   r12, r9  ; r12 = n

 sub    rsp, 32
 mov    rcx, SystemInfo
 call   GetSystemInfo
 add    rsp, 32
 mov    eax, [SystemInfo + 32]
 sar    eax, 1
 mov    dword [ProcessorCount], eax
 mov    esi, dword [ProcessorCount] ; rsi = i+1
 mov    rax, r12
 div    rsi
 mov    rdi, rax ; rdi = step
 mov    rbp, r12 ; rbp = upperbound
 ; rax is still step so just multiply by i
 lea    rdx, [rsi - 1]
 mul    rdx ; rax = i*step
 mov    rbx, rax ; rbx = lowerbound

 mov    eax, dword [ProcessorCount]
 shl    rax, 3; each handle is a pointer so has 8 bytes of size
 mov    rcx, rax
 call   malloc
 mov    qword [HandlePtr], rax
 mov    eax, dword [ProcessorCount]
 mov    rcx, 36
 mul    rcx ; each structure is 36 bytes long
 mov    rcx, rax
 call   malloc
 mov    qword [ParamsPtr], rax

 ; CreateThread takes 6 arguments:
 ; rcx = ThreadAttributes / NULL
 ; rdx = stackSize / NULL
 ; r8 = lpStartAddress / matmulWrapper
 ; r9 = lpParameter / parameter address
 ; 2 stack arguments, both null in our case
 ;
 ; returns handle in rax
 sub    rsp, 32 + 8 + 8
 mov    qword [rsp + 32], NULL
 mov    qword [rsp + 32 + 8], NULL
 mov    r8, matmulWrapper
threadStarts:
 lea    rdx, [rsi - 1]; rdx = i
 mov    rax, 36
 mul    rdx ; rax = 36*i = address offset of parameter struct
 add    rax, qword [ParamsPtr]
 mov    qword [rax], r15
 mov    qword [rax + 8], r14
 mov    qword [rax + 16], r13
 mov    dword [rax + 24], r12d
 mov    dword [rax + 28], ebx
 mov    dword [rax + 32], ebp

 mov    rdx, NULL
 mov    rcx, NULL
 mov    r8, matmulWrapper
 mov    r9, rax
 call   CreateThread

 ; calculate address of new handle
 lea    rdx, [8*rsi - 8]
 add    rdx, qword [HandlePtr]
 mov    qword [rdx], rax

 mov    rcx, rax
 lea    rdx, [rsi - 1]
 call   SetThreadIdealProcessor ; don't know if this helps any but should not hurt to try

 ; calculate upper-/lowerbound for next iteration
 mov    rbp, rbx ; new upperbound is old lowerbound
 sub    rbx, rdi ; new lowerbound = lowerbound - step    
 ; decrease loop counter
 dec    rsi
 jnz    threadStarts
 

 add    rsp, 32 + 8 + 8 ; clear stack from calls

 sub    rsp, 32
 mov    ecx, dword [ProcessorCount]
 mov    rdx, qword [HandlePtr]
 mov    r8d, TRUE
 mov    r9d, INFINITE
 call   WaitForMultipleObjects
 add    rsp, 32

 pop    rdi
 pop    rsi
 pop    r12
 pop    r13
 pop    r14
 pop    r15
 ret

matmulWrapper: ; thread wrapper for matmul rcx = pointer to structure containing all necessary data
 push   r15
 push   r14
 push   r13
 push   rbx
 push   rdi
 push   rsi
 push   rbp
 ; struct {
 ;  PTR C 8B Offset 0
 ;  PTR B 8B Offset 8
 ;  PTR A 8B Offset 16
 ;  
 ;  DWORD N 4B Offset 24
 ;  DWORD LOWERBOUND 4B Offset 28
 ;  DWORD UPPERBOUND 4B Offset 32
 ;  
 ;  Summed: 36B
 ; }
 mov    rax, rcx ; save pointer to structure
 
 mov    rcx, qword [rax]
 mov    r10, qword [rax + 8]
 mov    r8, qword [rax + 16]
 mov    r9d, dword [rax + 24]

 mov    ebp, dword [rax + 32]
 mov    r15d, dword [rax + 28]

 jmp    matmulI
 
matmul:; only for square matrices, rcx = pointer to c, rdx = pointer to b, r8 = pointer to a, r9 = n, no return
 push   r15
 push   r14
 push   r13
 push   rbx
 push   rdi
 push   rsi
 push   rbp

 mov    r10, rdx

 ; local variables 
 ; *c = rcx
 ; *b = r10
 ; *a = r8

 ; addr a = rdi
 ; addr b = rsi
 ; addr c = r11

 ; i = r15
 ; k = r14
 ; j = r13   

 ; n = r9
 ; sum = xmm2
 ; multiplicand1 = xmm0
 ; multiplicand2 = xmm1
 ; product = eax
 mov    rbp, r9
 xor    r15, r15 ; holds i
matmulI:
 lea    r14, [r9 - 3] ; holds k

 mov    rax, r15
 mul    r9
 lea    r11, [rax + r14 - 1]
matmulK:
 pxor   xmm2, xmm2

 mov    r13, r9 ; holds j

 mov    rax, r15
 mul    r9
 mov    rdi, rax ; holds n*i

 lea    rsi, [r14 - 1] ; holds k for b addr
;align 64 ; don't know if this helps but doesn't hurt remarkably
matmulJ:
 vbroadcastss   xmm0, dword [4*rdi + r8] ; xmm0 = a[n*i + j]
 add    rdi, 1
 
 movaps  xmm1, [4*rsi + r10]; xmm1 = b[n*j + k]
 add    rsi, r9

 vfmadd231ps  xmm2, xmm0, xmm1

 sub    r13, 1
 jnz    matmulJ

 movntps  [4*r11 + rcx], xmm2; c[n*i + k] = xmm2
 sub    r11, 4

 sub    r14, 4
 ja     matmulK

 add    r15, 1
 cmp    r15, rbp
 jne    matmulI

 pop    rbp
 pop    rsi
 pop    rdi
 pop    rbx
 pop    r13
 pop    r14
 pop    r15
 ret