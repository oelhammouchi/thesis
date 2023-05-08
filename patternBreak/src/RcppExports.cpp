// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppThread.h>
#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// glm_boot
Rcpp::NumericVector glm_boot(Rcpp::NumericMatrix triangle, int n_boot);
RcppExport SEXP _patternBreak_glm_boot(SEXP triangleSEXP, SEXP n_bootSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< Rcpp::NumericMatrix >::type triangle(triangleSEXP);
    Rcpp::traits::input_parameter< int >::type n_boot(n_bootSEXP);
    rcpp_result_gen = Rcpp::wrap(glm_boot(triangle, n_boot));
    return rcpp_result_gen;
END_RCPP
}
// glm_sim
Rcpp::NumericMatrix glm_sim(Rcpp::NumericMatrix triangle, int n_boot, Rcpp::NumericMatrix config, int type);
RcppExport SEXP _patternBreak_glm_sim(SEXP triangleSEXP, SEXP n_bootSEXP, SEXP configSEXP, SEXP typeSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< Rcpp::NumericMatrix >::type triangle(triangleSEXP);
    Rcpp::traits::input_parameter< int >::type n_boot(n_bootSEXP);
    Rcpp::traits::input_parameter< Rcpp::NumericMatrix >::type config(configSEXP);
    Rcpp::traits::input_parameter< int >::type type(typeSEXP);
    rcpp_result_gen = Rcpp::wrap(glm_sim(triangle, n_boot, config, type));
    return rcpp_result_gen;
END_RCPP
}
// mackBoot
Rcpp::NumericVector mackBoot(Rcpp::NumericMatrix triangle, int n_boot, Rcpp::String boot_types, Rcpp::String proc_dist, bool conditional, Rcpp::Nullable<Rcpp::String> resids_type, int seed);
RcppExport SEXP _patternBreak_mackBoot(SEXP triangleSEXP, SEXP n_bootSEXP, SEXP boot_typesSEXP, SEXP proc_distSEXP, SEXP conditionalSEXP, SEXP resids_typeSEXP, SEXP seedSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< Rcpp::NumericMatrix >::type triangle(triangleSEXP);
    Rcpp::traits::input_parameter< int >::type n_boot(n_bootSEXP);
    Rcpp::traits::input_parameter< Rcpp::String >::type boot_types(boot_typesSEXP);
    Rcpp::traits::input_parameter< Rcpp::String >::type proc_dist(proc_distSEXP);
    Rcpp::traits::input_parameter< bool >::type conditional(conditionalSEXP);
    Rcpp::traits::input_parameter< Rcpp::Nullable<Rcpp::String> >::type resids_type(resids_typeSEXP);
    Rcpp::traits::input_parameter< int >::type seed(seedSEXP);
    rcpp_result_gen = Rcpp::wrap(mackBoot(triangle, n_boot, boot_types, proc_dist, conditional, resids_type, seed));
    return rcpp_result_gen;
END_RCPP
}
// mackSim
Rcpp::DataFrame mackSim(Rcpp::NumericMatrix triangle, Rcpp::String sim_type, int n_boot, Rcpp::NumericVector mean_factors, Rcpp::NumericVector sd_factors, Rcpp::CharacterVector boot_types, Rcpp::String sim_dist, bool show_progress, int seed);
RcppExport SEXP _patternBreak_mackSim(SEXP triangleSEXP, SEXP sim_typeSEXP, SEXP n_bootSEXP, SEXP mean_factorsSEXP, SEXP sd_factorsSEXP, SEXP boot_typesSEXP, SEXP sim_distSEXP, SEXP show_progressSEXP, SEXP seedSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< Rcpp::NumericMatrix >::type triangle(triangleSEXP);
    Rcpp::traits::input_parameter< Rcpp::String >::type sim_type(sim_typeSEXP);
    Rcpp::traits::input_parameter< int >::type n_boot(n_bootSEXP);
    Rcpp::traits::input_parameter< Rcpp::NumericVector >::type mean_factors(mean_factorsSEXP);
    Rcpp::traits::input_parameter< Rcpp::NumericVector >::type sd_factors(sd_factorsSEXP);
    Rcpp::traits::input_parameter< Rcpp::CharacterVector >::type boot_types(boot_typesSEXP);
    Rcpp::traits::input_parameter< Rcpp::String >::type sim_dist(sim_distSEXP);
    Rcpp::traits::input_parameter< bool >::type show_progress(show_progressSEXP);
    Rcpp::traits::input_parameter< int >::type seed(seedSEXP);
    rcpp_result_gen = Rcpp::wrap(mackSim(triangle, sim_type, n_boot, mean_factors, sd_factors, boot_types, sim_dist, show_progress, seed));
    return rcpp_result_gen;
END_RCPP
}
// test_pois
Rcpp::NumericVector test_pois(int n, double lambda);
RcppExport SEXP _patternBreak_test_pois(SEXP nSEXP, SEXP lambdaSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< int >::type n(nSEXP);
    Rcpp::traits::input_parameter< double >::type lambda(lambdaSEXP);
    rcpp_result_gen = Rcpp::wrap(test_pois(n, lambda));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_patternBreak_glm_boot", (DL_FUNC) &_patternBreak_glm_boot, 2},
    {"_patternBreak_glm_sim", (DL_FUNC) &_patternBreak_glm_sim, 4},
    {"_patternBreak_mackBoot", (DL_FUNC) &_patternBreak_mackBoot, 7},
    {"_patternBreak_mackSim", (DL_FUNC) &_patternBreak_mackSim, 9},
    {"_patternBreak_test_pois", (DL_FUNC) &_patternBreak_test_pois, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_patternBreak(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
