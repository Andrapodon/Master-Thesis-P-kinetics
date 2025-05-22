library(tidyr)

d <- read.csv(file = "./data/P-release.csv", na.strings = c("", "n.a."))
d$Treatment <- d$Treatment |> factor()
d$uid <- paste(d$Site, d$Treatment, as.character(d$Repetition), sep="_")
d$Repetition <- as.factor(d$Repetition)

d$flos <- d$Pv_Olsen.mg.L.-d$Pv_labile.mg.L.



epsilon <- quantile(d$flos[d$flos > 0], 0.025, na.rm=TRUE)
d$flos[d$flos <= 0] <- epsilon/2 # set non-positive values to epsilon

d$Y1 <- log(1 - d$Pv.mg.L. / d$flos) # one timeseries removed, since flos too low
d$Y1[is.nan(d$Y1)] <- NA

d$Y3 <- log(1 - d$Pv.mg.L. / d$Pv_Olsen.mg.L.)
plot(d$t.min., d$Pv.mg.L.)
lines(smooth.spline(d$t.min., d$Pv.mg.L.))

library(lme4)
lmList(Y1 ~ t.min. | uid, d)

str(d)

library(ggplot2)
library(ggpmisc)
ggplot(d, aes(y=Y1, x=t.min., col = Repetition)) +
  geom_point() +
  facet_grid(Site ~ Treatment) + 
  ylab("ln(1 - P / Ps)")+
  geom_smooth(method="lm", alpha = 0.3)+stat_poly_eq(use_label(c("eq", "R2")))


# d2 <- d[complete.cases(d[,13]), c("Pv.mg.L.", "uid", "t.min.", "Repetition")]
# nls(Pv.mg.L. ~ PS * (1 - exp(-k * t.min.)), d2, subset = uid == "Ellinghausen_0P_1", start = list(PS = 0.1, k=0.001)) 
Res <- nlsList(Pv.mg.L. ~ PS * (1 - exp(-k * t.min.)) | uid, d[, c("Pv.mg.L.", "uid", "t.min.")],  start=list(PS=0.1,k=0.2))
Res


d$nls_pred <- predict(Res)

ggplot(d, aes(y=Pv.mg.L., x=t.min., col = Repetition)) +
  geom_point() +
    geom_smooth(method="nls", se=FALSE, formula = Pv.mg.L. ~ PS * (1 - exp(-k * t.min.))) +
  facet_grid(Treatment ~ Site) +
  geom_line(aes(y=nls_pred))
  # ylab("ln(1 - P / Ps)")+

#stat_poly_eq(use_label(c("eq", "R2")))



d_flos_ps <- cbind(aggregate(flos ~ uid, d, FUN=mean)[,"flos", drop=FALSE], coef(Res))
plot(flos ~ PS, d_flos_ps)


summary(R)

# Ich teste die Korrelation separat für jeden Standort und Düngelevel
site <- d$Site |> unique()

res <- vector(mode = "list")
res2 <- vector(mode = "list")
res3 <- vector(mode = "list")
# Flossman & Richter
df <- d[is.finite(d$Y1),]
for (s in site) {
  
  for (l in levels(d$Treatment)) {
    for (r in unique(d$Repetition)) 
      {
      
      print(paste0(s,l,r))
      res[[paste0(s,l,r)]] <- lm(Y1~t.min.,data = df[df$Site==s&df$Treatment==l&df$Repetition==r,])  
    }
    
    
  }
}





# Plabile as plateau

for (s in site) {
  
  for (l in levels(d$Treatment)) {
    for (r in unique(d$Repetition)) 
      {
      df <- d[is.finite(d$Y2),]
      res2[[paste0(s,l,r)]] <- lm(Y2~t.min.,data = df[df$Site==s&df$Treatment==l&df$Repetition==r,])  
    }
    
    
  }
}

df <- d[is.finite(d$Y3),]
for (s in site) {
  
  for (l in levels(d$Treatment)) 
    {
    
    for (r in unique(d$Repetition)) {
      df <- d[is.finite(d$Y3),]
      res3[[paste0(s,l,r)]] <- lm(Y3~t.min.,data = df[df$Site==s&df$Treatment==l&df$Repetition==r,])  
    }
    
    
  }
}



for (mod in res3) {
  mod |> summary() |> print()
}







plot(Y1~t.min.,data = d[d$Site==s&d$Treatment==l,])
abline(resi,col="blue")


plot(Y1~t.min.,data = na.omit(d[d$Treatment=="0P",]))
