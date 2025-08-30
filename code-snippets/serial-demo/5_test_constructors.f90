    function paramsToCase(testParameter) result(tst)
        type(find_steady_state_test_params), intent(in) :: testParameter
        type(find_steady_state_test_case) :: tst
        tst%params = testParameter
    end function paramsToCase

    function find_steady_state_test_params_toString(this) result(string)
        class (find_steady_state_test_params), intent(in) :: this
        character(:), allocatable :: string

        character(len=80) :: buffer
        integer :: nrow, ncol

        nrow = size(this%input_board, 1)
        ncol = size(this%input_board, 2)
        write(buffer,'(i2, "x", i2, " board with ", a)') &
            nrow, ncol, trim(this%description)

        string = trim(buffer)
    end function find_steady_state_test_params_toString