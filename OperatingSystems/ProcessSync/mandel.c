int main(int argc, char **argv)
{
	int line;
	int i;
	int n;
	pid_t p;
	struct pipesem root_sem;
	struct pipesem *sem;
	int color_val[x_chars];

	printf("\n");
	if (argc != 2) {
		perror("Input: mandel <number>");
		exit(0);
	}	

	n = atoi(argv[1]);
	if (n <=0 ) {
		perror("Input must be positive integer");
		exit(0);
	}

	if (n > y_chars)
		n = y_chars;

	xstep = (xmax - xmin) / x_chars;
	ystep = (ymax - ymin) / y_chars;

	sem = (struct pipesem *) malloc(n*sizeof(struct pipesem));

	pipesem_init(&root_sem, 0);
	pipesem_init(sem, 1);
	for (i = 1; i < n; i++)
		pipesem_init(sem+i,0);

	for (i = 0; i < n; i++) {
		p = fork();
		if (p < 0) {
			perror("fork");
			exit(0);
		}

		if (p == 0) {
		/*
	 	 * draw the Mandelbrot Set, one line at a time.
		 * Output is sent to file descriptor '1', i.e., standard output.
		 */
			for (line = i; line < y_chars; line+=n) {
				compute_mandel_line(line, color_val);
				pipesem_wait(sem + i);
				output_mandel_line(1, color_val);
				pipesem_signal(sem+(i+1)%n);
			}

			if (line == y_chars+n-1)
				pipesem_signal(&root_sem);

			return 0;
		}
	
	}


	pipesem_wait(&root_sem);
	reset_xterm_color(1);

	return 0;
}

