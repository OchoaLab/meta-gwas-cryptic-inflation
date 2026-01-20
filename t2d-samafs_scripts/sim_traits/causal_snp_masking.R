library(tidyverse)
library(genio)
for (rep_num in 1:10){
  causal_indexes = read.table(paste0("/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/sim_traits/rep_", 
                               rep_num, "/causal_id.txt"), header = TRUE) %>% pull(x)
  bim = read_plink("/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/exome_chip_qc")$bim
  m_causal = 100
  m_loci = nrow(bim)
  window = 5000000
  causal_neighbors_start <- vector( 'integer', m_causal )
  causal_neighbors_end <- vector( 'integer', m_causal )
  
  for ( i in 1L : m_causal ) {
    # i is index in causal_indexes
    # j is index in bim table
    j <- causal_indexes[ i ]
    # get chr/pos from bim
    chr <- bim$chr[ j ]
    pos <- bim$pos[ j ]
    # identify the window of interest first moving backward
    j_start <- j - 1L
    while( j_start > 0 && chr == bim$chr[ j_start ] && pos - bim$pos[ j_start ] < window )
      j_start <- j_start - 1L
    # j_start after loop is first case to fail window, so increment one to be back in window
    j_start <- j_start + 1L
    # repeat going up
    j_end <- j + 1L
    while( j_end <= m_loci && chr == bim$chr[ j_end ] && bim$pos[ j_end ] - pos < window )
      j_end <- j_end + 1L
    j_end <- j_end - 1L
    # add range to loci to ignore
    causal_neighbors_start[ i ] <- j_start
    causal_neighbors_end[ i ] <- j_end
  }
  
  rm_idx <- purrr::map2(causal_neighbors_start, causal_neighbors_end, seq) |> unlist()
  # Remove the causal indices from that removal set
  rm_idx <- setdiff(rm_idx, causal_indexes)
  # remove these indices from bim file
  bim_remove_id <- bim %>% slice(rm_idx) %>% pull(id)
  
  write.table(bim_remove_id, 
              paste0("/home/tt207/pro00108518/t2d-samafs/study2/exome_chip/cryptic-relatedness/sim_traits/rep_", 
                                    rep_num, "/bim_mask_id_5000000.txt"), row.names = FALSE, quote = FALSE)
}



