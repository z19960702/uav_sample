#include "Vehicle.h"

#include <math.h>
#include <VehicleList.h>


Vehicle::Vehicle(int identity)
{
    _latitude = 18 + (double)rand()/(double)RAND_MAX;
    _longtitude = 114 + (double)rand()/(double)RAND_MAX;
    _identity = identity;
    //_failureTime = Exp(Failure_Rate)* 10000;
    _failureTime = 10000 + rand() % 5000;
}
double Vehicle::Exp(double lambda){
    double pV = 0.0;
    while(true){
        pV = (double)rand()/(double)RAND_MAX;
        if(pV != 1){
            break;
        }
    }
    pV = (-1.0/lambda)*log(1-pV);
    return pV;
}
