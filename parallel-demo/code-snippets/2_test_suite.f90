    function getTestSuite() result(params)
        type(find_steady_state_test_params), allocatable :: params(:)

        integer :: i, max_num_ranks = 8
        integer, dimension(:,:), allocatable :: board

        allocate(board(31, 31))
        board = 0
        board(9,9:11)  = [0,1,0]
        board(10,9:11) = [1,1,1]
        board(11,9:11) = [1,0,1]
        board(12,9:11) = [0,1,0]

        allocate(params(max_num_ranks))
        do i = 1, max_num_ranks
            params(i) = find_steady_state_test_params(i, board, .true., 17, "an exploder initial state")
        end do
    end function getTestSuite