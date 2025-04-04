#### **Definition of a Syscall**

A **syscall** (system call) occurs when a program triggers an **interrupt** to request the **operating system** to perform a specific task. It serves as a communication mechanism between user-level applications and the system's kernel.

#### **Examples of Syscalls**

1. **File Management**:
    
    - `open`: Opens a file.
    - `read`: Reads data from a file.
    - `write`: Writes data to a file.
    - `close`: Closes an open file.
2. **Memory Management**:
    
    - `brk`, `sbrk`: Used to adjust the size of memory allocated to a program.

#### **File System**

Syscalls related to file management allow interaction with the system's file system. Here are some of the most commonly used calls:

- **File Creation and Management**:
    
    - `create`: Creates a new file.
    - `open`: Opens an existing file or creates a new one if necessary.
    - `close`: Closes an open file.
    - `read`: Reads the content of a file.
    - `write`: Writes data to a file.
- **File Manipulation**:
    
    - `lseek`: Moves the read/write cursor within a file.
    - `dup`: Creates a copy of a file descriptor.
    - `link`: Creates a physical link to a file.
    - `unlink`: Removes a file or a link.
- **File Information and Attribute Modification**:
    
    - `stat`, `fstat`: Retrieves information about a file (e.g., its type, size, permissions).
    - `access`: Checks if the file is accessible with the specified permissions.
    - `chmod`: Modifies the permissions of a file.
    - `chown`: Changes the owner and group of a file.
    - `umask`: Sets a default permission mask for file creation.
    - `ioctl`: Performs control operations on a file (often used for manipulating devices).

#### **Process Control**

System calls that manage processes are essential for application execution and management. Here are some of the most common ones:

- **Process Creation and Management**:
    
    - `execve`: Executes a program, replacing the current process with a new one.
    - `fork`: Creates a new process (child) by copying the calling process (parent).
    - `wait`: Waits for the termination of a child process.
    - `_exit`: Immediately terminates a process.
- **Process Information Retrieval**:
    
    - `getuid`: Returns the real user ID of the process.
    - `geteuid`: Returns the effective user ID, which may differ from the real user ID for processes with special privileges.
    - `getgid`: Returns the real group ID of the process.
    - `getegid`: Returns the effective group ID, similar to `geteuid`, but for the group.
- **Process Identifiers**:
    
    - `getpid`: Returns the process ID of the calling process.
    - `getppid`: Returns the parent process ID.
- **Signal Management**:
    
    - `signal`: Defines a function to handle a specific signal.
    - `kill`: Sends a signal to a process (commonly used to terminate a process).
    - `alarm`: Sets a timer after which an alarm signal (SIGALRM) will be sent to the process.
- **Working Directory Modification**:
    
    - `chdir`: Changes the current working directory of the process.
- Here are some C code examples demonstrating the use of various syscalls related to file management, memory management, and process control:

---

### **1. File Management Syscalls**

#### `open`, `read`, `write`, and `close`


```c
#include <fcntl.h>    // for open()
#include <unistd.h>   // for read(), write(), close()
#include <stdio.h>

int main() {
    // Open a file for writing
    int fd = open("example.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd == -1) {
        perror("open");
        return 1;
    }

    // Write data to the file
    const char *message = "Hello, world!";
    ssize_t bytes_written = write(fd, message, 13);
    if (bytes_written == -1) {
        perror("write");
        close(fd);
        return 1;
    }

    // Close the file
    if (close(fd) == -1) {
        perror("close");
        return 1;
    }

    return 0;
}
```
#### `lseek`

```c
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

int main() {
    int fd = open("example.txt", O_RDONLY);
    if (fd == -1) {
        perror("open");
        return 1;
    }

    // Move the file pointer to the 5th byte
    off_t new_pos = lseek(fd, 5, SEEK_SET);
    if (new_pos == -1) {
        perror("lseek");
        close(fd);
        return 1;
    }

    char buffer[6];
    ssize_t bytes_read = read(fd, buffer, 5);
    if (bytes_read == -1) {
        perror("read");
        close(fd);
        return 1;
    }
    buffer[bytes_read] = '\0'; // Null-terminate the string

    printf("Read from file: %s\n", buffer);

    close(fd);
    return 0;
}

```
### **2. Process Control Syscalls**

#### `fork`, `execve`, `wait`
```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();

    if (pid == -1) {
        perror("fork");
        return 1;
    }

    if (pid == 0) { // Child process
        printf("Child process: Executing 'ls' command\n");
        char *args[] = {"/bin/ls", NULL};
        execve(args[0], args, NULL);  // Replace child process with 'ls'
        perror("execve");  // execve only returns if there's an error
        return 1;
    } else { // Parent process
        wait(NULL);  // Wait for child to finish
        printf("Parent process: Child has finished execution\n");
    }

    return 0;
}

```
`getpid`, `getppid`
```c

#include <stdio.h>
#include <unistd.h>

int main() {
    pid_t pid = getpid();      // Get process ID
    pid_t ppid = getppid();    // Get parent process ID

    printf("Process ID: %d\n", pid);
    printf("Parent Process ID: %d\n", ppid);

    return 0;
}

```

### **3. Signal Management Syscalls**

#### `signal`, `kill`

```c
#include <stdio.h>
#include <unistd.h>
#include <signal.h>

void handle_signal(int sig) {
    if (sig == SIGINT) {
        printf("Received SIGINT (Ctrl+C)\n");
    }
}

int main() {
    // Set up signal handler for SIGINT (Ctrl+C)
    signal(SIGINT, handle_signal);

    printf("Waiting for SIGINT (press Ctrl+C to trigger it)...\n");

    // Infinite loop to keep the program running
    while (1) {
        sleep(1);
    }

    return 0;
}

```

`alarm`, `signal`

```c
#include <stdio.h>
#include <unistd.h>
#include <signal.h>

void alarm_handler(int sig) {
    printf("Alarm triggered!\n");
}

int main() {
    // Set up the alarm signal handler
    signal(SIGALRM, alarm_handler);

    // Set an alarm to trigger after 5 seconds
    alarm(5);

    printf("Waiting for alarm to go off...\n");

    // Wait indefinitely to catch the alarm signal
    while (1) {
        sleep(1);
    }

    return 0;
}

```
### **4. Memory Management Syscalls**

#### `brk`, `sbrk`
```c
#include <unistd.h>
#include <stdio.h>

int main() {
    // Get the current program break
    void *initial_brk = sbrk(0);
    printf("Initial program break: %p\n", initial_brk);

    // Request additional memory (increase program break)
    void *new_brk = sbrk(1024);  // Request 1 KB
    if (new_brk == (void *)-1) {
        perror("sbrk");
        return 1;
    }
    printf("New program break: %p\n", new_brk);

    // Reset to the initial program break
    if (sbrk(-1024) == (void *)-1) {
        perror("sbrk");
        return 1;
    }
    printf("Program break reset\n");

    return 0;
}

```

Here are some example of syscall in C