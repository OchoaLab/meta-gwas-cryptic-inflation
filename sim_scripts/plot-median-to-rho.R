library(tidyverse)
library(ochoalabtools)
library(metalcor)

# copy this package constant
em <- metalcor:::em

# produce a high resolution curve in the critical range where hard calculations are needed
xs <- seq( -0.5, 0.5, by = 0.001 )
n <- length( xs )
ys <- rep.int( NA, n )
for ( i in 1 : n )
    ys[i] <- rho_from_median( xs[i] )

# tidy data
data <- tibble(
    median = xs,
    rho = ys
)

# save here
setwd( '../data/' )

# plot!
fig_start( 'median-to-rho', wh = fig_scale( 1 ) )
ggplot( data, aes( x = median, y = rho ) ) +
    # diagonal guide
    geom_abline( slope = 1 / em, intercept = 0, col = 'gray', linetype = "dashed" ) +
    # box showing limits
    geom_hline( yintercept = c(-1,1), col = 'gray', linetype = "dashed" ) +
    geom_vline( xintercept = c(-1,1) * em, col = 'gray', linetype = "dashed" ) +
    # data
    geom_line() +
    theme_classic() +
    labs(
        x = 'Product median',
        y = 'Correlation'
    )
fig_end()
