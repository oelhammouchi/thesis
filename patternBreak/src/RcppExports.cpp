// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppThread.h>
#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// mack_boot
NumericVector mack_boot(NumericMatrix triangle, int n_boot, int resids_type, int boot_type, int dist);
RcppExport SEXP _patternBreak_mack_boot(SEXP triangleSEXP, SEXP n_bootSEXP, SEXP resids_typeSEXP, SEXP boot_typeSEXP, SEXP distSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type triangle(triangleSEXP);
    Rcpp::traits::input_parameter< int >::type n_boot(n_bootSEXP);
    Rcpp::traits::input_parameter< int >::type resids_type(resids_typeSEXP);
    Rcpp::traits::input_parameter< int >::type boot_type(boot_typeSEXP);
    Rcpp::traits::input_parameter< int >::type dist(distSEXP);
    rcpp_result_gen = Rcpp::wrap(mack_boot(triangle, n_boot, resids_type, boot_type, dist));
    return rcpp_result_gen;
END_RCPP
}
// glm_boot
NumericVector glm_boot(NumericMatrix triangle, int n_boot);
RcppExport SEXP _patternBreak_glm_boot(SEXP triangleSEXP, SEXP n_bootSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type triangle(triangleSEXP);
    Rcpp::traits::input_parameter< int >::type n_boot(n_bootSEXP);
    rcpp_result_gen = Rcpp::wrap(glm_boot(triangle, n_boot));
    return rcpp_result_gen;
END_RCPP
}
// mack_sim
NumericMatrix mack_sim(NumericMatrix triangle, int n_boot, NumericMatrix config, int type);
RcppExport SEXP _patternBreak_mack_sim(SEXP triangleSEXP, SEXP n_bootSEXP, SEXP configSEXP, SEXP typeSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type triangle(triangleSEXP);
    Rcpp::traits::input_parameter< int >::type n_boot(n_bootSEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type config(configSEXP);
    Rcpp::traits::input_parameter< int >::type type(typeSEXP);
    rcpp_result_gen = Rcpp::wrap(mack_sim(triangle, n_boot, config, type));
    return rcpp_result_gen;
END_RCPP
}
// glm_sim
NumericMatrix glm_sim(NumericMatrix triangle, int n_boot, NumericMatrix config, int type);
RcppExport SEXP _patternBreak_glm_sim(SEXP triangleSEXP, SEXP n_bootSEXP, SEXP configSEXP, SEXP typeSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type triangle(triangleSEXP);
    Rcpp::traits::input_parameter< int >::type n_boot(n_bootSEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type config(configSEXP);
    Rcpp::traits::input_parameter< int >::type type(typeSEXP);
    rcpp_result_gen = Rcpp::wrap(glm_sim(triangle, n_boot, config, type));
    return rcpp_result_gen;
END_RCPP
}
// test
NumericVector test();
RcppExport SEXP _patternBreak_test() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(test());
    return rcpp_result_gen;
END_RCPP
}
// test2
NumericVector test2();
RcppExport SEXP _patternBreak_test2() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(test2());
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_patternBreak_mack_boot", (DL_FUNC) &_patternBreak_mack_boot, 5},
    {"_patternBreak_glm_boot", (DL_FUNC) &_patternBreak_glm_boot, 2},
    {"_patternBreak_mack_sim", (DL_FUNC) &_patternBreak_mack_sim, 4},
    {"_patternBreak_glm_sim", (DL_FUNC) &_patternBreak_glm_sim, 4},
    {"_patternBreak_test", (DL_FUNC) &_patternBreak_test, 0},
    {"_patternBreak_test2", (DL_FUNC) &_patternBreak_test2, 0},
    {NULL, NULL, 0}
};

RcppExport void R_init_patternBreak(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
