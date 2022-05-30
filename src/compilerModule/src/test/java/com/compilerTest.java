package com;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.IOException;

import org.junit.jupiter.api.*;

public class compilerTest {

    @Test
    void testClassPathSeparator() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        if (System.getProperty("os.name").startsWith("Windows")){
            assertEquals(";",separator, "OK");
        }
        else {
            assertEquals(":",separator, "OK");
        }
    }

    @Test
    void testCompileSimple() throws IOException {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        boolean expected = true;
        String [] arguments = {"src/test/java/com/assets/HelloWorld.java", ""};
        boolean actual = comp.compile(arguments, separator);
        assertEquals(expected, actual);
    }

    @Test
    void testCompileImport() throws IOException {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        boolean expected = true;
        String [] args = {"-f", "src/test/java/com/assets/Import.java", "-cp", "src/test/java/com/assets/lib"};
        String [] arguments = comp.checkArguments(args, separator);
        boolean actual = comp.compile(arguments, separator);
        assertEquals(expected, actual);
    }

    @Test
    void testCompileFail() throws IOException {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        boolean expected = false;
        String [] args = {"-f", "src/test/java/com/assets/CompileError.java"};
        String [] arguments = comp.checkArguments(args, separator);
        boolean actual = comp.compile(arguments, separator);
        assertEquals(expected, actual);
    }

    @Test
    void testDisplayHelp() {
        compiler comp = new compiler();
        String expected = "";
        expected += "Welkom to the compiler module for the languages server for processing (LS4P)\n";
        expected += "Usage: <options>\n";
        expected += "Where possible options include:\n";
        expected += "-f  <path> file to compile\n";
        expected += "-cp <path> User added class files (imports). This can be a file or a directory\n";
        expected += "-h         This help text\n";

        String actual = comp.displayHelp();
        assertEquals(expected,actual);
    }

    @Test
    void testListJarFiles() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String expected = "src/test/java/com/assets/singleJar/test.jar";
        String arguments = "src/test/java/com/assets/singleJar";
        String actual = comp.listJarFiles(arguments, separator);
        assertEquals(expected,actual);
    }
}
