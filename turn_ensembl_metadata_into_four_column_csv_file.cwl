class: CommandLineTool
cwlVersion: v1.0
doc: Generate a four column csv file with the name in the first column,the assembly id in the second and the database subsection name in the third and the escaped species name as used in URLs in the last.

requirements:
  ShellCommandRequirement: {}

hints:
  SoftwareRequirement:
    packages:
      jq:
baseCommand: jq
inputs:
  ensemblgenomes_metadata:
    type: File
    doc: A json file from the ensemblgenomes website that
arguments:
  - -c
  - '.[]|[.name,.assembly_id,.dbname,.species]'
  - $(inputs.ensemblgenomes_metadata.path)
  - valueFrom: '|'
    shellQuote: false
  - tr
  - -d
  - '[]'
outputs:
  ensemblgenomes_metadata:
    type: File
    outputBinding:
      glob: ensemblgenomesMetadataForTaxid$(inputs.ensemblgenomes_metadata.basename).tsv
stdout: ensemblgenomesMetadataForTaxid$(inputs.ensemblgenomes_metadata.basename).tsv
