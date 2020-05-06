# Render all the .Rmd files in static/slides
blogdown::build_dir("static/slides")


# Convert all slide HTML files to PDF
slide_names_with_ext <- list.files(here::here("static/slides/"), pattern = "*.html")

slide_names_sans_ext <- tools::file_path_sans_ext(slide_names_with_ext)

pdfize <- function(slide_name) {
  pagedown::chrome_print(here::here(paste0("static/slides/", slide_name, ".html")),
                         output = here::here(paste0("static/slides/", slide_name, ".pdf")))
}

sapply(slide_names_sans_ext, pdfize)
