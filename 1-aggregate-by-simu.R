### AGGREGATE THE PIXELS INTO SIMU
### CREATES A CSV FILE WHERE EACH ROW CONTAINS THE NUMBER OF PIXELS OF 
### EACH CLASS OF A TILE THAT OVERLAPS A GIVEN SIMU

require(magrittr)

# WHERE SIMU SHAPEFILE IS STORED
basedir <- "C:\\Users\\pedro\\Dropbox\\pesquisa\\2021\\r+\\simu-brazil\\"
v <- terra::vect(paste0(basedir, "simu-brazil.shp"))

# WHERE PROCESSED TILES ARE STORED (CREATED BY PREVIOUS SCRIPT)
mdir <- "C:/Users/pedro/Dropbox/pesquisa/2022/aline/brasil_coverage_2000_all/"

files <- list.files(mdir, pattern = "\\.tif$")

mysum <- function(values) sum(values == 0, na.rm = TRUE)

for(file in files){
  inputfile <- paste0(mdir, file)
  inputRaster <- terra::rast(inputfile)
  cat(paste0("Processing ", file, "\n"))  
  
  for(i in 1:(dim(v)[1])){
    simu <- v[i,]
    pixels <- terra::extract(inputRaster, simu)
    
    mtable <- table(pixels)
    if(length(mtable) > 0){
      cat(paste0("Saving ", i, "\n"))
      mtable <- tibble::as_tibble(mtable)
      names(mtable) <- c("ID", "pixel", "n")
      result <- rep(0, 50)
      result[as.numeric(mtable$pixel) + 1] <- mtable$n
      result <- result[-1]
      result <- c(simu$ID, result)
      result <- paste0(result, collapse=",")
      
      write(result, "result-all-v4.csv", append = TRUE)
    }
  }
}

