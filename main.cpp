#include <iostream>
#include <math.h>
#include <random>

std::random_device rd;
std::mt19937 mt_engine(rd());

double function(int typ, double x){
    switch(typ){
        case 1:
            return std::pow(x, 1.0/3.0);
        case 2:
            return std::sin(x);
        case 3:
            return 4*x*pow(1.0-x, 3);
        default:
            return 0;
    }
}

double sup(int typ, int n, double a, double b){
    double dx=(b-a)/n;
    double max=function(typ, a);
    for (int i=0; i<=n; i++)
        if(max<function(typ, a+dx*i)){
            max=function(typ, a+dx*i);
        }
    return max;
}

void losuj(double &x, double &y){
    std::normal_distribution<double> dist(0.0, 1.0);
    x=dist(mt_engine);
    y=dist(mt_engine);
}
