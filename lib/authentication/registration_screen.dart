import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../exceptions/error_dialog.dart';
import '../exceptions/loading_dialog.dart';
import '../global/global_instance_or_variable.dart';
import '../presentation/color_manager.dart';
import '../widgets/container_decoration.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum FilterOption {
  //assigning label of interger
  Camera,
  Gallery,
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();
  String? completeAddress;
  var imagePath;
  String? riderImageUrl;

  bool isLoading = false;

  Position? position;
  List<Placemark>? placeMarks;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> pickedImageFromCamera() async {
    imageXFile = await _imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imagePath = File(imageXFile!.path);
    });
  }

  Future<void> pickedImageFromGallery() async {
    imageXFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = File(imageXFile!.path);
    });
  }

  Future uploadProfileImage() async {
    String? imagePathToString = imagePath.toString();
    var _splitImagePath = imagePathToString.split("/")[6];
    UploadTask? uploadTask;
    try {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('/riderImage/${_splitImagePath}');
      uploadTask = reference.putFile(imagePath);
    } on FirebaseException catch (error) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(error.code);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      var err =
          "An unknown error occurrred.\n\nplease check internet connection";
      _showErrorDialog(err);
    }
    //TaskSnapshot snapshot = await uploadTask!;
    TaskSnapshot snapshot = await uploadTask!.whenComplete(() {});
    //sellerImageUrl = await snapshot.ref.getDownloadURL();
    await snapshot.ref.getDownloadURL().then((url) {
      //sellerImageUrl = url;
      riderImageUrl = url;
      authenticateRiderAndSignUp();
    });
    //return sellerImageUrl;
  }

  Future<void> _formvalidationAndSave() async {
    if (imageXFile == null) {
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              message: "Please upload an image",
            );
          });
    }

    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    //_formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    uploadProfileImage();
  }

  Future authenticateRiderAndSignUp() async {

    try {
      //firebaseAuth = thiis variable from global_instance_or_variable file
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        saveDataToFireStore(userCredential.user!).then((value) {
          Navigator.pop(context);
          //send the seller to homepage
         // Navigator.push(context,
          //    MaterialPageRoute(builder: (context) => SellerHomeScreen()));
        });
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        isLoading = false;
      });
      // if (error.code == 'weak-password') {
      // } else if (error.code == 'email-already-in-use') {}
      _showErrorDialog(error.message!);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      var errMessage = "Could not authenticate.\nPlease try later.";
      _showErrorDialog(errMessage);
    }
  }

  Future saveDataToFireStore(User currentRider) async {
    //doc(current.uid) =all the seller information with the unique id.
    //uid will come from firebase auth(uid = User UID == check there in firebase auth)
    FirebaseFirestore.instance
        .collection("riders")
        .doc(currentRider.uid)
        .set({
      "riderUID": currentRider.uid,
      "riderEmail": currentRider.email,
      //trim() = for removing extra space
      "riderName": nameController.text.trim(),
      "riderAvatarUrl": riderImageUrl,
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "status": "approved",
      "earnings": 0.0,
      "latitude": position!.latitude,
      "longitude": position!.longitude,
    });
    //save data locally with sharedPrefernces
    sPref = await SharedPreferences.getInstance();
    //here uid and email come from firebase authectication. because if they are authenticate then
    //all data will store into firbase database
    await sPref!.setString("uid", currentRider.uid);
    await sPref!.setString("email", currentRider.email.toString());
    await sPref!.setString("name", nameController.text.trim());
    await sPref!.setString("photoUrl", riderImageUrl!);
  }

  getCurrentLocation() async {
    //by default permission stays denied. so it needs to send request to the usesr
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    //it will provide multiple location but exact location is in index[0]
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    //to get exact location
    Placemark pMark = placeMarks![0];
    //to get complete address
    completeAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare},${pMark.subLocality} ${pMark.locality},${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    //now assign completeAddress inside of locationController.text
    locationController.text = completeAddress!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register form"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const ContainerDecoration().decoaration(),
        ),
      ),
      body: isLoading == true
          ? Center(
              child: LoadingDailog(
                message: "Registering Account",
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              decoration: const ContainerDecoration().decoaration(),
              //color: Colors.red,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.20,
                            backgroundColor: Colors.white,
                            backgroundImage: imageXFile == null
                                ? null
                                : FileImage(File(imageXFile!.path)),
                            child: PopupMenuButton(
                              onSelected: (selectedValue) {
                                if (selectedValue == FilterOption.Camera) {
                                  setState(() {
                                    pickedImageFromCamera();
                                  });
                                } else {
                                  setState(() {
                                    pickedImageFromGallery();
                                  });
                                }
                              },
                              //icon: Icon(Icons.person),
                              child: imageXFile == null
                                  ? Icon(
                                      Icons.add_photo_alternate,
                                      size: MediaQuery.of(context).size.width *
                                          0.30,
                                    )
                                  : Visibility(
                                      visible: false,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Icon(
                                        Icons.add_photo_alternate,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                      ),
                                    ),
                              itemBuilder: (value) => [
                                const PopupMenuItem(
                                  child: Text("Camera"),
                                  value: FilterOption.Camera,
                                ),
                                const PopupMenuItem(
                                  child: Text("Gellery"),
                                  value: FilterOption.Gallery,
                                )
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 2),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide.none),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.cyan,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Name",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter a name";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 2),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide.none),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.cyan,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "email",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "please enter an email";
                                } else if (!value.contains('@')) {
                                  return "Invalid email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 2),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide.none),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.cyan,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "password",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "please enter password";
                                } else if (value.length < 6) {
                                  return "password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: confirmPasswordController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 2),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide.none),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.cyan,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "confirm password",
                              ),
                              validator: (value) {
                                if (value != passwordController.text) {
                                  return "passwords do not match";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                //isCollapsed: true,
                                //isDense: true,
                                contentPadding:
                                    EdgeInsets.only(right: 2, left: 2),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.cyan,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "phone",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "please enter a phone number";
                                } else if (value.length < 11) {
                                  return "number must be 11 digits";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: locationController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 2.0),
                                filled: true,
                                fillColor: Colors.white,
                                //isDense: true,
                                //isCollapsed: true,
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Colors.cyan,
                                ),
                                // prefixIcon: SizedBox(
                                //   child: Center(
                                //     widthFactor: 0.0,
                                //     child: Icon(Icons.location_on),
                                //   ),
                                // ),
                                hintText: "My Current Address",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  //gapPadding: 1,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter an address";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: 400,
                              height: 40,
                              alignment: Alignment.center,
                              child: ElevatedButton.icon(
                                label: const Text(
                                  "Get my Current Location",
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: const Icon(
                                  Icons.location_on,
                                  color: Colors.cyan,
                                ),
                                onPressed: () {
                                  getCurrentLocation();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: ColorManager.purple3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      ElevatedButton(
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: ColorManager.green2),
                          ),
                        ),
                        onPressed: () {
                          _formvalidationAndSave();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
