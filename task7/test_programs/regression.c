// regression.c
#include <stdio.h>

int main() {
    double x[] = {1, 2, 3, 4, 5};
    double y[] = {2.2, 2.8, 4.5, 3.7, 5.5};
    int n = 5;

    double sumx = 0, sumy = 0, sumxy = 0, sumx2 = 0;
    for (int i = 0; i < n; i++) {
        sumx  += x[i];
        sumy  += y[i];
        sumxy += x[i] * y[i];
        sumx2 += x[i] * x[i];
    }

    double denom = n * sumx2 - sumx * sumx;
    double a = (n * sumxy - sumx * sumy) / denom;   // division
    double b = (sumy * sumx2 - sumx * sumxy) / denom; // division

    printf("Regression line: y = %.3fx + %.3f\n", a, b);
    return 0;
}
