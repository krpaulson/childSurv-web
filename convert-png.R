
library(magick)

input_dir <- "~/Repos/childMort/results"
file_roots <- c("-mrs.eps", "-pars-ll.eps", "-pars-pe.eps", "-comp-to-dh.eps")
countries <- c("Kenya", "Brazil", "Estonia", "Syrian Arab Republic",
               "Argentina", "Australia", "Bahamas", "Bangladesh",
               "Barbados", "Belgium", "Benin", "Bulgaria", "Burkina Faso",
               "Burundi", "Cambodia", "Cameroon", "Canada",
               "Central African Republic", "Chad", "Chile",
               "Colombia", "Comoros", "Congo Democratic Republic",
               "Congo", "Cote d'Ivoire", "Croatia", "Cuba", "Cyprus",
               "Dominican Republic", "Ecuador", "Egypt", "El Salvador",
               "Ethiopia", "Finland", "France", "Gabon", "Gambia",
               "Ghana", "Guatemala", "Guinea", "Haiti", "Honduras",
               "Iceland", "Indonesia", "Japan", "Jordan", "Kazakhstan",
               "Lao People's Democratic Republic", "Latvia",
               "Lesotho", "Liberia", "Madagascar", "Malawi", "Mali",
               "Malta", "Mauritania", "Mauritius", "Mexico", "Morocco",
               "Mozambique", "Namibia", "Nepal", "Nicaragua", "Niger",
               "Nigeria", "Paraguay", "Peru", "Philippines", "Poland",
               "Portugal", "Romania", "Rwanda",
               "Saint Vincent and the Grenadines", "Serbia",
               "Sierra Leone", "Singapore", "Slovenia", "South Africa",
               "Sri Lanka", "State of Palestine", "Sudan",
               "Tanzania", "Thailand", "Timor-Leste",
               "Togo", "Uganda", "United Kingdom of Great Britain and Northern Ireland",
               "Yemen", "Zambia", "Zimbabwe")

for (cc in countries) {
  print(cc)
  if (!dir.exists(paste0("www/", cc))) dir.create(paste0("www/", cc))
  files <- paste0(input_dir, "/", cc, "/", cc, file_roots)
  for (ff in files) {
    if (file.exists(ff)) {
      output_filename <- paste0("www/", cc, "/", gsub(".eps", ".png", basename(ff)))
      img <- image_read(ff, density = 500)
      image_write(img, output_filename, format = "png")
    }
  }
}



files <- list.files("~/Repos/childMort/results", pattern = "-mrs.eps", recursive = T, full.names = TRUE)
for (ff in files) {
  output_filename <- paste0("~/Desktop/", gsub(".eps", ".pdf", basename(ff)))
  img <- image_read(ff, density = 500)
  image_write(img, output_filename, format = "pdf")
}

files <- list.files("~/Desktop/", pattern = "mrs.pdf", full.names = TRUE)
qpdf::pdf_combine(files, output = "~/Desktop/mrs-aug2026.pdf")


files <- list.files("~/Desktop/", pattern = "mrs.pdf", full.names = TRUE)
files_keep <- c()
files_skip <- c()
for (ff in files) {
  cc <- gsub("-mrs.pdf", "", basename(ff))
  if (cc %in% countries) {
    files_keep <- c(files_keep, ff)
  } else {
    files_skip <- c(files_skip, ff)
  }
}
qpdf::pdf_combine(files_keep, output = "~/Desktop/mrs-aug2026-keep.pdf")
qpdf::pdf_combine(files_skip, output = "~/Desktop/mrs-aug2026-skip.pdf")
