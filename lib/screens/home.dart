import 'package:butlr/screens/components/add_category.dart';
import 'package:butlr/screens/components/fab.dart';
import 'package:butlr/screens/components/my_tab_bar.dart';
import 'package:butlr/screens/components/my_popup_menu.dart';
import 'package:butlr/screens/components/task_view.dart';
import 'package:butlr/services/database.dart';
import 'package:butlr/shared/constants.dart';
import 'package:butlr/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool value = false;
  bool isLoading = true;

  List<String> categoryNames = [''];
  List tasksList = [[{'body': ''}]];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    List<Widget> tabList = [];
    List<Widget> tabViewList = [];

    void setData()async{
      final data = await Database(uid: user!.uid).getData();
      if (mounted) {
        setState((){
          categoryNames = data['categoryList'];
          tasksList = data['tasksList'];
          isLoading = false;
        });
      }
    }

    setData();

    for(int i = 0; i < categoryNames.length; i++){
      tabList.add(
        Tab(
          child: GestureDetector(
            onLongPress: (){
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (ogContext) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(53, 43, 33, 1),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    height: 71,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: (){
                              String newName = '';
                              showDialog(
                                context: ogContext,
                                builder:(context) => AlertDialog(
                                  titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  buttonPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  title: const Text('Rename'),
                                  content: TextFormField(
                                    cursorWidth: 1,
                                    textCapitalization: TextCapitalization.words,
                                    decoration: textInputDecoration.copyWith(
                                      hintText: 'New category name',
                                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0)
                                    ),
                                    onChanged: (value){
                                      setState(() {
                                        newName = value;
                                      });
                                    },
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      style: myButtonStyle.copyWith(
                                        backgroundColor: MaterialStateProperty.all(Colors.white30),
                                        foregroundColor: MaterialStateProperty.all(Colors.white)
                                      ),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel')
                                    ),
                                    ElevatedButton(
                                      style: myButtonStyle,
                                      onPressed: (){
                                        Database(uid: user!.uid).updateCategory(
                                          categoryName: categoryNames[i],
                                          newName: newName
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(ogContext);
                                      },
                                      child: const Text('Rename')
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Column(
                              children: const[
                                Icon(Icons.edit, color: Colors.white70,),
                                SizedBox(height: 2,),
                                Text('Rename', style: TextStyle(fontSize: 11, color: Colors.white70),),
                              ],
                            )
                          ),
                          TextButton(
                            onPressed: (){
                              showDialog(
                                context: ogContext,
                                builder:(context) => AlertDialog(
                                  titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  buttonPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  title: const Text('Confirm delete'),
                                  content: const Text('Are you sure you want to delete this category?'),
                                  actions: [
                                    ElevatedButton(
                                      style: myButtonStyle.copyWith(
                                        backgroundColor: MaterialStateProperty.all(Colors.white30),
                                        foregroundColor: MaterialStateProperty.all(Colors.white)
                                      ),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel')
                                    ),
                                    ElevatedButton(
                                      style: myButtonStyle.copyWith(
                                        backgroundColor: MaterialStateProperty.all(Colors.red),
                                        foregroundColor: MaterialStateProperty.all(Colors.white)
                                      ),
                                      onPressed: (){
                                        Database(uid: user!.uid).deleteCategory(categoryName: categoryNames[i]);
                                        Navigator.pop(context);
                                        Navigator.pop(ogContext);
                                      },
                                      child: const Text('Delete')
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Column(
                              children: const[
                                Icon(Icons.delete, color: Colors.white70,),
                                SizedBox(height: 2,),
                                Text('Delete', style: TextStyle(fontSize: 11, color: Colors.white70),),
                              ],
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Text(
              categoryNames[i],
              style: const TextStyle(fontSize: 16),
            )
          )
        )
      );
      tabViewList.add(
        TaskView(i: i, tasksList: tasksList, categoryNames: categoryNames)
      );
    }

    tabList.add(const Tab(child: Text('+ Add Category', style: TextStyle(fontSize: 16),)));
    tabViewList.add(
      const AddCategory()
    );
    

    return isLoading ? const Loading() : DefaultTabController(
      initialIndex: 0,
      length: categoryNames.length+1,
      child: Builder(
        builder: (context) {
          return Scaffold(
            floatingActionButton: DefaultTabController.of(context)!.index == categoryNames.length ? null : FAB(
              categoryNames: categoryNames,
              myContext: context
            ),
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light
              ),
              title: const Text('Managr'),
              elevation: 1,
              backgroundColor: Colors.white10,
              actions: [MyPopupMenu(user: user)],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: MyTabBar(tabList: tabList)
              ),
            ),
            body: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: tabViewList,
            ),    
          );
        }
      ),
    );
  }
}