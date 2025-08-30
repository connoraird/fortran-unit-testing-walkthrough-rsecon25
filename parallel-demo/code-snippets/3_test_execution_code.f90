    @Test
    subroutine TestFindSteadyState(this)
        class(find_steady_state_test_case), intent(inout) :: this

        logical :: actual_steady_state
        integer :: actual_generation_number

        call find_steady_state(actual_steady_state, actual_generation_number, this%params%input_board, &
                size(this%params%input_board, 1), size(this%params%input_board, 2), &
                this%getMpiCommunicator(), this%getNumProcessesRequested())

        @assertEqual(this%params%expected_generation_number, actual_generation_number, "Unexpected generation_number")
        @assertTrue(this%params%expected_steady_state .eqv. actual_steady_state, "Unexpected steady_state value")

    end subroutine TestFindSteadyState