# [Build Native Mobile Apps with Flutter](https://www.udacity.com/course/ud905)

This repo contains everything you need for [Build Native Mobile Apps with Flutter, by Google and Udacity](https://www.udacity.com/course/ud905). The Unit Converter app has been broken down into sub-projects. To get started, [set up your development environment](https://flutter.io/setup) and clone this repo, using `git clone git@github.com:flutter/udacity-course.git` or `git clone https://github.com/flutter/udacity-course.git`.

## Building the Complete Unit Converter App
### Android Studio/IntelliJ
1. Open the IDE and select `Import project (Gradle, Eclipse ADT, etc.)`. After you import the first time, you can use `Open an existing Android Studio project` in the future.
2. Choose the `unit_converter` project folder, located in this repo at [`/unit_converter/unit_converter`](https://github.com/flutter/udacity-course/tree/master/unit_converter/unit_converter). Select `Next` for all setup instructions, making sure that the Source Files screen shows Flutter as an option.
3. You can view your Flutter app files in the Projects tab in the Project Tool Window (View -> Tool Windows). Make sure your Flutter SDK is set and dependencies have been updated.
4. Make sure your device/emulator is running. You can view the AVD Manager at Tools -> AVD Manager, or by typing `Ctrl/Cmd` + `Shift` + `a` and typing in 'AVD Manager'.
5. Press the green Play button to run the app. Note that `main.dart` should be chosen in the dropdown on the left of the green Play button.

### Command Line
1. Run `cd ~/<repo location>/unit_converter/unit_converter`.
2. Make sure your device/emulator is running.
3. Run `flutter run`.

## Building Each Coding Exercise
Each coding exercise for the Udacity course is located in the [`course` directory](https://github.com/flutter/udacity-course/tree/master/course). Each exercise is split into a standalone Task project and Solution project. The Solution is one of many possible solutions. You can compare your implementation with the solution using the `diff` command.

### Android Studio/IntelliJ
1. Open the IDE and select `Import project (Gradle, Eclipse ADT, etc.)`. After you import the first time, you can use `Open an existing Android Studio project` in the future.
2. Find the coding exercise you want to do and choose the `task_` project folder. For example, for the second coding exercise, `02_category_widget`, choose the `task_02_category_widget` project located in this repo at [`/course/2_category_widget/task_02_category_widget`](https://github.com/flutter/udacity-course/tree/master/course/02_category_widget/task_02_category_widget).
3. You can view your Flutter app files in the Projects tab in the Project Tool Window (View -> Tool Windows). Make sure your Flutter SDK is set and dependencies have been updated.
4. Make sure your device/emulator is running. You can view the AVD Manager at Tools -> AVD Manager, or by typing `Ctrl/Cmd` + `Shift` + `a` and typing in 'AVD Manager'.
5. Press the green Play button to run the app. Note that `main.dart` should be chosen in the dropdown on the left of the green Play button.
6. Follow the README and complete the TODOs in the coding exercise.

# Style Guide
Use strong mode.

# Contribution Guidelines
Please feel free to file issues at https://github.com/flutter/udacity-course/issues. Flutter issues can be filed at https://github.com/flutter/flutter/issues.

You can also contribute changes. Setting up:
1. Fork `https://github.com/flutter/udacity-course` into your own GitHub account
2. `git clone git@github.com:<your_name_here>/udacity-course.git`
3. `cd udacity-course`
4. `git remote add upstream git@github.com:flutter/udacity-course.git`

Submitting changes:
1. `git fetch upstream`
2. `git checkout upstream/master -b name_of_your_branch`
3. Make changes
4. `git commit -a -m "<your informative commit message>"`
5. `git push origin name_of_your_branch`

To send a pull request:
1. `git pull-request` (if you are using [Hub](https://hub.github.com/)) or go to https://github.com/flutter/udacity-course and click the "Compare & pull request" button
2. Tag the relevant people and GitHub issue (if any)

# Resources

For a list of Flutter resources to help you get started as well as continue learning after the course, check [here](https://github.com/flutter/udacity-course/tree/master/resources.md).
