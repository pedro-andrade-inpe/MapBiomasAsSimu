### CONVERT THE OUTPUT INTO A GMS FILE

require(magrittr)

# WHERE SIMU SHAPEFILE IS STORED
basedir <- "C:\\Users\\pedro\\Dropbox\\pesquisa\\2021\\r+\\simu-brazil\\"
v <- terra::vect(paste0(basedir, "simu-brazil.shp"))

# THE CSV CREATED BY THE LAST SCRIPT
mdata <- read.table("result-all-v4.csv", sep=",", header = FALSE)
names(mdata) <- c("ID", paste0("v", 1:49))

units::install_unit("kha", "1e3ha")

pixelToHa <- function(value) units::set_units(value * 0.09, "ha")
pixelTokHa <- function(value) units::set_units(pixelToHa(value), "kha")

mdata <- mdata %>%
  as_tibble() %>%
  dplyr::mutate(ID = paste(ID)) %>%
  dplyr::mutate_if(is.numeric, pixelTokHa) %>%
  dplyr::group_by(ID) %>%
  dplyr::summarize_if(is.numeric, sum) 

saveSimU <- function(df, filename){
  res <- data.frame()
  for(i in 1:49){
    att <- paste0("v", i)
    res <- rbind(res, paste0(df$ID, ".", att, "\t", df[[att]]) %>% data.frame())
  }
  
  header <- "PARAMETER MAPBIOMAS2020\n(SimUid,class)  sourcing in 1000 ha per SimU\n/"
  
  colnames(res) <- header
  write.table(res, filename, row.names = FALSE, quote = FALSE)
}

saveSimU(mdata, "result-forest-fao-2020-v4.gms")

