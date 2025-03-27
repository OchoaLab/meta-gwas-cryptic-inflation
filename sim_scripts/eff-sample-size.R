library(simgenphen)
library(simtrait)
library(tidyverse)
library(ochoalabtools)

# using simulated kinship matrices, calculate some terms that come up in the inflation theory

# the ones that make the most sense to consider are admixture and family structure, the first is not quite what appears in the main simulations, but it's close enough I think

# want a series of sample sizes and heritabilities
n_inds <- 100 * ( 1 : 10 )
n_ind_max <- max( n_inds )
# NOTE: zero herit always results in no confounding, so no point in looking at that factor (complicates things otherwise)
n_herit <- 4
herits <- ( 1 : n_herit ) / n_herit
# and consider with and without family structure
Gs <- c( 1, 30 )
# vary FST too to have a range of structure
# the code works with fst=0 !!!
fsts <- (0:3) / 10
# NOTE: only constants we kept are `k_subpops = 3, bias_coeff = 0.5`

data <- NULL
for ( G in Gs ) {
    for ( fst in fsts ) {
        # make big kinship matrix 
        kinship_max <- sim_pop( n_ind = n_ind_max, G = G, fst = fst, verbose = FALSE )$kinship
        
        for ( n_ind in n_inds ) {
            # subsample
            indexes <- sample.int( n_ind_max, n_ind )
            kinship <- kinship_max[ indexes, indexes ]
            
            for ( herit in herits ) {
                message( 'G=', G, ', fst=', fst, ', n=', n_ind, ', h2=', herit )
                # construct V matrix depending on herit
                V <- cov_trait( kinship, herit )

                # invert, which is the form most of these things have
                V_inv <- solve( V )

                # one statistic is sum_inv
                sum_inv <- sum( V_inv )
                # the others all depend on the normalized version of V_inv
                V_inv_tilde <- V_inv / sum_inv
                w <- rowSums( V_inv_tilde )
                
                # gather data
                data_i <- tibble(
                    n_ind = n_ind,
                    G = G,
                    fst = fst,
                    herit = herit,
                    sum_inv = sum_inv,
                    tr_inv_tilde = sum( diag( V_inv_tilde ) ),
                    tr_w2 = sum( diag( crossprod( w ) ) ),
                    tr_delta = ( tr_inv_tilde - tr_w2 ) * sum_inv,
                    total = 2 * herit * tr_delta^2 / ( n_ind - 1 - ( 1 - herit ) * tr_delta )
                )
                
                data <- bind_rows( data, data_i )
            }
        }
    }
}

# save data for later analysis
setwd( '../data/' )
write_tsv( data, 'eff-sample-size.txt.gz' )

# to read back
#data <- read_tsv( 'eff-sample-size.txt.gz' )

# massage data a tiny bit for plot
data$herit <- factor( data$herit, levels = rev( herits ) )
data <- data %>% rename( FST = fst )

wh <- fig_scale( 2 )

# the total factor is very strongly correlated to sample size, as expected!  So confounding will grow with sample size
fig_start( 'factor', width = wh[1], height = wh[2] )
ggplot( data, aes( x = n_ind, y = total, col = herit ) ) +
    geom_line() +
    theme_classic() +
    facet_grid( G ~ FST, labeller = label_both ) +
    geom_abline( slope = 2, intercept = 0, linetype = 'dashed', color = 'gray' ) +
    labs( x = 'Sample size', y = 'Squared factor', col = 'Heritability' )
fig_end()

# get slope!
fig_start( 'slope', width = wh[1], height = wh[2] )
ggplot( data, aes( x = n_ind, y = total / n_ind, col = herit ) ) +
    geom_line() +
    theme_classic() +
    facet_grid( G ~ FST, labeller = label_both ) +
    labs( x = 'Sample size', y = 'Squared factor / sample size', col = 'Heritability' )
fig_end()


# other things to compare

## # a plot that shows how much larger tr_inv_tilde always is vs tr_w2, so maybe we can ignore that in our math...
## ggplot( data, aes( x = tr_w2, y = tr_inv_tilde, col = herit ) ) +
##     geom_line() +
##     theme_classic() +
##     scale_x_log10() +
##     scale_y_log10()

## # a more recent approximation suggests this is another relevant comparison
## ggplot( data, aes( x = n_ind, y = tr_delta, col = herit ) ) +
##     geom_line() +
##     theme_classic() +
##     geom_abline( slope = 1, intercept = 0, linetype = 'dashed', color = 'gray' )
## # to identify slope:
## ggplot( data, aes( x = n_ind, y = tr_delta / n_ind, col = herit ) ) +
##     geom_line() +
##     theme_classic() +
##     geom_abline( slope = 1, intercept = 0, linetype = 'dashed', color = 'gray' )
