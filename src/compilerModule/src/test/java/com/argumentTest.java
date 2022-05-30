package com;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.*;

public class argumentTest {

    @Test
    void testcheckArgumentsHelp() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String [] expected = {"h",""};
        String [] arguments = {"-h"};
        String [] actual = comp.checkArguments(arguments, separator);
        assertArrayEquals(expected, actual);
    }

    @Test
    void testactualNoArguments() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String [] expected = {"Missing arguments",""};
        String [] arguments = {""};
        String [] actual = comp.checkArguments(arguments, separator);
        assertArrayEquals(expected, actual);
    }

    @Test
    void testcheckArgumentsUnknown() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String [] expected = {"Unknown command",""};
        String [] arguments = {"-p", "test"};
        String [] actual = comp.checkArguments(arguments, separator);
        assertArrayEquals(expected, actual);
    }

    @Test
    void testcheckArgumentsFile() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String [] expected = {"test.java",""};
        String [] arguments = {"-f", "test.java"};
        String [] actual = comp.checkArguments(arguments, separator);
        assertArrayEquals(expected, actual);
    }

    @Test
    void testcheckArgumentsFileFail() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String [] expected = {"Missing arguments",""};
        String [] arguments = {"-f"};
        String [] actual = comp.checkArguments(arguments, separator);
        assertArrayEquals(expected, actual);
    }

    @Test
    void testcheckArgumentsClasspathDirect() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String [] expected = {"","test.jar"};
        String [] arguments = {"-cp", "test.jar"};
        String [] actual = comp.checkArguments(arguments, separator);
        assertArrayEquals(expected, actual);
    }

    @Test
    void testcheckArgumentsClasspathIndirectSingle() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String [] expected = {"","src/test/java/com/assets/singleJar/test.jar"};
        String [] arguments = {"-cp", "src/test/java/com/assets/singleJar"};
        String [] actual = comp.checkArguments(arguments, separator);
        assertArrayEquals(expected, actual);
    }

    @Test
    void testcheckArgumentsClasspathIndirectMultiple() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String [] expected = {"",""};

        if (System.getProperty("os.name").startsWith("Windows")){
            expected[1] = "src/test/java/com/assets/multipleJar/test.jar;src/test/java/com/assets/multipleJar/test2.jar";
        }
        else {
            expected[1] = "src/test/java/com/assets/multipleJar/test.jar:src/test/java/com/assets/multipleJar/test2.jar";
        }

        String [] arguments = {"-cp", "src/test/java/com/assets/multipleJar"};
        String [] actual = comp.checkArguments(arguments, separator);
        assertArrayEquals(expected, actual);
    }

    @Test
    void testcheckArgumentsClasspathFail() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String [] expected = {"Missing arguments",""};
        String [] arguments = {"-cp"};
        String [] actual = comp.checkArguments(arguments, separator);
        assertArrayEquals(expected, actual);
    }

    @Test
    void testcheckArgumentsFileAndClasspath() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String [] expected = {"test.java","lib.jar"};
        String [] arguments = {"-f", "test.java", "-cp", "lib.jar"};
        String [] actual = comp.checkArguments(arguments, separator);
        assertArrayEquals(expected, actual);
    }

    @Test
    void testcheckArgumentsFileAndClasspathInvert() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String [] expected = {"test.java","lib.jar"};
        String [] arguments = {"-cp", "lib.jar", "-f", "test.java"};
        String [] actual = comp.checkArguments(arguments, separator);
        assertArrayEquals(expected, actual);
    }

    @Test
    void testcheckArgumentsFileAndClasspathFail() {
        compiler comp = new compiler();
        String separator = comp.classPathSeparator();
        
        String expected = "Missing arguments";
        String [] arguments = {"-cp", "lib.jar", "-f"};
        String [] actual = comp.checkArguments(arguments, separator);
        assertEquals(expected, actual[0]);
    }
    
}
