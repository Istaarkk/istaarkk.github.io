#!/bin/bash

# Créer les répertoires de destination
mkdir -p content/posts/web-security
mkdir -p content/posts/low-level
mkdir -p content/posts/exploits

# Supprimer les fichiers existants pour éviter les doublons
rm -f content/posts/web-security/*.md
rm -f content/posts/low-level/*.md
rm -f content/posts/exploits/*.md

# 1. Web Fuzzing
cat > "content/posts/web-security/web-fuzzing.md" << 'EOF'
---
title: "Web Fuzzing Techniques"
date: 2024-04-04T15:30:00+02:00
draft: false
categories:
  - Web Security
tags:
  - Pentesting
  - HTB
  - Fuzzing
---

# Web Fuzzing Techniques

## Introduction to Fuzzing

Fuzzing is a technique used in security testing where automated software provides random, unexpected, or invalid data as inputs to a computer program. The program is then monitored for exceptions such as crashes, memory leaks, or failing built-in assertions.

## Common Fuzzing Tools

### FFuF (Fuzz Faster U Fool)

FFuF is a fast web fuzzer written in Go that allows for:
- Directory discovery
- Virtual host discovery
- Parameter fuzzing
- Authentication brute forcing

#### Basic Usage:
```bash
ffuf -w wordlist.txt -u https://target.com/FUZZ
```

### GoBuster

GoBuster is a directory/file & DNS busting tool written in Go:

```bash
gobuster dir -u https://target.com -w wordlist.txt
```

## Fuzzing Strategies

1. **Path Fuzzing**: Discovering hidden endpoints
2. **Parameter Fuzzing**: Finding undocumented parameters
3. **Value Fuzzing**: Testing parameter input boundaries
4. **HTTP Header Fuzzing**: Checking for header-based vulnerabilities

## Best Practices

- Start with small, targeted wordlists
- Filter out common response codes (like 404)
- Use rate limiting to avoid detection
- Save and analyze results carefully

## Resources for Wordlists

- SecLists: https://github.com/danielmiessler/SecLists
- FuzzDB: https://github.com/fuzzdb-project/fuzzdb
- Assetnote Wordlists: https://wordlists.assetnote.io/
EOF

# 2. Format String
cat > "content/posts/exploits/format-string.md" << 'EOF'
---
title: "Format String Vulnerabilities"
date: 2024-04-04T15:30:00+02:00
draft: false
categories:
  - Exploits
tags:
  - Binary Exploitation
  - Memory Corruption
---

# Format String Vulnerabilities

## Understanding Format String Vulnerabilities

Format string vulnerabilities occur when user input is passed directly to formatting functions (like `printf` in C) without proper validation. These vulnerabilities can lead to information disclosure, memory corruption, and even arbitrary code execution.

## The Printf Function Family

Functions vulnerable to format string attacks:
- `printf()`
- `fprintf()`
- `sprintf()`
- `snprintf()`
- `vprintf()`
- `vfprintf()`
- `vsprintf()`
- `vsnprintf()`

## Format Specifiers

Common format specifiers and their usage:
- `%s` - Print as string
- `%d` - Print as integer
- `%x` - Print as hexadecimal
- `%p` - Print memory address
- `%n` - Write the number of bytes printed so far to the provided address

## Exploitation Techniques

### Information Leakage

Using `%x` or `%p` to view stack contents:

```c
printf(user_input); // Vulnerable when user_input contains format specifiers
```

If `user_input` is `%x %x %x %x`, this will print 4 values from the stack.

### Memory Writing with %n

The `%n` specifier writes the number of characters printed so far to a provided address:

```c
int count;
printf("Hello%n", &count); // count will be 5
```

This can be used to write arbitrary values to memory.

### Full Exploitation Process

1. Locate the vulnerable printf call
2. Determine the offset on the stack
3. Identify target addresses to write to
4. Calculate the values needed
5. Create payload with appropriate format string

## Protection Mechanisms

- Compiler warnings (`-Wformat-security`)
- FORTIFY_SOURCE
- Format string auditing tools
- Proper use of format functions: `printf("%s", user_input);`

## References

- "Exploiting Format String Vulnerabilities" by scut / team teso
- "The Format String Vulnerability" by Tim Newsham
EOF

# 3. Low Level - Memory Management
cat > "content/posts/low-level/memory-management.md" << 'EOF'
---
title: "Memory Management: brk, mmap, and Memory Structure"
date: 2024-04-04T15:30:00+02:00
draft: false
categories:
  - Low Level
tags:
  - Memory
  - Linux
  - System Programming
---

# Memory Management: brk, mmap and Memory Structure

## Process Memory Layout

The memory of a process in Linux is organized into several segments:

1. **Text Segment**: Contains executable code (read-only)
2. **Data Segment**: Contains initialized global and static variables
3. **BSS Segment**: Contains uninitialized global and static variables
4. **Heap**: Dynamic memory allocation area (grows upward)
5. **Memory Mapping**: Area for shared libraries and mmap operations
6. **Stack**: Local variables and function call information (grows downward)

## Memory Allocation Mechanisms

### The brk System Call

The `brk()` system call changes the location of the program break, which defines the end of the process's data segment:

```c
int brk(void *addr);
```

- Used for small allocations
- Contiguous memory region
- Implementation behind `malloc()` for small allocations

### The mmap System Call

The `mmap()` system call creates a new mapping in the virtual address space:

```c
void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);
```

- Used for large allocations (typically > 128KB)
- Can map files into memory
- Implementation behind `malloc()` for large allocations

## Memory Allocation in Practice

### How malloc Works

The `malloc()` function in the C standard library typically:

1. Uses `brk()` for small allocations
2. Uses `mmap()` for large allocations
3. Maintains freelists to reuse freed memory
4. Implements various algorithms (e.g., first-fit, best-fit) to find suitable memory blocks

### Memory Fragmentation

Two types of fragmentation:
- **External fragmentation**: Free space is split into small, non-contiguous blocks
- **Internal fragmentation**: Allocated blocks are larger than needed

## Kernel Memory Management

The Linux kernel manages physical memory using:
- Page frames (typically 4KB)
- Page tables for virtual-to-physical mapping
- Buddy system for physical page allocation
- Slab allocator for kernel objects

## Analyzing Memory with Tools

- `/proc/<pid>/maps`: View process memory maps
- `pmap`: Display memory map of a process
- `vmstat`: Report virtual memory statistics
- `valgrind`: Memory debugging and leak detection

## Security Implications

- Buffer overflows
- Use-after-free vulnerabilities
- Memory leaks
- Heap spraying attacks

## Best Practices

- Always check return values from memory allocation functions
- Free allocated memory when no longer needed
- Use tools like Valgrind to detect memory issues
- Consider specialized allocators for specific use cases
EOF

# 4. Low Level - Assembly
cat > "content/posts/low-level/assembly-x86-64.md" << 'EOF'
---
title: "x86-64 Assembly: Registers, Calling Conventions and Examples"
date: 2024-04-04T15:30:00+02:00
draft: false
categories:
  - Low Level
tags:
  - Assembly
  - x86-64
  - Registers
---

# x86-64 Assembly: Registers, Calling Conventions and Examples

## General Purpose Registers

In x86-64 architecture, there are 16 general-purpose 64-bit registers:

- **RAX**: Accumulator, used for arithmetic operations and function return values
- **RBX**: Base register, sometimes used as a base pointer
- **RCX**: Counter register, used in string and loop operations
- **RDX**: Data register, used in I/O operations and some arithmetic operations
- **RSI**: Source index for string operations
- **RDI**: Destination index for string operations
- **RBP**: Base pointer for stack frames
- **RSP**: Stack pointer
- **R8-R15**: Additional registers introduced in x86-64

Each register can be accessed in different sizes:
- **R**X: 64-bit (e.g., RAX, RBX)
- **E**X: 32-bit (e.g., EAX, EBX)
- **X**: 16-bit (e.g., AX, BX)
- **H/L**: 8-bit high/low (e.g., AH/AL, BH/BL)

## Calling Conventions

### System V AMD64 ABI (Linux, macOS, FreeBSD)

Parameters passed in registers:
1. RDI: 1st argument
2. RSI: 2nd argument
3. RDX: 3rd argument
4. RCX: 4th argument
5. R8: 5th argument
6. R9: 6th argument
7. Additional arguments on the stack

Return value in RAX (or RDX:RAX for 128-bit values)

Callee-saved registers (must be preserved): RBX, RBP, R12-R15
Caller-saved registers (can be overwritten): RAX, RCX, RDX, RSI, RDI, R8-R11

### Microsoft x64 Calling Convention (Windows)

Parameters passed in registers:
1. RCX: 1st argument
2. RDX: 2nd argument
3. R8: 3rd argument
4. R9: 4th argument
5. Additional arguments on the stack

Return value in RAX

32 bytes of "shadow space" on stack reserved by caller even for functions with fewer than 4 parameters

## Basic Assembly Examples

### Function to Add Two Numbers

```nasm
section .text
global add_numbers

add_numbers:
    ; Function prologue
    push rbp
    mov rbp, rsp
    
    ; Add first and second parameters (RDI and RSI)
    mov rax, rdi
    add rax, rsi
    
    ; Function epilogue
    mov rsp, rbp
    pop rbp
    ret
```

### Recursive Factorial Function

```nasm
section .text
global factorial

factorial:
    ; Function prologue
    push rbp
    mov rbp, rsp
    
    ; Base case: if n <= 1, return 1
    cmp rdi, 1
    jle .base_case
    
    ; Recursive case: n * factorial(n-1)
    push rdi           ; Save n
    dec rdi            ; n-1
    call factorial     ; Call factorial(n-1)
    pop rdi            ; Restore n
    imul rax, rdi      ; n * factorial(n-1)
    jmp .done
    
.base_case:
    mov rax, 1
    
.done:
    ; Function epilogue
    mov rsp, rbp
    pop rbp
    ret
```

## Common Instructions

- **mov dest, src**: Move data from source to destination
- **push reg/imm**: Push register or immediate value onto stack
- **pop reg**: Pop value from stack into register
- **call label**: Call a function
- **ret**: Return from function
- **add dest, src**: Add source to destination
- **sub dest, src**: Subtract source from destination
- **mul reg**: Unsigned multiply (RAX * reg)
- **imul reg**: Signed multiply
- **div reg**: Unsigned divide (RDX:RAX / reg)
- **idiv reg**: Signed divide
- **jmp label**: Unconditional jump
- **je/jne label**: Jump if equal/not equal
- **jl/jle label**: Jump if less/less or equal
- **jg/jge label**: Jump if greater/greater or equal

## Debugging Assembly

Tools for debugging assembly code:
- **GDB**: Standard Linux debugger
- **LLDB**: Part of the LLVM project
- **x64dbg**: Windows debugger
- **Radare2/Rizin**: Reverse engineering framework

## Resources for Learning Assembly

- "Assembly Language for x86 Processors" by Kip Irvine
- "Professional Assembly Language" by Richard Blum
- "Introduction to 64 Bit Intel Assembly Language Programming" by Ray Seyfarth
- [x86 and amd64 instruction reference](https://www.felixcloutier.com/x86/)
EOF

# 5. LFI Exploitation
cat > "content/posts/web-security/lfi-exploitation.md" << 'EOF'
---
title: "LFI (Local File Inclusion) Exploitation"
date: 2024-04-04T15:30:00+02:00
draft: false
categories:
  - Web Security
tags:
  - LFI
  - PHP
  - Web Exploitation
---

# LFI (Local File Inclusion) Exploitation

## What is LFI?

Local File Inclusion (LFI) is a vulnerability that allows an attacker to include files on a server through the web browser. This vulnerability occurs when a web application includes a file without properly sanitizing the input, allowing an attacker to manipulate the parameter and include arbitrary files from the server.

## Common Vulnerable Code Patterns

In PHP:
```php
<?php
    include($_GET['page'] . '.php');
?>
```

In this example, if an attacker sets `?page=../../../etc/passwd%00`, they might be able to read the `/etc/passwd` file.

## Basic LFI Techniques

### Path Traversal

The most common technique is using directory traversal sequences (`../`) to navigate to sensitive files:

```
http://example.com/index.php?page=../../../etc/passwd
```

### Common Target Files

Linux:
- `/etc/passwd` - User accounts information
- `/etc/shadow` - Password hashes (usually requires privileges)
- `/etc/hosts` - Host name resolution
- `/proc/self/environ` - Environment variables
- `/var/log/apache2/access.log` - Web server logs
- `/var/www/html/config.php` - Web application configurations

Windows:
- `C:/Windows/System32/drivers/etc/hosts`
- `C:/Windows/win.ini`
- `C:/xampp/apache/logs/access.log`
- `C:/xampp/apache/logs/error.log`

## Advanced Exploitation Techniques

### PHP Wrappers

PHP provides various wrappers that can be used to exploit LFI vulnerabilities:

1. **php://filter**: Read PHP source code without executing it
```
http://example.com/index.php?page=php://filter/convert.base64-encode/resource=config
```

2. **php://input**: Use POST data as code
```
http://example.com/index.php?page=php://input
[POST data: <?php system("whoami"); ?>]
```

3. **data://**: Execute code directly
```
http://example.com/index.php?page=data://text/plain;base64,PD9waHAgc3lzdGVtKCJscyIpOyA/Pg==
```

### Log Poisoning

This technique involves injecting PHP code into log files and then including those files:

1. Send a request with PHP code in the User-Agent header:
```
<?php system($_GET['cmd']); ?>
```

2. Include the log file:
```
http://example.com/index.php?page=../../../var/log/apache2/access.log&cmd=whoami
```

## Mitigation Strategies

To prevent LFI vulnerabilities:

1. **Whitelist Approach**: Only allow known good values
```php
<?php
    $allowed_pages = ['home', 'about', 'contact'];
    $page = $_GET['page'];
    if (in_array($page, $allowed_pages)) {
        include($page . '.php');
    } else {
        include('home.php');
    }
?>
```

2. **File Path Sanitization**: Remove or encode dangerous characters
3. **Disable allow_url_include**: Set to Off in php.ini
4. **Use Security Functions**: `basename()` to extract the filename part
5. **Web Application Firewall (WAF)**: Implement rules to detect path traversal

## LFI to RCE (Remote Code Execution)

In some cases, LFI can be escalated to achieve remote code execution:

- Log poisoning
- Session poisoning
- /proc/self/environ exploitation
- Uploaded file inclusion

## Tools for LFI Testing

- LFISuite: https://github.com/D35m0nd142/LFISuite
- Kadimus: https://github.com/P0cL4bs/Kadimus
- LFI-Enum: https://github.com/flast101/php-lfi-payload-generator

## References

- OWASP: https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/07-Input_Validation_Testing/11.1-Testing_for_Local_File_Inclusion
- HackTricks: https://book.hacktricks.xyz/pentesting-web/file-inclusion
EOF

echo "Articles manually translated to English and organized by categories." 