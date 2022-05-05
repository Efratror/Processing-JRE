# Processing Java Runtime Environment (JRE)
A JRE is what makes java programs run. As processing is a java bast application it needs a JRE our the full java development kit(JDK) to execute. One advantage of a JRE is its smaller size (40-50 mb) also JRE's can be custom tailored to include all libraries needed to run an application. 

These JRE's are currently build for Processing 4.0b8 and use Openjdk-17.0.2.

## Included JRE platforms:
- Windows X64
- Linux X64
- macOS X64

**Note:** Only the JRE for the windows platform has been tested. All other JRE's are "without guaranties and use at your own risk."

## Building the Processing JRE's
If the processing foundation releases a new version of processing new JRE's need to be build. This can be done in a few simple steps:

1. Extract the core.jar file from the processing application
2. Place is in the `src/core` folder
3. Use Jdeps to check the dependencies for the core.jar
4. Place the dependencies in the `src/lib` folder
5. Execute the build.bat file to create the new custom JRE's

**Note:** At the moment building the JRE's is only supported on windows. Work is being done to create build scripts for Linux and possibly macOS.

### Requirements:
- a Java Development Kit V17.0.2 or higher.