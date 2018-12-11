class: CommandLineTool
cwlVersion: v1.0
doc: Retrieve metadata for Ensembl Genome data from taxid

baseCommand: curl
inputs:
  ncbiTaxid:
    type: string
arguments:
  - "https://rest.ensemblgenomes.org/info/genomes/taxonomy/$(inputs.ncbiTaxid)?content-type=application/json"
outputs:
  ensemblgenomes_metadata:
    type: File
    doc: A json file from the ensemblgenomes website that
    format: https://www.iana.org/assignments/media-types/text/application/json
    outputBinding:
      glob: ensemblgenomesMetadataForTaxid$(inputs.ncbiTaxid).json
stdout: ensemblgenomesMetadataForTaxid$(inputs.ncbiTaxid).json
