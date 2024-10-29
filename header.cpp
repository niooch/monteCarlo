//header.cpp
#include <string>
double (*wybierzFunkcje(const std::string &typ, double &a, double &b, double &M, double &dokladnaWartosc)) (double);
double monteCarloCalka(double (*f)(double), double a, double b, double M, int n);
double f1(double x);
double f2(double x);
double f3(double x);
double f_pi(double x);
