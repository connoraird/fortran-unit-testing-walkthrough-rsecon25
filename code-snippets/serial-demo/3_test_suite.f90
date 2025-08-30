    function getTestSuite() result(params)                                     
        type(find_steady_state_test_params), allocatable :: params(:)

        integer, dimension(:,:), allocatable :: board

        allocate(board(31,31))
        board = 0
        board(9, 9:11) = [0,1,0]
        board(10,9:11) = [1,1,1]
        board(11,9:11) = [1,0,1]
        board(12,9:11) = [0,1,0]
        params = [find_steady_state_test_params(board, .true., 17, "an exploder initial state")]
    end function getTestSuite