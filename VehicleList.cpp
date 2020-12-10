#include "VehicleList.h"
#include <QDebug>

VehicleList::VehicleList(int uavGroupIP, int boatIP,double lat,double lon,QObject* parent)
: QAbstractListModel(parent)
{
    connect(&flighttimer,SIGNAL(timeout()),this,SLOT(uavrunorient()));
    flighttimer.setInterval(30000);
    flighttimer.start();
    _uavGroupIP = uavGroupIP;
    _boatIP = boatIP;

    _centerlat = lat;
    _centerlon = lon;
    _xorient = (double)rand()/(double)RAND_MAX;
    _yorient = (double)rand()/(double)RAND_MAX;
    for(int uav_index=1; uav_index <= UAV_Leader; uav_index++){

        Vehicle uav = Vehicle(lat,lon,1);
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        _uavList << uav;
        endInsertRows();
    }
    for(int uav_index=1; uav_index <= UAV_Part; uav_index++){
        Vehicle uav = Vehicle(lat,lon,2);
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        _uavList << uav;
        endInsertRows();
    }
    for(int uav_index=1; uav_index <= UAV_Num - UAV_Leader - UAV_Part; uav_index++){
        Vehicle uav = Vehicle(lat,lon,3);
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        _uavList << uav;
        endInsertRows();
    }

}

void VehicleList::init(QList<Vehicle> uav)
{
    _uavList = uav;
}

bool VehicleList::setData(const QModelIndex& index, const QVariant& value, int role)
{
    bool result = false;
    if (index.row() < 0 || index.row() >= _uavList.count()) {
        return false;
    }
    Vehicle& p = _uavList[index.row()];
    if (role == LatitudeRole) {
        p.setlatitude(value.toDouble());
        emit dataChanged(index, index);
        result = true;
    } else if (role == LongtitudeRole) {
        p.setlongtitude(value.toDouble());
        emit dataChanged(index, index);
        result = true;
    } else if (role == IdentityRole) {
        p.setidentity(value.toInt());
        emit dataChanged(index, index);
        result = true;
    } else if (role == Failure_TimeRole) {
        p.setfailureTime(value.toLongLong());
        emit dataChanged(index, index);
        result = true;
    }else if (role == UAVIPRole) {
        p.setuavIP(value.toInt());
        emit dataChanged(index, index);
        result = true;
    }else if (role == ChangeTypeRole) {
        p.setchangeType(value.toBool());
        emit dataChanged(index, index);
        result = true;
    }
    return result;
}

void VehicleList::appendUav(const Vehicle& uav)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    _uavList << uav;
    endInsertRows();
}

void VehicleList::deleteUav(int index)
{
    if (rowCount() > index) {
        beginRemoveRows(QModelIndex(), index, index);
        _uavList.removeAt(index);
        endRemoveRows();
    }

}

void VehicleList::insertUav(int index, const Vehicle& point)
{
    if (index <= 0) // prepended
    {
        beginInsertRows(QModelIndex(), 0, 0);
    } else if (index >= rowCount()) { // appended
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
    } else {
        beginInsertRows(QModelIndex(), index, index);
    }
    _uavList.insert(index, point);
    endInsertRows();
}
QHash<int, QByteArray> VehicleList::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Failure_TimeRole] = "failure_Time";
    roles[LatitudeRole]     = "latitude";
    roles[LongtitudeRole]   = "longitude";
    roles[IdentityRole]     = "identity";
    roles[UAVIPRole]        = "uavip";
    roles[ChangeTypeRole]   = "changeType";
    return roles;
}
QVariant VehicleList::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= _uavList.count()) {
        return QVariant();
    }
    const Vehicle& uav = _uavList[index.row()];
    if (role == LatitudeRole) {
        return QVariant::fromValue(uav.latitude());
    } else if (role == LongtitudeRole) {
        return QVariant::fromValue(uav.longtitude());
    } else if (role == IdentityRole) {
        return QVariant::fromValue(uav.identity());
    } else if (role == Failure_TimeRole) {
        return QVariant::fromValue(uav.failureTime());
    }else if (role == UAVIPRole) {
        return QVariant::fromValue(uav.uavIP());
    }else if (role == ChangeTypeRole) {
        return QVariant::fromValue(uav.changeType());
    }
    return QVariant();
}
int VehicleList::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent)
    return _uavList.count();
}


void VehicleList::uavrunorient()
{
     _yorient = -_yorient;
      _xorient = -_xorient;
}
