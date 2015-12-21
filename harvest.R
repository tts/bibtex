library(rvest)

# Local URL
url <- "http://math.aalto.fi/en/current/publications/articles/"

linknodes <- url %>%
  html %>%
  html_nodes(xpath = "//a[starts-with(@href,'/en/current/publications/bibtex')]")

ids <- linknodes %>%
  html_attr("href") %>%
  strsplit(., "/") %>%
  lapply(., function(x) gsub("\\?id=", "", x[6]))

baseurl <- "http://math.aalto.fi/en/current/publications/bibtex/?id="

texts <- lapply(ids, function(x) {
  t <- paste0(baseurl, x) %>%
    html(encoding = "UTF-8") %>%
    html_nodes(xpath = "//div[@id='main-center'][@class='span9']/pre") %>%
    html_text() %>%
    gsub("\n", "", .) 
})

sink("math.bib")
paste(texts, collapse = '')
sink()

system("sed -i 's/}}@article/}},\\n\\n@article/g' math.bib")

# http://tuijasonkkila.fi/bibtex/bibtexbrowser.php?bib=math.bib
# http://www.monperrus.net/martin/bibtexbrowser/