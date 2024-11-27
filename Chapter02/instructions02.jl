using PkgTemplates
using Revise

template = Template(; license = "MIT", user = "Realife-Brahmin")

generate(template, "Calculator")

cd(joinpath(homedir(), ".julia", "dev", "Calculator"))