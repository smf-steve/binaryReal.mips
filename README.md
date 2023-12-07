# nextInt: Java Scanner.nextInt() Method


## Overview:

In this assignment, you are to develop three versions of a method/subroutine called  'nextInt()'. This method reads an ASCII string from stdin and converts it into an integer.  The method has one parameter, radix, the defines the base of the input number.

To accomplish this, there is a number of tasks that must be performed.

   1. Review your 25-binary-addition assignment to recall how to convert a base number into a decimal number.

   1. Implement in Java the 'bits2int()' method and a supporting method 'get_bit()'
      * this method reads in a sequence of binary digits  and converts the number into base 10

   1. Implement, in Java, the 'nextInt(int radix)' method and a supporting method 'glyph2int(char glyph, int radix)'
      * this method reads in a sequence of digits associated with the given radix and converts the number into base 10

   1. Transform the 'bits2int()' and the 'nextInt()' (along with its support) into Java TAC code.

   1. Implement, in MIPS, the 'nextInt(int radix)' subroutine and a supporting subroutine 'glyph2int(char glyph, int radix)'

   1. Validate your work via the `make validate`



## Tasks:

### Task 0: Software Development and Configuration Management Process
   1. Remember to follow the incremental development process
   1. Remember to iteratively:
      * edit your code
      * test your code
      * commit your code
   1. Use the make command to speed up and double check your work
      ```bash
      $ make
      Missing java_code tag
      Missing java_tac_code tag
      Missing mips_code tag
      You need a minimum of 20 commits
      make: [number_commits] Error 1 (ignored)

      "make test_java" to test your current version of nextInt.j
      "make test_mips" to test your current version of nextInt.s
      "make final" to test all your final versions of nextInt.*
      "make validate" to validate your final submission
      ```


### Task 1: 'bits2int()' and 'get_bit()' in Java
   1. Create a file called 'bits2int.j' that will contain both methods

   1. Write a Java method
      - Name: public static int get_bit();
      - Arguments:  none
      - Description: 
        * reads a single ASCII character from stdin
        * returns the integer value of the bit
      - Return Value: 
        *  0 : if the character is '0'
        *  1 : if the character is '1'
        * -1 : otherwise

   1. Test your method as follows:
      ```bash
      $ echo 0 | java_subroutine -L bits2int.j get_bit
      #########################################
      # Above is the output from your program
      #########################################
      
      v0:          0; 0x00 00 00 00; 0b0000 0000 0000 0000 0000 0000 0000 0000;
      
      $ echo 1 | java_subroutine -L bits2int.j get_bit
      #########################################
      # Above is the output from your program
      #########################################
      
      v0:          1; 0x00 00 00 01; 0b0000 0000 0000 0000 0000 0000 0000 0001;
      
      $ echo a | java_subroutine -L bits2int.j get_bit
      #########################################
      # Above is the output from your program
      #########################################
      
      v0:         -1; 0xFF FF FF FF; 0b1111 1111 1111 1111 1111 1111 1111 1111;
      ```

   1. Write a Java method
      - Name: public static int bits2int();
      - Arguments: none
      - Description:
        * reads a sequence of bits (via get_bit())
          (the sequence of bits ends when get_bit() returns -1)
        * converts this sequence into a decimal integer
      - Return Value:
        * an integer

   1. Test your method as follows:
      ```bash
      $ echo 0101 | java_subroutine bits2int
      #########################################
      # Above is the output from your program
      #########################################
      
      v0:          5; 0x00 00 00 05; 0b0000 0000 0000 0000 0000 0000 0000 0101;
      
      $ echo 0101a | java_subroutine bits2int
      #########################################
      # Above is the output from your program
      #########################################
      
      v0:          5; 0x00 00 00 05; 0b0000 0000 0000 0000 0000 0000 0000 0101;
      
      ```
      Notice that the char 'a' in the second test case terminates the binary sequence.  Hence, the string "0101" is converted into the number 5.


### Task 2. 'nextInt(int radix)' and 'glyph2digit(char radix, int radix)' in Java

   1. Consider how you would refactor your code from above to work for any base from 2..16

   1. Utilize the file called 'nextInt.j' that will contain both methods

   1. Refactor your get_bit() method to:
      - Name: public static int glyph2int(char glyph, int radix);
      - Arguments: 
        - glyph: an ASCII character to be changed to a number
        - radix: the base of the number
      - Description:
        * based upon the parameter glyph within the appropriate radix
        * converts the glyph to the corresponding base10 number
      - Return Value:
        * an integer

   1. Test your method 'glyph2int'  (following are some examples)
      - java_subroutine -L nextInt.j glyph2int F 16  # returns 15
      - java_subroutine -L nextInt.j glyph2int F 10  # returns -1

   1. Refactor your 'bit2int()' method to:
      - Name: public static int nextInt(int radix);
      - Arguments: radix
      - Description:
        * reads a sequence of glyphs using mips.read_s() into a buffer
        * process the buffer:
          - converting each glyph to a base10 number, and then
          - utilizes this number to obtain the next approximation of the final number
      - Return Value:
        * an integer

   1. If you are so inclined, consider replacing the multiplication step in your 
      algorithm with the appropriate shift operations:
      -  x * 2  ==  x << 1
      -  x * 4  ==  x << 2
      -  x * 8  ==  x << 3
      -  x * 10 ==  (x << 3) + (x << 1)
         ```
         i = (x << 3) + (x << 1);
         i = (x * 8) + (x * 2);
         i = 8x + 2x
         i = 10x
         ```

   1. Test your 'nextInt' method (following are some examples)
      - echo FACE     | java_subroutine nextInt 16  # returns 64206
      - echo DEADBEEF | java_subroutine nextInt 16  # returns -559038737
      - echo 149F     | java_subroutine nextInt 2   # returns  1
      - echo 149F     | java_subroutine nextInt 8   # returns  12
      - echo 149F     | java_subroutine nextInt 10  # returns  149
      - echo 149F     | java_subroutine nextInt 16  # returns  5279

   1. Utilize the `make test_java` command to further test your code.

   1. Tag your final commit from this section with the tag: java_code.

   1. Run the following commands to validate that all is really good!
      ```bash
      make final_java_code
      ``` 


### Task 3: Java TAC code
   Prepare to write your MIPS code by first transforming your Java code into Java TAC code

   1. Transform the methods in each of your files to Java TAC code.
      - bits2int.j: contains the bits2int and get_bit methods
      - nextInt.j: contains the nextInt and glyph2int methods

   1. Test your methods as you did above.

   1. Utilize the `make test_java` command to further test your code.

   1. Tag your final commit from this section with the tag: java_tac_code.

   1. Utilize the following make command to test your final Java versions:
      ```bash
      make final_java_code
      make final_java_tac_code
      ```

   1. Make appropriate adjustments to your code and your tags, as needed!


### Task 4: 'nextInt(int radix)' and 'glyph2int()' in MIPS

   1. Create a file called 'nextInt.s' file that will contain both subroutines.

   1. Transliterate your nextInt and glyph2int methods to produce two MIPS subroutines.

   1. Recall you need to insert the following directives into your 'nextInt.s' file, as we did in class for the 'strcat' example.

      ```mips
                 .data
      buffer:    .space 256

                 .text
                 .include ....
      ```

   1. Remember to demarshal your input arguments.

   1. To facilitate the call to the glyph2int subroutine, use the following transliteration.


        | Java TAC                | MIPS Macro                |
        |-------------------------|---------------------------|
        | a = glyph2int(b, c);    | call glyph2int b c        |
        |                         | move a, $v0               |

      This macro is defined in the 'macros/subroutine.s' file -- don't forget to include that file.

   1. Test your methods as you did above, but by using the `mips_subroutine` command.

   1. Utilize the `make test_mips` command to further test your code.

   1. Tag your final commit from this section with the tag: mips_code.

   1. Utilize the following to make command to test your final set of code for submission:
      ```bash
      make final_java_code
      make final_java_tac_code
      make final_mips_code
      ```

   1. Make appropriate adjustments to your code and your tags, as needed!


### Task 5: Validation Final Submission

   1. Prior to your final submission to the repository, run the `make final` command to test the three versions of your 'nextInt' method/subroutine.

   1. If you were careful and diligent with the steps above, all should be good.  If not make the necessary adjustments.

   1. If you are ready for your final commit, run the following commands:

      ```bash
      make final
      make validate
      git push
      git push --tags
      ```

