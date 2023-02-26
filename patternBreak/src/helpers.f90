module helpers

   use iso_c_binding
   use constants
   use rng_fort_interface
   use print_fort_interface

   implicit none

contains

   function single_outlier_mack(outlier_rowidx, outlier_colidx, factor, init_col, dev_facs, sigmas, dist) result(triangle)

      integer, intent(in):: outlier_rowidx, outlier_colidx
      real(c_double), intent(in) :: init_col(:), dev_facs(:), sigmas(:)
      integer(c_int), intent(in) :: dist

      real(c_double) :: factor
      real(c_double), allocatable:: triangle(:, :)

      real(c_double) :: shape, scale
      real(c_double) :: mean, sd

      integer :: n_dev, i, j

      n_dev = size(init_col)

      allocate(triangle(n_dev, n_dev), source=0._c_double)
      triangle(:, 1) = init_col

      if (dist == NORMAL) then

         do j = 2, n_dev
            do i = 1, n_dev + 1 - j
               if (i == outlier_rowidx) cycle
               mean = dev_facs(j - 1) * triangle(i, j - 1)
               sd = sigmas(j - 1) * sqrt(triangle(i, j - 1))
               triangle(i, j) = rnorm(mean, sd)
            end do
         end do

         if (outlier_colidx > 2) then
            do j = 2, outlier_colidx - 1
               mean = dev_facs(j - 1) * triangle(outlier_rowidx, j - 1)
               sd = sigmas(j - 1) * sqrt(triangle(outlier_rowidx, j - 1))
               triangle(outlier_rowidx, j) = rnorm(mean, sd)
            end do
         end if

         mean = factor * dev_facs(outlier_colidx - 1) * triangle(outlier_rowidx, outlier_colidx - 1)
         sd = sigmas(outlier_colidx - 1) * sqrt(triangle(outlier_rowidx, outlier_colidx - 1))
         triangle(outlier_rowidx, outlier_colidx) = rnorm(mean, sd)

         if (outlier_colidx < n_dev) then
            do j = outlier_colidx + 1, n_dev + 1 - outlier_rowidx
               mean = dev_facs(j - 1) * triangle(outlier_rowidx, j - 1)
               sd = sigmas(j - 1) * sqrt(triangle(outlier_rowidx, j - 1))
               triangle(outlier_rowidx, j) = rnorm(mean, sd)
            end do
         end if

      else if (dist == GAMMA) then

         do j = 2, n_dev
            do i = 1, n_dev + 1 - j
               if (i == outlier_rowidx) cycle
               shape = dev_facs(j - 1)**2 * triangle(i, j - 1) / sigmas(j - 1)**2
               scale = sigmas(j - 1)**2 / dev_facs(j - 1)
               triangle(i, j) = rgamma(shape, scale)
            end do
         end do

         if (outlier_colidx > 2) then
            do j = 2, outlier_colidx - 1
               shape = dev_facs(j - 1)**2 * triangle(outlier_rowidx, j - 1) / sigmas(j - 1)**2
               scale = sigmas(j - 1)**2 / dev_facs(j - 1)
               triangle(outlier_rowidx, j) = rgamma(shape, scale)
            end do
         end if

         shape = dev_facs(outlier_colidx - 1)**2 * triangle(outlier_rowidx, outlier_colidx - 1) / sigmas(outlier_colidx - 1)**2
         scale = sigmas(outlier_colidx - 1)**2 / dev_facs(outlier_colidx - 1)
         triangle(outlier_rowidx, outlier_colidx) = rgamma(shape, scale)

         if (outlier_colidx < n_dev) then
            do j = outlier_colidx + 1, n_dev + 1 - outlier_rowidx
               shape = dev_facs(j - 1)**2 * triangle(outlier_rowidx, j - 1) / sigmas(j - 1)**2
               scale = sigmas(j - 1)**2 / dev_facs(j - 1)
               triangle(outlier_rowidx, j) = rgamma(shape, scale)
            end do
         end if

      end if

   end function single_outlier_mack

   function calendar_outlier_mack(outlier_diagidx, factor, triangle, dev_facs, sigmas, dist) result(sim_triangle)

      integer, intent(in) :: outlier_diagidx
      real(c_double), intent(in):: factor
      real(c_double), intent(in) :: triangle(:, :), dev_facs(:), sigmas(:)
      integer(c_int), intent(in) :: dist

      integer :: i, j, n_dev, n_cols
      real(c_double), allocatable :: sim_triangle(:, :)
      real(c_double) :: shape, scale
      real(c_double) :: mean, sd

      n_dev = size(triangle, dim=1)

      allocate(sim_triangle(n_dev, n_dev), source=0._c_double)
      sim_triangle(:, 1) = triangle(:, 1)

      do i = 1, n_dev
         n_cols = n_dev + 2 - outlier_diagidx - i
         if (n_cols <= 1) then
            do j = 2, n_dev + 1 - i
               sim_triangle(i, j) = triangle(i, j)
            end do
         else
            do j = 2, n_cols - 1
               sim_triangle(i, j) = triangle(i, j)
            end do

            if (dist == NORMAL) then

               mean = factor * dev_facs(n_cols - 1) * sim_triangle(i, n_cols - 1)
               sd = sigmas(n_cols - 1) * sqrt(sim_triangle(i, n_cols - 1))

               sim_triangle(i, n_cols) = rnorm(mean, sd)

               do j = n_cols + 1, n_dev + 1 - i
                  mean = dev_facs(j - 1) * sim_triangle(i, j - 1)
                  sd = sigmas(j - 1) * sqrt(sim_triangle(i, j - 1))

                  sim_triangle(i, j) = rnorm(mean, sd)
               end do

            else if (dist == GAMMA) then

               shape = factor * dev_facs(n_cols - 1)**2 * sim_triangle(i, n_cols - 1) / sigmas(n_cols - 1)**2
               scale = sigmas(n_cols - 1)**2 / factor * dev_facs(n_cols - 1)

               sim_triangle(i, n_cols) = rgamma(shape, scale)

               do j = n_cols + 1, n_dev + 1 - i

                  shape = dev_facs(j - 1)**2 * sim_triangle(i, j - 1) / sigmas(j - 1)**2
                  scale = sigmas(j - 1)**2 / dev_facs(j - 1)

                  sim_triangle(i, j) = rgamma(shape, scale)

               end do

            end if

         end if
      end do

   end function calendar_outlier_mack

   function origin_outlier_mack(outlier_rowidx, factor, triangle, dev_facs, sigmas, dist) result(sim_triangle)

      integer, intent(in):: outlier_rowidx
      real(c_double), intent(in) :: triangle(:, :), dev_facs(:), sigmas(:)
      integer(c_int), intent(in) :: dist
      real(c_double), intent(in) :: factor

      real(c_double) :: shape, scale
      real(c_double) :: mean, sd
      real(c_double), allocatable:: sim_triangle(:, :)

      integer(c_int) :: n_dev, i, j

      n_dev = size(triangle, dim=1)
      sim_triangle = triangle

      do j = 2, n_dev + 1 - outlier_rowidx

         if (dist == NORMAL) then

            mean = factor * dev_facs(j - 1) * sim_triangle(outlier_rowidx, j - 1)
            sd = sigmas(j - 1) * sqrt(sim_triangle(outlier_rowidx, j - 1))
            sim_triangle(outlier_rowidx, j) = rnorm(mean, sd)

         else if (dist == GAMMA) then

            shape = factor * dev_facs(j - 1)**2 * sim_triangle(outlier_rowidx, j - 1) / sigmas(j - 1)**2
            scale = sigmas(j - 1)**2 / factor * dev_facs(j - 1)
            sim_triangle(outlier_rowidx, j) = rgamma(shape, scale)

         end if
      end do

   end function origin_outlier_mack

   subroutine single_outlier_glm(triangle, outlier_rowidx, outlier_colidx, factor, betas)
      integer(c_int), intent(in) :: outlier_rowidx
      integer(c_int), intent(in) :: outlier_colidx
      real(c_double), intent(in) :: factor
      real(c_double), intent(in) :: betas(:)
      real(c_double), intent(inout) :: triangle(:, :)
      
      real(c_double) :: lambda

      lambda = factor * exp(betas(1) + betas(outlier_rowidx - 1) + betas(outlier_colidx - 1))
      triangle(outlier_rowidx, outlier_colidx) = rpois(lambda) 

   end subroutine single_outlier_glm

   subroutine calendar_outlier_glm(triangle, outlier_diagidx, factor, betas)
      integer(c_int), intent(in) :: outlier_diagidx
      real(c_double), intent(in) :: factor
      real(c_double), intent(in) :: betas(:)
      real(c_double), intent(inout) :: triangle(:, :)
      
      real(c_double) :: lambda
      integer(c_int) :: i, j, n_dev

      n_dev = size(triangle, dim=1)

      do i = 1, n_dev

         j = n_dev + 2 - outlier_diagidx - i
         if (j < 1) cycle

         if (j == 1 .and. i == 1) then 
            lambda = factor * exp(betas(1))
         else if (j == 1) then
            lambda = factor * exp(betas(1) + betas(i - 1))
         else if (i == 1) then
            lambda = factor * exp(betas(1) + betas(j - 1))
         else
            lambda = factor * exp(betas(1) + betas(i - 1) + betas(j - 1))
         end if

         triangle(i, j) = rpois(lambda) 

      end do

   end subroutine calendar_outlier_glm

   subroutine origin_outlier_glm(triangle, outlier_rowidx, factor, betas)
      integer(c_int), intent(in) :: outlier_rowidx
      real(c_double), intent(in) :: factor
      real(c_double), intent(in) :: betas(:)
      real(c_double), intent(inout) :: triangle(:, :)
      
      real(c_double) :: lambda
      integer(c_int) :: i, j, n_dev

      n_dev = size(triangle, dim=1)

      i = outlier_rowidx

      do j = 1, n_dev + 1 - i

         if (j == 1 .and. i == 1) then 
            lambda = factor * exp(betas(1))
         else if (j == 1) then
            lambda = factor * exp(betas(1) + betas(i - 1))
         else if (i == 1) then
            lambda = factor * exp(betas(1) + betas(j - 1))
         else
            lambda = factor * exp(betas(1) + betas(i - 1) + betas(j - 1))
         end if   
         
         triangle(i, j) = rpois(lambda) 

      end do

   end subroutine origin_outlier_glm

   subroutine progress_bar(counter, max, inc)

      integer(c_int), intent(in) :: counter
      integer(c_int), intent(in) :: max
      integer(c_int), intent(in) :: inc

      character(len=999) :: buf
      character(kind=c_char, len=999) :: progress_str   
      integer :: cols
      real(c_double) :: progress
      real(c_double) :: pct_progress

      if (mod(counter, inc) == 0) then

         progress = real(counter, kind=c_double) / real(max, kind=c_double)
         pct_progress = 100*progress

         call get_environment_variable("COLUMNS", buf)
         read(buf, *) cols

         write(progress_str, "('Progress: ', f6.2)") pct_progress
         call Rprintf(achar(13) // c_null_char)
         call Rprintf(repeat(" ", cols) // c_null_char)
         call Rprintf(achar(13) // c_null_char)
         call Rprintf(trim(progress_str) // c_null_char )
         call Rprintf(achar(13) // c_null_char)
         call R_FlushConsole()

      end if

      if (counter == max) then

         call get_environment_variable("COLUMNS", buf)
         read(buf, *) cols

         call Rprintf(repeat(" ", cols) // c_null_char)

      end if
         
   end subroutine progress_bar

end module helpers
