rep_num = 1

root     <- '/hpc/group/ochoalab/tt207/meta_analysis_aim'
base_dir <- paste0(root, '/sim4_10000/rep', rep_num, '/')
covar_fn <- paste0(base_dir, '30G_covar_10000n_100causal_500000m_fes.txt')

covar <- read.table(covar_fn, header = TRUE, stringsAsFactors = FALSE,
                    check.names = FALSE)
stopifnot(all(c('famid','iid','sex','trait') %in% colnames(covar)))

for (n in c(4000, 2000)) {
    keep_fn <- paste0(base_dir, 'keep_n', n, '.txt')
    keep    <- read.table(keep_fn, header = FALSE, stringsAsFactors = FALSE,
                          col.names = c('famid', 'iid'))

    key_keep  <- paste(keep$famid,  keep$iid,  sep = '\t')
    key_covar <- paste(covar$famid, covar$iid, sep = '\t')
    covar_sub <- covar[match(key_keep, key_covar), , drop = FALSE]
    if (anyNA(covar_sub$famid))
        stop('Some kept individuals not found in covar file for n=', n)

    out_dir <- paste0(root, '/sim4_', n, '/rep', rep_num)
    dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
    out_fn  <- paste0(out_dir, '/30G_covar_', n, 'n_100causal_500000m_fes.txt')
    write.table(covar_sub, out_fn,
                row.names = FALSE, quote = FALSE, sep = '\t')
    cat('Wrote', out_fn, '\n')
}
