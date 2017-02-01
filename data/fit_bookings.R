

library(mclust)

PATH <- "www/"
fname <- paste(PATH,'expedia_casestudy_20170127.csv',sep='')
bookings <- read.csv(fname,sep=",",header=TRUE,fill=TRUE)
colnames(bookings) <- c("partner_id","mkt","bkg_value")


# fix a univariate mixture of 2 components and variable variance
mod = densityMclust(log10(bookings$bkg_value+1e-15),2)
#plot(mod, what = "density", data = log10(bookings$bkg_value), breaks = 15,xlab="bkg_value (log10)",xlim=c(-6,1))
# I can use this to classify
PATH <- ".../data/"
fname <- paste(PATH,'bookings_fit.rda',sep='')
save(mod,file=fname)
