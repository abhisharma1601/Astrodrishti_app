// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:kd/brain/wids.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:url_launcher/url_launcher.dart';

// class entry extends StatefulWidget {
//   entry({this.email});
//   String email;
//   @override
//   _entryState createState() => _entryState();
// }

// class _entryState extends State<entry> {
//   TextEditingController namect = new TextEditingController();
//   TextEditingController topic = new TextEditingController();
//   TextEditingController numb = new TextEditingController();
//   bool check = false;
//   String filename, filenamee = "Select PDF/DOCX File";
//   File result;
//   bool spin = false;

//   _launchURL(String ur) async {
//     if (await canLaunch(ur)) {
//       await launch(ur);
//     } else {
//       throw 'Could not launch $ur';
//     }
//   }

//   Widget x1 = Container(
//     margin: EdgeInsets.fromLTRB(10, 0, 15, 15),
//     padding: EdgeInsets.all(6),
//     decoration: BoxDecoration(
//       color: Colors.black,
//       borderRadius: BorderRadius.circular(10),
//       border: Border.all(color: Colors.white.withOpacity(0.5)),
//     ),
//     child: Center(
//       child: Text(
//         "Submit Entry",
//         style: TextStyle(
//             color: Colors.white.withOpacity(0.5),
//             fontSize: 32,
//             fontWeight: FontWeight.bold),
//       ),
//     ),
//   );
//   Widget x2 = Container(
//     margin: EdgeInsets.fromLTRB(10, 0, 15, 15),
//     padding: EdgeInsets.all(6),
//     decoration: BoxDecoration(
//       color: Colors.amberAccent[700],
//       borderRadius: BorderRadius.circular(10),
//       border: Border.all(color: Colors.white),
//     ),
//     child: Center(
//       child: Text(
//         "Submit Entry",
//         style: TextStyle(
//             color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
//       ),
//     ),
//   );

//   thanks() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return ModalProgressHUD(
//             opacity: 0.0,
//             inAsyncCall: spin,
//             progressIndicator: RefreshProgressIndicator(),
//             child: Dialog(
//                 child: Container(
//               height: 150,
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.red),
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10)),
//               padding: EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   Center(
//                     child: Text(
//                       "Thank You",
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 35,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Center(
//                     child: Text(
//                       "Your data has been saved in our database.",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomPadding: false,
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.amberAccent[700],
//         title: Text(
//           "Contest Entry",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 28,
//           ),
//         ),
//       ),
//       body: ModalProgressHUD(
//         opacity: 0.0,
//         inAsyncCall: spin,
//         progressIndicator: RefreshProgressIndicator(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             SizedBox(height: 5),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Text(
//                 "Enter your Data:",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 35,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 5, 15, 10),
//               child: Txtfld(contro: namect, txt: "Enter Name"),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 5, 15, 10),
//               child: Txtfld(contro: topic, txt: "Topic"),
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Container(
//                     margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.amberAccent[700]),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: Center(
//                         child: Text(
//                       "+91",
//                       style: TextStyle(fontSize: 15, color: Colors.white),
//                     )),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(5, 5, 15, 10),
//                     child: Txtfld(contro: numb, txt: "G-Pay/Paytm Number"),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//               child: Text(
//                 "Attach File:",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 35,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             GestureDetector(
//               onTap: () async {
//                 result = await FilePicker.getFile(type: FileType.any);
//                 filename = "${widget.email} Blog";
//                 setState(() {
//                   filenamee = "File Selected";
//                 });
//               },
//               child: Container(
//                   padding: EdgeInsets.all(15),
//                   margin: EdgeInsets.fromLTRB(10, 10, 15, 10),
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.amberAccent[700]),
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Text(
//                     "$filenamee",
//                     style: TextStyle(
//                         color: Colors.white.withOpacity(0.5), fontSize: 18),
//                   )),
//             ),
//             Row(
//               children: <Widget>[
//                 Checkbox(
//                     activeColor: Colors.black,
//                     checkColor: Colors.amberAccent[700],
//                     value: check,
//                     onChanged: (val) {
//                       setState(() {
//                         if (check == false) {
//                           if (filenamee != "Select PDF/DOCX File") {
//                             check = true;
//                             x1 = GestureDetector(
//                                 onTap: () async {
//                                   setState(() {
//                                     spin = true;
//                                   });
//                                   StorageReference reference = FirebaseStorage
//                                       .instance
//                                       .ref()
//                                       .child("Blogs/$filename");
//                                   StorageUploadTask uploadTask = reference
//                                       .putData(result.readAsBytesSync());
//                                   String url =
//                                       await (await uploadTask.onComplete)
//                                           .ref
//                                           .getDownloadURL();
//                                   if (namect.text != "" &&
//                                       topic.text != "" &&
//                                       numb.text != "") {
//                                     if (_isNumeric(numb.text) == true &&
//                                         numb.text.length == 10) {
//                                       await FirebaseFirestore.instance
//                                           .collection("contest")
//                                           .doc("bloggers")
//                                           .collection("emails")
//                                           .doc(widget.email)
//                                           .set({
//                                         "Name": namect.text.toUpperCase(),
//                                         "Topic": topic.text.toUpperCase(),
//                                         "Number": numb.text,
//                                         "link": url
//                                       });
//                                       Navigator.pop(context);
//                                       thanks();
//                                     } else {
//                                       showtoastinvalidnum();
//                                     }
//                                   } else {
//                                     showtoastempty();
//                                   }
//                                   setState(() {
//                                     spin = false;
//                                   });
//                                 },
//                                 child: x2);
//                           } else {
//                             showtoastfile();
//                           }
//                         } else {
//                           check = false;
//                           x1 = Container(
//                             margin: EdgeInsets.fromLTRB(10, 0, 15, 15),
//                             padding: EdgeInsets.all(6),
//                             decoration: BoxDecoration(
//                               color: Colors.black,
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(
//                                   color: Colors.white.withOpacity(0.5)),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "Submit Entry",
//                                 style: TextStyle(
//                                     color: Colors.white.withOpacity(0.5),
//                                     fontSize: 32,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           );
//                         }
//                       });
//                     }),
//                 Text(
//                   "You agree our terms and condition",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     launch("https://astrodrishti.online/contestrules.pdf");
//                   },
//                   child: Text(
//                     "  (Read more)",
//                     style: TextStyle(
//                       color: Colors.amberAccent[700],
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             Spacer(),
//             x1
//           ],
//         ),
//       ),
//     );
//   }
// }

// bool _isNumeric(String result) {
//   if (result == null) {
//     return false;
//   }
//   return double.tryParse(result) != null;
// }

// final showtoastinvalidnum = () => Fluttertoast.showToast(
//     msg: "In-valid Number",
//     toastLength: Toast.LENGTH_SHORT,
//     backgroundColor: Colors.black);

// final showtoastempty = () => Fluttertoast.showToast(
//     msg: "Fill Full Form",
//     toastLength: Toast.LENGTH_SHORT,
//     backgroundColor: Colors.black);

// final showtoastfile = () => Fluttertoast.showToast(
//     msg: "Select File !",
//     toastLength: Toast.LENGTH_SHORT,
//     backgroundColor: Colors.black);
