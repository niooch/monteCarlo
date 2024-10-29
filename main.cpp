//main.cpp
#include <iostream>
#include <cmath>
#include <random>
#include <vector>
#include "header.cpp"

double (*wybierzFunkcje(const std::string &typ, double &a, double &b, double &M, double &dokladnaWartosc)) (double) {
    if(typ == "f1"){
        //podpunkt a:
        a=0.0;
        b=8.0;
        M=2.0;
        dokladnaWartosc=12.0;
        return f1;
    } else if (typ == "f2"){
        //podpunkt b:
        a=0.0;
        b=M_PI;
        M=1.0;
        dokladnaWartosc=2.0;
        return f2;
    } else if (typ == "f3"){
        //podpunkt c:
        a=0.0;
        b=1.0;
        M=27.0/64.0;
        dokladnaWartosc=0.2;
        return f3;
    } else if (typ == "pi"){
        //zagadnienie liczenia pi:
        a=0.0;
        b=1.0;
        M=4.0;
        dokladnaWartosc=M_PI;
        return f_pi;
    } else {
        std::cerr<<"nie prawidlowe uzycie: f1, f2, f3 lub pi."<<std::endl;
        exit(1);
    }
}

int main(int argc, char* argv[]){
    if(argc<4){
        std::cerr<<"Uzycie: k, n, funkcja"<<std::endl;
        return 1;
    }

    //przyjecie argumentow
    int k = std::stoi(argv[1]);
    int n = std::stoi(argv[2]);
    std::string typ = argv[3];

    double a, b, M, dokladnaWartosc;
    double (*f)(double) = wybierzFunkcje(typ, a, b, M, dokladnaWartosc);

    std::vector<double> wyniki;
    for(int i=0; i<k; i++){
        double calka = monteCarloCalka(f, a, b, M, n);
        wyniki.push_back(calka);
        //wynik do gnuplota
        std::cout<<n<<"     "<<calka<<std::endl;
    }

    //liczenie sredniej
    double srednia=0.0;
    for(auto & i : wyniki)
        srednia+=i;
    srednia/=wyniki.size();
    std::cout<<n<<"      "<<srednia<<"       "<<dokladnaWartosc<<std::endl;

    return 0;
}

double monteCarloCalka(double (*f)(double), double a, double b, double M, int n){
    //przyszykowanie maszyny losujacej:
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> x_dist(a, b);
    std::uniform_real_distribution<> y_dist(0, M);

    int C=0;
    for(int i=0; i<n; i++){
        double x = x_dist(gen);
        double y = y_dist(gen);
        if(y<=f(x))
            C++;
    }
    //z polecenia
    double pole=(b-a)*M;
    return (static_cast<double>(C)/n)*pole;
}

//definicje funkcji:
double f1(double x){
    return std::pow(x, 1.0/3.0);
}
double f2(double x){
    return std::sin(x);
}
double f3(double x){
    return 4*x*std::pow(1-x, 3);
}
double f_pi(double x){
    return 4.0/(1.0+x*x);
}
