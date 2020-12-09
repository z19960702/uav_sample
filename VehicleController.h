#ifndef VEHICLECONTROLLER_H
#define VEHICLECONTROLLER_H


#include <Vehicle.h>
#include <VehicleList.h>

#include <QObject>
#include <QVariant>
#include <QVariantMap>
#include <QVariantList>
#include <QTimer>

#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <vector>
#include <queue>
#include <numeric>
#include <iterator>
#include <math.h>
#include <list>
#include <string.h>
#include <cstdlib>
#include <bits/stdc++.h>
using namespace std;


class VehicleController: public QObject {
    Q_OBJECT

public:
    VehicleController(QObject* parent = nullptr);
    Q_PROPERTY(VehicleList* uavList READ getuavList NOTIFY uavListChanged)
//    Q_PROPERTY(QVariant uavinfo READ getuavinfo NOTIFY uavinfoChanged)
//    Q_INVOKABLE QVariant getCurrentUAVInfo(void);
    Q_INVOKABLE void deleteUav(int index);
//    double Exp(double lambda);
    VehicleList* getuavList(){
        return uavList;
    }
signals:
    void uavListChanged(VehicleList* uavList);
    void uavtimeChanged();
public slots:
    void uavrun();
private:
//    list<UAV_Group>UAV_Group_List;  //创建空list
//    list<UAV>UAV_List;

    VehicleList* uavList;
    QTimer timer;
static int lat_orient;
static int lon_orient;
};

#endif
