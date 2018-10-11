#' ### Description:  
#' Power calculation for testing disease associated with marker in a case-control study.  
#' 
#' ***  
#' **Code:**  
#' Directory:  
#'  
#' > &nbsp;&nbsp;&nbsp;&nbsp;/mnt/research/NMDL/Power  
#'   
#' R Script:  
#'  
#' > &nbsp;&nbsp;&nbsp;&nbsp;Power.R  
#'  
#' **Output files:**  
#'  
#' > &nbsp;&nbsp;&nbsp;&nbsp;power_function.Rdata  
#'   
#' ***  

#' ### Code  
#' Clear Environment
rm(list=ls())

#' **Load required packages**
library(GeneticsDesign)
library(viridis)

#' **Session Information**
sessionInfo()

#' ### Description:  
#' The following is a sample code to get a table of power for different combinations of
#' high risk allele frequency P r(A) and genotype relative risk RR(Aa|aa). 

#' Risk allele frequency  
PA <- seq(from=0.1, to=0.5, by=0.05)
PA

#' Relative Risk of disease (1%, 25%, 50%, 75%, 100%)
RR <- c(1.01, 1.25, 1.5, 1.75, 2.0)

#' Function to calculate the power a genetic design given the frequency of risk allele, genotype relative risk, 
#' and number of casses and controls.
pow <- function(PA, RR, case, control){

    lenPA <- length(PA)
    lenRR <- length(RR)

    mat <- matrix(0, nrow=lenPA, ncol=lenRR)
    rownames(mat) <- paste("MAF=", formatC(PA, format="f", digits=2), sep="")
    colnames(mat) <- paste("RRAA=", RR, sep="")

    for(i in 1:lenPA){ 
        a <- PA[i]

        for(j in 1:lenRR){
            b <- RR[j]
            res <- GPC.default(pA=a, pD=0.1, RRAa=(1+b)/2, RRAA=b, 
                Dprime=1, pB=a, nCase=case, ratio=control/case, quiet=T)

            mat[i,j] <- res$power
        }
    }
    return(mat)
}

#' ### Power table for different number of cases.  
#' > Assuming 500 case and 500 controls
rst5 <- pow(PA, RR, case=500, control=500)
print(round(rst5,3))

#' > Assuming 400 case and 400 controls
rst4 <- pow(PA, RR, case=400, control=400)
print(round(rst4,3))

#' > Assuming 300 case and 300 controls
rst3 <- pow(PA, RR, case=300, control=300)
print(round(rst3,3))

#' > Assuming 200 case and 00 controls
rst2 <- pow(PA, RR, case=200, control=200)
print(round(rst2,3))

#' > Assuming 100 case and 100 controls
rst1 <- pow(PA, RR, case=100, control=100)
print(round(rst1,3))



#' ### Power table for different number of cases and 50% less controls.  
#' > Assuming 500 case and 500 controls
rst5.5 <- pow(PA, RR, case=500, control=1000)
print(round(rst5.5,3))

#' > Assuming 400 case and 200 controls
rst4.5 <- pow(PA, RR, case=400, control=800)
print(round(rst4.5,3))

#' > Assuming 300 case and 300 controls
rst3.5 <- pow(PA, RR, case=300, control=600)
print(round(rst3.5,3))

#' > Assuming 200 case and 200 controls
rst2.5 <- pow(PA, RR, case=200, control=400)
print(round(rst2.5,3))

#' > Assuming 100 case and 100 controls
rst1.5 <- pow(PA, RR, case=100, control=200)
print(round(rst1.5,3))


#' ### Merge results for relative risk of disease equal to 2 (100%) for risk allele given different number of case and controls  
#' > Equal number of case and controls
test1 <- data.frame(N500=rst5[,5], N400=rst4[,5], N300=rst3[,5], N200=rst2[,5], N100=rst1[,5])
# Save power table
write.table(test1, file=paste(getwd(), "power_equal.txt", sep="/"), 
    row.names=TRUE, col.names=TRUE, quote=FALSE, sep="\t")
print(round(test1,2)*100)

#' > Half the number of controls than cases
test2 <- data.frame(N500=rst5.5[,5], N400=rst4.5[,5], N300=rst3.5[,5], N200=rst2.5[,5], N100=rst1.5[,5])
# Save power table
write.table(test2, file=paste(getwd(), "power_unequal.txt", sep="/"), 
    row.names=TRUE, col.names=TRUE, quote=FALSE, sep="\t")
print(round(test2,2)*100)


#' ### Plot Power  
#+ power_equal, fig.align='center', fig.width=7, fig.height=7, dpi=600
color <- viridis(ncol(test1))
plot(y=test1[,1], x=PA, main=c("Power versus MAF:","Equal number of cases and controls"), 
    xlab="MAF", ylab="Power (%)", type="n", ylim=c(0,100))
for (i in 1:ncol(test1)){
    points(y=test1[,i]*100, x=PA, col=color[i], pch=16)
    lines(y=test1[,i]*100, x=PA, col=color[i], lty=1, lwd=2)
}
legend("bottomright", legend=c("N=500", "N=400", "N=300", "N=200", "N=300"), title="Number of Cases",
    lty=rep(1, ncol(test1)), lwd=rep(2, ncol(test1)), col=viridis(ncol(test1)), ncol=1, horiz=FALSE)
abline(h=80, col="black", lty=2, lwd=2)


#+ power_unequal, fig.align='center', fig.width=7, fig.height=7, dpi=600
color <- viridis(ncol(test2))
plot(y=test2[,1], x=PA, main=c("Power versus MAF:","Half number of controls vs cases"), 
    xlab="MAF", ylab="Power (%)", type="n", ylim=c(0,100))
for (i in 1:ncol(test2)){
    points(y=test2[,i]*100, x=PA, col=color[i], pch=16)
    lines(y=test2[,i]*100, x=PA, col=color[i], lty=1, lwd=2)
}
legend("bottomright", legend=c("N=500", "N=400", "N=300", "N=200", "N=300"), title="Number of Cases",
    lty=rep(1, ncol(test2)), lwd=rep(2, ncol(test2)), col=viridis(ncol(test2)), ncol=1, horiz=FALSE)
abline(h=80, col="black", lty=2, lwd=2)


#' ### Run R Script  
#+ eval = FALSE
htmlRunR
Power.R nodes=1,cpus-per-task=1,time=00:20:00,mem=10G +Power Table

