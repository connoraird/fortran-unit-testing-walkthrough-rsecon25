    @testParameter
    type, extends(AbstractTestParameter) :: find_steady_state_test_params
        !> The initial starting board to be passed into find_steady_state
        integer, dimension(:,:), allocatable :: input_board
        !> The expected value of steady_state
        logical :: expected_steady_state
        !> The expected output generation number
        integer :: expected_generation_number
        !> A description of the test to be outputted for logging
        character(len=100) :: description
    contains
        procedure :: toString => find_steady_state_test_params_toString
    end type find_steady_state_test_params

    @TestCase(testParameters={getTestSuite()}, constructor=paramsToCase)
    type, extends(ParameterizedTestCase) :: find_steady_state_test_case
        type(find_steady_state_test_params) :: params
    end type find_steady_state_test_case