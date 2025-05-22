library(tidyr)

d <- read.csv(file = "~/Downloads/P-release.csv")

d$Treatment <- d$Treatment |> factor()
d$flos <- d$Pv_Olsen.mg.L.-d$Pv_labile.mg.L.
d$Y1 <- log(d$flos-d$Pv.mg.L.)
d$Y2 <- log(d$Pv_labile.mg.L.-d$Pv.mg.L.)
d$Y3 <- log(d$Pv_Olsen.mg.L.-d$Pv.mg.L.)
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
