# Wrapper function for statistics calculated by snpR: single-SNP genetic
# statistics, proportion of polymorphic sites, number of segregating sites, FIS,
# pairwise-FST and HWE

calc_snpR_gendiv <- 
  function(snpR_object, facets) {
    snpR_object <- calc_ho(snpR_object, facets)
    snpR_object <- calc_he(snpR_object, facets)
    snpR_object <- calc_hwe(snpR_object, facets)  ##single
    snpR_object <- calc_pi(snpR_object, facets)
    snpR_object <- calc_seg_sites(snpR_object, facets)
    snpR_object <- calc_private(snpR_object, facets)
    snpR_object <- calc_hs(snpR_object, facets)
    snpR_object <- calc_prop_poly(snpR_object, facets)
    snpR_object <- calc_allelic_richness(snpR_object, facets)
    snpR_object <- calc_fis(snpR_object, facets)
    
    
    return(snpR_object)
  }
