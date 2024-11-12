// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:screenshot/screenshot.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'; // New import

class ARDecorScreen extends StatefulWidget {
  const ARDecorScreen({Key? key}) : super(key: key);

  @override
  _ARDecorScreenState createState() => _ARDecorScreenState();
}

class _ARDecorScreenState extends State<ARDecorScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  int currentModelIndex = 0;
  final ScreenshotController screenshotController = ScreenshotController();

  final List<Map<String, String>> modelData = [
  {
    "uri": "https://github.com/KhronosGroup/glTF-Sample-Models/raw/main/2.0/SheenChair/glTF-Binary/SheenChair.glb",
    "name": "Sheen Chair",
    "icon": "🚪"
  },
  {
    "uri": "https://raw.githubusercontent.com/gshahzer/Assets_Ar_Decor_flutter/main/sofa.glb",
    "name": "Black Modern Sofa",
    "icon": "🛋️"
  },
  {
    "uri": "https://github.com/KhronosGroup/glTF-Sample-Models/raw/main/2.0/IridescenceLamp/glTF-Binary/IridescenceLamp.glb",
    "name": "Iridescence Lamp",
    "icon": "💡"
  },
  {
    "uri": "https://raw.githubusercontent.com/gshahzer/Assets_Ar_Decor_flutter/main/arm_chair (1).glb",
    "name": "Arm Chair",
    "icon": "🖼️"
  },
  {
    "uri": "https://raw.githubusercontent.com/gshahzer/Assets_Ar_Decor_flutter/main/Coffee_table.glb",
    "name": "Coffee Table",
    "icon": "🪑"
  },
  {
    "uri": "https://raw.githubusercontent.com/gshahzer/Assets_Ar_Decor_flutter/main/Paintings.glb",
    "name": "Wall Painting",
    "icon": "🖼️"
  },
  {
    "uri": "https://raw.githubusercontent.com/gshahzer/Assets_Ar_Decor_flutter/main/cc0_table_lamp_7.glb",
    "name": "White Lamp",
    "icon": "🛋️"
  },
  {
    "uri": "https://raw.githubusercontent.com/gshahzer/Assets_Ar_Decor_flutter/main/free_pothos_potted_plant_money_plant.glb",
    "name": "Decorative Plant",
    "icon": "🌿"
  },
  {
    "uri": "https://raw.githubusercontent.com/gshahzer/Assets_Ar_Decor_flutter/main/bookshelf.glb",
    "name": "Bookshelf",
    "icon": "📚"
  },
];

   @override
  void initState() {
    super.initState();
    _requestCameraPermission(); // Request camera permission on init
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Decor'),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Stack(
          children: [
            ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            ),
            _buildBottomPanel(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _captureAndSaveScreenshot(context),
        child: const Icon(Icons.camera_alt),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Recommended AR Decor for Your Room, Please Select Elements",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  dropdownColor: Colors.white,
                  value: currentModelIndex,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  items: List.generate(
                    modelData.length,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: Row(
                        children: [
                          Text(
                            modelData[index]["icon"] ?? "❓",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            modelData[index]["name"] ?? "Model ${index + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onChanged: (int? newIndex) {
                    if (newIndex != null) {
                      setState(() {
                        currentModelIndex = newIndex;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRemoveEverything,
              icon: const Icon(Icons.clear_all),
              label: const Text("Remove All"),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                onPrimary: Colors.white,
                shadowColor: Colors.blueAccent.withOpacity(0.4),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager?.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
    );

    this.arObjectManager?.onInitialize();
    this.arSessionManager?.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager?.onNodeTap = onNodeTapped;
  }

  void onNodeTapped(List<String> nodeNames) {
    arSessionManager?.onError("Tapped on node: ${nodeNames.join(', ')}");
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
      (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane,
    );

    var newAnchor = ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
    bool? didAddAnchor = await arAnchorManager?.addAnchor(newAnchor);
     var modelURI = modelData[currentModelIndex]["uri"] ?? "";
    if (didAddAnchor ?? false) {
      anchors.add(newAnchor);
      var newNode = ARNode(
        type: NodeType.webGLB,
        uri: modelURI,
        scale: vm.Vector3(0.5, 0.5, 0.5),
        position: vm.Vector3(0.0, 0.0, 0.0),
        rotation: vm.Vector4(1.0, 0.0, 0.0, 0.0),
      );
      bool? didAddNodeToAnchor = await arObjectManager?.addNode(newNode, planeAnchor: newAnchor);
      if (didAddNodeToAnchor ?? false) {
        nodes.add(newNode);
      } else {
        arSessionManager?.onError("Failed to add node to anchor");
      }
    } else {
      arSessionManager?.onError("Failed to add anchor");
    }
  }

  void onRemoveEverything() {
    nodes.forEach((node) {
      arObjectManager?.removeNode(node);
    });
    nodes.clear();
    anchors.forEach((anchor) {
      arAnchorManager?.removeAnchor(anchor);
    });
    anchors.clear();
  }
  Future<void> _captureAndSaveScreenshot(BuildContext context) async {
    final Uint8List? image = await screenshotController.capture();
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/screenshot.png';
      File(path).writeAsBytesSync(image);
      GallerySaver.saveImage(path).then((bool? success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(success! ? 'Screenshot saved!' : 'Error saving screenshot.')),
        );
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
    if (await Permission.camera.isGranted) {
      // Camera permission granted
      setState(() {});
    } else {
      // Handle the case when the permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        // ignore: prefer_const_constructors
        SnackBar(content: Text('Camera permission is required to use AR features.')),
      );
    }
  }
}
