/*
 * mandel.c
 *
 * A program to draw the Mandelbrot Set on a 256-color xterm.
 *
 */

#include <stdio.h>
#include <unistd.h>
#include <assert.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

#include "mandel-lib.h"
#include "pipesem.h"

#define MANDEL_MAX_ITERATION 100000
#define NCHILDREN 1

/***************************
 * Compile-time parameters *
 ***************************/

/*
 * Output at the terminal is is x_chars wide by y_chars long
*/
int y_chars = 50;
int x_chars = 90;

/*
 * The part of the complex plane to be drawn:
 * upper left corner is (xmin, ymax), lower right corner is (xmax, ymin)
*/
double xmin = -1.8, xmax = 1.0;
double ymin = -1.0, ymax = 1.0;
    
/*
 * Every character in the final output is
 * xstep x ystep units wide on the complex plane.
 */
double xstep;
double ystep;

/*
 * This function computes a line of output
 * as an array of x_char color values.
 */
void compute_mandel_line(int line, int color_val[])
{
    /*
     * x and y traverse the complex plane.
     */
    double x, y;

    int n;
    int val;

    /* Find out the y value corresponding to this line */
    y = ymax - ystep * line;

    /* and iterate for all points on this line */
    for (x = xmin, n = 0; x <= xmax; x+= xstep, n++) {

        /* Compute the point's color value */
        val = mandel_iterations_at_point(x, y, MANDEL_MAX_ITERATION);
        if (val > 255)
            val = 255;

        /* And store it in the color_val[] array */
        val = xterm_color(val);
        color_val[n] = val;
    }
}

/*
 * This function outputs an array of x_char color values
 * to a 256-color xterm.
 */
void output_mandel_line(int fd, int color_val[])
{
    int i;
    
    char point ='@';
    char newline='\n';

    for (i = 0; i < x_chars; i++) {
        /* Set the current color, then output the point */
        set_xterm_color(fd, color_val[i]);
        if (write(fd, &point, 1) != 1) {
            perror("compute_and_output_mandel_line: write point");
            exit(1);
        }
    }

    /* Now that the line is done, output a newline character */
    if (write(fd, &newline, 1) != 1) {
        perror("compute_and_output_mandel_line: write newline");
        exit(1);
    }
}

void compute_and_output_mandel_line(int fd, int line)
{
    /*
     * A temporary array, used to hold color values for the line being drawn
     */
    int color_val[x_chars];

    compute_mandel_line(line, color_val);
    output_mandel_line(fd, color_val);
}


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

