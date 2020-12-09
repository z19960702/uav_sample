import QtQuick 2.15
import QtQuick.Window 2.15
import QtLocation 5.6
import QtPositioning 5.6
import QtQml.Models 2.15
import QtQml 2.15

import VehicleController 1.0

Window {
    visibility: Window.Maximized
    visible: true
    title: qsTr("UAV")

    property real latiposition: 18
    property real longposition: 114

    property var uavlistmodel: ListModel {}
    property var boatlistmodel: ListModel {}
    property real uavleadernum: 1
    property real boatleadernum: 1
    property real uavlinelatposition: 0
    property real uavlinelonposition: 0
    property real boatlinelatposition: 0
    property real boatlinelonposition: 0
    property real linesize: 0
    property real xorient: 1
    property real yorient: 1
    property VehicleController vehicle_controller: VehicleController {}
    property var uav_list: vehicle_controller.uavList
    //property var uav_list: vehicle_controller.getCurrentUAVInfo()
    property var parter_uav_list: ListModel {}
    property int shanshuoindex: 0
    property real waittime: 0
    Component.onCompleted: {
        var current_time = 0
        var index = 0
        for (var i = 0; i < uav_list.rowCount(); i++) {
            var uavdata = {
                "lat": uav_list.data(uav_list.index(i, 0), 257),
                "lon": uav_list.data(uav_list.index(i, 0), 258),
                "lastlat": uav_list.data(uav_list.index(i, 0), 257),
                "lastlon": uav_list.data(uav_list.index(i, 0), 258),
                "altitude": 2000,
                "identity": uav_list.data(uav_list.index(i, 0), 259),
                "failuretime": uav_list.data(uav_list.index(i, 0), 260),
                "display": true
            }

            if (i === 0) {
                current_time = uav_list.data(uav_list.index(i, 0), 260)
                index = 0
            } else {
                if (current_time > uav_list.data(uav_list.index(i, 0), 260)) {
                    index = i
                    current_time = uav_list.data(uav_list.index(i, 0), 260)
                }
            }

            uavlistmodel.append(uavdata)
            if (uav_list.data(uav_list.index(i, 0), 259) === 1) {
                uavleadernum = i
            }
            if (uav_list.data(uav_list.index(i, 0), 259) === 2) {
                parter_uav_list.append(uavdata)
            }
        }
        shanshuoindex = index
        chufatimer.interval = current_time
        chufatimer.restart()
        console.log("failuretime" + current_time)
        for (var j = 0; j < 3; j++) {
            var boatdata = {
                "lat": latiposition + Math.random() * 1 - 0.5,
                "lon": longposition + Math.random() * 1 - 0.5,
                "altitude": 0
            }
            boatlistmodel.append(boatdata)
        }
    }

    onUav_listChanged: {
        parter_uav_list.clear()
        for (var i = 0; i < uav_list.rowCount(); i++) {
            uavlistmodel.set(i, {
                                 "lat": uav_list.data(uav_list.index(i, 0),
                                                      257),
                                 "lon": uav_list.data(uav_list.index(i, 0),
                                                      258),
                                 "lastlat": uavlistmodel.get(i).lastlat,
                                 "lastlon": uavlistmodel.get(i).lastlon,
                                 "altitude": 2000,
                                 "identity": uav_list.data(uav_list.index(i,
                                                                          0),
                                                           259)
                             })
            if (uav_list.data(uav_list.index(i, 0), 259) === 1) {
                uavleadernum = i
            }
            if (uav_list.data(uav_list.index(i, 0), 259) === 2) {
                parter_uav_list.append(uavlistmodel.get(i))
            }
        }
    }
    Connections {
        target: vehicle_controller
        function onUavtimeChanged() {
            parter_uav_list.clear()
            var current_time = 0
            var index = 0
            for (var i = 0; i < uav_list.rowCount(); i++) {
                uavlistmodel.set(i, {
                                     "lat": uav_list.data(uav_list.index(i, 0),
                                                          257),
                                     "lon": uav_list.data(uav_list.index(i, 0),
                                                          258),
                                     "lastlat": uavlistmodel.get(i).lastlat,
                                     "lastlon": uavlistmodel.get(i).lastlon,
                                     "altitude": 2000,
                                     "identity": uav_list.data(uav_list.index(
                                                                   i, 0), 259),
                                     "display": true
                                 })
                if (uav_list.data(uav_list.index(i, 0), 259) === 1) {
                    uavleadernum = i
                }
                if (uav_list.data(uav_list.index(i, 0), 259) === 2) {
                    parter_uav_list.append(uavlistmodel.get(i))
                }
                if (i === 0) {
                    current_time = uav_list.data(uav_list.index(i, 0), 260)
                    index = 0
                } else {
                    if (current_time > uav_list.data(uav_list.index(i,
                                                                    0), 260)) {
                        index = i
                        current_time = uav_list.data(uav_list.index(i, 0), 260)
                    }
                }
            }
            shanshuoindex = index
            chufatimer.interval = current_time
            chufatimer.restart()
        }
    }
    //用于飞机与船的动态连线的动画显示
    Timer {
        id: linetimer
        interval: 10
        running: true
        repeat: true
        onTriggered: {
            if (linesize == 100)
                linesize = 0
            uavpolyline.opacity = 0.01 * linesize
            boatpolyline.opacity = 0.01 * linesize
            jiantou1.opacity = 0.01 * linesize
            jiantou2.opacity = 0.01 * linesize
            jiantou3.opacity = 0.01 * linesize
            jiantou4.opacity = 0.01 * linesize
            uavlinelatposition = boatlistmodel.get(
                        boatleadernum).lat + (uavlistmodel.get(
                                                  uavleadernum).lat - boatlistmodel.get(
                                                  boatleadernum).lat) * 0.01 * linesize
            uavlinelonposition = boatlistmodel.get(
                        boatleadernum).lon + (uavlistmodel.get(
                                                  uavleadernum).lon - boatlistmodel.get(
                                                  boatleadernum).lon) * 0.01 * linesize
            uavpolyline.path = [{
                                    "latitude": uavlinelatposition,
                                    "longitude": uavlinelonposition
                                }, {
                                    "latitude": boatlistmodel.get(
                                                    boatleadernum).lat,
                                    "longitude": boatlistmodel.get(
                                                     boatleadernum).lon
                                }]
            boatlinelatposition = uavlistmodel.get(
                        uavleadernum).lat + (boatlistmodel.get(
                                                 boatleadernum).lat - uavlistmodel.get(
                                                 uavleadernum).lat) * 0.01 * linesize
            boatlinelonposition = uavlistmodel.get(
                        uavleadernum).lon + (boatlistmodel.get(
                                                 boatleadernum).lon - uavlistmodel.get(
                                                 uavleadernum).lon) * 0.01 * linesize
            boatpolyline.path = [{
                                     "latitude": uavlistmodel.get(
                                                     uavleadernum).lat,
                                     "longitude": uavlistmodel.get(
                                                      uavleadernum).lon
                                 }, {
                                     "latitude": boatlinelatposition,
                                     "longitude": boatlinelonposition
                                 }]
            jiantou1.coordinate = QtPositioning.coordinate(uavlinelatposition,
                                                           uavlinelonposition)
            jiantou1.rotation = QtPositioning.coordinate(
                        uavlinelatposition, uavlinelonposition).azimuthTo(
                        QtPositioning.coordinate(
                            boatlistmodel.get(boatleadernum).lat,
                            boatlistmodel.get(boatleadernum).lon))

            jiantou2.coordinate = QtPositioning.coordinate(boatlinelatposition,
                                                           boatlinelonposition)
            jiantou2.rotation = QtPositioning.coordinate(
                        boatlinelatposition, boatlinelonposition).azimuthTo(
                        QtPositioning.coordinate(
                            uavlistmodel.get(uavleadernum).lat,
                            uavlistmodel.get(uavleadernum).lon))

            jiantou3.coordinate = QtPositioning.coordinate(
                        boatlistmodel.get(boatleadernum).lat,
                        boatlistmodel.get(boatleadernum).lon)
            jiantou3.rotation = 180 + QtPositioning.coordinate(
                        uavlinelatposition, uavlinelonposition).azimuthTo(
                        QtPositioning.coordinate(
                            boatlistmodel.get(boatleadernum).lat,
                            boatlistmodel.get(boatleadernum).lon))

            jiantou4.coordinate = QtPositioning.coordinate(
                        uavlistmodel.get(uavleadernum).lat,
                        uavlistmodel.get(uavleadernum).lon)
            jiantou4.rotation = 180 + QtPositioning.coordinate(
                        boatlinelatposition, boatlinelonposition).azimuthTo(
                        QtPositioning.coordinate(
                            uavlistmodel.get(uavleadernum).lat,
                            uavlistmodel.get(uavleadernum).lon))

            linesize++
        }
    }

    Timer {
        id: chufatimer
        onTriggered: {
            shanshuotimer.running = true
            xiaoshitimer.running = true
        }
    }
    Timer {
        id: shanshuotimer
        interval: 100
        repeat: true
        onTriggered: {
            uavlistmodel.get(shanshuoindex).display = !uavlistmodel.get(
                        shanshuoindex).display
        }
    }

    Timer {
        id: xiaoshitimer
        interval: 2000
        onTriggered: {
            shanshuotimer.running = false
            console.log("index" + shanshuoindex)
            vehicle_controller.deleteUav(shanshuoindex)
        }
    }

    Plugin {
        id: mapPlugin
        name: "esri"
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(latiposition, longposition) //南海区域的经纬度
        zoomLevel: 7
        MapPolyline {
            id: uavpolyline
            line.width: 2
            line.color: 'green'
            transform: Translate {
                y: y + 2
            }
            opacity: 0
        }
        MapQuickItem {
            id: jiantou1
            anchorPoint.x: sourceItem.width / 2
            anchorPoint.y: sourceItem.height / 2
            transform: Translate {
                y: y + 2
            }
            sourceItem: Item {
                width: 10
                height: 10
                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                }
                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.fillStyle = "green"
                        ctx.moveTo(0, 0)
                        ctx.lineTo(10, 0)
                        ctx.lineTo(5, 10)
                        ctx.lineTo(0, 0)
                        ctx.fill()
                    }
                }
            }
        }
        MapQuickItem {
            id: jiantou3
            anchorPoint.x: sourceItem.width / 2
            anchorPoint.y: sourceItem.height / 2
            transform: Translate {
                y: y + 2
            }
            sourceItem: Item {
                width: 10
                height: 10
                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                }
                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.fillStyle = "green"
                        ctx.moveTo(0, 0)
                        ctx.lineTo(10, 0)
                        ctx.lineTo(5, 10)
                        ctx.lineTo(0, 0)
                        ctx.fill()
                    }
                }
            }
        }

        MapPolyline {
            id: boatpolyline
            line.width: 2
            line.color: 'orange'
            transform: Translate {
                y: y - 2
            }
        }
        MapQuickItem {
            id: jiantou2
            anchorPoint.x: sourceItem.width / 2
            anchorPoint.y: sourceItem.height / 2
            transform: Translate {
                y: y - 2
            }
            sourceItem: Item {
                width: 10
                height: 10
                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                }
                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.fillStyle = "orange"
                        ctx.moveTo(0, 0)
                        ctx.lineTo(10, 0)
                        ctx.lineTo(5, 10)
                        ctx.lineTo(0, 0)
                        ctx.fill()
                    }
                }
            }
        }

        MapQuickItem {
            id: jiantou4
            anchorPoint.x: sourceItem.width / 2
            anchorPoint.y: sourceItem.height / 2
            transform: Translate {
                y: y - 2
            }
            sourceItem: Item {
                width: 10
                height: 10
                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                }
                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.fillStyle = "orange"
                        ctx.moveTo(0, 0)
                        ctx.lineTo(10, 0)
                        ctx.lineTo(5, 10)
                        ctx.lineTo(0, 0)
                        ctx.fill()
                    }
                }
            }
        }
        MapItemView {
            model: parter_uav_list
            delegate: MapPolyline {
                id: polyline
                visible: true
                line.width: 2
                line.color: "skyblue"
                path: [{
                        "latitude": lat,
                        "longitude": lon
                    }, {
                        "latitude": uavlistmodel.get(uavleadernum).lat,
                        "longitude": uavlistmodel.get(uavleadernum).lon
                    }]
            }
        }
        //小船
        MapItemView {
            model: boatlistmodel
            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(lat, lon, altitude)
                anchorPoint.x: boatItem.width / 2
                anchorPoint.y: boatItem.height / 2
                sourceItem: Item {
                    id: boatItem
                    width: 20
                    height: 20
                    transform: Rotation {
                        origin.x: boatItem.width / 2
                        origin.y: boatItem.height / 2
                    }
                    Image {
                        anchors.fill: parent
                        source: "qrc:/boat.svg"
                    }
                }
            }
        }

        MapItemView {
            id: uavshow
            model: uavlistmodel
            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(lat, lon, altitude)
                anchorPoint.x: sourceItem.width / 2
                anchorPoint.y: sourceItem.height / 2
                sourceItem: Item {
                    id: vehicleItem
                    width: 40
                    height: 20
                    visible: display
                    property color uav_color: identity == 1 ? "red" : identity
                                                              == 2 ? "blue" : "yellow"
                    transform: Rotation {
                        origin.x: vehicleItem.width / 2
                        origin.y: vehicleItem.height / 2
                    }
                    Item {
                        id: name
                        anchors.fill: parent
                        rotation: 180 + QtPositioning.coordinate(
                                      lat, lon, altitude).azimuthTo(
                                      QtPositioning.coordinate(lastlat,
                                                               lastlon,
                                                               altitude))
                        Rectangle {
                            width: 2
                            height: 20
                            color: vehicleItem.uav_color
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                        }
                        Rectangle {
                            width: 40
                            height: 2
                            color: vehicleItem.uav_color
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                        }
                        Rectangle {
                            width: 8
                            height: 2
                            color: vehicleItem.uav_color
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                        }
                    }
                }
            }
        }
    }
}
