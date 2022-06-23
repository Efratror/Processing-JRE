# Processing Java Runtime Environment (JRE)
A JRE is what makes java programs run. As processing is a java based application it needs a JRE our the full java development kit(JDK) to execute. One advantage of a JRE is its smaller size (40-50 mb) also JRE's can be custom tailored to include all libraries needed to run an application. 

These JRE's are currently build for Processing 4.0b8 and use Openjdk-17.0.2.

## Included JRE platforms:
- Windows X64
- Linux X64
- macOS X64

**Note:** Only the JRE for the windows platform has been tested. All other JRE's come "without guaranties and use at your own risk."

## Building the Processing JRE's
**Note:** All commands shown are for windows, replace `gradle` with `./gradlew` on Linux/macOs

As a build tool gradle is used, for building the JRE's use:
1. `gradlew build` to build the JRE's for all platforms
2. `gradlew buildWin` to build the JRE for windows
3. `gradlew buildLinux` to build the JRE for Linux
4. `gradlew buildMac` to build the JRE for macOS

### Building sub-projects:
The JRE build is based on two sub-projects, one which adds a custom compiler to be used as a javac replacement and one which converts the processing core libs and is't dependencies to modules. Building of these sub-projects can be done seperate through the following commands:

1. `gradlew buildCompiler` to build the custom java compiler
2. `gradlew buildModules` convert the processing libs to modules

### Changing the processing libraries
If the processing foundation releases a new version of processing new JRE's need to be build. This can be done in a few simple steps:

1. Extract the core.jar file from the processing application
2. Place is in the `src/processing/src/core` folder
3. Use [JDeps](https://docs.oracle.com/en/java/javase/17/docs/specs/man/jdeps.html) to check the dependencies for the core.jar
4. Place the dependencies in the `src/processing/src/lib` folder
5. Execute `gradlew cleanBuildModules` to rebuild the modules
6. Execute `gradlew build` to build the JRE's

**Note:** At the moment building the JRE's is only supported on windows. Work is being done to create build scripts for Linux and possibly macOS.

### Requirements:
- a Java Development Kit V17.0.2 or higher.