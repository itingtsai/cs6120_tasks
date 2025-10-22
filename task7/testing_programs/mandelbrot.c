// mandelbrot.c
#include <stdio.h>

int main() {
    int width = 80, height = 40;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            double cr = (x - width/2.0) / (width/4.0);   // division
            double ci = (y - height/2.0) / (height/4.0); // division
            double zr = 0, zi = 0;
            int iter = 0;
            while (zr*zr + zi*zi < 4.0 && iter < 50) {
                double tmp = zr*zr - zi*zi + cr;
                zi = 2*zr*zi + ci;
                zr = tmp;
                iter++;
            }
            putchar(iter == 50 ? '#' : ' ');
        }
        putchar('\n');
    }
    return 0;
}
