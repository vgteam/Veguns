class: CommandLineTool
cwlVersion: v1.0
doc: Join the proteomes and genome lists so that we have only Ensembl Bacteria genomes that have non redundant UniProtKB proteome. Which at the time of writing gives 200 genomes.

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}

baseCommand: tail
inputs:
  assembly_identifiers:
    type: File
    doc: |
      A tab seperated file with UniProt proteome and assembly identifiers from
      UniProt that have an as ancestor a the input NCBI ncbiTaxid
    format: https://www.iana.org/assignments/media-types/text/tab-separated-values
arguments:
  - -n
  - '+2'
  - $(inputs.assembly_identifiers.path)
  - valueFrom: '|'
    shellQuote: false
  - cut
  - -f
  - '2'
  - valueFrom: '|'
    shellQuote: false
  - tr
  - '\n'
  - valueFrom: '"|"'
    shellQuote: true
stdout: regex.re
outputs:
  assembly_identifiers_as_regex:
    type: string
    outputBinding:
      glob: regex.re
      loadContents: true
      outputEval: $(self[0].contents.substring(0,self[0].contents.length-1))
