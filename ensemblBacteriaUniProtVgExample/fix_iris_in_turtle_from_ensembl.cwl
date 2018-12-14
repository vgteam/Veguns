class: CommandLineTool
cwlVersion: v1.0
doc: Fix IRIs in ensembl RDF because ensembl cant be bothered

hints:
  SoftwareRequirement:
    packages:
      sed: {}


baseCommand: zcat
inputs:
  ensembl_turtle:
    type: File
arguments:
  - $(inputs.ensembl_turtle.path)
  - valueFrom: '|'
    shellQuote: false
  - sed -e 's/identifiers.org\/uniprot/purl.uniprot.org\/uniprot/g'
  - valueFrom: '|'
    shellQuote: false
  - gzip
outputs:
  fixed_ensembl_turtle:
    type: File
    outputBinding:
      glob: ensembl.ttl.gz
stdout: ensembl.ttl.gz
