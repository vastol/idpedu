# install.packages('rmarkdown')
# install.packages('gdata') # package for keep function
# install.packages('miscTools') # package for insertRow function

# library(rmarkdown)
# library('miscTools')

# setwd('V:/tolk/Private/PROJECT 02 O. DUERR/TEST FILES')

#################################################
#
#' Takes several rmd-files and merge it into a single file
#'
#' @param dir a temporary working directort
#' @param title of the exercise sheet
#' @param files a list of files containing the rmd-files which will be merged
#' 
#' To create a list of file one might use
#'  files = list.files(path='V:/tolk/Private/PROJECT 02 O. DUERR/TEST FILES',pattern = "HA0[1-2].Rmd")
mergeRMDFiles = function(dir = ".",title=".", files) {
       book_header = paste("---\ntitle:",title, "\n---")
       old = setwd(dir)
       
       if(length(grep("book.Rmd", list.files())) > 0){
          warning("book.Rmd already exists")
       }
       write(book_header, file = "book.Rmd")
       
       # Introduce Aufgabe names
       task.names=paste0("##Aufgabe ", 1:length(files))

       for(i in 1:length(files)){
             text = readLines(files[i])
             hspan = grep("---", text) # find the boundaries of meta-text
             # TODO tolk pls invetigate if '---' is allowed in Rmd outside meta text
             # Automatic Name Assignment to Aufgaben
             # Insert Aufgabe titles right after the meta-text
             text=c(text[1:hspan[2]],task.names[i],text[(hspan[2]+1):length(text)])
             text = text[-c(hspan[1]:hspan[2])] # get rid of the meta-text
             
             # Delete all variables except lsg and baseDir 
             # to avoid variable conflict across files
             text[length(text)+1]="```{r, echo=FALSE, eval=TRUE}"
             # TODO: tolk, dueo remove or check why package not availibe
             # text[length(text)+1]="keep(lsg,baseDir,sure=T)"
             # TODO: tolk pls make the baseDir pointing to the directory the file came from. Before the main text comes
             text[length(text)+1]="```"                  
             write(text, sep = "\n", file = "book.Rmd", append = T) # sep = "\n" for newline sepation
         }
         # Render the input file to the specified output format using pandoc        
         # render("book.Rmd", output_format = "pdf_document")
         setwd(old)
}

