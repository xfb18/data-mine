library(tm)

# docs = vector(length=8,mode="list")
# for (i in 1:8) {
# a = readLines(paste("docs/",i,".txt",sep=""))
# docs[[i]] = paste(a,collapse=" ")
# }
# docs[[9]] = "Raphael is cool, but rude! Michelangelo is a party dude!"
# names(docs) = c(paste("doc",1:8),"query")
# save(file="docs.Rdata",docs)
load(file="docs.Rdata")

corp = VCorpus(VectorSource(docs))
dtm = DocumentTermMatrix(corp, control=list(tolower=TRUE,removePunctuation=TRUE,removeNumbers=TRUE))

mydtm = as.matrix(dtm)
q = c("but","cool","dude","party","michelangelo","raphael","rude")
mat = cbind(mydtm[,q],sqrt(colSums((t(mydtm[1:9,])-mydtm[9,])^2)))
#colSums(abs(t(mydtm[1:9,])-mydtm[9,])))
colnames(mat) = c(q,"dist")

mydtm.dl = mydtm/rowSums(mydtm)
mat.dl = cbind(mydtm.dl[,q],
sqrt(colSums((t(mydtm.dl[1:9,])-mydtm.dl[9,])^2)))
#colSums(abs(t(mydtm.dl[1:9,])-mydtm.dl[9,])))
colnames(mat.dl) = c(q,"dist")

mydtm.el = mydtm/sqrt(rowSums(mydtm^2))
mat.el = cbind(
mydtm.el[,q],
sqrt(colSums((t(mydtm.el[1:9,])-mydtm.el[9,])^2)))
#colSums(abs(t(mydtm.el[1:9,])-mydtm.el[9,])))
colnames(mat.el) = c(q,"dist")

a = cbind(mat.dl[,8],mat.el[,8])
colnames(a) = c("dist/doclen","dist/l2len")
rownames(a) = paste(rownames(a),
c("(tmnt leo)","(tmnt rap)","(tmnt mic)","(tmnt don)",
"(real leo)","(real rap)","(real mic)","(real don)"))

dtm.idf = DocumentTermMatrix(corp, control=list(tolower=TRUE,removePunctuation=TRUE,removeNumbers=TRUE,weighting=weightTfIdf))
mydtm.idf.dl = as.matrix(dtm.idf)
mat.idf.dl = cbind(
mydtm.idf.dl[,q],
sqrt(colSums((t(mydtm.idf.dl[1:9,])-mydtm.idf.dl[9,])^2)))
#colSums(abs(t(mydtm.idf.dl[1:9,])-mydtm.idf.dl[9,])))
colnames(mat.idf.dl) = c(q,"dist")

mydtm.idf.el = mydtm.idf.dl * rowSums(mydtm) / sqrt(rowSums(mydtm^2))
mat.idf.el = cbind(
mydtm.idf.el[,q],
sqrt(colSums((t(mydtm.idf.el[1:9,])-mydtm.idf.el[9,])^2)))
#colSums(abs(t(mydtm.idf.el[1:9,])-mydtm.idf.el[9,])))
colnames(mat.idf.el) = c(q,"dist")

# nw = colSums(mydtm!=0)
# mydtm.idf.dl = scale(mydtm.dl,center=FALSE,scale=1/log(9/nw))
# mydtm.idf.el = scale(mydtm.el,center=FALSE,scale=1/log(9/nw))

a = cbind(mat.idf.dl[,8],mat.idf.el[,8])
colnames(a) = c("dist/doclen/idf","dist/l2len/idf")
rownames(a) = paste(rownames(a),
c("(tmnt leo)","(tmnt rap)","(tmnt mic)","(tmnt don)",
"(real leo)","(real rap)","(real mic)","(real don)"))

## quick check that order matters
D = nrow(mydtm)
nw = colSums(mydtm!=0)

a = mydtm/rowSums(mydtm)
aa = scale(a,center=FALSE,scale=1/log(D/nw))

b = scale(mydtm,center=FALSE,scale=1/log(D/nw))
bb = b/rowSums(b)

