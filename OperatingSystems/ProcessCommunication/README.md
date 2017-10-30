Execution control of programs using sleep/wait functions and signals. Inter-process communication using pipes.

# Brief Description:

fork_procs: generates a specific process tree using the fork function to create new processes and sleep/wait functions to control their execution.

Execution example:
./fork_procs

proctree: gets as input a file that describes a tree and generates a process tree by creating a process for each node of the tree in the input file. It uses fork and sleep/wait functions to create the tree.

Example:
./proctree proc.tree

signals: has the same functionality as proctree, but it uses signals instead of the sleep/wait functions for execution control.

Example:
./signals proc.tree

tree2expr: gets as input a file that contains a binary tree and corresponds to a mathematical expression, and calculates the value of the expresion by creating a process for each node of the tree. Each process calculates the value of the subexpression that corresponds to its node. It uses pipes for inter-process communication and results sharing. The functionality for creating the tree is based on signals.

Example:
./tree2expr expr.tree
