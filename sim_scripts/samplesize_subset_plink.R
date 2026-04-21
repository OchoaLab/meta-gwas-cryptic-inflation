# Creates n=4000 and n=2000 subsets nested within the EXISTING keep_n6000.txt.
rep_num =1

base_dir <- paste0('./sim4_10000/rep',
                   rep_num, '/')

# Read the existing n=6000 keep file — new subsets are nested within it
keep_6000_fn <- paste0(base_dir, 'keep_n6000.txt')
if (!file.exists(keep_6000_fn))
    stop('Expected existing keep file not found: ', keep_6000_fn)

keep_6000 <- read.table(keep_6000_fn, header = FALSE, stringsAsFactors = FALSE)
stopifnot(nrow(keep_6000) == 6000)

# Seed per rep so draws are reproducible but independent across reps
set.seed(seed + rep_num)
idx_4000 <- sample(nrow(keep_6000), 4000)
idx_2000 <- sample(idx_4000, 2000)   # nested: 2000 ⊂ 4000 ⊂ 6000

for (n in c(4000, 2000)) {
    idx     <- if (n == 4000) idx_4000 else idx_2000
    keep_df <- keep_6000[idx, 1:2]
    keep_fn <- paste0(base_dir, 'keep_n', n, '.txt')
    write.table(keep_df, keep_fn,
                row.names = FALSE, col.names = FALSE,
                quote = FALSE, sep = '\t')
    cat('Wrote', keep_fn, '\n')
}
