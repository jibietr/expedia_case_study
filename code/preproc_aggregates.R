
# Compute partner and market aggregates:
# num bookings, total booking, mean booking value
# market share, partner share, etc.
library(plyr)
library(reshape)

PATH <- "www/"
fname <- paste(PATH,'expedia_casestudy_20170127.csv',sep='')
bookings <- read.csv(fname,sep=",",header=TRUE,fill=TRUE)
colnames(bookings) <- c("partner_id","mkt","bkg_value")
bookings$bkg_id <- seq(nrow(bookings))

# compute aggregates...
aggr.prt.mkt <- ddply(bookings,.(partner_id,mkt),summarize,
  tot_prt_mkt_bkg_value = sum(bkg_value),
  num_bkgs = length(bkg_value),
  mean_bkg_value=mean(bkg_value))
# compute market aggregates
aggr.mkt <- ddply(aggr.prt.mkt,.(mkt),summarize,
  num_partners = length(partner_id),
  tot_mkt_bkg_value = sum(tot_prt_mkt_bkg_value),
  mean_bkg_value=mean(mean_bkg_value),
  num_bkgs=sum(num_bkgs))
aggr.prt <- ddply(aggr.prt.mkt,.(partner_id),summarize,
    num_markets = length(mkt),
    tot_prt_bkg_value = sum(tot_prt_mkt_bkg_value),
    mean_bkg_value=mean(mean_bkg_value),
    num_bkgs=sum(num_bkgs))
# compute market share
total_mkt_value <- aggr.mkt[,c("mkt","tot_mkt_bkg_value")]
aggr.prt.mkt <- merge(aggr.prt.mkt,total_mkt_value,all.x=TRUE)
aggr.prt.mkt$mkt_share <- aggr.prt.mkt$tot_prt_mkt_bkg_value/aggr.prt.mkt$tot_mkt_bkg_value
# compute partner share
total_prt_value <- aggr.prt[,c("partner_id","tot_prt_bkg_value")]
aggr.prt.mkt <- merge(aggr.prt.mkt,total_prt_value,all.x=TRUE)
aggr.prt.mkt$prt_share <- aggr.prt.mkt$tot_prt_mkt_bkg_value/aggr.prt.mkt$tot_prt_bkg_value

# write output
PATH <- "../data/"
fname <- paste(PATH,'aggregates.rda',sep='')
save(aggr.prt.mkt,aggr.mkt,aggr.prt,file=fname)
