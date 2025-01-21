library(tidyverse)

male = read.table("/datacommons/ochoalab/ssns_gwas/saige/ns_male/saige_output.txt", header = TRUE) %>% 
  mutate(N = 2418)
write.table(male, "/datacommons/ochoalab/ssns_gwas/saige/ns_male/saige_output_N.txt", 
            col.names = TRUE, row.names = FALSE, quote = FALSE)

female = read.table("/datacommons/ochoalab/ssns_gwas/saige/ns_female/saige_output.txt", header = TRUE) %>% 
  mutate(N = 2064)
write.table(female, "/datacommons/ochoalab/ssns_gwas/saige/ns_female/saige_output_N.txt", 
            col.names = TRUE, row.names = FALSE, quote = FALSE)

srns_ssns_discovery = read.table("/datacommons/ochoalab/ssns_gwas/saige/ssns_srns/saige_output.txt", header = TRUE) %>% 
  mutate(N = 1066)
write.table(srns_ssns_discovery, "/datacommons/ochoalab/ssns_gwas/saige/ssns_srns/saige_output_N.txt", 
            col.names = TRUE, row.names = FALSE, quote = FALSE)

srns_ssns_bristol= read.table("/datacommons/ochoalab/ssns_gwas/replication/saige_results/bristol/saige/saige_output.txt", header = TRUE) %>% 
  mutate(N = 513)
write.table(srns_ssns_bristol, "/datacommons/ochoalab/ssns_gwas/replication/saige_results/bristol/saige/saige_output_N.txt", 
            col.names = TRUE, row.names = FALSE, quote = FALSE)

srns_ssns_curegn = read.table("/datacommons/ochoalab/ssns_gwas/replication/saige_results/curegn/saige/saige_output_ssns_srns.txt", header = TRUE) %>% 
  mutate(N = 918)
write.table(srns_ssns_curegn, "/datacommons/ochoalab/ssns_gwas/replication/saige_results/curegn/saige/saige_output_ssns_srns_N.txt", 
            col.names = TRUE, row.names = FALSE, quote = FALSE)
