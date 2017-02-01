


# LIBRARIES
library(plyr)
library(lsa)
library(reshape)
library(RJSONIO)

# LOAD DATA
PATH <- "www/"
fname <- paste(PATH,'expedia_casestudy_20170127.csv',sep='')
bookings <- read.csv(fname,sep=",",header=TRUE,fill=TRUE)
colnames(bookings) <- c("partner_id","mkt","bkg_value")

# compute booking value per market and partner
aggr.partner.mkt <- ddply(bookings,.(partner_id,mkt),summarize, prt_mkt_bkg_value = sum(bkg_value))

# COMPUTE SIMILARITY USING COSINE DISTANCE
# we are interested in distribution of booking values across markets
mat <- reshape(aggr.partner.mkt, idvar = "partner_id", timevar = "mkt", direction = "wide")
# input 0's for markets where partner is not present
mat[is.na(mat)] <- 0
rownames(mat) <- mat[,1]
sim <- cosine(t(as.matrix(mat[,-1])))
# transform to data frame
sim <- as.data.frame(sim)
sim$prt1 <- rownames(sim)
sim <- melt.data.frame(sim)
colnames(sim) <- c("prt1","prt2","similarity")

# write a json entry for each partner
partners <- levels(aggr.partner.mkt$partner_id)
lines <- aaply(partners,1,function(partner,mkt.values,sim.values){
  # get top markets
  mkt.values <- subset(mkt.values,partner_id==partner)
  top.markets <- head(arrange(mkt.values,desc(prt_mkt_bkg_value)),10)
  # get most similar partners
  sim.values <- subset(sim.values,prt1==partner & prt2!=partner)
  sim.partners <- head(arrange(sim.values,desc(similarity)),10)
  # create list structure
  el <- list()
  el[["partner_name"]] <- partner
  top10markets <- setNames(split(top.markets$prt_mkt_bkg_value, seq(nrow(top.markets))), top.markets$mkt)
  el[["top10markets"]] <- top10markets
  el[["similar_partners"]] <- sim.partners$prt2
  el
},mkt.values=aggr.partner.mkt,sim.values=sim)
# convert to json
json <- toJSON(lines,collapse="")
# collapse des not eliminate all return carriages
json <- gsub("[\r\n]", "", json)
# WRITE FILE
PATH <- "../results/"
fname <- paste(PATH,'expedia_partners.json',sep='')
writeLines(json,fname)

# HOW DO YOU THINK YOU COULD USE THIS DATA TO HELP EXPEDIA PARTNERS?

# FIND MOST SIMILAR PARTNER TO de1201d4d1b6

partner <- "de1201d4d1b6"
sim.values <- subset(sim,prt1==partner & prt2!=partner)
most_similar_partner <- arrange(sim.values,desc(similarity))$prt2[1]
