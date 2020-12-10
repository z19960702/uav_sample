#include "VehicleController.h"
#include <QDebug>

VehicleController::VehicleController(QObject* parent ) : QObject(parent)

{
    connect(&timer,SIGNAL(timeout()),this,SLOT(uavrun()));
    timer.setInterval(16);
    timer.start();
}

void VehicleController::createList(int count,QList<int> uavGroupIPList, QList<int> boatIPList,QList<double> lat, QList<double> lon)
{
    for(int i = 0; i < count;i++) {
        VehicleList* uavList = new VehicleList(uavGroupIPList[i],boatIPList[i],lat[i],lon[i]);
        uavGroupList.append(uavList);
    }
    emit uavGroupListChanged(uavGroupList);
}

void VehicleController::deleteUav(int gropuIP,int num,double lat,double lon)
{
    VehicleList* uavList = uavGroupList[gropuIP];
    int type = uavList->data(uavList->index(num),VehicleList::IdentityRole).toInt();
    long long current = uavList->data(uavList->index(num),VehicleList::Failure_TimeRole).toLongLong();
    uavList->deleteUav(num);
    for(int j = 0;j<uavGroupList.count();j++){
        VehicleList* uav_List = uavGroupList[j];
        for(int i =0;i<uav_List->rowCount();i++){
            uav_List->setData(uav_List->index(i), uav_List->data(uav_List->index(i),VehicleList::Failure_TimeRole).toLongLong() - current, VehicleList::Failure_TimeRole);
        }
    }
    Vehicle uav = Vehicle(lat,lon,3);
    uavList->appendUav(uav);

    bool blueflag = false;
    bool yellowflag = false;
    if(type == 1){
        for(int i =0;i<uavList->rowCount();i++){
            if(QVariant(uavList->data(uavList->index(i),VehicleList::IdentityRole)).toInt() == 2 and !blueflag){
                uavList->setData(uavList->index(i), 1, VehicleList::IdentityRole);
                blueflag = true;
                uavList->setData(uavList->index(i), true, VehicleList::ChangeTypeRole);
            }

            if(QVariant(uavList->data(uavList->index(i),VehicleList::IdentityRole)).toInt()==3 and !yellowflag){
                uavList->setData(uavList->index(i), 2, VehicleList::IdentityRole);
                yellowflag = true;
                uavList->setData(uavList->index(i), true, VehicleList::ChangeTypeRole);
            }
        }
    }
    else if(type == 2){
        for(int i =0;i<uavList->rowCount();i++){
            if(QVariant(uavList->data(uavList->index(i),VehicleList::IdentityRole)).toInt()==3 and !yellowflag){
                uavList->setData(uavList->index(i), 2, VehicleList::IdentityRole);
                yellowflag = true;
                uavList->setData(uavList->index(i), true, VehicleList::ChangeTypeRole);
            }
        }
    }
    emit uavGroupListChanged(uavGroupList);
    emit uavtimeChanged();

    for(int j = 0;j<uavGroupList.count();j++){
        VehicleList* uav_List = uavGroupList[j];
        for(int i =0;i<uav_List->rowCount();i++){
            uav_List->setData(uav_List->index(i), false, VehicleList::ChangeTypeRole);
        }
    }
}

void VehicleController::uavrun()
{
    for(int j = 0; j < uavGroupList.count();j++) {
        VehicleList* uavList = uavGroupList[j];
        for(int i = 0; i < uavList->rowCount();i++) {
            double lat = uavList->data(uavList->index(i),VehicleList::LatitudeRole).toDouble() ;
            double lon = uavList->data(uavList->index(i),VehicleList::LongtitudeRole).toDouble();
            lat = lat + 0.001 * uavList-> yorient();
            lon = lon + 0.001 * uavList-> xorient();
            uavList->setData(uavList->index(i), lat, VehicleList::LatitudeRole);
            uavList->setData(uavList->index(i), lon, VehicleList::LongtitudeRole);
        }
    }
    emit uavGroupListChanged(uavGroupList);
}



