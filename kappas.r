library("irr")
slangs = c("sv", "bg", "hr", "cs", "da", "nl", "he", "hi", "it", "lv", "lt", "el", "pl", "pt", "ro", "ru", "sl", "sk", "es", "ca", "fr", "de", "ar", "uk")

tlangs = c("sv", "bg", "hr", "cs", "da", "nl", "he", "hi", "it", "lv", "lt", "el", "pl", "pt", "ro", "ru", "sl", "sk", "es", "ca", "fr", "de", "ar", "uk")

for (i in slangs){
  for (j in tlangs){
    filename = paste(i,"_",j,"_for_kappa.tsv",sep="")
    results <- read.csv(file=filename, sep = "\t", header=TRUE, dec=".")
    fkappa = kappam.fleiss(results, exact = FALSE, detail = FALSE)
    output <- paste(i, j, fkappa$value,sep="\t")
    #print(output)

    write(output, file="kappas.tsv", append=TRUE)
    #print(fkappa)
  }


}

