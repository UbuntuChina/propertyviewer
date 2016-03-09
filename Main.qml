import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.Layouts 1.1

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    id: mainview
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "propertyviewer.xiaoguo"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(60)
    height: units.gu(85)

    property var obj: null
    property var datalist: []

    function createQmlObject(objName) {
        var objStr = "import QtQuick 2.4;
                      import QtQuick.XmlListModel 2.0;
                      import Qt.labs.folderlistmodel 2.1;
                      import Qt.labs.settings 1.0;
                      import QtQuick.Particles 2.0;
                      import QtQuick.Window 2.2;
//                      import QtTest 1.1;
                      import Ubuntu.Components 1.2;
                      import Ubuntu.Components.ListItems 1.0;
                      import Ubuntu.Components.Pickers 1.0;
                      import Ubuntu.Components.Popups 1.0;
                      import Ubuntu.Components.Styles 1.2;
                      import Ubuntu.Layouts 1.0;
                      import Ubuntu.PerformanceMetrics 1.0;
//                      import Ubuntu.Test 1.0;
                      import Ubuntu.Web 0.2;
                      import QtContacts 5.0;
                      import QtLocation 5.3;
                      import QtOrganizer 5.0;
                      import Ubuntu.Content 1.1;
                      import Ubuntu.DownloadManager 0.1;
                      import Ubuntu.OnlineAccounts 0.1;
                      import QtSensors 5.0;
//                      import QtAudioEngine 1.0;
                      import QtMultimedia 5.4;
                      import QtQml 2.2;"

        if ( pack.text != "" ) {
            objStr += "import " + pack.text + ";"
        }

        objStr += objName + "{ id: myid"
        objStr += "}";
        console.log("objStr: " + objStr);
        var obj = Qt.createQmlObject(objStr, page, "myobj");
        return obj
    }

    function getProperties() {
        console.log("it is clicked")
        if ( obj != undefined ) {
            obj.destroy();
        }

        obj = createQmlObject(type.text);

        var list = [];

        list.push(obj.toString());

        // Now get the properties of the obj
        var keys = Object.keys(obj);
        for( var i = 0; i < keys.length; i++ ) {
            var key = keys[ i ];
            var data = key + ' : ' + obj[ key ];
            list.push( data  );
        }

        console.log("Let's dump the data");
        datalist = list;

        for ( key in datalist) {
            console.log( datalist[key] );
        }
    }

    Page {
        id: page
        title: i18n.tr("PropertyViewer")

        property var datalist: ["good"]

        ListModel {
            id: mymodel
        }

        Column {
            anchors.fill: parent
            spacing: units.gu(1.5)

            RowLayout {
                id: search
                spacing: units.gu(1)
                width: parent.width

                TextField {
                    id: type
                    width: parent.width
                    Layout.preferredWidth: parent.width*0.7
                    placeholderText: "A QML type (eg. Rectangle)"
                    hasClearButton: true

                    onAccepted: {
                        getProperties()
                    }
                }

                Button {
                    text: "Get"

                    onClicked: {
                        getProperties()
                    }
                }
            }

            TextField {
                id: pack
                width: parent.width
                placeholderText: "Package name if not detected (eg. QtSensors 5.0) "
                hasClearButton: true
            }

            ListView {
                clip:true
                width: parent.width
                height: parent.height - search.height
                model: datalist;

                delegate: Label {
                    text: modelData
                    fontSize: "large"
                }
            }
        }
    }
}

