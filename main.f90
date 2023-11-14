program main
  ! Oh yes! documentation time
  ! yeah so i'll try adding parameters input as it is apparently possible
  ! the way we'll make that work is :
  ! compiled.out weight_type input_file output_file
  ! weight_type : ones or square
  ! input_file : path to the file
  ! output_file : path to the file
  implicit none
  real :: pi = acos(-1.0)





    integer :: i

    integer :: max_elements
    integer, parameter :: start = 2280 
    real, parameter :: step = 0.01
    real, allocatable :: data(:) ! max_elements


    !  DECLARED BUT OVERWRITTEN USING COMMAND ARGUMENTS
    ! file opening
    character(100) :: filename = "data/spectre_1.txt"
    !output files
    character(100) :: filename_output = "output/spectre_1"




    ! X
    character(100) :: weight_type ! set later using command arguments
    real :: sigma 
    real, allocatable :: X(:) ! (max_elements)
    real, allocatable :: omegas(:)!(max_elements) 
    real :: m_omega

    ! coefficients
    real, allocatable :: weights(:)!(max_elements) = [(1, i=1, max_elements)]
    real :: m_y, m_x, m_x2, m_x3, m_x4, m_xy, m_x2y, m_w

    real :: under
    real :: a0, a1, a2

    ! final coeffs
    real :: omegam, gamma, S

    !final theoretical curve
    real, allocatable :: theoretical_f(:)!(max_elements)





    ! commandline arguments
    ! weight type
    call get_command_argument(1, weight_type)
    ! input file
    call get_command_argument(2, filename)
    ! output file
    call get_command_argument(3, filename_output)












    call CountLinesInFile(filename, max_elements)
    print *, "number of items", max_elements


    ! allocate stuff
    ! data
    allocate(data(max_elements))
    ! X
    allocate(X(max_elements))
    !omegas
    allocate(omegas(max_elements))
    !weights
    allocate(weights(max_elements))
    weights = [(1, i=1, max_elements)]
    !theoretical_f
    allocate(theoretical_f(max_elements))











    print *, "Opening and reading file ", filename
    call ReadFileFixed(filename, max_elements, data)
    ! print *, data


    print *, "Getting sigma"
    omegas = [(start + real(i - 1) * step, i = 1,max_elements)]
    ! print *, omegas

    call ComputeStandardDeviation(omegas, max_elements, sigma)
    print *, "Sigma : ", sigma

    print *, "Computing X"
    call ComputeAverage(omegas, max_elements, m_omega)
    print *, "m_omega", m_omega
    X = (omegas - m_omega) / sigma

    
    ! weight computation if set to square 
    print *, "Weight type =================================================", weight_type
    if (weight_type == "square") then
      weights = (data)**2
    endif
    
    
    call ComputeAverage(weights, max_elements, m_w)
    

    print *, "Getting means"
    ! m_y
    call weighted_average(1/data, weights, max_elements, m_y)
    ! m_x
    call weighted_average(X, weights, max_elements, m_x)
    ! m_x2
    call weighted_average(X**2, weights, max_elements, m_x2)
    ! m_x3
    call weighted_average(X**3, weights, max_elements, m_x3)
    ! m_x4
    call weighted_average(X**4, weights, max_elements, m_x4)
    ! m_xy
    call weighted_average(X*(1/data), weights, max_elements, m_xy)
    ! m_x2y
    call weighted_average(X**2*(1/data), weights, max_elements, m_x2y)

    print *, "m_y", m_y, "m_x", m_x, "m_x2", m_x2, "m_x3", m_x3, "m_x4", m_x4, "m_xy", m_xy, "m_x2y", m_x2y





    print *, "Getting a0 - a2"

    under = m_w*m_x2*m_x4 + 2*m_x*m_x2*m_x3 - m_x2**3 - m_w*m_x3**2 - m_x**2*m_x4
    print *, "denom", under

    a0 = (m_y*m_x2*m_x4 + m_xy*m_x3*m_x2 + m_x*m_x3*m_x2y - m_x2y*m_x2**2 - m_y*m_x3**2 - m_x*m_xy*m_x4)/under

    a1 = (m_w*m_xy*m_x4 + m_x2*m_x3*m_y + m_x*m_x2*m_x2y - m_x2**2*m_xy - m_x*m_x4*m_y - m_w*m_x3*m_x2y  )/under

    a2 = (m_w*m_x2*m_x2y + m_x*m_x3*m_y + m_x*m_x2*m_xy - m_x2**2*m_y - m_x**2*m_x2y - m_w*m_x3*m_xy)/under

    print *, "a0", a0, "a1", a1, "a2", a2



    omegam = m_omega - ((sigma*a1) / (2*a2))
    gamma = sigma * sqrt((a0/a2) - (a1**2)/(4*a2**2))
    S = (pi*sigma) / sqrt(a0*a2 - (a1**2)/4)

    print *, "omegam", omegam, "gamma", gamma, "S", S




    ! theoretical curve using previously computed parameters
    theoretical_f = (S/pi) * gamma/((omegas-omegam)**2 + gamma**2)

    print *, S, gamma, omegam, sigma

    print *, "theoretical was computed correctly"
    print *, "saving in : ", filename_output


    ! save it somewhere over the rainbow
    open(unit=10, file=filename_output, status='replace')
    do i = 1, size(theoretical_f)
      write(10, '(F6.2)') theoretical_f(i)
    end do
    close(10)


    print *, "file correctly written"
































    contains 

    subroutine ComputeStandardDeviation(arr, n, std_dev)
        implicit none
        real, intent(in) :: arr(:)  ! Array of real numbers
        integer, intent(in) :: n     ! Number of elements in the array
        real, intent(out) :: std_dev ! Output variable for the standard deviation
        real :: mean               ! Mean of the array
        real :: sum_squared_diff   ! Sum of squared differences
        integer :: i
      
        ! Calculate the mean of the array using the previously defined subroutine
        call ComputeAverage(arr, n, mean)
      
        ! Initialize the sum of squared differences to zero
        sum_squared_diff = 0.0
      
        ! Compute the sum of squared differences from the mean
        do i = 1, n
          sum_squared_diff = sum_squared_diff + (arr(i) - mean)**2
        end do
      
        ! Calculate the standard deviation
        if (n > 1) then
          std_dev = sqrt(sum_squared_diff / real(n))
        else
          ! Handle the case where n is less than 2 to avoid division by zero
          std_dev = 0.0
        end if
      end subroutine ComputeStandardDeviation
      

    subroutine ComputeAverage(arr, n, average)
        implicit none
        real, intent(in) :: arr(:)  ! Array of real numbers
        integer, intent(in) :: n     ! Number of elements in the array
        real, intent(out) :: average ! Output variable for the average
        real :: total              ! Variable to store the running sum
        integer :: i


        ! Initialize the running sum to zero
        total = 0.0
      
        ! Compute the sum of all elements in the array
        do i = 1, n
          total = total + arr(i)
        end do
      
        ! Calculate the average
        average = total / real(n)

      end subroutine ComputeAverage
      


    subroutine weighted_average(values, weights, n, result)
        implicit none
        real, intent(in) :: values(:) ! Array of values
        real, intent(in) :: weights(:) ! Array of weights
        integer, intent(in) :: n        ! Number of values/weights
        real, intent(out) :: result    ! Weighted average result
      
        integer :: i
     
        result = 0.0
      
        do i = 1, n
          result = result + (values(i) * weights(i))
        end do
      
        result = result / real(n)

      
      end subroutine weighted_average




      subroutine ReadFileFixed(RFF_filename, RFF_max_elements, RFF_data)
        implicit none
    
        integer, intent(in) :: RFF_max_elements
        real, intent(out) :: RFF_data(RFF_max_elements)
        integer :: num_elements
        integer :: unit_number, ios
        character(100) :: RFF_filename
    
        ! Open the file for reading
        open(unit=unit_number, file=RFF_filename, status='old', action='read', iostat=ios)
        if (ios /= 0) then
            write(*, *) 'Error opening file: ', RFF_filename
            stop
        end if
    
        ! Read the data from the file into the array
        num_elements = 0
        do
            read(unit_number, *, iostat=ios) RFF_data(num_elements + 1)
            if (ios /= 0) exit
            num_elements = num_elements + 1
        end do
    
        ! Close the file
        close(unit_number)
    
    end subroutine ReadFileFixed

    subroutine CountLinesInFile(filename, num_lines)
      character(len=*), intent(in) :: filename
      integer, intent(out) :: num_lines
      integer :: ierr
    
      character(512) :: line
      integer :: unit
      num_lines = 0
      ierr = 0
    
      ! Open the file
      open(unit, file=filename, status='old', action='read', iostat=ierr)
      if (ierr /= 0) then
        ierr = 1
        return
      end if
    
      ! Read the file line by line and count the lines
      do
        read(unit, '(A)', iostat=ierr) line
        if (ierr /= 0) then
          if (ierr /= -1) then
            ierr = 2
          end if
          exit
        end if
        num_lines = num_lines + 1
      end do
    
      ! Close the file
      close(unit)
    end subroutine CountLinesInFile
    
    


end program main