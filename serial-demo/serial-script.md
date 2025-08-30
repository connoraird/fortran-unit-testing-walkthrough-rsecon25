# Writing a serial unit test demo script

## Demoing the src code

- I have been developing some exercises to help teach unit testing in Fortran. We will be taking a look at one of those now.
- The src code for this exercise is an implementation of conway’s game of life which you may or may not have heard of
- The important thing to know is 
    - The program reads in a data file representing a starting state.
    - The system is then evolved and printed to the terminal at each time step
- There are some instructions for building shown here but I have already done this to save time so I will just run the model to demonstrate what the game of life is.
    - **./build-cmake/game-of-life ../models/model-1.dat**
- The task we will be focusing on is writing a completely new pFUnit test for the subroutine find_steady_state
- Before we look at find_steady_state, I am going to create a new test file 
    - **create test file**
    - We can utilise the test skeleton we saw earlier, however now we have the dependencies filled in
        - **Paste skeleton into new test file**
- Now we want to define the test parameter type which will be the inputs and expected outputs of the code we are testing. These are the important aspects to understand and the implementation should not really influence how we write our test. 
So let’s take a look at the signature of find_steady_state
    - **Open the test code**
    - We can see that there are two inputs, animate and input_board
        - `animate` is something we will likely always want to be false for testing
        - `input_board` represents the starting state of our system so will determine the value of our expected outputs
    - We can also see two outputs steady_state and generation_number
        - `steady_state` indicates if steady state was found
        - `generation_number` is the  number of generations simulated. 

## Writing the new test file

### Defining custom types

- Therefore, we can now define our parameters type
    - To save time I am going to cheat a little and use some pre-prepared slides rather than typing live.
        - **switch back to slides**
    - Firstly, to allow funit to use our new type we must extend the base type AbstractTestParameters provided by the funit library
    - We then define our inputs, in this case just the input board as we will always set animate to false
    - Then we define our expected outputs, steady_state and generation_number
    - We then define a description and a type-bound procedure called toString.
        - These allow pFUnit to log some helpful information when we run our tests and we’ll see that later
    - Finally we tag our type with a pFUnit macro to allow the preprocessor to pick up this type.
- For pFUnit, we need to define a second type. 
    - This one will extend ParameterizedTestCase from the pFUnit library. This type will be used to let pFUnit know how to run our test case.
    - Our test case type will have only one component and that will be the parameters we have just defined.
    - And finally, we add another pFUnit macro for the preprocessor
        - In this macro we provide some extra info
            - We provide a function which will populate the parameters for our test suite
            - And we provide a constructor for this new type
            - We will implement both of these in a moment.
- We can now add these new types to our test file
    - **Paste types into the test file**

### Define the test suite

- The next step is to define our test parameters or the test suite
    - **return to slides**
    - This is the function we called earlier within the macro of our test case type to define the test parameters
    - Thus, from this function we will return an array of test parameters using the type we have just defined.
    - We can define our inputs for each scenario we want to test, in this case that means defining a board to act as the starting state
    - In the interest of time I’ll just define a single scenario and this will match the model I demonstrated earlier which we read from a file. 
        - This starting state is actually known as an exploder due to the way it evolves.
    - Using this input board we can then populate our parameter array with the scenario. 
        - Here, I am using the default constructor that will be created for our parameter type. 
        - The inputs to this constructor go in the order they were defined in the type. I.e. Inputs then expected outputs and then a description.
    - As we saw earlier, we should expect steady state to be found within 17 generations. 
    - We can now add this to out test file
        - **paste into test file**

### Defining the test execution code

- Now we can define the part of our test which will call find_steady_state and make assertions on its outputs.
    - This will be a subroutine which takes in the test case type we defined earlier
    - We call our src function with variables that will store the actual value of the outputs.
    - We can then begin asserting that these actual outputs match what we expected. 
        - pFUnit provides macros to make writing assertions easier.
        - Therefore, we can use the generic macro, assertEqual, which works for multiple different types
        - We can also pass a message which will be printed should the assertion fail.
    - We can also assert that steady state was reached
        - Unfortunately, assert equal cannot be used for logicals but we can use the assertTrue macro instead.
    - Finally we tag the subroutine with a Test macro to tell the pFUnit preprocessor that this is a test.
    - We can now add this test to our new test file
        - **Copy test to test file**

### Defining the constructors

- Finally we need to define some constructors, including this constructor for our test case type and the toString function used for logging our parameters .
    - Starting with the test case constructor.
        - This will be a function that converts an instance of our parameters type to that of our test case type
        - Therefore, we simply set the input to params within the test case.
    - The toString function 
        - converts an instance of our parameters to a character array or string.
        - We can write whatever we want in this string. I have opted to write the size of the board and the description which I have written to a buffer.
        - I then save this buffer to the string to be returned, trimming any excess whitespace
    - We can now add these two constructors to our test file
        - **Paste constructors into test file**

## Adding to CMakeLists build

- Now that we have a complete test file we need to add this test to our build system so that it can be run with ctest.
    - I have a CMakeLists file within the pfunit directory which is added as a subdirectory in the top level CMakeLists
- Let’s take a look at how we integrate pfunit into our cmake project.
    - Firstly we need to find our pfunit package using find_package which is a built-in CMake function.
        - CMake can find pfunit if we have added the pfunit installed path to our CMAKE_PREFIX_PATH. I will show what this looks like in a moment when I build the tests
        - We then enable ctest which is cmakes inbuilt testing functionality
        - We create a library for our src code
        - We then filter all our tests such that we have only the test files we want to include in an individual ctest test. I have opted to have one test file per ctest test.
        - We can then create a ctest test using a CMake function provided by pfunit, add_pfunit_ctest.
            - Our test is named pfunit_find_steady_state_tests
            - And we have linked the test file to our src code.
- Now we can add our test to cmake and run the tests
    - **copy test into cmake**
    - **build** 
        - Here we provide the path to the the installed pfunit library **cmake -B build -DCMAKE_PREFIX_PATH=/home/vscode/pfunit/build/installed**
        - **cmake –build build-cmake**
        - Then we can run our tests with ctest **ctest –test-dir build-cmake**
- To prove the test is working I will intentionally break it
    - **change 17 to 16**
    - **build and re-run**
