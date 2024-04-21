library(bnpsd)
library(ape)

# set up tree, defining topology and edges on a relative scale
make_corr_psi_tree <- function( k_subpops ) {
  
  # here we have recursive nesting, so it's always the same shape roughly
  # need k_subpops >= 2 for all of this to make sense
  if ( k_subpops < 2 )
    stop( '`k_subpops` must be 2 or larger!' )
  
  # initialize newick-formatted tree string
  # no labels for nodes
  tree_str <- '(,)'
  # NOTE: k_tmp is a temporary copy that will be zero when done here
  k_tmp <- k_subpops - 2 # this tree already has two nodes
  while ( k_tmp > 0 ) {
    # add another layer
    tree_str <- paste0( '(,', tree_str, ')' )
    # decrement k_subpops by 1 here only
    k_tmp <- k_tmp - 1
  }
  # finish tree by adding semicolon to end
  tree_str <- paste0( tree_str, ';' )
  # turn to real tree object
  tree_subpops <- ape::read.tree( text = tree_str )
  # add more details now
  # want additive edges to be same length
  # and let's go with 1/k_subpops to be in safe range
  tree_subpops$edge.length <- rep.int( 1 / k_subpops, nrow( tree_subpops$edge ) )
  # add intuitive labels
  tree_subpops$tip.label <- paste0( 'S', 1 : k_subpops )
  
  # lastly, simulation works best if these were additive edges (hard to define directly from probabilistic)
  # so let's go backwards instead and calculate probablistic edges now
  tree_subpops <- bnpsd::tree_additive( tree_subpops, rev = TRUE )
  
  # done, return tree object!
  return( tree_subpops )
}