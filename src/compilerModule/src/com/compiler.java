package com;

import java.io.*;
import java.util.*;
import javax.tools.*;
import java.nio.file.*;
import java.util.stream.*;

public class compiler {

    public static void main(String[] arguments) throws IOException {
        
        
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        String[] args = comp.checkArguments(arguments, separator);

        if (!(args[0] == "Missing arguments" || args[0] == "Unknown command" || args[0] == "h")) {
            comp.compile(args, separator);
        }

        
    }

    protected String classPathSeparator() {
        String OS = System.getProperty("os.name");
        
        if (OS.startsWith("Windows")){
            return ";";
        }
        else {
            return":";
        }

    }

    protected String[] checkArguments(String[] arguments, String separator){
        String[] args = {"",""};
        for (int i = 0; i < arguments.length; i += 2) {
            
            if (arguments.length <= i+1 && arguments[i] != "-h") {
                args[0] = "Missing arguments";
                System.out.println(displayHelp());
                break;
            }

            switch (arguments[i]) {
                case "-f":
                    args[0] = arguments[i+1];

                    break;
                case "-cp":
                    if (arguments[i+1].contains(".jar")) {
                        args[1] = arguments[i+1];
                        
                    }
                    else{
                        args[1] = listJarFiles(arguments[i+1], separator);
                    }
                    break;
                case "-h":
                    args[0] = "h";
                    System.out.println(displayHelp());
                    break;
                default:
                    System.out.println(displayHelp());
                    args[0] = "Unknown command";
                    break;
            }
        }

        return args;
    }

    protected String displayHelp(){
        String message = "";
        message += "Welkom to the compiler module for the languages server for processing (LS4P)\n";
        message += "Usage: <options>\n";
        message += "Where possible options include:\n";
        message += "-f  <path> file to compile\n";
        message += "-cp <path> User added class files (imports). This can be a file or a directory\n";
        message += "-h         This help text\n";

        return message;
    }

    protected String listJarFiles(String path, String separator) {
        String jarPaths = "";
        try (Stream<Path> walk = Files.walk(Paths.get(path))) {
            // We want to find only regular files
            List<String> result = walk.filter(Files::isRegularFile)
                    .map(x -> x.toString()).collect(Collectors.toList());
            for (String filePath : result) {
                if (filePath.contains(".jar")){
                    if (jarPaths == "") {
                        jarPaths += filePath.replace("\\", "/");
                    }
                    else {
                        jarPaths += separator+filePath.replace("\\", "/");
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            System.exit(1);
        }
        return jarPaths;
    }

    protected boolean compile(String[] args, String seperator) throws IOException{
        
        File file = new File(args[0]);
        
        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        DiagnosticCollector<JavaFileObject> diagnostics = new DiagnosticCollector<JavaFileObject>();
        StandardJavaFileManager fileManager = compiler.getStandardFileManager(diagnostics, null, null);
        
        var javaClasspath = System.getProperty("java.class.path");
        List<String> options = new ArrayList<String>();
        if (javaClasspath != null) {
            options.addAll(Arrays.asList("-classpath", javaClasspath+seperator+args[1]));
        }
        else {
            options.addAll(Arrays.asList("-classpath", args[1]));
        }
        options.addAll(Arrays.asList("-Xdiags:verbose"));
    
        Iterable<? extends JavaFileObject> compilationUnits =
            fileManager.getJavaFileObjects(file);
        compiler.getTask(null, fileManager, diagnostics, options, null, compilationUnits).call();
    
        for (Diagnostic<? extends JavaFileObject> diagnostic : diagnostics.getDiagnostics()) {
            if (diagnostic.getSource() != null) {
                    String fileUri = diagnostic.getSource().toUri().toString();
                    String filePath = fileUri.replace("file:///", "");
    
                    System.out.format("%s:%s:L%d:C%d:%s%n%s%n",
                        filePath,
                        diagnostic.getKind().toString(),                  
                        diagnostic.getLineNumber(),
                        diagnostic.getColumnNumber(),
                        diagnostic.getCode(),
                        diagnostic.getMessage(null)
                    );
            }
            else {
                System.out.format("%s:%s%n%s%n",
                    diagnostic.getKind().toString(),                  
                    diagnostic.getCode(),
                    diagnostic.getMessage(null)
                );
            }
    
        }                      
    
        fileManager.close();

        if (diagnostics.getDiagnostics().size() > 0 ) {
            return false;
        }
        return true;
    }
      
}