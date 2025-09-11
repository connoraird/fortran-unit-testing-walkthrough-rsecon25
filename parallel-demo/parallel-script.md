# Writing a parallel unit test demo script

## Demoing the src code

- We will now take a look at an MPI parallelised version of the game of life we have already looked at. 
    - Like the serial version this is an exercise within the exercises repository but now we are looking at episode 5.
- As this is version is parallelised, we can now run this program using mpirun with different numbers of ranks
    - **mpirun -np 1 ./build-cmake/game-of-life ../models/model-1.dat**
    - **mpirun -np 3 ./build-cmake/game-of-life ../models/model-1.dat**
    - **mpirun -np 8 ./build-cmake/game-of-life ../models/model-1.dat**
- Our task this time is to rewrite the serial test of find_steady_state as a parallel test. To do this we should take a look at how the signature of find_steady_state has changed
    - `animate` is no longer present
    - We have the same outputs as the serial version, `steady_state` and `generation_number`
    - But now there a several more inputs
        - We still have an `input_board` representing the starting state of the system, but now this is called a `global_input_board` as there will also be state local to each rank.
        - We also have `global_ny` and `global_nx` which represent the size of the `global_input_board`
        - We also have a `base_mpi_communicator` indicating that this is an MPI parallelised subroutine.
        - Finally we have `nprocs` representing the number of MPI processors.
    - We should now be able to define our custom types for the parallel test
        - Note that in this exercise the serial test we created earlier is already present however there are a few extra comments, but it's the exact same test.
            - Therefore, the first task is to update the library we're using from funit to pfunit to give us access to the parallel library.

## Writing the new test file

### Defining custom types

- With this we can define our types for the parallel test
    - The only real difference is in the base type we must extend.
        - Instead of extending AbstractTestParameter, we now extend MPITestParameter
    - We then define our inputs and expected outputs which are very similar to the serial versions
    - We also require the same macro as the serial parameter type
- There is also a change needed for the test case type
    - Again the only real change is to the base type we are extending
    - We now extend MPITestCase
- We can now update these types in our parallel test
    - **paste updated types into parallel test**

### Define test suite 

- Next we’ll look at the test suite
    - There is no change to the signature or how we populate the board
    - The key change is that we now add a set of parameters for each number of ranks we want to test.
    - Again, we are using the default constructor of our custom parameter type.
        - However, notice that there is an additional input parameter number of ranks parameters comes from the pfunit base type we have extended - `MPITestParameter`
    - We can now add this test suite into our parallel test file
        - **paste test suite into test file**

### Defining the test execution code
- Looking at the rest of our parallel test, there is not much more that needs to be updated.
    - The constructors do not need to change as we are still using the same parameters in our parallel test as we were in the serial test
    - The only thing we need to update further is the call to find_steady_state to use its new signature within our actual test subroutine.
        - Here we can see how pFUnit is able to control the number of MPI ranks we use for each test case.
            - We are calling type bound functions provided by the pFUnit base types we have extended.
            - These calls return the base mpi communicator to pass into find_steady_state as well as the number of ranks we have requested.
        - **paste call to parallel subroutine into parallel test**
- We have now fully updated our serial test to be a parallel test of find_steady_state

## Adding to CMakeLists build

- The only left to do before we build and run our new test is to make sure CMake is aware that this is a parallel test.
    - To do this we need to make a very small change to tell pFUnit and CMake the maximum number of MPI ranks that this test should be able to be ran with
        - **paste the `MAX_PES 8` line into the parallel CMakeLists.txt**
    - Note that this number must be more than or equal to the maximum number of ranks we request in our test suite.
        - **open test file and show that we set that to be 8**
- We can now build and run our test
    - **cmake –build build-cmake**
    - **ctest –test-dir build-cmake**
- Like we did before, let’s prove the test is working by intentionally breaking it
    - **change 17 to 16**
    - **build and re-run**
    - We can see multiple failures, one for each number of input ranks


