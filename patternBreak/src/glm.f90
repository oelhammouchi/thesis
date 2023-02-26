module glm

   use, intrinsic :: iso_c_binding
   use constants
   use helpers
   use rng_fort_interface

   implicit none

contains

   subroutine glm_boot(n_dev, triangle, reserve, n_boot, excl_resids)

      real(c_double), intent(in) :: triangle(n_dev, n_dev)
      real(c_double), intent(inout) :: reserve(n_boot)

      integer(c_int), intent(in) :: n_dev, n_boot

      integer(c_int), intent(in), optional :: excl_resids(:, :)

      integer(c_int) :: n_pts, n_covs, n_pred
      real(c_double), allocatable :: betas(:)
      real(c_double), allocatable :: X_pred(:, :) 
      real(c_double), allocatable :: y_pred(:)
      real(c_double), allocatable :: resids(:, :)

      real(c_double), allocatable :: triangle_boot(:, :)
      real(c_double), allocatable :: betas_boot(:)
      real(c_double), allocatable :: resids_boot(:, :)

      logical(c_bool), allocatable :: resids_mask(:, :)
      real(c_double), allocatable :: flat_resids(:)

      integer(c_int) :: i, j, k, i_boot, info
      integer(c_int) :: n_excl_resids, n_resids

      n_pts = (n_dev**2 + n_dev) / 2
      n_covs = 2*n_dev - 1

      n_pred = n_dev ** 2 - n_pts

      allocate(X_pred(n_pred, n_covs))
      allocate(betas(n_covs))

      allocate(resids_boot(n_pts, n_pts))
      allocate(betas_boot(n_covs))
      allocate(triangle_boot(n_pts, n_pts))
      allocate(y_pred(n_pred))

      allocate(resids(n_dev, n_dev))

      allocate(flat_resids(n_pts))
      allocate(resids_mask(n_dev, n_dev))

      resids_mask = .true.

      n_resids = ((n_dev - 1)**2 + (n_dev - 1))/2 - 1

      if (present(excl_resids)) then

         n_excl_resids = size(excl_resids, dim=1)
         n_resids = n_resids - n_excl_resids

         do i = 1, n_excl_resids
            resids_mask(excl_resids(i, 1), excl_resids(i, 2) - 1) = .false.
         end do

      end if

      call poisson_fit(triangle, betas, resids)

      flat_resids = pack(resids, resids_mask)

      ! Resample residuals and simulate triangle.
      call GetRNGstate()

      do i_boot = 1, n_boot

         do i = 1, n_dev
            do j = 1, n_dev + 1 - i
               resids_boot(i, j) = flat_resids(1 + int(n_pts * rand()))
               triangle_boot(i, j) = resids_boot(i, j) * sqrt(triangle(i, j)) + triangle(i, j)
            end do
         end do

         call poisson_fit(triangle_boot, betas_boot)

         X_pred(:, 1) = 1._c_double

         k = 1
         do i = 2, n_dev
            do j = n_dev + 1 - i + 1, n_dev
               X_pred(k, i) = 1
               if (j /= 1) X_pred(k, n_dev + j - 1) = 1
               k = k + 1
            end do
         end do

         y_pred = exp(matmul(X_pred, betas_boot))

         do i = 1, n_pred
            y_pred(i) = rpois(y_pred(i))
         end do

         reserve(i_boot) = sum(y_pred)

      end do

      call PutRNGstate()

   end subroutine glm_boot

   subroutine glm_sim(n_dev, triangle, n_config, m_config, config, type, n_boot, results) bind(C, name='glm_sim_')

      integer(c_int), intent(in), value :: n_dev, n_boot, n_config, m_config, type
      real(c_double), intent(in) :: config(n_config, m_config)
      real(c_double), intent(in) :: triangle(n_dev, n_dev)
      real(c_double), intent(out) :: results(n_boot * n_config, m_config + 1)

      integer(c_int) :: i, j, k, i_sim, counter, n_rows, inc
      integer(c_int) :: outlier_rowidx
      integer(c_int) :: outlier_colidx
      integer(c_int) :: outlier_diagidx
      integer(c_int) :: excl_diagidx
      integer(c_int) :: excl_rowidx

      integer(c_int), allocatable :: excl_resids(:, :)
      real(c_double) :: indiv_dev_facs(n_dev - 1, n_dev - 1)
      real(c_double) :: dev_facs(n_dev - 1)
      real(c_double) :: sigmas(n_dev - 1)
      real(c_double) :: reserve(n_boot)
      real(c_double) :: init_col(n_dev)
      real(c_double) :: triangle_sim(n_dev, n_dev)
      real(c_double) :: factor

      integer(c_int) :: n_covs
      real(c_double), allocatable :: betas(:)

      n_covs = 2*n_dev - 1

      allocate(betas(n_covs))
      call poisson_fit(triangle, betas)

      counter = 0

      do i_sim = 1, n_config

         if (type == SINGLE) then


            allocate(excl_resids(1, 2))
            excl_resids(1, :) = int(config(i_sim, 4:5))

            outlier_rowidx = int(config(i_sim, 1))
            outlier_colidx = int(config(i_sim, 2))
            factor = config(i_sim, 3)

            call single_outlier_glm(triangle_sim, outlier_rowidx, outlier_colidx, factor, betas)

            call glm_boot(n_dev, triangle_sim, reserve, n_boot, excl_resids)

            results(((i_sim - 1)*n_boot + 1):(i_sim*n_boot), 1:m_config) = transpose(spread(config(i_sim, :), 2, n_boot))
            results(((i_sim - 1)*n_boot + 1):(i_sim*n_boot), m_config + 1) = reserve

            deallocate(excl_resids)

         else if (type == CALENDAR) then


            outlier_diagidx = int(config(i_sim, 1))
            excl_diagidx = int(config(i_sim, 3))
            factor = config(i_sim, 2)

            allocate(excl_resids(n_dev - excl_diagidx, 2), source=0)

            k = 1
            do j = 2, n_dev
               i = n_dev + 2 - excl_diagidx - j
               if (i <= 0) cycle
               excl_resids(k, :) = [i, j]
               k = k + 1
            end do

            call calendar_outlier_glm(triangle_sim, outlier_diagidx, factor, betas)

            call glm_boot(n_dev, triangle_sim, reserve, n_boot, excl_resids)

            deallocate(excl_resids)

            results(((i_sim - 1)*n_boot + 1):(i_sim*n_boot), 1:m_config) = transpose(spread(config(i_sim, :), 2, n_boot))
            results(((i_sim - 1)*n_boot + 1):(i_sim*n_boot), m_config + 1) = reserve

         else if (type == ORIGIN) then


            outlier_rowidx = int(config(i_sim, 1))
            excl_rowidx = int(config(i_sim, 3))
            factor = config(i_sim, 2)

            allocate(excl_resids(n_dev - excl_rowidx, 2), source=0)

            k = 1
            do j = 2, n_dev + 1 - excl_rowidx
               excl_resids(k, :) = [excl_rowidx, j]
               k = k + 1
            end do

            call origin_outlier_glm(triangle_sim, outlier_rowidx, factor, betas)

            call glm_boot(n_dev, triangle_sim, reserve, n_boot, excl_resids)

            deallocate(excl_resids)

            results(((i_sim - 1)*n_boot + 1):(i_sim*n_boot), 1:m_config) = transpose(spread(config(i_sim, :), 2, n_boot))
            results(((i_sim - 1)*n_boot + 1):(i_sim*n_boot), m_config + 1) = reserve

         end if

         inc = max(n_config/1000, 1)
         call progress_bar(counter, n_config, inc)
         counter = counter + 1

      end do

   end subroutine glm_sim

   subroutine poisson_fit(triangle, betas, resids)
      real(c_double), intent(in) :: triangle(:, :)
      real(c_double), intent(inout) :: betas(:)
      real(c_double), intent(inout), optional :: resids(:, :)

      real(c_double), allocatable :: X(:, :)
      real(c_double), allocatable :: y(:)

      integer(c_int) :: n_pts, n_covs, n_dev
      integer(c_int) :: i, j, k

      real(c_double) :: diff, eps
      real(c_double), allocatable :: IPIV(:, :), rhs(:), lhs(:, :)
      real(c_double), allocatable :: W(:, :), z(:), eta(:)
      integer(c_int) :: info

      real(c_double), allocatable :: triangle_fit(:, :)
      real(c_double), allocatable :: y_fit(:)

      n_dev = size(triangle, dim=1)

      ! Compute GLM matrix dimensions.
      n_pts = (n_dev**2 + n_dev) / 2
      n_covs = 2*n_dev - 1

      ! Allocate IRWLS variables.
      allocate(X(n_pts, n_covs))
      allocate(y(n_pts))
      allocate(W(n_pts, n_pts))
      allocate(z(n_pts))
      allocate(eta(n_pts))

      ! Allocate LAPACK helper variables.
      allocate(IPIV(n_covs, n_covs))
      allocate(rhs(n_covs))
      allocate(lhs(n_covs, n_covs))

      allocate(triangle_fit(n_dev, n_dev))
      allocate(y_fit(n_pts))

      ! Set up feature matrix and response vector.
      X(:, 1) = 1._c_double

      k = 1
      do i = 1, n_dev
         do j = 1, n_dev + 1 - i
            if (i /= 1) X(k, i) = 1
            if (j /= 1) X(k, n_dev + j - 1) = 1
            y(k) = triangle(i, j)
            k = k + 1
         end do
      end do

      y(1) = triangle(1, 1)

      ! Initialise GLM coefficients.
      betas = spread(0._c_double, 1, n_covs)
      betas(1) = log(sum(y) / n_pts)

      ! Fit Poisson GLM using IRWLS.
      diff = 1E6
      eps = 1E-6
      do while (diff > eps)

         eta = matmul(X, betas)

         W = 0

         do i = 1, n_pts
            W(i, i) = exp(eta(i))
         end do

         z = eta + exp(-eta)*y - 1

         lhs = matmul(matmul(transpose(X), W), X)
         rhs = matmul(matmul(transpose(X), W), z)

         call dgesv(n_covs, 1, lhs, n_covs, IPIV, rhs, n_covs, info)

         diff = norm2(betas - rhs)

         betas = rhs

      end do

      y_fit = exp(matmul(X, betas))

      ! Compute fitted triangle.
      k = 1
      do i = 1, n_dev
         do j = 1, n_dev + 1 - i
            triangle_fit(i, j) = y_fit(k)
            k = k + 1
         end do
      end do

      ! Compute residuals.
      if (present(resids)) then

         do i = 1, n_dev
            do j = 1, n_dev + 1 - i
               resids(i, j) = (triangle(i, j) - triangle_fit(i, j)) / sqrt(triangle_fit(i, j))
            end do
         end do

      end if

   end subroutine poisson_fit

   subroutine glm_boot_centry(n_dev, triangle, n_boot, reserve) bind(C, name='glm_boot_')

      real(c_double), intent(in) :: triangle(n_dev, n_dev)
      real(c_double), intent(inout) :: reserve(n_boot)

      integer(c_int), intent(in), value :: n_dev, n_boot

      call glm_boot(n_dev, triangle, reserve, n_boot)

   end subroutine glm_boot_centry

end module glm
