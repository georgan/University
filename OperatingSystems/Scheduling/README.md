A Round-Robin scheduler is implemented in C. The following programs are provided:

scheduler: receives as input the names of programs and controls their execution until their termination. When they terminate, scheduler terminates too. It uses signal-handling to control their execution.

scheduler-shell: adds to the scheduler a shell program that provides interaction with the user. No input is required. The following commands are provided by the shell:
  - p: print running processes
  - k: kill a process using their ID
  - e: create a new process
  - q: exit shell

scheduler-shell2: has the same functionality as scheduler-shell has, and provides two further commands that change the priority of the processes that are executed. These commands are the following:
  - h: moves a process to the high priority list
  - l: moves a process to the low priority list
