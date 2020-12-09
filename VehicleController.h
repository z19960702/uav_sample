#ifndef VEHICLECONTROLLER_H
#define VEHICLECONTROLLER_H


#include <Vehicle.h>
#include <VehicleList.h>

#include <QObject>
#include <QVariant>
#include <QVariantMap>
#include <QVariantList>
#include <QTimer>

#include <math.h>

class VehicleController: public QObject {
    Q_OBJECT

public:
    VehicleController(QObject* parent = nullptr);
    Q_PROPERTY(QList<VehicleList*> uavGroupList READ getuavGroupList NOTIFY uavGroupListChanged)
    Q_INVOKABLE void deleteUav(int gropuIP, int index,double lat,double lon);
    Q_INVOKABLE void createList(int count,QList<int> uavGroupIPList, QList<int> boatIPList,QList<double> lat, QList<double> lon);
    Q_INVOKABLE int getboatIP(int index){
        return uavGroupList[index]->boatIP();
    }
    QList<VehicleList*> getuavGroupList(){
        return uavGroupList;
    }
signals:
    void uavGroupListChanged(QList<VehicleList*> uavGroupList);
    void uavtimeChanged();
public slots:
    void uavrun();
private:
    QList<VehicleList*> uavGroupList;
    QTimer timer;
static int lat_orient;
static int lon_orient;
};

#endif
