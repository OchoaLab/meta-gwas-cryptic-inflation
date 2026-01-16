# simulate just a few p-values with a mix of null and alternatives, with varying power

library(simtrait)
library(tidyverse)
library(ochoalabtools)

# sample size of each case
m <- 100000 # final desired size, looks best
#m <- 1000 # while we tweak
# for degrees of freedom
df <- 1

# reuse nulls in all of these cases
p_null <- runif( m )

# expected p-values, same for both and in all cases
m2 <- m * 2
ps_exp <- ( 1 : m2 ) / ( m2 + 1 )

# set power
n_panels <- 9
ncp_max <- 4
ncps <- ( 0 : ( n_panels - 1 ) ) / ( n_panels - 1 ) * ncp_max 

data <- NULL

for ( ncp in ncps ) {
    # draw alternative p-values assuming chi-sq test and non-central chi-sq as alternative distribution
    # first the test statistics with their effect added
    t_alt <- rchisq( m, df, ncp )
    # and their p-values
    p_alt <- pchisq( t_alt, df, lower.tail = FALSE )

    # combine p-values
    ps <- c( p_null, p_alt )

    # correct them with GC
    obj <- pval_gc( ps, df )
    ps_gc <- obj$pvals
    lambda_gc <- obj$lambda

    # sort the p-values
    ps <- sort( ps )
    ps_gc <- sort( ps_gc )

    # put in a tidy structure
    data <- bind_rows(
        data,
        tibble( p_obs = ps   , p_exp = ps_exp, NCP = ncp, type = 'Raw' ),
        tibble( p_obs = ps_gc, p_exp = ps_exp, NCP = ncp, type = 'GC-adjusted' )
    )

}

# otherwise order is wrong in legend
data <- data %>% mutate( type = factor( type, levels = c( 'Raw', 'GC-adjusted' ) ) )


# go where we want this figure
setwd( '../data/' )

# make qq plots
# copy style from /figures/realdata_sex-meta_GC.Rmd (real version of this)
fig_start( 'gc-overcorrection-example', wh = fig_scale( 0.9 ) )
ggplot( data, aes(x = -log10( p_exp ), y = -log10( p_obs ), color = type ) ) +
    geom_point( size = 0.8, alpha = 0.7 ) +
    geom_abline(intercept = 0, slope = 1, color = "gray50", linetype = "dashed") +
    labs(
        x = expression(Expected~~-log[10](italic(p))),
        y = expression(Observed~~-log[10](italic(p))),
        color = 'P-value Type'
    ) +
    theme_classic() +
    facet_wrap( vars( NCP ), labeller = label_both ) +
    theme( legend.position = "top" ) +
    scale_color_brewer( palette = "Set1" )
fig_end()
