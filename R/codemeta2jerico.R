library(jsonlite)

# Function to convert metadata to SOCIB glider toolbox format
convert_metadata_to_socib <- function(metadata_json, file) {
  # Load metadata
  metadata <- jsonlite::fromJSON(metadata_json)

  # Exception for programming_language
  programming_language <- NA
  if("programmingLanguage" %in% names(metadata)){
    if(typeof(metadata$programmingLanguage) == "list"){
      programming_language <- metadata$programmingLanguage$name
    }
    if(typeof(metadata$programmingLanguage) == "character"){
      programming_language <- metadata$programmingLanguage
    }
  }

  # Create SOCIB glider toolbox format
  socib_glider_toolbox <- list(
    '_class' = 'Software',
    'alias' = ifelse("codeRepository" %in% names(metadata), metadata$codeRepository, NA),
    'abstract' = ifelse("description" %in% names(metadata), metadata$description, NA),
    'author' = data.frame("_class" = 'Person', "name" = paste(metadata$author$givenName, metadata$author$familyName, sep = " "), stringsAsFactors = FALSE, check.names = FALSE),
    'contributor' = ifelse("contributor" %in% names(metadata), data.frame("_class" = 'Person', "name" = paste(metadata$contributor$givenName, metadata$contributor$familyName, sep = " "), stringsAsFactors = FALSE), NA),
    'description' = ifelse("description" %in% names(metadata), metadata$description, NA),
    'distribution' = list('_class' = 'Distribution', 'accessURL' = ifelse("codeRepository" %in% names(metadata), metadata$codeRepository, NA)),
    'downloadURL' = ifelse("codeRepository" %in% names(metadata), paste(metadata$codeRepository, '/archive/refs/heads/master.zip', sep = ''), NA),
    'keywords' = ifelse("keywords" %in% names(metadata), list(metadata$keywords), NA),
    'language' = list("English"),
    'license' = ifelse("license" %in% names(metadata), metadata$license, NA),
    'modified' = ifelse("version" %in% names(metadata), metadata$version, NA),
    'name' = ifelse("name" %in% names(metadata), metadata$name, NA),
    'organization' = list('_class' = 'Organization', 'alias' = ifelse("provider" %in% names(metadata), metadata$provider$url, NA)),
    'owner' = ifelse("provider" %in% names(metadata), list('_class' = 'Organization', 'alias' = metadata$provider$url), NA),
    'publisher' = ifelse("provider" %in% names(metadata), list('_class' = 'Organization', 'alias' = metadata$provider$url), NA),
    'published' = ifelse("version" %in% names(metadata), metadata$version, NA),
    'programming_language' = programming_language,
    'url' = ifelse("codeRepository" %in% names(metadata), metadata$codeRepository, NA),
    'version' = ifelse("version" %in% names(metadata), metadata$version, NA)
  )

  # Remove unnecessary fields
  fields_to_remove <- c("@context", "@type", "identifier", "relatedLink", "issueTracker", "runtimePlatform",
                        "provider", "maintainer", "softwareSuggestions", "softwareRequirements",
                        "applicationCategory", "isPartOf", "fileSize", "releaseNotes", "readme",
                        "contIntegration", "developmentStatus")
  socib_glider_toolbox <- socib_glider_toolbox[!(names(socib_glider_toolbox) %in% fields_to_remove)]

  # Convert to JSON
  socib_glider_toolbox_json <- jsonlite::toJSON(socib_glider_toolbox, auto_unbox = TRUE, pretty = TRUE)

  # Save
  cat(socib_glider_toolbox_json, file = file)
}

# List all codemeta files
files <- list(
  worrms = "https://raw.githubusercontent.com/ropensci/worrms/master/codemeta.json",
  mregions = "https://raw.githubusercontent.com/ropensci/mregions/master/codemeta.json",
  EMODnetBioCheck = "https://raw.githubusercontent.com/EMODnet/EMODnetBioCheck/master/codemeta.json",
  eurobis = "https://raw.githubusercontent.com/lifewatch/eurobis/master/codemeta.json",
  pyworms = "https://raw.githubusercontent.com/salvafern/pyworms/master/codemeta.json",
  ipt = "https://raw.githubusercontent.com/salvafern/ipt/master/codemeta.json"
)

# Convert in bulk
for(i in 1:length(files)){
  out <- glue::glue('./output/jerico-ri-metadata-{names(files[i])}.json')
  convert_metadata_to_socib(files[[i]], file = out)
}

