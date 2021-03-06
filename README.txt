The scanner.c file contains the project description. The shell script file automatically executes the program on the test cases.


/* ----------------------------PROJECT DESCRIPTION -------------------------
   In this project, you are asked to finish an INCOMPLETE lexical analyzer, 
   certain parts are not coded and you should read the code and fill in the gaps.
   I am going to start by describing the tokens. Then I will discuss some
   difficulty in recognizing tokens that have overlapping prefixes. Then I 
   will give you the requirements for the project.

   It is very important that you read everything carefully. If you are in a
   rush to finish the project, you cannot afford working fast! You should 
   work deliberately and carefully.

   Note: the lexical analyzer provided executes and produces output, but it
   is not always correct output. After you add your code, it shoudl produce
   the correct output in all cases.
 
   ALPHABET

   the alphabet is
                    {0 , 1, 2, 3, 4, 5, 6, 7, 8, 9,
                     a , b , c , ... , z ,
                     A , B, C , ... , Z ,
                     < , > , = , + , - , _ , * , / , 
                     ( , ) , [ , ] , 
                     ',' , :  , ; , . }

   TOKENS

   The tokens are

                    VAR        = (V)(A)(R)
                    BEGIN      = (B)(E)(G)(I)(N)
                    END        = (E)(N)(D)
                    ASSIGN     = (A)(S)(S)(I)(G)(N)
                    IF         = (I)(F)
                    WHILE      = (W)(H)(I)(L)(E)
                    DO         = (D)(O)
                    THEN       = (T)(H)(E)(N)
                    PRINT      = (P)(R)(I)(N)(T)
                    INT        = (I)(N)(T)
                    REAL       = (R)(E)(A)(L)
                    STRING     = (S)(T)(R)(I)(N)(G)
                    PLUS       = '+'
                    MINUS      =  -
					UNDERSCORE =  _
                    DIV        =  / 
                    MULT       =  *
                    EQUAL      = '='
                    COLON      =  :
                    COMMA      =  ,
                    SEMICOLON  =  ;
                    LBRAC      =  [
                    RBRAC      =  ]
                    LPAREN     =  '('
                    RPAREN     =  ')'
                    NOTEQUAL   =  <>
                    GREATER    =  >
                    LESS       =  <
                    LTEQ       =  <=
                    GTEQ       =  >=
                    LSHIFT     =  <<
                    RSHIFT     =  >>
                    DOT        =  '.'
                    NUM        =  pdigit digit* + 0
                    REALNUM    =  NUM DOT digit digit*
                    ID         =  letter (letter+digit)*
                    FUNCID     =  (F)(U)(N)(C)(_) ID
                    SCINUM     =  REALNUM (E+e) ('+' + '-')NUM

                    where 
                          pdigit = 1+2+3+4+5+6+7+8+9
                          digit  = 0+1+2+3+4+5+6+7+8+9
                          letter = a+b+...+z+A+B+...+Z
 
Note that 0.00 is allowed as REALNUM, but 00.1 is not allowed
Also, note that token definitions are case-sensitive. So, "while" is not 
a WHILE token.
Finally, I am using ' ' to distinguish between alphabet synbols and meta
symbols. For example, parentheses are used both as alphabet symbols or as
part of the definition of regular expressions. 

LEXICAL ANALYSIS AND ITS COMPLICATIONS
The main function of lexical analysis is to identify the next token in the input. In the program you are given, the functions that does that is the getToken() function. If there is more than one possibility, we look for the longest possible token. For example, if the input is "FUNC_A1", we do not return two tokens "FUNC"
as an ID token because "FUNC_A1" is a FUNCID and  222 for example and is 
the longest possible token starting at the beginning of the input.

Reading the input is done using a function that reads the next character. In C, getchar() is such a function.

Identifying the longest token is not not always straightforward. For example, consider the input

              111.a

As we start reading the digits, we know that we are looking either for NUM
or for a REALNUM. When '.' is read, we think that there might still be a chance
that a REALNUM will be identified. When the 'a' is read, we realize that we should
identify 111 as a NUM and '.' as a DOT.

In general, this might require backtracking multiple characters (alphabet symbols). In the language we are considering, we need to backtrack at most 2 characters. One way to achieve that in the case of REALNUM is to keep track of every position in which we have identified a "maximal" token (a token that cannot be extended further). For example, in the example above, 111 is a maximal NUM token because for the given input it cannot be extended further into a longer NUM token. The token returned is the longest maximal token. If the input were

      111.1

then both 111 and 111.1 are maximal tokens and we choose the longer between the two.
Note that the ungetc() function can be called multiple times, but characters that are ungot are available for reading operations in the reverse order they were put back into the stream.

So, if you execute 

             ungetc('a',stdin); ungetc('b',stdin); 
             x = getchar(); y = getchar();

then x is 'b' and y is 'a'.

To simplify the identfication of tokens, we should have the cursor pointing
to the next character after the token just identidied. For example, for the input "111+", we need to read the '+' to determine that the token is 111. Instead of keeping the '+' that we read in a variable of the lexical analyzer, we "return it" to the input stream so that next time we call getToken() it will read the '+'. A similar approach would work for REALNUM but the solution is a little more
complicated because we need to return more than one character (see below). 

Another complication arises when the input exactly matches more than one token
in which case the longest prefix matching rule does not help. 
For example, "WHILE" is a WHILE token, but it also matches the format of ID (identifier). In this case, the practice is to identify (return) the token that appears first in the list of tokens. In our list WHILE appears before ID, so we identify "WHILE" as WHILE and not as ID.
       
REQUIREMENTS

You are asked to finish the getToken() and associated functions to identify all tokens defined above. The output of the program is a list of tokens and the line numbers in which they appear. For ID, FUNCID, NUM, REALNUM and SCINUM the actual token string should be printed.

Your program will read the input from standard input (you do not need to modify how characters are read). To read input from a file, you can simply execute the 
following from the command prompt

        ./a.out <filein >fileout

This will execute the program and treats filein as standard output and fileout as standard output. So, instead of diplaying output on the terminal, it will simply write it to file fileout.

You should run and test you program on the general machines. To login to general, you can execute "ssh username@general.asu.edu" from a command prompt 
(where username is your asurite user name) or run the ssh program and connect 
to general. 

To compile your program, you execute 


       gcc scanner.c 

from the command prompt. 

To test your program, I provide you with a set of test cases and the expected output for these cases. Your program will be tested on these cases and some other cases. 

To automate testing your program on the many cases, I provided you with a shell script that will automatically run your program on all the test cases and compares your programs output with the expected output. If they match, it reports success, otherwise, it reports failures and shows where the expected and produced outputs differ. The script expects that your executable name is a.out and that the test cases are in a directory called tests. The script file, the executable and the tests directory should all be in the same directory for testing. In other words, if your project directory is project2, then a.out, test1.sh and tests are all in the directory project2. To execute the script, simply type

      ./test1.sh

from the command prompt. If it complains about test1.sh having no permission, execute

      chmod 700 test1.sh

from the command prompt. You only need to execute chmod once (if you are interested to know, chmod changes the file permission to be executable).

The result of executing test1.sh is a list of all the files that pass the tests and those that do not pass with a comparison between expected output and output of your code. At the end, there is a number. This is the number of the test cases that pass. 

IMPORTANT

read the syllabus for instructions on how to name your files. This is 
very important.

Also, please read the syllabus on grading of programmming assignments.