#include "Vehicle.h"

#include <math.h>
#include <VehicleList.h>


Vehicle::Vehicle(double lat,double lon, int identity)
{
    _latitude = lat + (double)rand()/(double)RAND_MAX;
    _longtitude = lon + (double)rand()/(double)RAND_MAX;
    _identity = identity;
    //_failureTime = Exp(Failure_Rate)* 10000;
    _failureTime = 1000 + rand() % 5000;
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
