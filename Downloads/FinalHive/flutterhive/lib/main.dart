import 'package:flutterhive/person.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'boxes.dart';

late Box boxDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxPersons = await Hive.openBox<Person>('personBox');
  boxDetails = await Hive.openBox('detailsBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF001F24),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF004D54),
          elevation: 2,
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF00363A),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController targetAgeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController goalsController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  int? editingIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15.0),
          Image.network(
            'https://avatars.githubusercontent.com/u/55202745?s=200&v=4',
            height: 100,
          ),
          const SizedBox(height: 5.0),
          Flexible(
            flex: 3,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: taskNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Task Title',
                            hintText: 'Enter task description...',
                            floatingLabelStyle: TextStyle(color: Colors.tealAccent),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: targetAgeController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Task Date',
                            hintText: 'Tap to select date...',
                            floatingLabelStyle: TextStyle(color: Colors.tealAccent),
                            suffixIcon: Icon(Icons.calendar_month, color: Colors.tealAccent),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Color(0xFF00838F),
                                      onPrimary: Colors.white,
                                      surface: Color(0xFF00363A),
                                      onSurface: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              setState(() {
                                targetAgeController.text = "${pickedDate.year}${pickedDate.month.toString().padLeft(2, '0')}${pickedDate.day.toString().padLeft(2, '0')}";
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: locationController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Location',
                            hintText: 'Enter location...',
                            floatingLabelStyle: TextStyle(color: Colors.tealAccent),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: timeController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Time',
                            hintText: 'Tap to select time...',
                            floatingLabelStyle: TextStyle(color: Colors.tealAccent),
                            suffixIcon: Icon(Icons.access_time, color: Colors.tealAccent),
                          ),
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Color(0xFF00838F),
                                      onPrimary: Colors.white,
                                      surface: Color(0xFF00363A),
                                      onSurface: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedTime != null && mounted) {
                              setState(() {
                                timeController.text = pickedTime.format(context);
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: goalsController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Goals',
                            hintText: 'Enter goals...',
                            floatingLabelStyle: TextStyle(color: Colors.tealAccent),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: categoryController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Category',
                            hintText: 'Work, School, Personal...',
                            floatingLabelStyle: TextStyle(color: Colors.tealAccent),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: priorityController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Priority',
                            hintText: 'High, Medium, Low...',
                            floatingLabelStyle: TextStyle(color: Colors.tealAccent),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00838F),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (taskNameController.text.trim().isEmpty || targetAgeController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill out all input fields!')),
                              );
                              return;
                            }

                            int? parsedAge = int.tryParse(targetAgeController.text.trim());
                            if (parsedAge == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Invalid date structure formatted error!')),
                              );
                              return;
                            }

                            Map details = {
                              'location': locationController.text.trim(),
                              'time': timeController.text.trim(),
                              'goals': goalsController.text.trim(),
                              'category': categoryController.text.trim(),
                              'priority': priorityController.text.trim(),
                            };

                            if (editingIndex == null) {
                              int newKey = await boxPersons.add(
                                Person(
                                  name: taskNameController.text.trim(),
                                  age: parsedAge,
                                ),
                              );
                              await boxDetails.put(newKey, details);
                            } else {
                              await boxPersons.putAt(
                                editingIndex!,
                                Person(
                                  name: taskNameController.text.trim(),
                                  age: parsedAge,
                                ),
                              );
                              await boxDetails.put(
                                boxPersons.keyAt(editingIndex!),
                                details,
                              );
                            }

                            setState(() {
                              editingIndex = null;
                              taskNameController.clear();
                              targetAgeController.clear();
                              locationController.clear();
                              timeController.clear();
                              goalsController.clear();
                              categoryController.clear();
                              priorityController.clear();
                            });
                          },
                          icon: Icon(editingIndex == null ? Icons.add : Icons.save),
                          label: Text(editingIndex == null ? 'Add Task' : 'Save Changes'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: boxPersons.length,
                    itemBuilder: (context, index) {
                      Person person = boxPersons.getAt(index);
                      Map details = boxDetails.get(boxPersons.keyAt(index)) ?? {};
                      String rawDate = person.age.toString();
                      String formattedDate = rawDate;
                      if (rawDate.length == 8) {
                        formattedDate = "${rawDate.substring(0, 4)}-${rawDate.substring(4, 6)}-${rawDate.substring(6, 8)}";
                      }
                      return ListTile(
                        leading: IconButton(
                          onPressed: () {
                            setState(() {
                              boxDetails.delete(boxPersons.keyAt(index));
                              boxPersons.deleteAt(index);
                              if (editingIndex == index) {
                                editingIndex = null;
                                taskNameController.clear();
                                targetAgeController.clear();
                                locationController.clear();
                                timeController.clear();
                                goalsController.clear();
                                categoryController.clear();
                                priorityController.clear();
                              }
                            });
                          },
                          icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                        ),
                        title: Text(
                          person.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Due: $formattedDate\n'
                          'Time: ${details['time'] ?? ''}\n'
                          'Location: ${details['location'] ?? ''}\n'
                          'Goals: ${details['goals'] ?? ''}\n'
                          'Category: ${details['category'] ?? ''}\n'
                          'Priority: ${details['priority'] ?? ''}',
                          style: const TextStyle(color: Colors.tealAccent, fontSize: 12),
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_note, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  editingIndex = index;
                                  taskNameController.text = person.name;
                                  targetAgeController.text = person.age.toString();
                                  locationController.text = details['location'] ?? '';
                                  timeController.text = details['time'] ?? '';
                                  goalsController.text = details['goals'] ?? '';
                                  categoryController.text = details['category'] ?? '';
                                  priorityController.text = details['priority'] ?? '';
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () {
              setState(() {
                boxPersons.clear();
                boxDetails.clear();
                editingIndex = null;
                taskNameController.clear();
                targetAgeController.clear();
                locationController.clear();
                timeController.clear();
                goalsController.clear();
                categoryController.clear();
                priorityController.clear();
              });
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete All'),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}