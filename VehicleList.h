#ifndef VEHICLELIST_H
#define VEHICLELIST_H

#include <QAbstractListModel>
#include <Vehicle.h>

const int UAV_Group_Num = 1;
const int UAV_Num = 5;
const int UAV_Leader = 1;
const int UAV_Part = 2;

class VehicleList : public QAbstractListModel{
    Q_OBJECT
public:
    enum ParameterRoles {
        LatitudeRole        = Qt::UserRole + 1,
        LongtitudeRole      = Qt::UserRole + 2,
        IdentityRole        = Qt::UserRole + 3,
        Failure_TimeRole    = Qt::UserRole + 4
    };
    VehicleList(int uavGroupIP, int boatIP,double lat,double lon, QObject* parent = nullptr);
    void deleteUav(int index);
    void appendUav(const Vehicle& uav);

    void insertUav(int index, const Vehicle& uav);

    QList<Vehicle>      uavList() const { return _uavList; }
    int      boatIP() const { return _boatIP; }
    int      uavGroupIP() const { return _uavGroupIP; }

    // overload
    int      rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    bool     setData(const QModelIndex& index, const QVariant& value, int role);
    void     init(QList<Vehicle> uavList);
    void     clearRemote();

protected:
    QHash<int, QByteArray> roleNames() const;



private:
    QList<Vehicle> _uavList;
    int _uavGroupIP;
    int _boatIP;
};

#endif // VEHICLELIST_H
