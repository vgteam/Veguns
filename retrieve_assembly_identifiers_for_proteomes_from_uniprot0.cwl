class: CommandLineTool
cwlVersion: v1.0
doc: Retrieve assembly id’s for E.coli proteomes that are non redundant in UniProtKB
label: get assembly ids for proteome per taxid from UniProtKB

baseCommand: curl
inputs:
  ncbiTaxid:
    type: string
arguments:
  - "https://www.uniprot.org/proteomes/?query=taxonomy%3A$(inputs.ncbiTaxid)+redundant%3Ano&format=tab&columns=id,assembly"
outputs:
  assembly_identifiers:
    type: File
    doc: A tab seperated file with NCBI Taxon and assembly identifiers from UniProt that have an as ancestor a the input NCBI ncbiTaxid
    format: https://www.iana.org/assignments/media-types/text/tab-separated-values
    outputBinding:
      glob: ncbiTaxonomyIndentifiersWithAssemblyFromUniProtThatHaveAsAncestor$(inputs.ncbiTaxid).tsv
stdout: ncbiTaxonomyIndentifiersWithAssemblyFromUniProtThatHaveAsAncestor$(inputs.ncbiTaxid).tsv
