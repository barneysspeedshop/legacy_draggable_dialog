import 'package:flutter/material.dart';
import 'package:legacy_draggable_dialog/legacy_draggable_dialog.dart';
import 'package:legacy_draggable_dialog/draggable_dialog.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draggable Dialog Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Draggable Dialog Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(title)),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(onPressed: () => _showSimpleDialog(context), child: const Text('Show Simple Dialog')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showSimpleDialogWithClose(context), child: const Text('Show Simple Dialog With Close Button in Title')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showCustomActionsDialog(context), child: const Text('Show Dialog with Custom Actions')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showCustomFooterDialog(context), child: const Text('Show Dialog with Custom Footer')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showCustomHeaderDialog(context), child: const Text('Show Dialog with Custom Header')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showDialogWithThemedButton(context), child: const Text('Show Dialog with Themed Button')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showDialogWithDangerTheme(context), child: const Text('Show Dialog with Danger Theme')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showDialogWithSuccessTheme(context), child: const Text('Show Dialog with Success Theme')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showDialogWithCustomButtons(context), child: const Text('Show Dialog with Custom Buttons')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showScrollableDialog(context), child: const Text('Show Dialog with Scrollable Body')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showExpandableDialog(context), child: const Text('Show Dialog with Expandable Sections')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showFormDialog(context), child: const Text('Show Dialog with Form')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showLoadingDialog(context), child: const Text('Show Loading Dialog')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showTabbedDialog(context), child: const Text('Show Dialog with Tabs')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showTabbedViewDialog(context), child: const Text('Show Dialog with Tabbed View Package')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _showCollapsibleDialog(context), child: const Text('Show Collapsible Dialog')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSimpleDialog(BuildContext context) {
    showLegacyDraggableDialog(
      context: context,
      title: 'Simple Dialog',
      body: const Center(
        child: Padding(padding: EdgeInsets.all(16.0), child: Text('This is a basic dialog with OK button.')),
      ),
      width: 800,
      height: 200,
      maxHeight: 150,
      actions: [ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
    );
  }

  void _showSimpleDialogWithClose(BuildContext context) {
    showLegacyDraggableDialog(
      context: context,
      title: 'Simple Dialog',
      body: const Center(
        child: Padding(padding: EdgeInsets.all(16.0), child: Text('This is a basic dialog with OK button.')),
      ),
      width: 800,
      height: 200,
      maxHeight: 150,
      onClose: () => Navigator.of(context).pop(),
      actions: [ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
    );
  }

  void _showCustomActionsDialog(BuildContext context) {
    showLegacyDraggableDialog(
      context: context,
      title: 'Dialog with Actions',
      body: const Center(
        child: Padding(padding: EdgeInsets.all(16.0), child: Text('This dialog uses the `actions` parameter to build a custom footer.')),
      ),
      width: 800,
      height: 250,
      onClose: () => Navigator.of(context).pop(),
      actions: [
        StatefulBuilder(
          builder: (context, setState) {
            return Row(
              children: [
                Checkbox(value: true, onChanged: (val) {}),
                const Text('Option'),
              ],
            );
          },
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Help')),
        ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Confirm')),
      ],
    );
  }

  void _showCustomFooterDialog(BuildContext context) {
    showLegacyDraggableDialog(
      context: context,
      title: 'Custom Footer',
      body: const Center(child: Text('This dialog uses a completely custom footer widget.')),
      width: 800,
      height: 200,
      onClose: () => Navigator.of(context).pop(),
      footer: Container(
        color: Colors.deepPurple.withOpacity(0.2),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.info_outline),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Dismiss')),
          ],
        ),
      ),
    );
  }

  void _showCustomHeaderDialog(BuildContext context) {
    showLegacyDraggableDialog(
      context: context,
      // title is ignored because a custom header is provided
      body: const Center(child: Text('This dialog uses a completely custom header widget.')),
      width: 800,
      height: 200,
      header: Container(
        color: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.drag_handle, color: Colors.white),
            const Text('Custom Draggable Header', style: TextStyle(color: Colors.white)),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialogWithThemedButton(BuildContext context) {
    showLegacyDraggableDialog(
      context: context,
      title: 'Dialog with Themed Button',
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('This dialog uses `onOk` to show the default themed button from `DraggableDialogThemeData`.'),
        ),
      ),
      width: 800,
      height: 250,
      onClose: () => Navigator.of(context).pop(),
      onOk: () => Navigator.of(context).pop(),
      okText: 'Themed OK',
    );
  }

  void _showDialogWithDangerTheme(BuildContext context) {
    showLegacyDraggableDialog(
      context: context,
      title: 'Danger Zone',
      body: const Center(
        child: Padding(padding: EdgeInsets.all(16.0), child: Text('This action is irreversible. Are you sure?')),
      ),
      width: 800,
      height: 200,
      onClose: () => Navigator.of(context).pop(),
      onOk: () => Navigator.of(context).pop(),
      okText: 'Delete',
      theme: DraggableDialogThemeData(
        buttonStyle: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
      ),
    );
  }

  void _showDialogWithSuccessTheme(BuildContext context) {
    showLegacyDraggableDialog(
      context: context,
      title: 'Success!',
      body: const Center(
        child: Padding(padding: EdgeInsets.all(16.0), child: Text('The operation was completed successfully.')),
      ),
      width: 800,
      height: 200,
      onClose: () => Navigator.of(context).pop(),
      onOk: () => Navigator.of(context).pop(),
      okText: 'Great!',
      theme: DraggableDialogThemeData(
        titleStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
        buttonStyle: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
      ),
    );
  }

  void _showDialogWithCustomButtons(BuildContext context) {
    showLegacyDraggableDialog(
      context: context,
      title: 'Dialog with Custom Buttons',
      body: const Center(
        child: Padding(padding: EdgeInsets.all(16.0), child: Text('This dialog demonstrates using different button types in the `actions` parameter.')),
      ),
      width: 800,
      height: 250,
      onClose: () => Navigator.of(context).pop(),
      actions: [
        TextButton(onPressed: () {}, child: const Text('TextButton')),
        OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
        ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Elevated')),
      ],
    );
  }

  void _showScrollableDialog(BuildContext context) {
    showLegacyDraggableDialog(
      context: context,
      title: 'Scrollable Content',
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) {
          return ListTile(title: Text('Item ${index + 1}'), leading: const Icon(Icons.label));
        },
      ),
      width: 800,
      height: 350,
      onClose: () => Navigator.of(context).pop(),
      actions: [ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
    );
  }

  void _showExpandableDialog(BuildContext context) {
    showLegacyDraggableDialog(
      context: context,
      title: 'Expandable Sections',
      body: ListView(
        children: const [
          ExpansionTile(
            title: Text('User Information'),
            leading: Icon(Icons.person),
            children: <Widget>[
              ListTile(title: Text('Name: John Doe')),
              ListTile(title: Text('Email: john.doe@example.com')),
            ],
          ),
          ExpansionTile(
            title: Text('Application Settings'),
            leading: Icon(Icons.settings),
            children: <Widget>[
              ListTile(title: Text('Enable Notifications')),
              ListTile(title: Text('Dark Mode Preference')),
            ],
          ),
          ExpansionTile(
            title: Text('Help & Feedback'),
            leading: Icon(Icons.help),
            children: <Widget>[
              ListTile(title: Text('Send Feedback')),
              ListTile(title: Text('About the App')),
            ],
          ),
        ],
      ),
      width: 800,
      height: 400,
      onClose: () => Navigator.of(context).pop(),
    );
  }

  void _showFormDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String username = '';
    String password = '';

    showLegacyDraggableDialog(
      context: context,
      title: 'Login Form',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                onSaved: (value) => username = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onSaved: (value) => password = value!,
              ),
            ],
          ),
        ),
      ),
      width: 800,
      height: 320,
      onClose: () => Navigator.of(context).pop(),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              // In a real app, you'd use the username and password
              print('Logging in with $username and $password');
              Navigator.of(context).pop();
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _showLoadingDialog(BuildContext context) {
    // Show the dialog
    showLegacyDraggableDialog(
      context: context,
      title: 'Processing...',
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Please wait while we process your request.')],
        ),
      ),
      width: 800,
      height: 200,
      barrierDismissible: false,
      // Provide an empty footer to satisfy the assertion for non-dismissible dialogs
      footer: const SizedBox.shrink(),
    );

    // Simulate a network call and close the dialog after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  void _showTabbedDialog(BuildContext context) {
    showLegacyDraggableDialog(
      context: context,
      title: 'Tabbed Content',
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.info)),
              Tab(icon: Icon(Icons.details)),
              Tab(icon: Icon(Icons.more_horiz)),
            ],
          ),
          body: TabBarView(
            children: [
              const Center(child: Text('General Information')),
              const Center(child: Text('Detailed Specifications')),
              const Center(child: Text('More Options')),
            ],
          ),
        ),
      ),
      width: 450,
      height: 300,
      onClose: () => Navigator.of(context).pop(),
    );
  }

  void _showTabbedViewDialog(BuildContext context) {
    List<TabData> tabs = [
      TabData(
        text: 'Tab 1',
        content: const Center(child: Text('Content 1')),
      ),
      TabData(
        text: 'Tab 2',
        content: const Center(child: Text('Content 2')),
      ),
      TabData(
        text: 'Tab 3',
        content: const Center(child: Text('Content 3')),
      ),
    ];
    TabbedViewController controller = TabbedViewController(tabs);

    showLegacyDraggableDialog(
      context: context,
      title: 'Tabbed View Package',
      body: TabbedViewTheme(
        data: TabbedViewThemeData.underline(),
        child: TabbedView(controller: controller),
      ),
      width: 800,
      height: 350,
      onClose: () => Navigator.of(context).pop(),
    );
  }

  void _showCollapsibleDialog(BuildContext context) {
    showDraggableDialogWithBuilder(
      context: context,
      width: 800,
      height: 200,
      builder: (context, onDragUpdate) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isCollapsed = false;
            return StatefulBuilder(
              builder: (context, setState) {
                return DraggableDialog(
                  onDragUpdate: onDragUpdate,
                  header: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    color: Colors.blueGrey[100],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Collapsible Dialog',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(isCollapsed ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                              onPressed: () {
                                setState(() {
                                  isCollapsed = !isCollapsed;
                                });
                              },
                            ),
                            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  body: isCollapsed
                      ? const SizedBox.shrink()
                      : const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('This is the body of the collapsible dialog. Click the arrow in the header to collapse or expand me.'),
                        ),
                  footer: isCollapsed
                      ? null
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
                          ),
                        ),
                  maxHeight: isCollapsed ? 100 : 200,
                  expandContent: !isCollapsed,
                );
              },
            );
          },
        );
      },
    );
  }
}
