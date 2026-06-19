# trying to get a rough idea for how mean kinship depends on the population and sample sizes, to mimic the setup of Shchur and Nielsen 2018.
# v2 explicitly calculates between-study kinship only, to remove trivial diagonal effect from the start

library(simfam)
library(tidyverse)
library(ggpubr)
library(ochoalabtools)

# raw data tibble; don't recalculate data if we're just updating plots
file_data <- 'mean-kinship.txt.gz'

# want a series of population sizes (N)
Ns <- 1000 * ( 1 : 10 )
# and sample sizes (n) are just in steps of 100 down to 100
n_step <- 100
# family structure only!
G <- 30
# variance is very noisy, let's have replicates
n_rep <- 10

# note the number of possible unique ancestors is much larger than the biggest pop size N, so we're definitely going back far enough
# 2^G # 1,073,741,824

# work from this location
setwd( '../data/' )

if ( ! file.exists( file_data ) ) {

    # calculate desired statistics
    data <- NULL

    for ( N in Ns ) {
        for ( rep in 1 : n_rep ) {
            message( N )
            # make "population" kinship matrix
            # simulate pedigree 
            ped <- sim_pedigree( N, G )
            # extract local kinship, already calculated and subset to last generation!
            kinship_pop <- ped$kinship_local
            # use sex to separate into two studies.  Have to filter for last generation first
            fam <- ped$fam %>% filter( id %in% ped$ids[[G]] )
            indexes_sex <- fam$sex == 1
            kinship_between <- kinship_pop[ indexes_sex, !indexes_sex ]
            
            # record mean kinship for full population, before subsampling
            data_i <- tibble(
                N = N,
                rep = rep,
                n = N,
                mean_kinship = mean( kinship_pop ),
                var_kinship = mean( ( kinship_pop - mean_kinship )^2 ),
                n1 = sum( indexes_sex ),
                n2 = sum( !indexes_sex ),
                mean_kinship_between = mean( kinship_between ),
                var_kinship_between = mean( ( kinship_between - mean_kinship_between )^2 )
            )
            data <- bind_rows( data, data_i )

            # collect data for samples now
            n <- N - n_step
            while ( n > 0 ) {
                message( N, ', ', n )
                # subsample
                indexes <- sample.int( N, n )
                kinship_n <- kinship_pop[ indexes, indexes ]
                fam_n <- fam[ indexes, ]
                indexes_sex <- fam_n$sex == 1
                kinship_n_between <- kinship_n[ indexes_sex, !indexes_sex ]

                # gather data
                data_i <- tibble(
                    N = N,
                    rep = rep,
                    n = n,
                    mean_kinship = mean( kinship_n ),
                    var_kinship = mean( ( kinship_n - mean_kinship )^2 ),
                    n1 = sum( indexes_sex ),
                    n2 = sum( !indexes_sex ),
                    mean_kinship_between = mean( kinship_n_between ),
                    var_kinship_between = mean( ( kinship_n_between - mean_kinship_between )^2 )
                )
                data <- bind_rows( data, data_i )
                
                # for next round
                n <- n - n_step
            }
        }
    }
    
    # save data for later analysis
    write_tsv( data, file_data )
} else
    # read back existing data
    data <- read_tsv( file_data, show_col_types = FALSE )

# first thing we want to do is average replicates
# we're not using n1,n2 so toss those
data <- data %>% select( -n1, -n2, -rep ) %>% 
    summarize(
        mean_kinship = mean( mean_kinship ),
        var_kinship = mean( var_kinship ),
        mean_kinship_between = mean( mean_kinship_between ),
        var_kinship_between = mean( var_kinship_between ),
        .by = c(N, n)
    )

# the original, full kinship plot
fig_start( 'mean-kinship', wh = 1.5 * fig_scale( 1.5 ) )
# n slices, plot vs 1/N
p1 <- ggplot(
    data,
    aes( x = 1/N, y = mean_kinship, col = n, group = factor( n, levels = unique(sort(n)) ) )
) +
    geom_line() +
    theme_classic() +
    labs( x = 'Inverse pop. size (1/N)', y = 'Mean kinship', col = 'Sample size (n)' )
# N slices, plot vs 1/n
p2 <- ggplot(
    data,
    aes( x = 1/n, y = mean_kinship, col = N, group = factor( N, levels = Ns ) )
) +
    geom_line() +
    theme_classic() +
    labs( x = 'Inverse sample size (1/n)', y = 'Mean kinship', col = 'Pop. size (N)' )
# variance panels now
# n slices, plot vs 1/N
p3 <- ggplot(
    data,
    aes( x = 1/N, y = var_kinship, col = n, group = factor( n, levels = unique(sort(n)) ) )
) +
    geom_line() +
    theme_classic() +
    labs( x = 'Inverse pop. size (1/N)', y = 'Kinship variance', col = 'Sample size (n)' )
# N slices, plot vs 1/n
p4 <- ggplot(
    data,
    aes( x = 1/n, y = var_kinship, col = N, group = factor( N, levels = Ns ) )
) +
    geom_line() +
    theme_classic() +
    labs( x = 'Inverse sample size (1/n)', y = 'Kinship variance', col = 'Pop. size (N)' )
ggarrange( p1, p2, p3, p4, labels = 'AUTO', nrow = 2, ncol = 2, align = 'hv' )
fig_end()

# and kinship between studies only, which actually goes in the paper
fig_start( 'mean-kinship-between', wh = 1.5 * fig_scale( 1.5 ) )
# n slices, plot vs 1/N
p1 <- ggplot(
    data,
    aes( x = 1/N, y = mean_kinship_between, col = n, group = factor( n, levels = unique(sort(n)) ) )
) +
    geom_line() +
    theme_classic() +
    labs( x = 'Inverse pop. size (1/N)', y = 'Mean kinship', col = 'Sample size (n)' )
# N slices, plot vs 1/n
p2 <- ggplot(
    data,
    aes( x = n, y = mean_kinship_between, col = N, group = factor( N, levels = Ns ) )
) +
    geom_line() +
    theme_classic() +
    labs( x = 'Sample size (n)', y = 'Mean kinship', col = 'Pop. size (N)' )
# variance panels now
# n slices, plot vs 1/N
p3 <- ggplot(
    data,
    aes( x = 1/N, y = var_kinship_between, col = n, group = factor( n, levels = unique(sort(n)) ) )
) +
    geom_line() +
    theme_classic() +
    labs( x = 'Inverse pop. size (1/N)', y = 'Kinship variance', col = 'Sample size (n)' )
# N slices, plot vs 1/n
p4 <- ggplot(
    data,
    aes( x = n, y = var_kinship_between, col = N, group = factor( N, levels = Ns ) )
) +
    geom_line() +
    theme_classic() +
    labs( x = 'Sample size (n)', y = 'Kinship variance', col = 'Pop. size (N)' )
ggarrange( p1, p2, p3, p4, labels = 'AUTO', nrow = 2, ncol = 2, align = 'hv' )
fig_end()

# for joint kinship...
# as could also be seen visually, the slope is the same in all slices (about 0.5!), and n affects the intercept somehow
# the math for both cases suggest this model:
lm( mean_kinship ~ N_inv + n_inv, data = data %>% mutate( N_inv = 1 / N, n_inv = 1/n ) )
## (Intercept)        N_inv        n_inv  
##  -4.206e-05    1.143e+01    5.022e-01  
lm( mean_kinship ~ 0 + N_inv + n_inv, data = data %>% mutate( N_inv = 1 / N, n_inv = 1/n ) )
##   N_inv    n_inv  
## 11.2919   0.5001  

# constrained model
obj <- lm( mean_kinship - n_inv/2 ~ 0 + N_inv, data = data %>% mutate( N_inv = 1 / N, n_inv = 1/n ) )

coef( obj )
##    N_inv 
## 11.29228 

# extremely well fit!!!
summary( obj )
##        Estimate Std. Error t value Pr(>|t|)    
## N_inv 11.292278   0.005264    2145   <2e-16 ***
## Residual standard error: 2.849e-05 on 549 degrees of freedom
## Multiple R-squared:  0.9999,	Adjusted R-squared:  0.9999 
## F-statistic: 4.602e+06 on 1 and 549 DF,  p-value: < 2.2e-16

# repeat for between
lm( mean_kinship_between ~ N_inv + n_inv, data = data %>% mutate( N_inv = 1 / N, n_inv = 1/n ) )
## (Intercept)        N_inv        n_inv  
##  -4.676e-05    1.146e+01   -1.678e-03  
lm( mean_kinship_between ~ 0 + N_inv + n_inv, data = data %>% mutate( N_inv = 1 / N, n_inv = 1/n ) )
##    N_inv     n_inv  
## 11.30544  -0.00396  

# constrained model
obj <- lm( mean_kinship_between ~ 0 + N_inv, data = data %>% mutate( N_inv = 1 / N ) )

coef( obj )
##    N_inv 
## 11.29029 

# fit is also excellent!
summary( obj )
##        Estimate Std. Error t value Pr(>|t|)    
## N_inv 11.290290   0.005797    1948   <2e-16 ***
## Residual standard error: 3.137e-05 on 549 degrees of freedom
## Multiple R-squared:  0.9999,	Adjusted R-squared:  0.9999 
## F-statistic: 3.793e+06 on 1 and 549 DF,  p-value: < 2.2e-16

# for variance, focus on between only
# again, intercept is practically zero compared to everything else
lm( var_kinship_between ~ N_inv + n_inv, data = data %>% mutate( N_inv = 1 / N, n_inv = 1/n ) )
## (Intercept)        N_inv        n_inv  
##   7.822e-06    1.610e-01   -2.009e-04
# sample size is also practically unimportant here
lm( var_kinship_between ~ 0 + N_inv + n_inv, data = data %>% mutate( N_inv = 1 / N, n_inv = 1/n ) )
##     N_inv      n_inv  
## 0.1862081  0.0001808  

# constrained model
obj <- lm( var_kinship_between ~ 0 + N_inv, data = data %>% mutate( N_inv = 1 / N ) )

coef( obj )
##     N_inv 
## 0.1868996 

# fit is still pretty good, but worst yet, not surprising because I do see a curve for the smallest N
summary( obj )
##       Estimate Std. Error t value Pr(>|t|)    
## N_inv 0.186900   0.001201   155.7   <2e-16 ***
## Residual standard error: 6.498e-06 on 549 degrees of freedom
## Multiple R-squared:  0.9778,	Adjusted R-squared:  0.9778 
## F-statistic: 2.423e+04 on 1 and 549 DF,  p-value: < 2.2e-16


### var_kinship_between modeling ###
# spent a lot of time on this, didn't get great fits, but that doesn't really matter I thing


# before trying more things, let's average more
# the figure suggests a weighted average would be better because smaller sample sizes have higher variance
# the obvious inverse variance weight estimate is the sample size itself, but since there are different numbers of samples for each N, I think it makes the most sense to write a loop that does that (can't think of nice tricks)
data2 <- data %>% select( N, n, var_kinship_between ) %>% summarize( var_kinship_between = weighted.mean( var_kinship_between, n), .by = N )

# a lot of problems are caused because we're missing an implicit point with variance zero at infinite sample sizes (simple models extrapolate to negative variances otherwise), let me add it manually to guide the fits better...
data2 <- bind_rows( data2, tibble( N = Inf, var_kinship_between = 0 ) )

# confirm correctness visually, good!
## ggplot(
##     data %>% filter( n >= 5000 ),
##     aes( x = 1/N, y = var_kinship_between, col = n, group = factor( n, levels = unique(sort(n)) ) )
## ) +
##     geom_line() +
##     theme_classic() +
##     labs( x = 'Inverse pop. size (1/N)', y = 'Kinship variance', col = 'Sample size (n)' ) +
##     geom_line( data = data2 %>% mutate( n = 10000 ), col = 'red' )

# now use the cleaner data, averaged over n so that's no longer a variable

# started out with plots, but because of the various fits, we draw those in the end now...

# repeat fits now too
# first repeat the old fit, but with the smaller data2 (because now R2 is different)
summary( lm( var_kinship_between ~ N_inv, data = data2 %>% mutate( N_inv = 1 / N ) ) )
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 9.420e-06  2.964e-06   3.178   0.0112 *  
## N_inv       1.524e-01  7.897e-03  19.302 1.24e-08 ***
## Residual standard error: 6.929e-06 on 9 degrees of freedom
## Multiple R-squared:  0.9764,	Adjusted R-squared:  0.9738 
## F-statistic: 372.6 on 1 and 9 DF,  p-value: 1.242e-08
summary( lm( var_kinship_between ~ 0 + N_inv, data = data2 %>% mutate( N_inv = 1 / N ) ) )
##       Estimate Std. Error t value Pr(>|t|)    
## N_inv 0.170232   0.007692   22.13 7.96e-10 ***
## Residual standard error: 9.576e-06 on 10 degrees of freedom
## Multiple R-squared:   0.98,	Adjusted R-squared:  0.978 
## F-statistic: 489.8 on 1 and 10 DF,  p-value: 7.958e-10

# after including origin (N=Inf), now this is judged a worse fitm as it should be
summary( lm( var_kinship_between ~ N_inv_sqrt, data = data2 %>% mutate( N_inv_sqrt = 1 / sqrt(N) ) ) )
##               Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.503e-05  7.157e-06  -3.497  0.00675 ** 
## N_inv_sqrt   5.198e-03  4.386e-04  11.852 8.56e-07 ***
## Residual standard error: 1.107e-05 on 9 degrees of freedom
## Multiple R-squared:  0.9398,	Adjusted R-squared:  0.9331 
## F-statistic: 140.5 on 1 and 9 DF,  p-value: 8.555e-07

# fit improves a tiny bit without intercept, haha.  Must be that base residuals are different too
summary( lm( var_kinship_between ~ 0 + N_inv_sqrt, data = data2 %>% mutate( N_inv_sqrt = 1 / sqrt(N) ) ) )
##            Estimate Std. Error t value Pr(>|t|)    
## N_inv_sqrt 0.003842   0.000298   12.89 1.49e-07 ***
## Residual standard error: 1.613e-05 on 10 degrees of freedom
## Multiple R-squared:  0.9432,	Adjusted R-squared:  0.9375 
## F-statistic: 166.1 on 1 and 10 DF,  p-value: 1.487e-07

# have a mix of inverse linear and square root effects
summary( lm( var_kinship_between ~ N_inv_sqrt + I(N_inv_sqrt^2), data = data2 %>% mutate( N_inv_sqrt = 1 / sqrt(N) ) ) )
##                   Estimate Std. Error t value Pr(>|t|)    
## (Intercept)     -4.093e-06  4.395e-06  -0.931  0.37898    
## N_inv_sqrt       1.868e-03  5.415e-04   3.450  0.00870 ** 
## I(N_inv_sqrt^2)  1.019e-01  1.558e-02   6.542  0.00018 ***
## Residual standard error: 4.66e-06 on 8 degrees of freedom
## Multiple R-squared:  0.9905,	Adjusted R-squared:  0.9881 
## F-statistic: 417.9 on 2 and 8 DF,  p-value: 8.081e-09

# this is now the best fit that doesn't give negative variances!
obj <- lm( var_kinship_between ~ 0 + N_inv_sqrt + I(N_inv_sqrt^2), data = data2 %>% mutate( N_inv_sqrt = 1 / sqrt(N) ) )
summary( obj )
##                  Estimate Std. Error t value Pr(>|t|)    
## N_inv_sqrt      0.0014186  0.0002438   5.819 0.000253 ***
## I(N_inv_sqrt^2) 0.1124732  0.0105978  10.613 2.18e-06 ***
## Residual standard error: 4.625e-06 on 9 degrees of freedom
## Multiple R-squared:  0.9958,	Adjusted R-squared:  0.9949 
## F-statistic:  1067 on 2 and 9 DF,  p-value: 2.019e-11

# PLOTS

# visually, sqrt produces a straight line, and that makes total sense given standard formulas
p1 <- ggplot(
    data2,
    aes( x = 1/N, y = var_kinship_between )
) +
    geom_line() +
    theme_classic() +
    labs( x = 'Inverse pop. size (1/N)', y = 'Kinship variance' ) +
    expand_limits(x = 0, y = 0) +
    geom_function( fun = function(x) coef( obj )[1] * sqrt(x) + coef(obj)[2] * x, col = 'blue' ) +
    geom_abline( slope = 0.170232, intercept = 0, col = 'gray' ) # fit without intercept, clearly will extrapolate poorly when N is smaller (bigger 1/N), but at lower values this is probably good

p2 <- ggplot(
    data2,
    aes( x = 1/sqrt(N), y = var_kinship_between )
) +
    geom_line() +
    theme_classic() +
    labs( x = 'Inverse sqrt pop. size (1/sqrt(N))', y = 'Kinship variance' ) +
    expand_limits(x = 0, y = 0) +
    geom_function( fun = function(x) coef( obj )[1] * x + coef(obj)[2] * x^2, col = 'blue' ) +
    geom_abline( slope = 6.173e-03, intercept = -4.300e-05, col = 'red' ) + # fit with intercept, follows data better but predicts negative variances at the largest N (outside what we were able to simulate, but clearly wrong)
    geom_abline( slope = 0.003841609, intercept = 0, col = 'gray' ) # fit without intercept, can tell it's really bad

ggarrange( p1, p2 )

