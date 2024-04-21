library(genio)
library(ochoalabtools)

# get base of file to process
name_in <- args_cli()
if ( is.na( name_in ) )
    stop( 'usage: <name> (.fam input, .phen output)' )

# read FAM
fam <- read_fam( name_in )

# write PHEN!
write_phen( name_in, fam )
