package com;
import javax.tools.*;
import java.io.*;
import java.util.*;

public class compiler {
    public static void main(String[] arguments) throws IOException {
        for (String s: arguments) {
            File file = new File(s);
            
            JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
            DiagnosticCollector<JavaFileObject> diagnostics = new DiagnosticCollector<JavaFileObject>();
            StandardJavaFileManager fileManager = compiler.getStandardFileManager(diagnostics, null, null);
            
            var classpath = System.getProperty("java.class.path");
            List<String> options = new ArrayList<String>();
            options.addAll(Arrays.asList("-classpath", classpath));
            options = Arrays.asList("-Xdiags:verbose");
     
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
         }
        }
      
}