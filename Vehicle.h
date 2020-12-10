#ifndef VEHICLE_H
#define VEHICLE_H

const double time_limit = 30;
const double time_max = 33;
const double Failure_Rate = 300;
const double Authenticate_Rate = 720.0;

class Vehicle  {
public:
    Vehicle(double lat,double lon,int identity);

    int uavIP(void)const{
        return _uavIP;
    }
    double latitude(void)const{
        return _latitude;
    }
    double longtitude(void)const{
        return _longtitude;
    }
    int identity(void)const{
        return _identity;
    }
    long long failureTime(void)const{
        return _failureTime;
    }
    bool changeType(void)const{
        return _changeType;
    }

    void setchangeType(bool changeType){
        _changeType = changeType;
    }
    void setuavIP(int uavIP){
        _uavIP = uavIP;
    }
    void setidentity(int id){
        _identity = id;
    }
    void setlatitude(double latitude){
        _latitude = latitude;
    }
    void setlongtitude(double longtitude){
        _longtitude = longtitude;
    }
    void setfailureTime(long long failureTime){
        _failureTime = failureTime;
    }

    double Exp(double lambda);

private:
    double _latitude;
    double _longtitude;
    int _uavIP;
    bool _changeType;
//    int Security_Level;
//    int UAV_Group_IP;
    int _identity;
    long long _failureTime;


};
#endif // VEHICLE_H
