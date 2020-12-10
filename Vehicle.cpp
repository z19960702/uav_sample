#include "Vehicle.h"

#include <math.h>
#include <VehicleList.h>


Vehicle::Vehicle(double lat,double lon, int identity)
{
    _latitude = lat + (double)rand()/(double)RAND_MAX+0.01;
    _longtitude = lon + (double)rand()/(double)RAND_MAX+0.01;
    _identity = identity;
    _uavIP = rand();
    _changeType = false;
    _failureTime = Exp(Failure_Rate)* 50000;
    //_failureTime = 4000 + rand() % 5000;

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
