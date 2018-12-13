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
  assembly_identifiers_as_regex:
    type: string
  ncbiTaxid:
    type: string
arguments:
  - -c
  - '[.[]|select(.assembly_id|test("$(inputs.assembly_identifiers_as_regex)"))|.]'
  - $(inputs.ensemblgenomes_metadata.path)
outputs:
  filtered_ensemblgenomes_metadata:
    type: File
    outputBinding:
      glob: $(inputs.ncbiTaxid)_filtered_ensembl_metadata.json
stdout: $(inputs.ncbiTaxid)_filtered_ensembl_metadata.json
