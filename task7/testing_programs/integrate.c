// integrate.c
#include <stdio.h>
#include <math.h>

double f(double x) {
    return sin(x) / x;   // floating-point division
}

double integrate(double a, double b, int n) {
    double h = (b - a) / n;   // division
    double sum = 0.5 * (f(a) + f(b));

    for (int i = 1; i < n; ++i) {
        double x = a + i * h;
        sum += f(x);
    }

    return sum * h;  // multiplication only
}

int main() {
    double result = integrate(1.0, 10.0, 1000);
    printf("Integral ≈ %.6f\n", result);
    return 0;
}
