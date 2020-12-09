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

    property real latposition: 18
    property real lonposition: 114
    property var uavlistmodel: ListModel {}
    property var boatlistmodel: ListModel {}
    property var leader_boat_list: ListModel {} //leader和船之间的连线
    property var parter_uav_list: ListModel {} //leader和partner之间的连线

    property real uavlinelatposition: 0
    property real uavlinelonposition: 0
    property real boatlinelatposition: 0
    property real boatlinelonposition: 0
    property real linesize: 0
    property var vehicle_controller: VehicleController {}
    property var uav_list: vehicle_controller.uavGroupList
    property int shanshuoindex: 0
    property int shanshuogroupindex: 0
    property int shanshuouavindex: 0
    property real waittime: 0
    property var boatlist: []
    property var latlist: [17, 18, 19]
    property var lonlist: [110, 114, 118]
    //构建Controller
    function showUAVInfo() {}
    Component.onCompleted: {
        var uavlist = [1, 2, 3]
        boatlist = [0, 0, 1]

        vehicle_controller.createList(3, uavlist, boatlist, latlist, lonlist)

        boatlistmodel.clear()
        uavlistmodel.clear()
        parter_uav_list.clear()
        leader_boat_list.clear()
        for (var k = 0; k < 3; k++) {
            var boatdata = {
                "lat": latposition + Math.random() * 1 - 0.5,
                "lon": lonposition + Math.random() * 1 - 0.5,
                "boatIP": k
            }
            boatlistmodel.append(boatdata)
        }
        var current_time = 1000000000

        var uav_index = 0
        for (var j = 0; j < uav_list.length; j++) {
            var leaderlat = 0
            var leaderlon = 0
            var uavgroup = uav_list[j]
            var boatip = vehicle_controller.getboatIP(j)
            for (var i = 0; i < uavgroup.rowCount(); i++) {
                var uavdata = {
                    "lat": uavgroup.data(uavgroup.index(i, 0), 257),
                    "lon": uavgroup.data(uavgroup.index(i, 0), 258),
                    "lastlat": uavgroup.data(uavgroup.index(i, 0), 257),
                    "lastlon": uavgroup.data(uavgroup.index(i, 0), 258),
                    "identity": uavgroup.data(uavgroup.index(i, 0), 259),
                    "failuretime": uavgroup.data(uavgroup.index(i, 0), 260),
                    "boatNum": boatip,
                    "display": true
                }
                if (current_time > uavgroup.data(uavgroup.index(i, 0), 260)) {
                    shanshuoindex = i
                    shanshuogroupindex = j
                    shanshuouavindex = uav_index
                    current_time = uavgroup.data(uavgroup.index(i, 0), 260)
                }
                uavlistmodel.append(uavdata)
                if (uavgroup.data(uavgroup.index(i, 0), 259) === 1) {
                    var data1 = {
                        "uavlat": uavgroup.data(uavgroup.index(i, 0), 257),
                        "uavlon": uavgroup.data(uavgroup.index(i, 0), 258),
                        "boatlat": boatlistmodel.get(boatlist[j]).lat,
                        "boatlon": boatlistmodel.get(boatlist[j]).lon,
                        "touavlat": 0,
                        "touavlon": 0,
                        "toboatlat": 0,
                        "toboatlon": 0
                    }
                    leaderlat = uavgroup.data(uavgroup.index(i, 0), 257)
                    leaderlon = uavgroup.data(uavgroup.index(i, 0), 258)
                    leader_boat_list.append(data1)
                }
                if (uavgroup.data(uavgroup.index(i, 0), 259) === 2) {
                    var data2 = {
                        "leaderlat": leaderlat,
                        "leaderlon": leaderlon,
                        "partnerlat": uavgroup.data(uavgroup.index(i, 0), 257),
                        "partnerlon": uavgroup.data(uavgroup.index(i, 0), 258)
                    }
                    parter_uav_list.append(data2)
                }
                uav_index++
            }
        }
        shanshuouavindex = chufatimer.interval = current_time
        chufatimer.restart()
    }

    onUav_listChanged: {
        var uav_index = 0
        var leader_boat_index = 0
        var parter_uav_index = 0
        for (var j = 0; j < uav_list.length; j++) {
            var leaderlat = 0
            var leaderlon = 0
            var uavgroup = uav_list[j]
            for (var i = 0; i < uavgroup.rowCount(); i++) {
                var uavdata = {
                    "lat": uavgroup.data(uavgroup.index(i, 0), 257),
                    "lon": uavgroup.data(uavgroup.index(i, 0), 258),
                    "lastlat": uavlistmodel.get(uav_index).lastlat,
                    "lastlon": uavlistmodel.get(uav_index).lastlon,
                    "identity": uavgroup.data(uavgroup.index(i, 0), 259),
                    "failuretime": uavgroup.data(uavgroup.index(i, 0), 260),
                    "display": true
                }
                uavlistmodel.set(uav_index, uavdata)
                if (uavgroup.data(uavgroup.index(i, 0), 259) === 1) {
                    var data1 = {
                        "uavlat": uavgroup.data(uavgroup.index(i, 0), 257),
                        "uavlon": uavgroup.data(uavgroup.index(i, 0), 258)
                    }
                    leaderlat = uavgroup.data(uavgroup.index(i, 0), 257)
                    leaderlon = uavgroup.data(uavgroup.index(i, 0), 258)
                    leader_boat_list.set(leader_boat_index, data1)
                    leader_boat_index++
                }
                if (uavgroup.data(uavgroup.index(i, 0), 259) === 2) {
                    var data2 = {
                        "leaderlat": leaderlat,
                        "leaderlon": leaderlon,
                        "partnerlat": uavgroup.data(uavgroup.index(i, 0), 257),
                        "partnerlon": uavgroup.data(uavgroup.index(i, 0), 258)
                    }
                    parter_uav_list.set(parter_uav_index, data2)
                    parter_uav_index++
                }
                uav_index++
            }
        }
    }

    Connections {
        target: vehicle_controller
        function onUavtimeChanged() {
            var current_time = 1000000000
            var uav_index = 0
            var leader_boat_index = 0
            var parter_uav_index = 0
            for (var j = 0; j < uav_list.length; j++) {
                var leaderlat = 0
                var leaderlon = 0
                var uavgroup = uav_list[j]
                var boatip = vehicle_controller.getboatIP(j)
                for (var i = 0; i < uavgroup.rowCount(); i++) {
                    var uavdata = {
                        "lat": uavgroup.data(uavgroup.index(i, 0), 257),
                        "lon": uavgroup.data(uavgroup.index(i, 0), 258),
                        "lastlat": uavlistmodel.get(uav_index).lastlat,
                        "lastlon": uavlistmodel.get(uav_index).lastlon,
                        "identity": uavgroup.data(uavgroup.index(i, 0), 259),
                        "failuretime": uavgroup.data(uavgroup.index(i, 0), 260),
                        "display": true
                    }
                    uavlistmodel.set(uav_index, uavdata)
                    if (current_time > uavgroup.data(uavgroup.index(i,
                                                                    0), 260)) {
                        shanshuoindex = i
                        shanshuogroupindex = j
                        shanshuouavindex = uav_index
                        current_time = uavgroup.data(uavgroup.index(i, 0), 260)
                    }
                    if (uavgroup.data(uavgroup.index(i, 0), 259) === 1) {
                        var data1 = {
                            "uavlat": uavgroup.data(uavgroup.index(i, 0), 257),
                            "uavlon": uavgroup.data(uavgroup.index(i, 0), 258)
                        }
                        leaderlat = uavgroup.data(uavgroup.index(i, 0), 257)
                        leaderlon = uavgroup.data(uavgroup.index(i, 0), 258)
                        leader_boat_list.set(leader_boat_index, data1)
                        leader_boat_index++
                    }
                    if (uavgroup.data(uavgroup.index(i, 0), 259) === 2) {
                        var data2 = {
                            "leaderlat": leaderlat,
                            "leaderlon": leaderlon,
                            "partnerlat": uavgroup.data(uavgroup.index(i, 0),
                                                        257),
                            "partnerlon": uavgroup.data(uavgroup.index(i, 0),
                                                        258)
                        }
                        parter_uav_list.set(parter_uav_index, data2)
                        parter_uav_index++
                    }
                    uav_index++
                }
            }
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
            for (var i = 0; i < leader_boat_list.count; i++) {
                leader_boat_list.get(i).touavlat = leader_boat_list.get(
                            i).boatlat + ((leader_boat_list.get(
                                               i).uavlat - leader_boat_list.get(
                                               i).boatlat) * 0.01 * linesize)
                leader_boat_list.get(i).touavlon = leader_boat_list.get(
                            i).boatlon + ((leader_boat_list.get(
                                               i).uavlon - leader_boat_list.get(
                                               i).boatlon) * 0.01 * linesize)
                leader_boat_list.get(i).toboatlat = leader_boat_list.get(
                            i).uavlat + ((leader_boat_list.get(
                                              i).boatlat - leader_boat_list.get(
                                              i).uavlat) * 0.01 * linesize)
                leader_boat_list.get(i).toboatlon = leader_boat_list.get(
                            i).uavlon + ((leader_boat_list.get(
                                              i).boatlon - leader_boat_list.get(
                                              i).uavlon) * 0.01 * linesize)
            }

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
            uavlistmodel.get(shanshuouavindex).display = !uavlistmodel.get(
                        shanshuouavindex).display
        }
    }

    Timer {
        id: xiaoshitimer
        interval: 2000
        onTriggered: {
            shanshuotimer.running = false
            vehicle_controller.deleteUav(shanshuogroupindex, shanshuoindex,
                                         latlist[shanshuogroupindex],
                                         lonlist[shanshuogroupindex])
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
        center: QtPositioning.coordinate(latposition, lonposition) //南海区域的经纬度
        zoomLevel: 7
        MapItemView {
            id: uavpolyline
            model: leader_boat_list
            delegate: MapPolyline {
                line.width: 2
                line.color: 'green'
                path: [{
                        "latitude": boatlat,
                        "longitude": boatlon
                    }, {
                        "latitude": touavlat,
                        "longitude": touavlon
                    }]
                transform: Translate {
                    y: 2
                }
            }
        }
        MapItemView {
            id: jiantou1
            model: leader_boat_list
            delegate: MapQuickItem {

                coordinate: QtPositioning.coordinate(touavlat, touavlon)
                anchorPoint.x: sourceItem.width / 2
                anchorPoint.y: sourceItem.height / 2
                transform: Translate {
                    y: 2
                }
                rotation: QtPositioning.coordinate(touavlat,
                                                   touavlon).azimuthTo(
                              QtPositioning.coordinate(boatlat, boatlon))
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
        }
        MapItemView {
            id: jiantou3
            model: leader_boat_list
            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(boatlat, boatlon)
                anchorPoint.x: sourceItem.width / 2
                anchorPoint.y: sourceItem.height / 2
                transform: Translate {
                    y: 2
                }
                rotation: 180 + QtPositioning.coordinate(touavlat,
                                                         touavlon).azimuthTo(
                              QtPositioning.coordinate(boatlat, boatlon))
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
        }
        MapItemView {
            id: boatpolyline
            model: leader_boat_list
            delegate: MapPolyline {
                line.width: 2
                line.color: 'orange'
                path: [{
                        "latitude": uavlat,
                        "longitude": uavlon
                    }, {
                        "latitude": toboatlat,
                        "longitude": toboatlon
                    }]
                transform: Translate {
                    y: 2
                }
            }
        }
        MapItemView {
            id: jiantou2
            model: leader_boat_list
            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(toboatlat, toboatlon)
                anchorPoint.x: sourceItem.width / 2
                anchorPoint.y: sourceItem.height / 2
                transform: Translate {
                    y: 2
                }
                rotation: QtPositioning.coordinate(toboatlat,
                                                   toboatlon).azimuthTo(
                              QtPositioning.coordinate(uavlat, uavlon))
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
        }
        MapItemView {
            id: jiantou4
            model: leader_boat_list
            delegate: MapQuickItem {

                coordinate: QtPositioning.coordinate(uavlat, uavlon)
                anchorPoint.x: sourceItem.width / 2
                anchorPoint.y: sourceItem.height / 2
                transform: Translate {
                    y: 2
                }
                rotation: 180 + QtPositioning.coordinate(toboatlat,
                                                         toboatlon).azimuthTo(
                              QtPositioning.coordinate(uavlat, uavlon))
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
        }
        MapItemView {
            model: parter_uav_list
            delegate: MapPolyline {
                id: polyline
                visible: true
                line.width: 2
                line.color: "skyblue"
                path: [{
                        "latitude": leaderlat,
                        "longitude": leaderlon
                    }, {
                        "latitude": partnerlat,
                        "longitude": partnerlon
                    }]
            }
        }

        //小船
        MapItemView {
            model: boatlistmodel
            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(lat, lon)
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
                coordinate: QtPositioning.coordinate(lat, lon)
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
                        rotation: 180 + QtPositioning.coordinate(lat,
                                                                 lon).azimuthTo(
                                      QtPositioning.coordinate(lastlat,
                                                               lastlon))
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
